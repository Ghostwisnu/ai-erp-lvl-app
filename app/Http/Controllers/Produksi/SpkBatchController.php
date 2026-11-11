<?php

namespace App\Http\Controllers\Produksi;

use App\Exports\PpsExport;
use App\Http\Controllers\Admin\BaseAdminController;
use App\Models\Brand;
use App\Models\ProductionDaily;
use App\Models\Spk;
use App\Models\SpkBatch;
use App\Models\SpkBatchTrack;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\HttpFoundation\Response;

class SpkBatchController extends BaseAdminController
{
    // 1. Halaman Daftar Batch per SPK
    public function index(Spk $spk): Response|Responsable
    {
        $spk->load(['batches.tracks', 'details', 'brand']);

        return $this->renderAdminPage('Produksi/Batch/Index', [
            'spk' => $spk,
        ]);
    }

    // 2. Proses Pecah Batch Berdasarkan Size
    public function split(Request $request, Spk $spk): Response|Responsable
    {
        $validated = $request->validate([
            'batches' => 'required|array|min:2',
            'batches.*.batch_code' => 'required|string|max:50',
            'batches.*.sizes' => 'required|array',
            'batches.*.sizes.*.size_name' => 'required|string',
            'batches.*.sizes.*.qty' => 'required|integer|min:0',
        ]);
        $batches = $this->validatedBatches($validated['batches'] ?? null);

        $spkSizes = $spk->details->pluck('qty', 'size_name')->toArray();

        $batchSizesTotal = [];
        foreach ($batches as $batch) {
            foreach ($batch['sizes'] as $size) {
                $batchSizesTotal[$size['size_name']] = ($batchSizesTotal[$size['size_name']] ?? 0) + $size['qty'];
            }
        }

        foreach ($spkSizes as $sizeName => $qty) {
            if (($batchSizesTotal[$sizeName] ?? 0) !== $qty) {
                return back()->with('error', "Total size $sizeName tidak sesuai dengan SPK utama ($qty).");
            }
        }

        DB::transaction(function () use ($spk, $batches) {
            foreach ($batches as $batchData) {
                $totalQty = array_sum(array_column($batchData['sizes'], 'qty'));

                $spk->batches()->create([
                    'batch_code' => $batchData['batch_code'],
                    'qty' => $totalQty,
                    'sizes' => $batchData['sizes'], // handled by $casts = ['sizes' => 'array']
                    'status' => 'pending',
                ]);
            }
        });

        return back()->with('success', 'SPK berhasil dipecah menjadi '.count($batches).' batch berdasarkan size.');
    }

    // 3. Proses Gabung Batch (Merge)
    public function merge(Spk $spk): Response|Responsable
    {
        DB::transaction(function () use ($spk) {
            SpkBatchTrack::whereIn('spk_batch_id', $spk->batches()->pluck('id'))->delete();
            $spk->batches()->delete();
        });

        return back()->with('success', 'Batch berhasil digabungkan kembali ke SPK utama.');
    }

    // 4. Update Posisi/Status Produksi Batch
    public function updateTrack(Request $request, SpkBatch $batch): Response|Responsable
    {
        $request->validate([
            'department' => 'required|in:cutting,setting,sewing,stroble,gudang_semi,lasting,injection,finishing,packing',
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
    public function schedule(): Response|Responsable
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
            'brands' => Brand::query()->orderBy('name')->get(['id', 'name']),
        ]);
    }

    public function exportSchedule(Request $request): Response|Responsable
    {
        $validated = $request->validate([
            'brand_id' => 'nullable|integer|exists:brands,id',
        ]);
        $brandId = isset($validated['brand_id']) ? (int) $validated['brand_id'] : null;
        $filename = $brandId
            ? "data-pps-brand-{$brandId}.xlsx"
            : 'data-pps-semua-brand.xlsx';

        return Excel::download(new PpsExport($brandId), $filename);
    }

    // 6. Simpan Daily Output Massal
    public function storeDaily(Request $request): Response|Responsable
    {
        $request->validate([
            'report_date' => 'required|date',
            'department' => 'required|in:cutting,setting,sewing,stroble,gudang_semi,lasting,injection,finishing,packing',
            'items' => 'required|array',
            'items.*.spk_id' => 'required|exists:spks,id',
            'items.*.spk_batch_id' => 'nullable|exists:spk_batches,id',
            'items.*.qty' => 'required|integer|min:0',
        ]);

        DB::transaction(function () use ($request) {
            foreach ($request->items as $item) {
                if ($item['qty'] <= 0) {
                    continue;
                }

                $existing = ProductionDaily::where('department', $request->department)
                    ->where('report_date', $request->report_date)
                    ->when($item['spk_batch_id'], fn ($q) => $q->where('spk_batch_id', $item['spk_batch_id']))
                    ->when(! $item['spk_batch_id'], fn ($q) => $q->where('spk_id', $item['spk_id'])->whereNull('spk_batch_id'))
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
    public function destroyDaily(ProductionDaily $daily): Response|Responsable
    {
        $daily->delete();

        return back()->with('success', 'Daily output berhasil dihapus.');
    }

    /**
     * @return list<array{batch_code: string, sizes: list<array{size_name: string, qty: int}>}>
     */
    private function validatedBatches(mixed $batches): array
    {
        if (! is_array($batches)) {
            abort(422);
        }

        $result = [];
        foreach ($batches as $batch) {
            if (! is_array($batch) || ! is_string($batch['batch_code'] ?? null)) {
                abort(422);
            }

            $sizes = $batch['sizes'] ?? null;
            if (! is_array($sizes)) {
                abort(422);
            }

            $validatedSizes = [];
            foreach ($sizes as $size) {
                if (
                    ! is_array($size)
                    || ! is_string($size['size_name'] ?? null)
                    || ! is_int($size['qty'] ?? null)
                ) {
                    abort(422);
                }

                $validatedSizes[] = [
                    'size_name' => $size['size_name'],
                    'qty' => $size['qty'],
                ];
            }

            $result[] = [
                'batch_code' => $batch['batch_code'],
                'sizes' => $validatedSizes,
            ];
        }

        return $result;
    }
}
