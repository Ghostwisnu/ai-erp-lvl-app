<?php

use App\Models\Asset;
use App\Models\AssetCategory;
use App\Models\AssetLocation;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $permission = Permission::findOrCreate('manage-assets', 'web');
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo($permission);
    $this->actingAs($this->admin);
});

it('creates an asset and opens its detail page', function () {
    $category = AssetCategory::create(['name' => 'Elektronik']);

    $response = $this->post(route('admin.assets.store'), [
        'code' => 'AST-001',
        'name' => 'Laptop',
        'asset_category_id' => $category->id,
        'acquisition_date' => now()->subDay()->toDateString(),
        'acquisition_cost' => 15000000,
        'salvage_value' => 1000000,
        'useful_life_months' => 60,
        'condition' => 'good',
        'status' => 'in_service',
    ]);

    $asset = Asset::query()->where('code', 'AST-001')->firstOrFail();

    $response->assertRedirect(route('admin.assets.show', $asset));
    $this->assertDatabaseHas('assets', [
        'id' => $asset->id,
        'name' => 'Laptop',
        'asset_category_id' => $category->id,
    ]);

    $this->get(route('admin.assets.show', $asset))
        ->assertOk()
        ->assertInertia(fn ($page) => $page->component('Admin/Assets/Show'));
});

it('records asset assignment and maintenance activity', function () {
    $category = AssetCategory::create(['name' => 'Peralatan']);
    $location = AssetLocation::create(['name' => 'Gudang']);
    $assignee = User::factory()->create();
    $asset = Asset::create([
        'code' => 'AST-002',
        'name' => 'Mesin',
        'asset_category_id' => $category->id,
        'acquisition_date' => now()->subYear()->toDateString(),
        'acquisition_cost' => 10000000,
        'salvage_value' => 0,
        'useful_life_months' => 60,
        'condition' => 'good',
        'status' => 'in_service',
    ]);

    $this->post(route('admin.assets.assign', $asset), [
        'assigned_to' => (string) $assignee->id,
        'asset_location_id' => (string) $location->id,
        'notes' => 'Penempatan awal',
    ])->assertRedirect(route('admin.assets.show', $asset));

    $this->assertDatabaseHas('asset_movements', [
        'asset_id' => $asset->id,
        'to_user_id' => $assignee->id,
        'to_location_id' => $location->id,
        'action' => 'assigned',
    ]);

    $this->post(route('admin.assets.maintenance.store', $asset), [
        'service_date' => now()->toDateString(),
        'service_type' => 'preventive',
        'description' => 'Pemeriksaan rutin',
        'cost' => 250000,
        'status' => 'in_progress',
    ])->assertRedirect(route('admin.assets.show', $asset));

    $this->assertDatabaseHas('assets', [
        'id' => $asset->id,
        'status' => 'maintenance',
    ]);
    $this->assertDatabaseHas('asset_maintenances', [
        'asset_id' => $asset->id,
        'description' => 'Pemeriksaan rutin',
        'status' => 'in_progress',
    ]);
});
