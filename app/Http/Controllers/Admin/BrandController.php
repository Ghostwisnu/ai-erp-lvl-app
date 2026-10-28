<?php

namespace App\Http\Controllers\Admin;

use App\Models\Brand;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class BrandController extends BaseAdminController
{
    public function index()
    {
        return $this->renderAdminPage('Admin/Brands/Index', [
            'brands' => Brand::withCount('sizeRuns')->latest()->paginate(10)
        ]);
    }

    public function create()
    {
        return $this->renderAdminPage('Admin/Brands/Create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:brands,name',
            'code' => 'required|string|max:255|unique:brands,code',
            'description' => 'nullable|string',
            'sizes' => 'required|array|min:1',
            'sizes.*' => 'required|string|max:50',
        ]);

        DB::transaction(function () use ($validated) {
            $brand = Brand::create([
                'name' => $validated['name'],
                'code' => $validated['code'],
                'description' => $validated['description'],
            ]);

            foreach ($validated['sizes'] as $index => $sizeName) {
                $brand->sizeRuns()->create([
                    'size_name' => $sizeName,
                    'order' => $index + 1,
                ]);
            }
        });

        return redirect()->route('admin.brands.index')->with('success', 'Brand berhasil dibuat.');
    }

    public function show(Brand $brand)
    {
        return $this->renderAdminPage('Admin/Brands/Show', [
            'brand' => $brand->load('sizeRuns')
        ]);
    }

    public function edit(Brand $brand)
    {
        return $this->renderAdminPage('Admin/Brands/Edit', [
            'brand' => $brand->load('sizeRuns')
        ]);
    }

    public function update(Request $request, Brand $brand)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:brands,name,' . $brand->id,
            'code' => 'required|string|max:255|unique:brands,code,' . $brand->id,
            'description' => 'nullable|string',
            'sizes' => 'required|array|min:1',
            'sizes.*' => 'required|string|max:50',
        ]);

        DB::transaction(function () use ($validated, $brand) {
            $brand->update([
                'name' => $validated['name'],
                'code' => $validated['code'],
                'description' => $validated['description'],
            ]);

            // Hapus size lama dan buat baru (cara paling simpel untuk update)
            $brand->sizeRuns()->delete();

            foreach ($validated['sizes'] as $index => $sizeName) {
                $brand->sizeRuns()->create([
                    'size_name' => $sizeName,
                    'order' => $index + 1,
                ]);
            }
        });

        return redirect()->route('admin.brands.index')->with('success', 'Brand berhasil diupdate.');
    }

    public function destroy(Brand $brand)
    {
        $brand->delete();
        return redirect()->route('admin.brands.index')->with('success', 'Brand berhasil dihapus.');
    }
}
