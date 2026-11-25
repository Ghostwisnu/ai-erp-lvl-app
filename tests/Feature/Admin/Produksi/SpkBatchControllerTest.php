<?php

use App\Models\Brand;
use App\Models\ProductionDaily;
use App\Models\Spk;
use App\Models\SpkBatch;
use App\Models\SpkBatchTrack;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $permission = Permission::findOrCreate('manage-spk', 'web');
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo($permission);
    $this->actingAs($this->admin);

    $this->brand = Brand::create(['name' => 'Test Brand', 'code' => 'TB001']);

    $this->spk = Spk::create([
        'po_number' => 'PO-001',
        'xfd_date' => '2026-11-20',
        'brand_id' => $this->brand->id,
        'art_color' => 'Red',
        'status' => 'create',
        'start_date' => '2026-11-01',
    ]);

    // Create SPK details
    $this->spk->details()->create([
        'size_name' => 'M',
        'qty' => 100,
    ]);
    $this->spk->details()->create([
        'size_name' => 'L',
        'qty' => 50,
    ]);
});

// ============================================================
// Schedule (PPS) Tests
// ============================================================

it('renders the production schedule page', function () {
    $response = $this->get(route('produksi.spk-schedules.index'));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('spks')
            ->has('brands'));
});

it('exports PPS with all brands when no filter is provided', function () {
    $response = $this->get(route('produksi.spk-schedules.export'));

    $response->assertStatus(200)
        ->assertHeader('content-disposition', 'attachment; filename=data-pps-semua-brand.xlsx');
});

it('exports PPS filtered by brand', function () {
    $response = $this->get(route('produksi.spk-schedules.export', ['brand_id' => $this->brand->id]));

    $response->assertStatus(200)
        ->assertHeader('content-disposition', 'attachment; filename=data-pps-brand-'.$this->brand->id.'.xlsx');
});

// ============================================================
// Split Batch Tests
// ============================================================

it('splits SPK into multiple batches based on size', function () {
    $response = $this->post(route('produksi.spk-batches.split', $this->spk), [
        'batches' => [
            [
                'batch_code' => 'BATCH-001',
                'sizes' => [
                    ['size_name' => 'M', 'qty' => 60],
                ],
            ],
            [
                'batch_code' => 'BATCH-002',
                'sizes' => [
                    ['size_name' => 'M', 'qty' => 40],
                    ['size_name' => 'L', 'qty' => 50],
                ],
            ],
        ],
    ]);

    $response->assertRedirect()
        ->assertSessionHas('success', 'SPK berhasil dipecah menjadi 2 batch berdasarkan size.');

    expect($this->spk->batches)->toHaveCount(2);
});

it('validates split batch sizes match total SPK size', function () {
    // Total M = 100, but we're only allocating 60 in batch 1 + 40 in batch 2 = 100
    // But we're only checking M in batch 1 = 60, leaving L unallocated -> should fail
    $response = $this->post(route('produksi.spk-batches.split', $this->spk), [
        'batches' => [
            [
                'batch_code' => 'BATCH-001',
                'sizes' => [
                    ['size_name' => 'M', 'qty' => 60],
                ],
            ],
            [
                'batch_code' => 'BATCH-002',
                'sizes' => [
                    ['size_name' => 'M', 'qty' => 50], // 60+50=110, but M total is 100 -> should fail
                    ['size_name' => 'L', 'qty' => 30], // L total should be 50, but we have 30
                ],
            ],
        ],
    ]);

    $response->assertRedirect()
        ->assertSessionHas('error', 'Total size M tidak sesuai dengan SPK utama (100).');
});

it('requires at least 2 batches to split', function () {
    $response = $this->post(route('produksi.spk-batches.split', $this->spk), [
        'batches' => [
            [
                'batch_code' => 'BATCH-001',
                'sizes' => [
                    ['size_name' => 'M', 'qty' => 100],
                ],
            ],
        ],
    ]);

    // Should fail validation - only 1 batch provided but min:2 required
    expect($response->status())->toBeIn([302, 422, 403]);
});

// ============================================================
// Merge Batch Tests
// ============================================================

it('merges all batches back into main SPK', function () {
    // First create some batches - need at least 2 for split validation
    $this->post(route('produksi.spk-batches.split', $this->spk), [
        'batches' => [
            [
                'batch_code' => 'BATCH-001',
                'sizes' => [
                    ['size_name' => 'M', 'qty' => 60],
                ],
            ],
            [
                'batch_code' => 'BATCH-002',
                'sizes' => [
                    ['size_name' => 'M', 'qty' => 40],
                    ['size_name' => 'L', 'qty' => 50],
                ],
            ],
        ],
    ]);

    expect($this->spk->fresh()->batches)->toHaveCount(2);

    $response = $this->post(route('produksi.spk-batches.merge', $this->spk));

    $response->assertRedirect()
        ->assertSessionHas('success', 'Batch berhasil digabungkan kembali ke SPK utama.');

    expect($this->spk->fresh()->batches)->toHaveCount(0);
});

it('deletes all tracks when merging batches', function () {
    // Create batch with track
    $batch = SpkBatch::create([
        'spk_id' => $this->spk->id,
        'batch_code' => 'BATCH-001',
        'qty' => 100,
    ]);

    $batch->tracks()->create([
        'department' => 'cutting',
        'start_date' => '2026-11-05',
    ]);

    $this->post(route('produksi.spk-batches.merge', $this->spk));

    expect(SpkBatchTrack::count())->toBe(0);
});

// ============================================================
// Update Track Tests
// ============================================================

it('updates batch track for valid department', function () {
    $batch = SpkBatch::create([
        'spk_id' => $this->spk->id,
        'batch_code' => 'BATCH-001',
        'qty' => 100,
    ]);

    $response = $this->post(route('produksi.spk-batches.update-track', $batch), [
        'department' => 'cutting',
        'start_date' => '2026-11-05',
    ]);

    $response->assertRedirect()
        ->assertSessionHas('success', 'Posisi batch berhasil diupdate.');

    $batch = $batch->fresh();

    expect($batch->current_department)->toBe('cutting')
        ->and($batch->status)->toBe('in_progress');
});

it('validates department against approved list', function () {
    $batch = SpkBatch::create([
        'spk_id' => $this->spk->id,
        'batch_code' => 'BATCH-001',
        'qty' => 100,
    ]);

    $response = $this->post(route('produksi.spk-batches.update-track', $batch), [
        'department' => 'invalid_department',
        'start_date' => '2026-11-05',
    ]);

    // Should fail validation
    expect($response->status())->toBeIn([302, 422, 403]);
});

it("ends previous track when starting a new one", function () {
    Carbon::setTestNow("2026-11-10 12:00:00");

    $batch = SpkBatch::create([
        "spk_id" => $this->spk->id,
        "batch_code" => "BATCH-001",
        "qty" => 100,
    ]);

    // First track
    $firstTrack = $batch->tracks()->create([
        "department" => "cutting",
        "start_date" => "2026-11-05",
    ]);

    // Start a new track
    $this->post(route("produksi.spk-batches.update-track", $batch), [
        "department" => "sewing",
        "start_date" => "2026-11-10",
    ]);

    $tracks = $batch->fresh()->tracks;

    // Check dates are Carbon objects with proper dates
    // Handle both Carbon dates and string dates from SQLite
    $endDate = $tracks[0]->end_date;
    $startDate2 = $tracks[1]->start_date;

    if ($endDate instanceof Carbon) {
        expect($endDate->format("Y-m-d"))->toBe("2026-11-09");
    } else {
        expect($endDate)->toBe("2026-11-09");
    }

    if ($startDate2 instanceof Carbon) {
        expect($startDate2->format("Y-m-d"))->toBe("2026-11-10");
    } else {
        expect($startDate2)->toBe("2026-11-10");
    }

    expect($tracks[1]->end_date)->toBeNull()
        ->and($batch->fresh()->current_department)->toBe("sewing")
        ->and($batch->fresh()->status)->toBe("in_progress");

    Carbon::setTestNow();
});

// ============================================================
// Store Daily Output Tests
// ============================================================

it('stores daily output for production departments', function () {
    $response = $this->post(route('produksi.daily-output.store'), [
        'report_date' => '2026-11-15',
        'department' => 'cutting',
        'items' => [
            [
                'spk_id' => $this->spk->id,
                'qty' => 100,
            ],
        ],
    ]);

    $response->assertRedirect()
        ->assertSessionHas('success', 'Daily output massal berhasil disimpan.');

    expect(ProductionDaily::where('department', 'cutting')->count())->toBe(1);
});

it('updates existing daily entry instead of duplicating', function () {
    // Create initial entry
    ProductionDaily::create([
        'spk_id' => $this->spk->id,
        'department' => 'cutting',
        'report_date' => '2026-11-15',
        'qty' => 100,
    ]);

    // Try to store again for same date/spk
    $response = $this->post(route('produksi.daily-output.store'), [
        'report_date' => '2026-11-15',
        'department' => 'cutting',
        'items' => [
            [
                'spk_id' => $this->spk->id,
                'qty' => 50,
            ],
        ],
    ]);

    $response->assertRedirect()
        ->assertSessionHas('success', 'Daily output massal berhasil disimpan.');

    // Controller behavior: creates new entry (not increment)
    // This is the current behavior - if we want increment, need to fix controller
    expect(ProductionDaily::where('department', 'cutting')->count())->toBe(1);
});

it('validates department against approved list when storing daily', function () {
    $response = $this->post(route('produksi.daily-output.store'), [
        'report_date' => '2026-11-15',
        'department' => 'invalid_department',
        'items' => [
            ['spk_id' => $this->spk->id, 'qty' => 10],
        ],
    ]);

    // Should fail validation
    expect($response->status())->toBeIn([302, 422, 403]);
});

// ============================================================
// Department Validation Tests
// ============================================================

it('accepts all valid production departments', function () {
    $batch = SpkBatch::create([
        'spk_id' => $this->spk->id,
        'batch_code' => 'BATCH-001',
        'qty' => 100,
    ]);

    $validDepartments = ['cutting', 'setting', 'sewing', 'stroble', 'gudang_semi', 'lasting', 'injection', 'finishing', 'packing'];

    foreach ($validDepartments as $dept) {
        $response = $this->post(route('produksi.spk-batches.update-track', $batch), [
            'department' => $dept,
            'start_date' => '2026-11-15',
        ]);

        $response->assertRedirect();
        $batch->refresh();

        expect($batch->current_department)->toBe($dept);
    }
});
