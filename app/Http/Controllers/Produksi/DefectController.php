<?php

namespace App\Http\Controllers\Produksi;

use App\Http\Controllers\Admin\BaseAdminController;
use App\Models\DefectCategory;
use App\Models\ProductionDefect;
use App\Models\Spk;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class DefectController extends BaseAdminController
{
    public function index(Request $request): Response|Responsable
    {
        $department = $request->input('dept', 'qc'); // qc, warehouse, finishing
        $selectedSpk = null;
        $selectedSpkId = $request->integer('spk_id');

        if ($selectedSpkId > 0) {
            $selectedSpk = Spk::with('brand')->find($selectedSpkId);
        }

        // Ambil SPK Active
        $activeSpks = Spk::with('brand')->where('status', 'active')->get();

        // Ambil Kategori Defect sesuai Brand dari SPK yang dipilih
        $defectCategories = collect();
        if ($selectedSpk) {
            $defectCategories = DefectCategory::where('brand_id', $selectedSpk->brand_id)->get();
        } else {
            // If no SPK selected, show defect categories from all active brands or just all categories
            $defectCategories = DefectCategory::with('brand')->get();
        }

        // Format defect categories for frontend (convert to array)
        $defectCategories = $defectCategories->map(fn (DefectCategory $category) => [
            'id' => $category->id,
            'name' => $category->name,
            'description' => $category->description,
            'brand_id' => $category->brand_id,
        ]);

        // Ambil Data Defect berdasarkan SPK yang dipilih (bisa data hari ini atau sebelumnya)
        $defectsQuery = ProductionDefect::with(['spk', 'defectCategory']);
        
        if ($selectedSpkId > 0) {
            $defectsQuery->where('spk_id', $selectedSpkId);
        }
        
        $dailyDefects = $defectsQuery
            ->where('department', $department)
            ->get();

        return $this->renderAdminPage('Produksi/Defect/Index', [
            'department' => $department,
            'activeSpks' => $activeSpks,
            'selectedSpk' => $selectedSpk,
            'defectCategories' => ['data' => $defectCategories],
            'dailyDefects' => $dailyDefects,
        ]);
    }

    public function store(Request $request): Response|Responsable
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
