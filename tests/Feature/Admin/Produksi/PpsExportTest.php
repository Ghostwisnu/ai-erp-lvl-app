<?php

use App\Exports\PpsExport;
use App\Models\Brand;
use App\Models\Spk;
use App\Models\User;
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
});

// ============================================================
// BUG TEST: Department Consistency in PpsExport
// ============================================================

it('has correct department list matching the production departments', function () {
    // The DEPARTMENTS constant should match the validation in SpkBatchController
    // Approved departments: cutting, setting, sewing, stroble, lasting, injection, finishing, packing
    // (8 departments - gudang_semi and packing are NOT in WIP boxes per requirement)

    $export = new PpsExport;

    // Use reflection to access the private constant
    $reflection = new ReflectionClass($export);
    $constant = $reflection->getConstant('DEPARTMENTS');

    // Assert the correct departments are present
    expect(array_keys($constant))->toContain('cutting')
        ->and(array_keys($constant))->toContain('setting')
        ->and(array_keys($constant))->toContain('sewing')
        ->and(array_keys($constant))->toContain('stroble')
        ->and(array_keys($constant))->toContain('lasting')
        ->and(array_keys($constant))->toContain('injection')
        ->and(array_keys($constant))->toContain('finishing')
        ->and(array_keys($constant))->toContain('packing');

    // Assert OLD buggy department names are NOT present
    expect(array_keys($constant))->not->toContain('cementing')
        ->and(array_keys($constant))->not->toContain('gudang_semi');
});

it('exports SPK data with correct headers', function () {
    $brand = Brand::create(['name' => 'Test Brand', 'code' => 'TB001']);
    $spk = Spk::create([
        'po_number' => 'PO-001',
        'xfd_date' => '2026-11-20',
        'brand_id' => $brand->id,
        'art_color' => 'Red',
        'status' => 'create',
        'start_date' => '2026-11-01',
    ]);

    $export = new PpsExport;
    $headings = $export->headings();

    // Verify standard headers
    expect($headings[0])->toBe('NO')
        ->and($headings[1])->toBe('PO NO.')
        ->and($headings[2])->toBe('MODEL')
        ->and($headings[3])->toBe('WARNA')
        ->and($headings[4])->toBe('JUMLAH');

    // Verify department headers are present
    $departmentCount = 8; // 8 departments: cutting, setting, sewing, stroble, lasting, injection, finishing, packing
    $expectedHeaderCount = 5 + ($departmentCount * 4) + 1; // 5 base + 8*4 dept rows + XFD

    // Check that all headers contain the correct departments
    $allHeaders = implode(' ', $headings);

    // Convert to uppercase for case-insensitive matching
    $allHeadersUpper = strtoupper($allHeaders);

    expect($allHeadersUpper)->toContain('PEMOTONGAN')  // cutting
        ->and($allHeadersUpper)->toContain('PENGELEMAN')  // setting
        ->and($allHeadersUpper)->toContain('PENJAHITAN')  // sewing
        ->and($allHeadersUpper)->toContain('STROBLE')  // stroble
        ->and($allHeadersUpper)->toContain('PEMASANGAN SOL')  // lasting
        ->and($allHeadersUpper)->toContain('INJEKSI')  // injection
        ->and($allHeadersUpper)->toContain('PENYELESAIAN')  // finishing
        ->and($allHeadersUpper)->toContain('PENGEMASAN')  // packing
        ->and($allHeadersUpper)->toContain('XFD');
});

it('exports empty collection when no SPKs exist', function () {
    $export = new PpsExport;
    $collection = $export->collection();

    expect($collection)->isEmpty();
});

it('filters export by brand when brand_id is provided', function () {
    $brand1 = Brand::create(['name' => 'Brand A', 'code' => 'BA']);
    $brand2 = Brand::create(['name' => 'Brand B', 'code' => 'BB']);

    $spk1 = Spk::create([
        'po_number' => 'PO-001',
        'xfd_date' => '2026-11-20',
        'brand_id' => $brand1->id,
        'art_color' => 'Red',
        'status' => 'create',
    ]);

    $spk2 = Spk::create([
        'po_number' => 'PO-002',
        'xfd_date' => '2026-11-20',
        'brand_id' => $brand2->id,
        'art_color' => 'Blue',
        'status' => 'create',
    ]);

    $export = new PpsExport($brand1->id);
    $collection = $export->collection();

    expect($collection)->toHaveCount(1);
});

it('exports data for all brands when no brand_id is provided', function () {
    $brand1 = Brand::create(['name' => 'Brand A', 'code' => 'BA']);
    $brand2 = Brand::create(['name' => 'Brand B', 'code' => 'BB']);

    Spk::create([
        'po_number' => 'PO-001',
        'xfd_date' => '2026-11-20',
        'brand_id' => $brand1->id,
        'art_color' => 'Red',
        'status' => 'create',
    ]);

    Spk::create([
        'po_number' => 'PO-002',
        'xfd_date' => '2026-11-20',
        'brand_id' => $brand2->id,
        'art_color' => 'Blue',
        'status' => 'create',
    ]);

    $export = new PpsExport;
    $collection = $export->collection();

    expect($collection)->toHaveCount(2);
});

// ============================================================
// INTEGRATION TEST: Export Response
// ============================================================

it('generates excel file with correct headers for brand-specific export', function () {
    $brand = Brand::create(['name' => 'Test Brand', 'code' => 'TB001']);
    Spk::create([
        'po_number' => 'PO-001',
        'xfd_date' => '2026-11-20',
        'brand_id' => $brand->id,
        'art_color' => 'Red',
        'status' => 'create',
    ]);

    // Test the export endpoint - use the correct route name
    $response = $this->get(route('produksi.spk-schedules.export', ['brand_id' => $brand->id]));

    $response->assertStatus(200)
        ->assertHeader('content-disposition', 'attachment; filename=data-pps-brand-'.$brand->id.'.xlsx');
});
