<?php

namespace App\Http\Controllers\Admin;

use App\Models\AssetCategory;
use App\Models\AssetLocation;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\Response;

class AssetCatalogController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        return $this->renderAdminPage('Admin/Assets/Catalog', [
            'categories' => AssetCategory::withCount('assets')->orderBy('name')->get(),
            'locations' => AssetLocation::withCount('assets')->orderBy('name')->get(),
        ]);
    }

    /** @return Responsable|Response */
    public function storeCategory(Request $request)
    {
        AssetCategory::create($request->validate([
            'name' => ['required', 'string', 'max:255', 'unique:asset_categories,name'],
            'description' => ['nullable', 'string', 'max:2000'],
        ]));

        return back()->with('success', 'Kategori aset berhasil ditambahkan.');
    }

    /** @return Responsable|Response */
    public function updateCategory(Request $request, AssetCategory $assetCategory)
    {
        $assetCategory->update($request->validate([
            'name' => ['required', 'string', 'max:255', Rule::unique('asset_categories', 'name')->ignore($assetCategory->id)],
            'description' => ['nullable', 'string', 'max:2000'],
        ]));

        return back()->with('success', 'Kategori aset berhasil diperbarui.');
    }

    /** @return Responsable|Response */
    public function destroyCategory(AssetCategory $assetCategory)
    {
        if ($assetCategory->assets()->exists()) {
            return back()->with('error', 'Kategori tidak dapat dihapus karena masih digunakan aset.');
        }

        $assetCategory->delete();

        return back()->with('success', 'Kategori aset berhasil dihapus.');
    }

    /** @return Responsable|Response */
    public function storeLocation(Request $request)
    {
        AssetLocation::create($request->validate([
            'name' => ['required', 'string', 'max:255', 'unique:asset_locations,name'],
            'description' => ['nullable', 'string', 'max:2000'],
        ]));

        return back()->with('success', 'Lokasi aset berhasil ditambahkan.');
    }

    /** @return Responsable|Response */
    public function updateLocation(Request $request, AssetLocation $assetLocation)
    {
        $assetLocation->update($request->validate([
            'name' => ['required', 'string', 'max:255', Rule::unique('asset_locations', 'name')->ignore($assetLocation->id)],
            'description' => ['nullable', 'string', 'max:2000'],
        ]));

        return back()->with('success', 'Lokasi aset berhasil diperbarui.');
    }

    /** @return Responsable|Response */
    public function destroyLocation(AssetLocation $assetLocation)
    {
        if ($assetLocation->assets()->exists()) {
            return back()->with('error', 'Lokasi tidak dapat dihapus karena masih digunakan aset.');
        }

        $assetLocation->delete();

        return back()->with('success', 'Lokasi aset berhasil dihapus.');
    }
}
