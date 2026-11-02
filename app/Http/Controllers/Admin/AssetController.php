<?php

namespace App\Http\Controllers\Admin;

use App\Models\Asset;
use App\Models\AssetCategory;
use App\Models\AssetLocation;
use App\Models\AssetMaintenance;
use App\Models\AssetMovement;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\StreamedResponse;

class AssetController extends BaseAdminController
{
    public function index(Request $request)
    {
        $assets = Asset::query()
            ->with(['category:id,name', 'location:id,name', 'assignee:id,name'])
            ->when($request->filled('search'), function ($query) use ($request) {
                $search = $request->string('search')->trim()->toString();
                $query->where(function ($query) use ($search) {
                    $query->where('code', 'like', "%{$search}%")
                        ->orWhere('name', 'like', "%{$search}%")
                        ->orWhere('serial_number', 'like', "%{$search}%");
                });
            })
            ->when($request->filled('status'), fn ($query) => $query->where('status', $request->string('status')))
            ->when($request->filled('category'), fn ($query) => $query->where('asset_category_id', $request->integer('category')))
            ->latest()
            ->paginate(15)
            ->withQueryString();

        $assets->getCollection()->each(fn (Asset $asset) => $asset->append('current_book_value'));

        return $this->renderAdminPage('Admin/Assets/Index', [
            'assets' => $assets,
            'categories' => AssetCategory::query()->orderBy('name')->get(['id', 'name']),
            'filters' => $request->only('search', 'status', 'category'),
        ]);
    }

    public function create()
    {
        return $this->renderAdminPage('Admin/Assets/Create', $this->formOptions());
    }

    public function store(Request $request)
    {
        $validated = $request->validate($this->assetRules());
        $asset = Asset::create($validated);

        return to_route('admin.assets.show', $asset)->with('success', 'Aset berhasil ditambahkan.');
    }

    public function show(Asset $asset)
    {
        $asset->load([
            'category:id,name',
            'location:id,name',
            'assignee:id,name',
            'movements.fromUser:id,name',
            'movements.toUser:id,name',
            'movements.fromLocation:id,name',
            'movements.toLocation:id,name',
            'maintenances.performer:id,name',
        ])->append('current_book_value');

        return $this->renderAdminPage('Admin/Assets/Show', [
            'asset' => $asset,
            ...$this->formOptions(),
        ]);
    }

    public function edit(Asset $asset)
    {
        return $this->renderAdminPage('Admin/Assets/Edit', [
            'asset' => $asset,
            ...$this->formOptions(),
        ]);
    }

    public function update(Request $request, Asset $asset)
    {
        $asset->update($request->validate($this->assetRules($asset)));

        return to_route('admin.assets.show', $asset)->with('success', 'Aset berhasil diperbarui.');
    }

    public function destroy(Asset $asset)
    {
        $asset->delete();

        return to_route('admin.assets.index')->with('success', 'Aset berhasil dihapus.');
    }

    public function assign(Request $request, Asset $asset)
    {
        $validated = $request->validate([
            'assigned_to' => ['nullable', 'integer', 'exists:users,id'],
            'asset_location_id' => ['nullable', 'integer', 'exists:asset_locations,id'],
            'notes' => ['nullable', 'string', 'max:2000'],
        ]);

        DB::transaction(function () use ($request, $asset, $validated) {
            $asset = Asset::query()->lockForUpdate()->findOrFail($asset->id);
            $fromUser = $asset->assigned_to;
            $fromLocation = $asset->asset_location_id;
            $toUser = array_key_exists('assigned_to', $validated) && $validated['assigned_to'] !== null
                ? (int) $validated['assigned_to']
                : (array_key_exists('assigned_to', $validated) ? null : $fromUser);
            $toLocation = array_key_exists('asset_location_id', $validated) && $validated['asset_location_id'] !== null
                ? (int) $validated['asset_location_id']
                : (array_key_exists('asset_location_id', $validated) ? null : $fromLocation);

            if ($fromUser === $toUser && $fromLocation === $toLocation) {
                throw ValidationException::withMessages([
                    'assigned_to' => 'Pilih penanggung jawab atau lokasi yang berbeda.',
                ]);
            }

            $action = $fromUser !== $toUser
                ? ($fromUser === null ? 'assigned' : ($toUser === null ? 'returned' : 'transferred'))
                : 'location_changed';

            $asset->update([
                'assigned_to' => $toUser,
                'asset_location_id' => $toLocation,
            ]);

            AssetMovement::create([
                'asset_id' => $asset->id,
                'action' => $action,
                'from_user_id' => $fromUser,
                'to_user_id' => $toUser,
                'from_location_id' => $fromLocation,
                'to_location_id' => $toLocation,
                'performed_by' => $request->user()->id,
                'notes' => $validated['notes'] ?? null,
                'occurred_at' => now(),
            ]);
        });

        return to_route('admin.assets.show', $asset)->with('success', 'Penanggung jawab atau lokasi aset berhasil diperbarui.');
    }

    public function storeMaintenance(Request $request, Asset $asset)
    {
        $validated = $request->validate([
            'service_date' => ['required', 'date', 'before_or_equal:today'],
            'service_type' => ['required', Rule::in(['preventive', 'corrective', 'inspection', 'other'])],
            'vendor' => ['nullable', 'string', 'max:255'],
            'description' => ['required', 'string', 'max:5000'],
            'cost' => ['required', 'numeric', 'min:0'],
            'next_service_date' => ['nullable', 'date', 'after_or_equal:service_date'],
            'status' => ['required', Rule::in(['completed', 'in_progress'])],
        ]);

        DB::transaction(function () use ($request, $asset, $validated) {
            AssetMaintenance::create([
                ...$validated,
                'asset_id' => $asset->id,
                'performed_by' => $request->user()->id,
            ]);

            if ($validated['status'] === 'in_progress') {
                $asset->update(['status' => 'maintenance']);
            } elseif ($asset->status === 'maintenance') {
                $asset->update(['status' => 'in_service']);
            }
        });

        return to_route('admin.assets.show', $asset)->with('success', 'Riwayat perawatan aset berhasil dicatat.');
    }

    public function reports()
    {
        $assets = Asset::with(['category:id,name', 'location:id,name', 'assignee:id,name'])
            ->orderBy('code')
            ->get()
            ->each(fn (Asset $asset) => $asset->append('current_book_value'));

        return $this->renderAdminPage('Admin/Assets/Reports', [
            'assets' => $assets,
            'summary' => [
                'assetCount' => $assets->count(),
                'acquisitionTotal' => round($assets->sum('acquisition_cost'), 2),
                'bookValueTotal' => round($assets->sum('current_book_value'), 2),
                'maintenanceTotal' => round(AssetMaintenance::sum('cost'), 2),
            ],
        ]);
    }

    public function export(): StreamedResponse
    {
        $assets = Asset::with(['category:id,name', 'location:id,name', 'assignee:id,name'])
            ->orderBy('code')
            ->get();

        return response()->streamDownload(function () use ($assets) {
            $output = fopen('php://output', 'w');
            fputcsv($output, ['Kode', 'Nama', 'Kategori', 'Lokasi', 'Penanggung Jawab', 'Status', 'Tanggal Perolehan', 'Nilai Perolehan', 'Nilai Buku']);

            foreach ($assets as $asset) {
                fputcsv($output, [
                    $asset->code,
                    $asset->name,
                    $asset->category->name,
                    $asset->location?->name ?? '',
                    $asset->assignee?->name ?? '',
                    $asset->status,
                    $asset->acquisition_date->toDateString(),
                    $asset->acquisition_cost,
                    $asset->current_book_value,
                ]);
            }

            fclose($output);
        }, 'laporan-aset.csv', ['Content-Type' => 'text/csv; charset=UTF-8']);
    }

    private function assetRules(?Asset $asset = null): array
    {
        return [
            'code' => ['required', 'string', 'max:50', Rule::unique('assets', 'code')->ignore($asset?->id)],
            'name' => ['required', 'string', 'max:255'],
            'asset_category_id' => ['required', 'integer', 'exists:asset_categories,id'],
            'asset_location_id' => ['nullable', 'integer', 'exists:asset_locations,id'],
            'serial_number' => ['nullable', 'string', 'max:100', Rule::unique('assets', 'serial_number')->ignore($asset?->id)],
            'brand' => ['nullable', 'string', 'max:100'],
            'model' => ['nullable', 'string', 'max:100'],
            'acquisition_date' => ['required', 'date', 'before_or_equal:today'],
            'acquisition_cost' => ['required', 'numeric', 'min:0'],
            'salvage_value' => ['required', 'numeric', 'min:0', 'lte:acquisition_cost'],
            'useful_life_months' => ['required', 'integer', 'min:1', 'max:1200'],
            'condition' => ['required', Rule::in(['good', 'fair', 'poor'])],
            'status' => ['required', Rule::in(['in_service', 'maintenance', 'retired'])],
            'description' => ['nullable', 'string', 'max:5000'],
        ];
    }

    private function formOptions(): array
    {
        return [
            'categories' => AssetCategory::query()->orderBy('name')->get(['id', 'name']),
            'locations' => AssetLocation::query()->orderBy('name')->get(['id', 'name']),
            'users' => User::query()->orderBy('name')->get(['id', 'name']),
        ];
    }
}
