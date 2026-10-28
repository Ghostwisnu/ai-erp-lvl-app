<?php

namespace App\Http\Controllers\Produksi;

use App\Http\Controllers\Admin\BaseAdminController;
use App\Models\Brand;
use App\Models\Spk;
use App\Models\SpkDetail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class SpkController extends BaseAdminController
{
    public function index()
    {
        $spks = Spk::with('brand')->withSum('details', 'qty')->latest()->paginate(10);
        return $this->renderAdminPage('Produksi/Spk/Index', ['spks' => $spks]);
    }

    public function create()
    {
        $brands = Brand::with('sizeRuns')->orderBy('name')->get();
        return $this->renderAdminPage('Produksi/Spk/Create', ['brands' => $brands]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'po_number' => 'required|string|unique:spks,po_number',
            'xfd_date' => 'required|date',
            'brand_id' => 'required|exists:brands,id',
            'art_color' => 'required|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
            'details' => 'required|array',
            'details.*.size_name' => 'required|string',
            'details.*.qty' => 'required|integer|min:0',
            'details.*.barcode' => 'nullable|string|max:255',
        ]);

        DB::transaction(function () use ($validated, $request) {
            $imagePath = null;
            if ($request->hasFile('image')) {
                $imagePath = $request->file('image')->store('spk_images', 'public');
            }

            $spk = Spk::create([
                'po_number' => $validated['po_number'],
                'xfd_date' => $validated['xfd_date'],
                'brand_id' => $validated['brand_id'],
                'art_color' => $validated['art_color'],
                'image_path' => $imagePath,
                'status' => 'create', // Pastikan default status create
            ]);

            foreach ($validated['details'] as $detail) {
                if ($detail['qty'] > 0) {
                    $spk->details()->create([
                        'size_name' => $detail['size_name'],
                        'qty' => $detail['qty'],
                        'barcode' => $detail['barcode'] ?? null,
                    ]);
                }
            }
        });

        return redirect()->route('produksi.spks.index')->with('success', 'SPK berhasil dibuat.');
    }

    public function show(Spk $spk)
    {
        return $this->renderAdminPage('Produksi/Spk/Show', ['spk' => $spk->load('brand', 'details')]);
    }

    public function edit(Spk $spk)
    {
        $brands = Brand::with('sizeRuns')->orderBy('name')->get();
        return $this->renderAdminPage('Produksi/Spk/Edit', [
            'spk' => $spk->load('details'),
            'brands' => $brands
        ]);
    }

    public function update(Request $request, Spk $spk)
    {
        $validated = $request->validate([
            'po_number' => 'required|string|unique:spks,po_number,' . $spk->id,
            'xfd_date' => 'required|date',
            'brand_id' => 'required|exists:brands,id',
            'art_color' => 'required|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
            'details' => 'required|array',
            'details.*.size_name' => 'required|string',
            'details.*.qty' => 'required|integer|min:0',
            'details.*.barcode' => 'nullable|string|max:255',
        ]);

        DB::transaction(function () use ($validated, $spk, $request) {
            $imagePath = $spk->image_path;

            if ($request->hasFile('image')) {
                if ($spk->image_path) {
                    Storage::disk('public')->delete($spk->image_path);
                }
                $imagePath = $request->file('image')->store('spk_images', 'public');
            }

            $spk->update([
                'po_number' => $validated['po_number'],
                'xfd_date' => $validated['xfd_date'],
                'brand_id' => $validated['brand_id'],
                'art_color' => $validated['art_color'],
                'image_path' => $imagePath,
            ]);

            $spk->details()->delete();

            foreach ($validated['details'] as $detail) {
                if ($detail['qty'] > 0) {
                    $spk->details()->create([
                        'size_name' => $detail['size_name'],
                        'qty' => $detail['qty'],
                        'barcode' => $detail['barcode'] ?? null,
                    ]);
                }
            }
        });

        return redirect()->route('produksi.spks.index')->with('success', 'SPK berhasil diupdate.');
    }

    public function destroy(Spk $spk)
    {
        if ($spk->image_path) {
            Storage::disk('public')->delete($spk->image_path);
        }
        $spk->delete();
        return redirect()->route('produksi.spks.index')->with('success', 'SPK berhasil dihapus.');
    }

    public function printBarcode(Spk $spk)
    {
        return $this->renderAdminPage('Produksi/Spk/PrintBarcode', [
            'spk' => $spk->load('brand', 'details')
        ]);
    }

    // METHOD BARU UNTUK UPDATE STATUS
    public function updateStatus(Request $request, Spk $spk)
    {
        $request->validate([
            'status' => 'required|in:create,active,finished,closed'
        ]);

        $spk->update(['status' => $request->status]);

        return redirect()->back()->with('success', 'Status SPK berhasil diubah menjadi ' . strtoupper($request->status));
    }
}
