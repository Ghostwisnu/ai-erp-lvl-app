<?php

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\LeaveRequest;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $permission = Permission::findOrCreate('manage-leave-requests', 'web');
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo($permission);
    $this->actingAs($this->admin);

    $employeeUser = User::factory()->create();
    $this->employee = Employee::create([
        'user_id' => $employeeUser->id,
        'employee_code' => 'LV-001',
        'full_name' => 'Ayu',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'P',
        'department' => 'Produksi',
        'join_date' => '2020-01-01',
    ]);
});

it('allows deleting a pending leave request', function () {
    $leaveRequest = createLeaveRequestForDeletionTest($this->employee, 'pending');

    $this->delete(route('admin.leave-requests.destroy', $leaveRequest))
        ->assertRedirect(route('admin.leave-requests.index'));

    $this->assertDatabaseMissing('leave_requests', ['id' => $leaveRequest->id]);
});

it('prevents deleting an approved leave request and its synchronized attendance', function () {
    $leaveRequest = createLeaveRequestForDeletionTest($this->employee, 'approved');
    Attendance::create([
        'employee_id' => $this->employee->id,
        'date' => $leaveRequest->start_date,
        'status' => 'sick',
        'notes' => 'Izin: Periksa dokter',
    ]);

    $this->delete(route('admin.leave-requests.destroy', $leaveRequest))
        ->assertStatus(409);

    $this->assertDatabaseHas('leave_requests', ['id' => $leaveRequest->id]);
    $this->assertDatabaseHas('attendances', [
        'employee_id' => $this->employee->id,
        'date' => $leaveRequest->start_date,
    ]);
});

function createLeaveRequestForDeletionTest(Employee $employee, string $status): LeaveRequest
{
    return LeaveRequest::create([
        'employee_id' => $employee->id,
        'type' => 'sakit',
        'start_date' => '2026-10-30',
        'end_date' => '2026-10-30',
        'reason' => 'Periksa dokter',
        'status' => $status,
    ]);
}
