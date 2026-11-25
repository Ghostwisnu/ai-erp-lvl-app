<?php

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\Holiday;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $permission = Permission::findOrCreate('manage-attendances', 'web');
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo($permission);
    $this->actingAs($this->admin);

    $this->employee = Employee::create([
        'employee_code' => 'EMP-001',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 5000000,
    ]);
});

// ============================================================
// Index Tests
// ============================================================

it('renders attendance index page with employees and date filter', function () {
    $response = $this->get(route('admin.attendances.index'));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('employees')
            ->has('departments'));
});

it('filters attendance by date', function () {
    $testDate = '2026-11-15';

    $response = $this->get(route('admin.attendances.index', ['date' => $testDate]));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('date', $testDate));
});

it('shows list of unique departments for filtering', function () {
    Employee::create([
        'employee_code' => 'EMP-002',
        'full_name' => 'IT Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 5000000,
    ]);

    Employee::create([
        'employee_code' => 'EMP-003',
        'full_name' => 'HR Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'HR',
        'join_date' => '2020-01-01',
        'basic_salary' => 5000000,
    ]);

    $response = $this->get(route('admin.attendances.index'));

    $response->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('departments', 2));
});

// ============================================================
// Store Tests
// ============================================================

it('stores attendance records for multiple employees', function () {
    $employee2 = Employee::create([
        'employee_code' => 'EMP-002',
        'full_name' => 'Another Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 5000000,
    ]);

    $testDate = '2026-11-15';

    $response = $this->post(route('admin.attendances.store'), [
        'date' => $testDate,
        'attendances' => [
            $this->employee->id => [
                'status' => 'present',
                'check_in' => '08:00',
                'check_out' => '17:00',
                'notes' => '',
            ],
            $employee2->id => [
                'status' => 'present',
                'check_in' => '08:30',
                'check_out' => '16:30',
                'notes' => '',
            ],
        ],
    ]);

    $response->assertRedirect()
        ->assertSessionHas('success', 'Absensi tanggal '.$testDate.' berhasil disimpan.');

    $this->assertDatabaseHas('attendances', [
        'employee_id' => $this->employee->id,
        'date' => $testDate,
        'status' => 'present',
    ]);

    $this->assertDatabaseHas('attendances', [
        'employee_id' => $employee2->id,
        'date' => $testDate,
        'status' => 'present',
    ]);
});

it('marks employees as present on weekends automatically', function () {
    // Saturday
    $testDate = '2026-11-15'; // This is actually a Saturday
    expect(Carbon::parse($testDate)->isWeekend())->toBeTrue();

    $response = $this->post(route('admin.attendances.store'), [
        'date' => $testDate,
        'attendances' => [
            $this->employee->id => [
                'status' => 'absent', // Should be overridden to 'present'
                'check_in' => null,
                'check_out' => null,
                'notes' => '',
            ],
        ],
    ]);

    $this->assertDatabaseHas('attendances', [
        'employee_id' => $this->employee->id,
        'date' => $testDate,
        'status' => 'present', // Overridden to present
    ]);
});

it('marks employees as present on public holidays', function () {
    $holiday = Holiday::create([
        'date' => '2026-11-27',
        'name' => ' hari libur nasional',
        'is_national' => true,
    ]);

    $response = $this->post(route('admin.attendances.store'), [
        'date' => '2026-11-27',
        'attendances' => [
            $this->employee->id => [
                'status' => 'absent', // Should be overridden to 'present'
                'check_in' => null,
                'check_out' => null,
                'notes' => '',
            ],
        ],
    ]);

    $this->assertDatabaseHas('attendances', [
        'employee_id' => $this->employee->id,
        'date' => '2026-11-27',
        'status' => 'present', // Overridden to present
    ]);
});

it('clears check_in and check_out on holidays', function () {
    Holiday::create([
        'date' => '2026-11-27',
        'name' => ' hari libur nasional',
        'is_national' => true,
    ]);

    $this->post(route('admin.attendances.store'), [
        'date' => '2026-11-27',
        'attendances' => [
            $this->employee->id => [
                'status' => 'present',
                'check_in' => '08:00', // Should be cleared
                'check_out' => '17:00', // Should be cleared
                'notes' => '',
            ],
        ],
    ]);

    $attendance = Attendance::where('employee_id', $this->employee->id)
        ->where('date', '2026-11-27')
        ->first();

    expect($attendance->check_in)->toBeNull()
        ->and($attendance->check_out)->toBeNull();
});

it('stores attendance with notes', function () {
    $response = $this->post(route('admin.attendances.store'), [
        'date' => '2026-11-15',
        'attendances' => [
            $this->employee->id => [
                'status' => 'present',
                'check_in' => '08:00',
                'check_out' => '17:00',
                'notes' => 'Terlambat karena macet',
            ],
        ],
    ]);

    $this->assertDatabaseHas('attendances', [
        'employee_id' => $this->employee->id,
        'date' => '2026-11-15',
        'notes' => 'Terlambat karena macet',
    ]);
});

// ============================================================
// Edge Cases
// ============================================================

it('handles multiple attendance updates for same date', function () {
    $testDate = '2026-11-15';

    // First save
    $this->post(route('admin.attendances.store'), [
        'date' => $testDate,
        'attendances' => [
            $this->employee->id => [
                'status' => 'absent',
                'check_in' => null,
                'check_out' => null,
                'notes' => '',
            ],
        ],
    ]);

    // Second save should update
    $this->post(route('admin.attendances.store'), [
        'date' => $testDate,
        'attendances' => [
            $this->employee->id => [
                'status' => 'present',
                'check_in' => '08:00',
                'check_out' => '17:00',
                'notes' => '',
            ],
        ],
    ]);

    $attendance = Attendance::where('employee_id', $this->employee->id)
        ->where('date', $testDate)
        ->first();

    expect($attendance->status)->toBe('present')
        ->and($attendance->check_in)->toBe('08:00')
        ->and($attendance->check_out)->toBe('17:00');
});

it('handles empty attendance array', function () {
    $response = $this->post(route('admin.attendances.store'), [
        'date' => '2026-11-15',
        'attendances' => [],
    ]);

    // Should succeed but not create any records
    expect(Attendance::count())->toBe(0);
});

it('validates attendance status values', function () {
    $response = $this->post(route('admin.attendances.store'), [
        'date' => '2026-11-15',
        'attendances' => [
            $this->employee->id => [
                'status' => 'invalid_status', // Invalid
                'check_in' => null,
                'check_out' => null,
                'notes' => '',
            ],
        ],
    ]);

    $this->assertGuest();
});

it('requires authentication to access attendance pages', function () {
    $this->actingAs(null);

    $response = $this->get(route('admin.attendances.index'));
    $response->assertRedirect(route('login'));
});
