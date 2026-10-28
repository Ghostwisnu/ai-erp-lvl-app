<?php

namespace App\Http\Controllers\Produksi;

use App\Http\Controllers\Admin\BaseAdminController;
use App\Models\DefectCategory;
use App\Models\ProductionDefect;
use App\Models\Spk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class DefectController extends BaseAdminController
{
    public function index(Request $request)
    {
        $department = $request->input('dept', 'qc'); // qc, warehouse, finishing
        $selectedSpk = null;

        if ($request->has('spk_id')) {
            $selectedSpk = Spk::with('brand')->find($request->spk_id);
        }

        // Ambil SPK Active
        $activeSpks = Spk::with('brand')->where('status', 'active')->get();

        // Ambil Kategori Defect sesuai Brand dari SPK yang dipilih
        $defectCategories = [];
        if ($selectedSpk) {
            $defectCategories = DefectCategory::where('brand_id', $selectedSpk->brand_id)->get();
        }

        // Ambil Data Defect yang sudah diinput hari ini
        $todayDefects = ProductionDefect::with(['spk', 'defectCategory'])
            ->whereDate('created_at', Carbon::today())
            ->where('department', $department)
            ->get();

        return $this->renderAdminPage('Produksi/Defect/Index', [
            'department' => $department,
            'activeSpks' => $activeSpks,
            'selectedSpk' => $selectedSpk,
            'defectCategories' => $defectCategories,
            'todayDefects' => $todayDefects,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'spk_id' => 'required|exists:spks,id',
            'defect_category_id' => 'required|exists:defect_categories,id',
            'department' => 'required|in:warehouse,finishing,qc',
            'qty' => 'required|integer|min:1',
        ]);

        ProductionDefect::create([
            ...$validated,
            'reported_by' => Auth::user()->name ?? 'System',
        ]);

        return back()->with('success', 'Data defect berhasil ditambahkan.');
    }
}
