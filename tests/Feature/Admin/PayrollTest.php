<?php

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\Holiday;
use App\Models\LeaveRequest;
use App\Models\Overtime;
use App\Models\PayrollRun;
use App\Models\User;
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

it('calculates 30-day payroll and locks an approved run through payment', function () {
    $employee = createPayrollTestEmployee('PAY-001', 'Ayu', 3000000);

    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-04',
        'status' => 'absent',
    ]);
    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-03',
        'status' => 'sick',
    ]);
    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-10-31',
        'status' => 'absent',
    ]);
    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-02',
        'status' => 'absent',
    ]);

    LeaveRequest::create([
        'employee_id' => $employee->id,
        'type' => 'sakit',
        'start_date' => '2026-11-03',
        'end_date' => '2026-11-03',
        'reason' => 'Sakit',
        'status' => 'approved',
    ]);
    Holiday::create([
        'date' => '2026-11-02',
        'name' => 'Hari Libur',
        'is_national' => true,
    ]);

    $overtime = Overtime::create([
        'date' => '2026-11-05',
        'department' => 'Produksi',
        'purpose' => 'Lembur produksi',
        'pic' => 'HR',
    ]);
    $overtime->employees()->attach($employee->id, [
        'type' => 'reguler',
        'duration' => 2.5,
    ]);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ])->assertRedirect();

    $run = PayrollRun::query()->firstOrFail();
    $item = $run->items()->firstOrFail();

    expect($run->period_start->toDateString())->toBe('2026-10-26')
        ->and($run->period_end->toDateString())->toBe('2026-11-25')
        ->and((float) $item->daily_rate)->toBe(100000.0)
        ->and($item->unpaid_absence_days)->toBe(1)
        ->and((float) $item->absence_deduction)->toBe(100000.0)
        ->and((float) $item->overtime_hours)->toBe(2.5)
        ->and((float) $item->overtime_hourly_rate)->toBe(12500.0)
        ->and((float) $item->overtime_amount)->toBe(31250.0);

    $this->post(route('admin.payroll.adjustments.store', [$run, $item]), [
        'type' => 'allowance',
        'description' => 'Tunjangan makan',
        'amount' => 150000,
    ])->assertRedirect();
    $this->post(route('admin.payroll.adjustments.store', [$run, $item]), [
        'type' => 'deduction',
        'description' => 'Kasbon',
        'amount' => 75000,
    ])->assertRedirect();

    $this->post(route('admin.payroll.approve', $run))->assertRedirect();
    $this->post(route('admin.payroll.adjustments.store', [$run, $item]), [
        'type' => 'allowance',
        'description' => 'Perubahan setelah persetujuan',
        'amount' => 1000,
    ])->assertStatus(409);
    $this->post(route('admin.payroll.paid', $run))->assertRedirect();

    expect($run->fresh()->status)->toBe('paid')
        ->and((float) $item->fresh()->adjustments()->where('type', 'allowance')->sum('amount'))->toBe(150000.0)
        ->and((float) $item->fresh()->adjustments()->where('type', 'deduction')->sum('amount'))->toBe(75000.0);
});

it('uses the same 30-day salary divisor for short and long cutoff periods', function () {
    createPayrollTestEmployee('PAY-002', 'Bima', 3000000);

    foreach ([[3, 2027, '2027-02-26', '2027-03-25'], [4, 2027, '2027-03-26', '2027-04-25']] as [$month, $year, $start, $end]) {
        $this->post(route('admin.payroll.store'), [
            'month' => $month,
            'year' => $year,
        ])->assertRedirect();

        $run = PayrollRun::where(compact('month', 'year'))->firstOrFail();
        $item = $run->items()->firstOrFail();

        expect($run->period_start->toDateString())->toBe($start)
            ->and($run->period_end->toDateString())->toBe($end)
            ->and((float) $item->daily_rate)->toBe(100000.0);
    }
});

it('allows deleting draft payroll runs', function () {
    createPayrollTestEmployee('PAY-003', 'Citra', 3000000);

    $this->post(route('admin.payroll.store'), [
        'month' => 11,
        'year' => 2026,
    ])->assertRedirect();

    $run = PayrollRun::query()->firstOrFail();
    $this->delete(route('admin.payroll.destroy', $run))
        ->assertRedirect(route('admin.payroll.index'));

    $this->assertDatabaseMissing('payroll_runs', ['id' => $run->id]);
});

function createPayrollTestEmployee(string $code, string $name, int $salary): Employee
{
    $user = User::factory()->create();

    return Employee::create([
        'user_id' => $user->id,
        'employee_code' => $code,
        'full_name' => $name,
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'P',
        'department' => 'Produksi',
        'join_date' => '2020-01-01',
        'basic_salary' => $salary,
    ]);
}
