<?php

namespace App\Http\Controllers\Produksi;

use App\Http\Controllers\Admin\BaseAdminController;
use App\Models\ProductionScan;
use App\Models\Spk;
use App\Models\SpkDetail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class ScanController extends BaseAdminController
{
    public function index()
    {
        // Hitung statistik hari ini untuk halaman pilih departemen
        $stats = [
            'warehouse' => [
                'daily' => ProductionScan::where('department', 'warehouse')->whereDate('created_at', Carbon::today())->count(),
                'pass' => ProductionScan::where('department', 'warehouse')->where('status', 'pass')->whereDate('created_at', Carbon::today())->count(),
                'defect' => ProductionScan::where('department', 'warehouse')->where('status', 'defect')->whereDate('created_at', Carbon::today())->count(),
            ],
            'finishing' => [
                'daily' => ProductionScan::where('department', 'finishing')->whereDate('created_at', Carbon::today())->count(),
                'pass' => ProductionScan::where('department', 'finishing')->where('status', 'pass')->whereDate('created_at', Carbon::today())->count(),
                'defect' => ProductionScan::where('department', 'finishing')->where('status', 'defect')->whereDate('created_at', Carbon::today())->count(),
            ]
        ];

        return $this->renderAdminPage('Produksi/Scan/SelectDepartment', ['stats' => $stats]);
    }

    public function scan($department, Request $request)
    {
        // 1. TAMPILKAN SEMUA SPK YANG STATUSNYA 'ACTIVE' (Tanpa filter departemen)
        $activeSpks = Spk::with('brand', 'details')
            ->where('status', 'active')
            ->get();

        // 2. Ambil SPK yang sedang dipilih beserta jumlah scan-nya DI DEPARTEMEN INI
        $selectedSpk = null;
        if ($request->has('spk_id')) {
            $selectedSpk = Spk::with(['brand', 'details' => function ($q) use ($department) {
                // Hitung berapa banyak yang sudah di-scan di departemen ini
                $q->withCount(['scans' => function ($sq) use ($department) {
                    $sq->where('department', $department);
                }]);
            }])->find($request->spk_id);
        }

        return $this->renderAdminPage('Produksi/Scan/ScanBoard', [
            'department' => $department,
            'activeSpks' => $activeSpks,
            'selectedSpk' => $selectedSpk
        ]);
    }

    public function submitScan(Request $request)
    {
        $request->validate([
            'spk_id' => 'required|exists:spks,id',
            'department' => 'required|in:warehouse,finishing',
            'barcode' => 'required|string',
            'status' => 'required|in:pass,defect',
        ]);

        // Cari SpkDetail berdasarkan barcode
        $detail = SpkDetail::whereHas('spk', function ($q) use ($request) {
            $q->where('id', $request->spk_id);
        })->where('barcode', $request->barcode)->first();

        if (!$detail) {
            return back()->with('error', 'Barcode tidak ditemukan di PO ini!');
        }

        // Simpan scan
        ProductionScan::create([
            'spk_detail_id' => $detail->id,
            'department' => $request->department,
            'status' => $request->status,
            'scanned_by' => Auth::user()->name ?? 'System',
        ]);

        return back()->with('success', 'Scan berhasil!');
    }
}
