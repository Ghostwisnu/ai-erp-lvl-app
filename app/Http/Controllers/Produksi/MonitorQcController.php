<?php

namespace App\Http\Controllers\Produksi;

use App\Http\Controllers\Admin\BaseAdminController;
use App\Models\ProductionDefect;
use App\Models\ProductionScan;
use App\Models\Spk;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class MonitorQcController extends BaseAdminController
{
    public function index(Request $request)
    {
        // Set timezone ke Asia/Jakarta untuk pencocokan jam
        $timezone = 'Asia/Jakarta';

        $activeSpks = Spk::with('brand')
            ->whereIn('status', ['active', 'create'])
            ->orderBy('created_at', 'desc')
            ->get();

        $selectedSpkId = $request->input('spk_id', $activeSpks->first()?->id);
        $selectedSpk = null;

        if ($selectedSpkId) {
            $selectedSpk = Spk::with('brand', 'details')->find($selectedSpkId);
        }

        $date = $request->input('date', Carbon::now($timezone)->toDateString());

        // Definisikan Time Slot
        $timeSlots = [
            '07:15-09:45',
            '09:45-12:00',
            '12:45-14:15',
            '14:15-16:15',
            '16:15-18:00',
            '18:30-22:00',
        ];

        $monitorData = [];
        $totalPerSlot = array_fill_keys($timeSlots, 0);
        $grandTotal = 0;

        $totalPassAllTime = 0;
        $totalPo = 0;

        if ($selectedSpk) {
            $totalPo = $selectedSpk->details->sum('qty');

            // 1. TOTAL SCAN (PASS) KESELURUHAN
            $totalPassAllTime = ProductionScan::whereHas('spkDetail', function ($q) use ($selectedSpk) {
                $q->where('spk_id', $selectedSpk->id);
            })->where('status', 'pass')->count();

            // 2. TOTAL DEFECT KESELURUHAN
            $totalDefectAllTime = ProductionDefect::where('spk_id', $selectedSpk->id)->sum('qty');

            // 3. Ambil Top 10 Defect (Keseluruhan)
            $topDefects = ProductionDefect::where('spk_id', $selectedSpk->id)
                ->select('defect_category_id', DB::raw('SUM(qty) as total'))
                ->groupBy('defect_category_id')
                ->orderByDesc('total')
                ->limit(10)
                ->with('defectCategory')
                ->get();

            $topDefectIds = $topDefects->pluck('defect_category_id')->toArray();

            // 4. Ambil Data Defect UNTUK TANGGAL INI (Isi Matrix)
            $defectsOnDate = ProductionDefect::where('spk_id', $selectedSpk->id)
                ->whereDate('created_at', $date)
                ->whereIn('defect_category_id', $topDefectIds)
                ->get();

            // 5. Susun Matrix
            foreach ($topDefects as $defect) {
                $row = [
                    'name' => $defect->defectCategory->name ?? 'Unknown',
                    'slots' => [],
                    'total' => 0
                ];

                foreach ($timeSlots as $slot) {
                    list($start, $end) = explode('-', $slot);

                    // Filter menggunakan timezone Asia/Jakarta
                    $qtyInSlot = $defectsOnDate->filter(function ($item) use ($defect, $start, $end, $timezone) {
                        $time = $item->created_at->timezone($timezone)->format('H:i');
                        return $item->defect_category_id == $defect->defect_category_id
                            && $time >= $start && $time <= $end;
                    })->sum('qty');

                    $row['slots'][$slot] = $qtyInSlot;
                    $row['total'] += $qtyInSlot;
                    $totalPerSlot[$slot] += $qtyInSlot;
                }

                $monitorData[] = $row;
                $grandTotal += $row['total'];
            }
        }

        // 6. HITUNG PERSENTASE SESUAI RUMUS BARU
        // Defect % = (Total Defect / Total Scan) * 100
        $defectPercentage = $totalPassAllTime > 0 ? round(($totalDefectAllTime / $totalPassAllTime) * 100, 1) : 0;

        // Pass % = (Total Scan / Total PO) * 100
        $passPercentage = $totalPo > 0 ? round(($totalPassAllTime / $totalPo) * 100, 1) : 0;

        return $this->renderAdminPage('Produksi/Monitor/Index', [
            'activeSpks' => $activeSpks,
            'selectedSpk' => $selectedSpk,
            'date' => $date,
            'timeSlots' => $timeSlots,
            'monitorData' => $monitorData,
            'totalPerSlot' => $totalPerSlot,
            'grandTotal' => $grandTotal,
            'stats' => [
                'passPercentage' => $passPercentage,
                'defectPercentage' => $defectPercentage,
                'totalPass' => $totalPassAllTime,
                'totalDefect' => $totalDefectAllTime,
                'totalPo' => $totalPo,
            ]
        ]);
    }
}
