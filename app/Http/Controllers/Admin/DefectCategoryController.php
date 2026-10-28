<?php

namespace App\Http\Controllers\Admin;

use App\Models\Brand;
use App\Models\DefectCategory;
use Illuminate\Http\Request;

class DefectCategoryController extends BaseAdminController
{
    public function index()
    {
        return $this->renderAdminPage('Admin/Defects/Index', [
            'defects' => DefectCategory::with('brand')->latest()->paginate(10)
        ]);
    }

    public function create()
    {
        return $this->renderAdminPage('Admin/Defects/Create', [
            'brands' => Brand::orderBy('name')->get()
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'brand_id' => 'required|exists:brands,id',
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        DefectCategory::create($validated);
        return redirect()->route('admin.defect-categories.index')->with('success', 'Kategori Defect berhasil dibuat.');
    }

    public function edit(DefectCategory $defectCategory)
    {
        return $this->renderAdminPage('Admin/Defects/Edit', [
            'defect' => $defectCategory,
            'brands' => Brand::orderBy('name')->get()
        ]);
    }

    public function update(Request $request, DefectCategory $defectCategory)
    {
        $validated = $request->validate([
            'brand_id' => 'required|exists:brands,id',
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $defectCategory->update($validated);
        return redirect()->route('admin.defect-categories.index')->with('success', 'Kategori Defect berhasil diupdate.');
    }

    public function destroy(DefectCategory $defectCategory)
    {
        $defectCategory->delete();
        return redirect()->route('admin.defect-categories.index')->with('success', 'Kategori Defect berhasil dihapus.');
    }
}
