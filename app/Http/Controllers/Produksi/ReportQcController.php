<?php

namespace App\Http\Controllers\Produksi;

use App\Http\Controllers\Admin\BaseAdminController;
use App\Models\Spk;
use App\Models\ProductionScan;
use App\Models\ProductionDefect;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ReportQcController extends BaseAdminController
{
    // 1. Halaman Daftar PO
    public function index()
    {
        $spks = Spk::with('brand')
            ->withCount(['scans as total_scan', 'defects as total_defect'])
            ->withSum('details', 'qty')
            ->latest()
            ->get();

        return $this->renderAdminPage('Produksi/Report/Index', ['spks' => $spks]);
    }

    // 2. Halaman Detail Report
    public function show(Spk $spk)
    {
        $spk->load('brand', 'details');

        $totalPo = $spk->details->sum('qty');

        // Hitung Total Scan (Pass) dan Total Defect
        $totalPass = ProductionScan::whereHas('spkDetail', function ($q) use ($spk) {
            $q->where('spk_id', $spk->id);
        })->where('status', 'pass')->count();

        $totalDefect = ProductionDefect::where('spk_id', $spk->id)->sum('qty');

        // Rumus Persentase
        $defectPercentage = $totalPass > 0 ? round(($totalDefect / $totalPass) * 100, 1) : 0;
        $passPercentage = $totalPo > 0 ? round(($totalPass / $totalPo) * 100, 1) : 0;

        // --- MENGAMBIL DAFTAR TANGGAL UNIK ---
        $defectDates = ProductionDefect::where('spk_id', $spk->id)->select(DB::raw('DATE(created_at) as date'))->pluck('date');
        $scanDates = ProductionScan::whereHas('spkDetail', fn($q) => $q->where('spk_id', $spk->id))->select(DB::raw('DATE(created_at) as date'))->pluck('date');
        $dates = $defectDates->merge($scanDates)->unique()->sort()->values();

        // --- DATA GRAFIK LINE ---
        $chartData = [];
        foreach ($dates as $date) {
            $scanCount = ProductionScan::whereHas('spkDetail', fn($q) => $q->where('spk_id', $spk->id))
                ->whereDate('created_at', $date)->count();
            $defectCount = ProductionDefect::where('spk_id', $spk->id)
                ->whereDate('created_at', $date)->sum('qty');

            $chartData[] = [
                'date' => date('d M', strtotime($date)),
                'scanned' => $scanCount,
                'defect' => $defectCount,
            ];
        }

        // --- DATA TABEL DEFECT (Ranking) ---
        $defectRanking = ProductionDefect::where('spk_id', $spk->id)
            ->select('defect_category_id', DB::raw('SUM(qty) as total'))
            ->groupBy('defect_category_id')
            ->with('defectCategory')
            ->orderByDesc('total')
            ->get()
            ->map(function ($item) {
                return [
                    'name' => $item->defectCategory ? $item->defectCategory->name : 'Unknown',
                    'total' => $item->total,
                ];
            });

        // --- DATA MATRIX DEFECT x TANGGAL ---
        $matrixData = [];
        foreach ($defectRanking as $rank) {
            $row = ['defect' => $rank['name'], 'total' => $rank['total']];

            foreach ($dates as $date) {
                $qty = ProductionDefect::where('spk_id', $spk->id)
                    ->whereHas('defectCategory', function ($q) use ($rank) {
                        $q->where('name', $rank['name']);
                    })
                    ->whereDate('created_at', $date)
                    ->sum('qty');

                // KUNCI PERBAIKAN: Gunakan format Y-m-d (misal: "2026-10-27")
                $row[date('Y-m-d', strtotime($date))] = $qty;
            }
            $matrixData[] = $row;
        }

        return $this->renderAdminPage('Produksi/Report/Show', [
            'spk' => $spk,
            'stats' => [
                'totalPo' => $totalPo,
                'totalPass' => $totalPass,
                'totalDefect' => $totalDefect,
                'defectPercentage' => $defectPercentage,
                'passPercentage' => $passPercentage,
            ],
            'chartData' => $chartData,
            'defectRanking' => $defectRanking,
            'matrixData' => $matrixData,
            'dates' => $dates,
        ]);
    }
}
