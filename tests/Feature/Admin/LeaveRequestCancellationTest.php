<?php

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\LeaveRequest;
use App\Models\PayrollRun;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo(Permission::findOrCreate('manage-leave-requests', 'web'));
    $this->actingAs($this->admin);

    $this->employee = Employee::create([
        'user_id' => User::factory()->create()->id,
        'employee_code' => 'CN-001',
        'full_name' => 'Ayu',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'P',
        'join_date' => '2020-01-01',
    ]);
});

function approvedLeaveForCancel(Employee $employee): LeaveRequest
{
    return LeaveRequest::create([
        'employee_id' => $employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-03',
        'end_date' => '2026-11-04',
        'reason' => 'Acara keluarga',
        'status' => 'pending',
    ]);
}

it('cancels an approved leave request and removes its synchronized attendance', function () {
    $leave = approvedLeaveForCancel($this->employee);

    $this->post(route('admin.leave-requests.approve', $leave), ['status' => 'approved', 'approval_note' => 'ok'])
        ->assertRedirect();
    expect(Attendance::where('employee_id', $this->employee->id)->count())->toBe(2);

    $this->post(route('admin.leave-requests.cancel', $leave), ['cancel_reason' => 'Rencana batal'])
        ->assertRedirect();

    $leave->refresh();
    expect($leave->status)->toBe('cancelled')
        ->and($leave->cancel_reason)->toBe('Rencana batal')
        ->and($leave->cancelled_by)->toBe($this->admin->id)
        ->and(Attendance::where('employee_id', $this->employee->id)->count())->toBe(0);
});

it('requires a reason and only allows cancelling approved requests', function () {
    $leave = approvedLeaveForCancel($this->employee);

    $this->post(route('admin.leave-requests.cancel', $leave), ['cancel_reason' => 'x'])
        ->assertStatus(409);

    $this->post(route('admin.leave-requests.approve', $leave), ['status' => 'approved', 'approval_note' => 'ok']);
    $this->post(route('admin.leave-requests.cancel', $leave), [])
        ->assertSessionHasErrors('cancel_reason');

    expect($leave->fresh()->status)->toBe('approved');
});

it('blocks cancellation when the payroll period is approved', function () {
    $leave = approvedLeaveForCancel($this->employee);
    $this->post(route('admin.leave-requests.approve', $leave), ['status' => 'approved', 'approval_note' => 'ok']);

    PayrollRun::create([
        'month' => 11,
        'year' => 2026,
        'period_start' => '2026-10-26',
        'period_end' => '2026-11-25',
        'status' => 'approved',
        'generated_by' => $this->admin->id,
    ]);

    $this->post(route('admin.leave-requests.cancel', $leave), ['cancel_reason' => 'Batal'])
        ->assertStatus(409);

    expect($leave->fresh()->status)->toBe('approved')
        ->and(Attendance::where('employee_id', $this->employee->id)->count())->toBe(2);
});
