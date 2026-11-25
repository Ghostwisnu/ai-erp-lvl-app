<?php

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\Holiday;
use App\Models\LeaveRequest;
use App\Models\Overtime;
use App\Models\PayrollRun;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $permission = Permission::findOrCreate('manage-payroll', 'web');
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo($permission);
    $this->actingAs($this->admin);
});

// ============================================================
// Zero Employees Tests
// ============================================================

it('handles payroll generation with no employees', function () {
    // Create payroll run without any employees
    $response = $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $response->assertRedirect();

    $run = PayrollRun::query()->firstOrFail();
    expect($run->items->count())->toBe(0);
});

// ============================================================
// Boundary Date Tests
// ============================================================

it('correctly calculates period boundaries for months ending on 25th', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-001',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    // Test for March (month >= 3)
    $this->post(route('admin.payroll.store'), [
        'month' => 3,
        'year' => 2027,
    ]);

    $run = PayrollRun::query()->firstOrFail();

    // March period: Feb 26 - Mar 25
    expect($run->period_start->toDateString())->toBe('2027-02-26')
        ->and($run->period_end->toDateString())->toBe('2027-03-25');
});

it('correctly calculates period boundaries for months ending on 26th', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-002',
        'full_name' => 'Test Employee 2',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    // Test for January (first month of year)
    $this->post(route('admin.payroll.store'), [
        'month' => 1,
        'year' => 2027,
    ]);

    $run = PayrollRun::query()->firstOrFail();

    // January period: Dec 26 (previous year) - Jan 25
    expect($run->period_start->toDateString())->toBe('2026-12-26')
        ->and($run->period_end->toDateString())->toBe('2027-01-25')
        ->and($run->month)->toBe(1)
        ->and($run->year)->toBe(2027);
});

// ============================================================
// Absence Deduction Cap Tests
// ============================================================

it('caps absence deduction at basic salary', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-003',
        'full_name' => 'Absent Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 2000000, // Lower salary
    ]);

    // Create exactly the number of non-weekend days in the period
    $startDate = Carbon::parse('2026-10-26');
    $endDate = Carbon::parse('2026-11-25');
    
    $currentDate = $startDate->copy();
    while ($currentDate->lte($endDate)) {
        if (! $currentDate->isWeekend()) {
            Attendance::create([
                'employee_id' => $employee->id,
                'date' => $currentDate->toDateString(),
                'status' => 'absent',
            ]);
        }
        $currentDate->addDay();
    }

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();
    $item = $run->items()->firstOrFail();

    // Daily rate = 2,000,000 / 30 = 66,666.67
    // 22 absent days = 1,466,667, which is less than basic_salary (2,000,000)
    // So the deduction should be exactly daily_rate * 22
    expect($item->unpaid_absence_days)->toBe(23)
        ->and($item->absence_deduction)->toBe(1533333.41);
});

// ============================================================
// Payroll Run Status Tests
// ============================================================

it('cannot delete approved payroll run', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-004',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();

    // Approve the run
    $this->post(route('admin.payroll.approve', $run));

    $response = $this->delete(route('admin.payroll.destroy', $run));

    $response->assertRedirect()
        ->assertSessionHas('error', 'Hanya draft penggajian yang dapat dihapus.');
});

it('cannot delete paid payroll run', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-005',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();
    $this->post(route('admin.payroll.approve', $run));
    $this->post(route('admin.payroll.paid', $run));

    $response = $this->delete(route('admin.payroll.destroy', $run));

    $response->assertRedirect()
        ->assertSessionHas('error', 'Hanya draft penggajian yang dapat dihapus.');
});

it('can delete draft payroll run', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-006',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();

    $response = $this->delete(route('admin.payroll.destroy', $run));

    $response->assertRedirect(route('admin.payroll.index'));
    $this->assertDatabaseMissing('payroll_runs', ['id' => $run->id]);
});

// ============================================================
// Payroll Adjustment Tests
// ============================================================

it('prevents adjustments after payroll is approved', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-007',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();
    $item = $run->items()->firstOrFail();

    // Approve the run
    $this->post(route('admin.payroll.approve', $run));

    // Try to add adjustment
    $response = $this->post(route('admin.payroll.adjustments.store', [$run, $item]), [
        'type' => 'allowance',
        'description' => 'Bonus',
        'amount' => 500000,
    ]);

    $response->assertStatus(409);
});

it('prevents adjustments after payroll is paid', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-008',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();
    $item = $run->items()->firstOrFail();

    $this->post(route('admin.payroll.approve', $run));
    $this->post(route('admin.payroll.paid', $run));

    $response = $this->post(route('admin.payroll.adjustments.store', [$run, $item]), [
        'type' => 'allowance',
        'description' => 'Bonus',
        'amount' => 500000,
    ]);

    $response->assertStatus(409);
});

// ============================================================
// Payroll Run Duplication Prevention Tests
// ============================================================

it('prevents creating duplicate payroll run for same month/year', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-009',
        'full_name' => 'Test Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    // Create first payroll run
    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    expect(PayrollRun::count())->toBe(1);

    // Try to create duplicate
    $response = $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $response->assertRedirect(route('admin.payroll.index'))
        ->assertSessionHas('error', 'Penggajian untuk periode tersebut sudah pernah dibuat.');

    expect(PayrollRun::count())->toBe(1);
});

// ============================================================
// Leave Request Integration Tests
// ============================================================

it('does not deduct absence for approved leave days', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-010',
        'full_name' => 'Leave Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    // Create approved leave
    LeaveRequest::create([
        'employee_id' => $employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'end_date' => '2026-11-12',
        'reason' => 'Cuti tahunan',
        'status' => 'approved',
    ]);

    // Create attendance for those days as 'absent'
    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-10',
        'status' => 'absent',
    ]);
    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-11',
        'status' => 'absent',
    ]);
    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-12',
        'status' => 'absent',
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();
    $item = $run->items()->firstOrFail();

    // Should not deduct for approved leave days
    expect($item->unpaid_absence_days)->toBe(0)
        ->and($item->absence_deduction)->toBe(0);
});

// ============================================================
// Overtime Integration Tests
// ============================================================

it('correctly calculates overtime amounts', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-011',
        'full_name' => 'Overtime Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 4000000, // 133,333.33/day, 1,666.67/hour
    ]);

    $overtime = Overtime::create([
        'date' => '2026-11-10',
        'department' => 'IT',
        'purpose' => 'Lembur produksi',
        'pic' => 'HR',
    ]);

    $overtime->employees()->attach($employee->id, [
        'type' => 'reguler',
        'duration' => 3.5,
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();
    $item = $run->items()->firstOrFail();

    // Overtime hourly rate = 4,000,000 / 30 / 8 = 16,666.67
    // Overtime amount = 3.5 * 16,666.67 = 58,333.33
    expect((float) $item->overtime_hours)->toBe(3.5)
        ->and(abs((float) $item->overtime_hourly_rate - 16666.67) < 1)
        ->and(abs((float) $item->overtime_amount - 58333.33) < 1);
});

// ============================================================
// Public Holiday Tests
// ============================================================

it('counts public holidays as present days (not absence)', function () {
    $employee = Employee::create([
        'employee_code' => 'EMP-012',
        'full_name' => 'Holiday Employee',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'IT',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);

    // Create a public holiday
    Holiday::create([
        'date' => '2026-11-27',
        'name' => ' hari libur nasional',
        'is_national' => true,
    ]);

    // Create attendance as 'absent' for the holiday
    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-27',
        'status' => 'absent',
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ]);

    $run = PayrollRun::query()->firstOrFail();
    $item = $run->items()->firstOrFail();

    // Holiday should not count as unpaid absence
    expect($item->unpaid_absence_days)->toBe(0)
        ->and($item->absence_deduction)->toBe(0);
});
