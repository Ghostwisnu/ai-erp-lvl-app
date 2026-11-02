<?php

use App\Models\Employee;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $this->admin = User::factory()->create(['name' => 'Admin Utama']);
    $this->admin->givePermissionTo(
        Permission::findOrCreate('manage-employees', 'web'),
        Permission::findOrCreate('manage-users', 'web'),
    );
    $this->actingAs($this->admin);
});

it('filters employees across all pages on the server', function () {
    foreach (range(1, 15) as $i) {
        Employee::create([
            'user_id' => User::factory()->create()->id,
            'employee_code' => sprintf('FLT-%03d', $i),
            'full_name' => $i === 1 ? 'Zebra Unik' : "Karyawan $i",
            'birth_place' => 'Bandung',
            'birth_date' => '1990-01-01',
            'gender' => 'L',
            'department' => $i === 1 ? 'Gudang' : 'Produksi',
            'join_date' => '2020-01-01',
        ]);
    }

    $this->get(route('admin.employees.index', ['search' => 'Zebra']))
        ->assertInertia(fn ($page) => $page->has('employees.data', 1)->where('employees.data.0.full_name', 'Zebra Unik'));
    $this->get(route('admin.employees.index', ['department' => 'Gudang']))
        ->assertInertia(fn ($page) => $page->has('employees.data', 1));
    $this->get(route('admin.employees.index', ['search' => 'FLT-0']))
        ->assertInertia(fn ($page) => $page->where('employees.total', 15));
});

it('only lists unassigned users plus the current one when editing an employee', function () {
    $make = fn (string $code) => Employee::create([
        'user_id' => User::factory()->create()->id,
        'employee_code' => $code,
        'full_name' => $code,
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'join_date' => '2020-01-01',
    ]);
    $mine = $make('USR-001');
    $make('USR-002');
    $free = User::factory()->create();

    $this->get(route('admin.employees.edit', $mine))
        ->assertInertia(fn ($page) => $page
            ->where('users', fn ($users) => collect($users)->pluck('id')->sort()->values()->all()
                === collect([$mine->user_id, $free->id, $this->admin->id])->sort()->values()->all()));
});

it('filters users by name and role across all pages', function () {
    $role = Role::findOrCreate('operator', 'web');
    User::factory()->count(14)->create();
    User::factory()->create(['name' => 'Zebra Pengguna'])->assignRole($role);

    $this->get(route('admin.users.index', ['search' => 'Zebra']))
        ->assertInertia(fn ($page) => $page->has('users.data', 1)->where('users.data.0.name', 'Zebra Pengguna'));
    $this->get(route('admin.users.index', ['role' => 'operator']))
        ->assertInertia(fn ($page) => $page->has('users.data', 1)->where('filters.role', 'operator'));
});
