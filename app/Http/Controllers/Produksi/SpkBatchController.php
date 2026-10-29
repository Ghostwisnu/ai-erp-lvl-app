<?php

namespace App\Http\Controllers\Produksi;

use App\Http\Controllers\Admin\BaseAdminController;
use App\Models\Spk;
use App\Models\SpkBatch;
use App\Models\SpkBatchTrack;
use App\Models\ProductionDaily;
use App\Models\ProductionScan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SpkBatchController extends BaseAdminController
{
    // 1. Halaman Daftar Batch per SPK
    public function index(Spk $spk)
    {
        $spk->load(['batches.tracks', 'details', 'brand']);
        return $this->renderAdminPage('Produksi/Batch/Index', [
            'spk' => $spk,
        ]);
    }

    // 2. Proses Pecah Batch Berdasarkan Size
    public function split(Request $request, Spk $spk)
    {
        $request->validate([
            'batches' => 'required|array|min:2',
            'batches.*.batch_code' => 'required|string|max:50',
            'batches.*.sizes' => 'required|array',
            'batches.*.sizes.*.size_name' => 'required|string',
            'batches.*.sizes.*.qty' => 'required|integer|min:0',
        ]);

        $spkSizes = $spk->details->pluck('qty', 'size_name')->toArray();

        $batchSizesTotal = [];
        foreach ($request->batches as $batch) {
            foreach ($batch['sizes'] as $size) {
                $batchSizesTotal[$size['size_name']] = ($batchSizesTotal[$size['size_name']] ?? 0) + $size['qty'];
            }
        }

        foreach ($spkSizes as $sizeName => $qty) {
            if (($batchSizesTotal[$sizeName] ?? 0) !== $qty) {
                return back()->with('error', "Total size $sizeName tidak sesuai dengan SPK utama ($qty).");
            }
        }

        DB::transaction(function () use ($spk, $request) {
            foreach ($request->batches as $batchData) {
                $totalQty = collect($batchData['sizes'])->sum('qty');

                $spk->batches()->create([
                    'batch_code' => $batchData['batch_code'],
                    'qty' => $totalQty,
                    'sizes' => $batchData['sizes'], // handled by $casts = ['sizes' => 'array']
                    'status' => 'pending',
                ]);
            }
        });

        return back()->with('success', 'SPK berhasil dipecah menjadi ' . count($request->batches) . ' batch berdasarkan size.');
    }

    // 3. Proses Gabung Batch (Merge)
    public function merge(Spk $spk)
    {
        DB::transaction(function () use ($spk) {
            SpkBatchTrack::whereIn('spk_batch_id', $spk->batches()->pluck('id'))->delete();
            $spk->batches()->delete();
        });

        return back()->with('success', 'Batch berhasil digabungkan kembali ke SPK utama.');
    }

    // 4. Update Posisi/Status Produksi Batch
    public function updateTrack(Request $request, SpkBatch $batch)
    {
        $request->validate([
            'department' => 'required|in:cutting,sewing,lasting,cementing,injection,finishing,packing',
            'start_date' => 'required|date',
        ]);

        DB::transaction(function () use ($batch, $request) {
            $batch->tracks()->whereNull('end_date')->update(['end_date' => now()->toDateString()]);
            $batch->tracks()->create([
                'department' => $request->department,
                'start_date' => $request->start_date,
            ]);
            $batch->update([
                'current_department' => $request->department,
                'status' => 'in_progress',
            ]);
        });

        return back()->with('success', 'Posisi batch berhasil diupdate.');
    }

    // 5. Halaman PPS
    public function schedule()
    {
        $spks = Spk::with(['brand', 'batches.tracks', 'batches.dailies', 'details', 'dailies'])
            ->orderBy('brand_id')
            ->orderBy('xfd_date', 'asc')
            ->get();

        // Ambil data scan finishing per SPK dan per Size
        $finishingScans = DB::table('production_scans as ps')
            ->join('spk_details as d', 'd.id', '=', 'ps.spk_detail_id')
            ->where('ps.department', 'finishing')
            ->select(
                'd.spk_id',
                'd.size_name', // <-- Tambahkan size_name
                DB::raw('COUNT(*) as total_scan'),
                DB::raw('MAX(ps.created_at) as last_scan')
            )
            ->groupBy('d.spk_id', 'd.size_name') // <-- Group by SPK & Size
            ->get();

        // Format ulang data agar mudah dibaca di View: $finishingScans[spk_id][size_name]
        $scanResults = [];
        foreach ($finishingScans as $scan) {
            $scanResults[$scan->spk_id][$scan->size_name] = $scan;
        }

        return $this->renderAdminPage('Produksi/Batch/Schedule', [
            'spks' => $spks,
            'finishingScans' => $scanResults, // Data scan terstruktur
        ]);
    }

    // 6. Simpan Daily Output Massal
    public function storeDaily(Request $request)
    {
        $request->validate([
            'report_date' => 'required|date',
            'department' => 'required|in:cutting,sewing,lasting,cementing,injection,finishing,packing',
            'items' => 'required|array',
            'items.*.spk_id' => 'required|exists:spks,id',
            'items.*.spk_batch_id' => 'nullable|exists:spk_batches,id',
            'items.*.qty' => 'required|integer|min:0',
        ]);

        DB::transaction(function () use ($request) {
            foreach ($request->items as $item) {
                if ($item['qty'] <= 0) continue;

                $existing = ProductionDaily::where('department', $request->department)
                    ->where('report_date', $request->report_date)
                    ->when($item['spk_batch_id'], fn($q) => $q->where('spk_batch_id', $item['spk_batch_id']))
                    ->when(!$item['spk_batch_id'], fn($q) => $q->where('spk_id', $item['spk_id'])->whereNull('spk_batch_id'))
                    ->first();

                if ($existing) {
                    $existing->increment('qty', $item['qty']);
                } else {
                    ProductionDaily::create([
                        'spk_id' => $item['spk_id'],
                        'spk_batch_id' => $item['spk_batch_id'],
                        'department' => $request->department,
                        'report_date' => $request->report_date,
                        'qty' => $item['qty'],
                    ]);
                }
            }
        });

        return back()->with('success', 'Daily output massal berhasil disimpan.');
    }

    // 7. Hapus Daily Output
    public function destroyDaily(ProductionDaily $daily)
    {
        $daily->delete();
        return back()->with('success', 'Daily output berhasil dihapus.');
    }
}
