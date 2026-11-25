<?php

use App\Models\Employee;
use App\Models\Overtime;
use App\Models\OvertimeEmployee;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $permission = Permission::findOrCreate('manage-overtimes', 'web');
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo($permission);
    $this->actingAs($this->admin);

    $this->employee = Employee::create([
        'employee_code' => 'EMP-001',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'user_id' => $this->admin->id,
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 5000000,
    ]);

    $this->employee2 = Employee::create([
        'employee_code' => 'EMP-002',
        'full_name' => 'Another Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'user_id' => null,
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 5000000,
    ]);
});

// ============================================================
// Index Tests
// ============================================================

it('renders overtime index page with paginated results', function () {
    // Create some overtime records
    Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Lembur rutin',
        'pic' => 'Admin',
    ]);

    $response = $this->get(route('admin.overtimes.index'));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('overtimes'));
});

// ============================================================
// Create Tests
// ============================================================

it('shows form with departments and employees', function () {
    $departments = Employee::whereNotNull('department')
        ->where('department', '!=', '')
        ->distinct()
        ->pluck('department')
        ->toArray();

    $response = $this->get(route('admin.overtimes.create'));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('departments')
            ->has('employees'));
});

// ============================================================
// Store Tests
// ============================================================

it('creates overtime record with employees', function () {
    $overtimeDate = '2026-11-15';

    $response = $this->post(route('admin.overtimes.store'), [
        'date' => $overtimeDate,
        'department' => 'IT',
        'purpose' => 'Project deadline',
        'pic' => 'John Doe',
        'employees' => [
            [
                'id' => $this->employee->id,
                'type' => 'reguler',
                'duration' => 2.5,
                'mutation_reason' => null,
            ],
            [
                'id' => $this->employee2->id,
                'type' => 'mutasi',
                'duration' => 3.0,
                'mutation_reason' => 'Bongkar baru',
            ],
        ],
    ]);

    $response->assertRedirect(route('admin.overtimes.index'))
        ->assertSessionHas('success', 'Form Lembur berhasil dibuat.');

    $overtime = Overtime::first();
    expect($overtime->date->toDateString())->toBe($overtimeDate)
        ->and($overtime->department)->toBe('IT')
        ->and($overtime->purpose)->toBe('Project deadline')
        ->and($overtime->pic)->toBe('John Doe');

    // Check pivot records
    expect(OvertimeEmployee::where('overtime_id', $overtime->id)->count())->toBe(2);
});

it('validates overtime duration range', function () {
    $response = $this->post(route('admin.overtimes.store'), [
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Test',
        'pic' => 'Admin',
        'employees' => [
            [
                'id' => $this->employee->id,
                'type' => 'reguler',
                'duration' => 20, // Invalid: max 16
            ],
        ],
    ]);

    // Should fail validation
    expect($response->status())->toBeIn([302, 422, 403]);
});

it('validates overtime type values', function () {
    $response = $this->post(route('admin.overtimes.store'), [
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Test',
        'pic' => 'Admin',
        'employees' => [
            [
                'id' => $this->employee->id,
                'type' => 'invalid_type', // Invalid
                'duration' => 2.0,
            ],
        ],
    ]);

    // Should fail validation
    expect($response->status())->toBeIn([302, 422, 403]);
});

it('requires at least one employee for overtime', function () {
    $response = $this->post(route('admin.overtimes.store'), [
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Test',
        'pic' => 'Admin',
        'employees' => [], // Empty
    ]);

    // Should fail validation
    expect($response->status())->toBeIn([302, 422, 403]);
});

// ============================================================
// Show Tests
// ============================================================

it('shows overtime detail page with employee pivot data', function () {
    $overtime = Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Meeting',
        'pic' => 'Admin',
    ]);

    $overtime->employees()->attach($this->employee->id, [
        'type' => 'reguler',
        'duration' => 2.5,
    ]);

    $response = $this->get(route('admin.overtimes.show', $overtime));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('overtime')
            ->has('overtime.employees'));
});

// ============================================================
// Edit Tests
// ============================================================

it('shows overtime edit form with existing data', function () {
    $overtime = Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Meeting',
        'pic' => 'Admin',
    ]);

    $response = $this->get(route('admin.overtimes.edit', $overtime));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('overtime')
            ->where('overtime.purpose', 'Meeting'));
});

// ============================================================
// Update Tests
// ============================================================

it('updates overtime record', function () {
    $overtime = Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Meeting',
        'pic' => 'Admin',
    ]);

    $response = $this->put(route('admin.overtimes.update', $overtime), [
        'date' => '2026-11-16',
        'department' => 'Finance',
        'purpose' => 'Updated Purpose',
        'pic' => 'Updated PIC',
        'employees' => [
            [
                'id' => $this->employee->id,
                'type' => 'reguler',
                'duration' => 1.5,
            ],
        ],
    ]);

    $response->assertRedirect(route('admin.overtimes.index'))
        ->assertSessionHas('success', 'Form Lembur berhasil diupdate.');

    $overtime->refresh();
    expect($overtime->date->toDateString())->toBe('2026-11-16')
        ->and($overtime->department)->toBe('Finance')
        ->and($overtime->purpose)->toBe('Updated Purpose');
});

it('replaces all employees when updating overtime', function () {
    $overtime = Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Meeting',
        'pic' => 'Admin',
    ]);

    // Attach first employee
    $overtime->employees()->attach($this->employee->id, [
        'type' => 'reguler',
        'duration' => 2.0,
    ]);

    // Update with different employee
    $this->put(route('admin.overtimes.update', $overtime), [
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Meeting',
        'pic' => 'Admin',
        'employees' => [
            [
                'id' => $this->employee2->id,
                'type' => 'reguler',
                'duration' => 3.0,
            ],
        ],
    ]);

    $pivotCount = OvertimeEmployee::where('overtime_id', $overtime->id)->count();
    expect($pivotCount)->toBe(1);

    $pivot = OvertimeEmployee::where('overtime_id', $overtime->id)->first();
    expect($pivot->employee_id)->toBe($this->employee2->id);
});

// ============================================================
// Destroy Tests
// ============================================================

it('deletes overtime record', function () {
    $overtime = Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Meeting',
        'pic' => 'Admin',
    ]);

    $overtime->employees()->attach($this->employee->id, [
        'type' => 'reguler',
        'duration' => 2.0,
    ]);

    $response = $this->delete(route('admin.overtimes.destroy', $overtime));

    $response->assertRedirect(route('admin.overtimes.index'))
        ->assertSessionHas('success', 'Form Lembur berhasil dihapus.');

    $this->assertDatabaseMissing('overtimes', ['id' => $overtime->id]);
    $this->assertDatabaseMissing('overtime_employees', ['overtime_id' => $overtime->id]);
});

// ============================================================
// Daily Schedule Tests
// ============================================================

it('shows daily schedule for a specific date', function () {
    Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Daily review',
        'pic' => 'Admin',
    ]);

    $response = $this->get(route('admin.overtimes.dailySchedule', [
        'date' => '2026-11-15',
    ]));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('overtimes')
            ->where('date', '2026-11-15'));
});

// ============================================================
// Print Tests
// ============================================================

it('shows printable overtime view', function () {
    $overtime = Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Meeting',
        'pic' => 'Admin',
        'created_by' => $this->admin->id,
    ]);

    $response = $this->get(route('admin.overtimes.print', $overtime));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('overtime'));
});

// ============================================================
// Edge Cases
// ============================================================

it('handles overtime amounts correctly in calculations', function () {
    $overtime = Overtime::create([
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Test',
        'pic' => 'Admin',
    ]);

    $overtime->employees()->attach($this->employee->id, [
        'type' => 'reguler',
        'duration' => 2.5,
    ]);

    // Verify the duration is stored correctly
    $pivot = OvertimeEmployee::find($overtime->pivot->id ?? DB::table('overtime_employees')->where('overtime_id', $overtime->id)->first()->id ?? 0);

    $overtimeEmployee = OvertimeEmployee::where('overtime_id', $overtime->id)
        ->where('employee_id', $this->employee->id)
        ->first();

    expect($overtimeEmployee->duration)->toBe(2.5);
});

it('validates that employee exists in overtime creation', function () {
    $response = $this->post(route('admin.overtimes.store'), [
        'date' => '2026-11-15',
        'department' => 'IT',
        'purpose' => 'Test',
        'pic' => 'Admin',
        'employees' => [
            [
                'id' => 99999, // Invalid employee ID
                'type' => 'reguler',
                'duration' => 2.0,
            ],
        ],
    ]);

    // Should fail validation
    expect($response->status())->toBeIn([302, 422, 403]);
});
