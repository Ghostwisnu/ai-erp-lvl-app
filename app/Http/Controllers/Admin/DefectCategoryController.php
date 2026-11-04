<?php

namespace App\Http\Controllers\Admin;

use App\Models\Brand;
use App\Models\DefectCategory;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class DefectCategoryController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        return $this->renderAdminPage('Admin/Defects/Index', [
            'defects' => DefectCategory::with('brand')->latest()->paginate(10),
        ]);
    }

    /** @return Responsable|Response */
    public function create()
    {
        return $this->renderAdminPage('Admin/Defects/Create', [
            'brands' => Brand::orderBy('name')->get(),
        ]);
    }

    /** @return Responsable|Response */
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

    /** @return Responsable|Response */
    public function edit(DefectCategory $defectCategory)
    {
        return $this->renderAdminPage('Admin/Defects/Edit', [
            'defect' => $defectCategory,
            'brands' => Brand::orderBy('name')->get(),
        ]);
    }

    /** @return Responsable|Response */
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

    /** @return Responsable|Response */
    public function destroy(DefectCategory $defectCategory)
    {
        $defectCategory->delete();

        return redirect()->route('admin.defect-categories.index')->with('success', 'Kategori Defect berhasil dihapus.');
    }
}
