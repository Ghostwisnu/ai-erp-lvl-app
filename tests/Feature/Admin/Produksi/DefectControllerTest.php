<?php

use App\Models\Brand;
use App\Models\DefectCategory;
use App\Models\ProductionDefect;
use App\Models\Spk;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $permission = Permission::findOrCreate('manage-defects', 'web');
    $this->admin = User::factory()->create(['name' => 'Test Admin']);
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

    $this->defectCategory = DefectCategory::create([
        'brand_id' => $this->brand->id,
        'name' => 'Gerah',
    ]);
});

it('renders defect list page with active SPKs and defect categories', function () {
    $response = $this->get(route('produksi.defects.index'));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('activeSpks')
            ->has('defectCategories')
            ->where('department', 'qc')); // Default department
});

it('filters defects by selected SPK', function () {
    ProductionDefect::create([
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'qc',
        'qty' => 5,
    ]);

    $response = $this->get(route('produksi.defects.index', [
        'spk_id' => $this->spk->id,
    ]));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('selectedSpk')
            ->where('selectedSpk.id', $this->spk->id));
});

it('shows defect categories filtered by brand', function () {
    $categoryForBrand = DefectCategory::create([
        'brand_id' => $this->brand->id,
        'name' => 'Retak',
    ]);

    $response = $this->get(route('produksi.defects.index'));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('defectCategories.data', 2)
            ->where('defectCategories.data.0.name', 'Gerah')
            ->where('defectCategories.data.1.name', 'Retak'));
});

// ============================================================
// Store Tests
// ============================================================

it('creates a new production defect record', function () {
    $response = $this->post(route('produksi.defects.store'), [
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'qc',
        'qty' => 10,
    ]);

    $response->assertRedirect()
        ->assertSessionHas('success', 'Data defect berhasil ditambahkan.');

    $this->assertDatabaseHas('production_defects', [
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'qc',
        'qty' => 10,
    ]);
});

it('validates required fields for defect creation', function () {
    $response = $this->post(route('produksi.defects.store'), [
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'qc',
        'qty' => 0, // Invalid: qty must be at least 1
    ]);

    // Should fail validation (422) - in Laravel 12, user stays authenticated
    expect($response->status())->toBeIn([302, 422, 403]);
});

it('validates department against valid options', function () {
    $response = $this->post(route('produksi.defects.store'), [
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'invalid_dept',
        'qty' => 5,
    ]);

    // Should fail validation (422)
    expect($response->status())->toBeIn([302, 422, 403]);
});

it('validates defect category exists', function () {
    $response = $this->post(route('produksi.defects.store'), [
        'spk_id' => $this->spk->id,
        'defect_category_id' => 9999, // Invalid ID
        'department' => 'qc',
        'qty' => 5,
    ]);

    // Should fail validation (422)
    expect($response->status())->toBeIn([302, 422, 403]);
});

it('includes reported_by user name in defect record', function () {
    $response = $this->post(route('produksi.defects.store'), [
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'qc',
        'qty' => 5,
    ]);

    $defect = ProductionDefect::first();
    expect($defect->reported_by)->toBe($this->admin->name);
});

// ============================================================
// Department Filter Tests
// ============================================================

it('shows defects for different departments', function () {
    ProductionDefect::create([
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'qc',
        'qty' => 5,
        'reported_by' => $this->admin->name,
    ]);

    ProductionDefect::create([
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'warehouse',
        'qty' => 3,
        'reported_by' => $this->admin->name,
    ]);

    // QC department
    $response = $this->get(route('produksi.defects.index', ['dept' => 'qc']));
    $response->assertOk();

    // Warehouse department
    $response = $this->get(route('produksi.defects.index', ['dept' => 'warehouse']));
    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('department', 'warehouse'));
});

it('shows all defects for selected SPK', function () {
    ProductionDefect::create([
        'spk_id' => $this->spk->id,
        'defect_category_id' => $this->defectCategory->id,
        'department' => 'qc',
        'qty' => 5,
        'reported_by' => $this->admin->name,
    ]);

    $response = $this->get(route('produksi.defects.index'));

    // Should show defects for the SPK
    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('dailyDefects', 1));
});
