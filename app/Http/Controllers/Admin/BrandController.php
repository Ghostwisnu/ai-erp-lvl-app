<?php

namespace App\Http\Controllers\Admin;

use App\Models\Brand;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response;

class BrandController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        return $this->renderAdminPage('Admin/Brands/Index', [
            'brands' => Brand::withCount('sizeRuns')->latest()->paginate(10),
        ]);
    }

    /** @return Responsable|Response */
    public function create()
    {
        return $this->renderAdminPage('Admin/Brands/Create');
    }

    /** @return Responsable|Response */
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

    /** @return Responsable|Response */
    public function show(Brand $brand)
    {
        return $this->renderAdminPage('Admin/Brands/Show', [
            'brand' => $brand->load('sizeRuns'),
        ]);
    }

    /** @return Responsable|Response */
    public function edit(Brand $brand)
    {
        return $this->renderAdminPage('Admin/Brands/Edit', [
            'brand' => $brand->load('sizeRuns'),
        ]);
    }

    /** @return Responsable|Response */
    public function update(Request $request, Brand $brand)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:brands,name,'.$brand->id,
            'code' => 'required|string|max:255|unique:brands,code,'.$brand->id,
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

    /** @return Responsable|Response */
    public function destroy(Brand $brand)
    {
        $brand->delete();

        return redirect()->route('admin.brands.index')->with('success', 'Brand berhasil dihapus.');
    }
}
