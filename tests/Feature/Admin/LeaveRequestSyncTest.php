<?php

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\LeaveRequest;
use App\Models\PayrollRun;
use App\Models\User;
use Carbon\Carbon;
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
// Approval Sync Tests
// ============================================================

it('creates attendance records when leave request is approved', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'end_date' => '2026-11-12',
        'reason' => 'Cuti tahunan',
        'status' => 'pending',
    ]);

    // Approve the leave
    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
        'approval_note' => 'Disetujui',
    ]);

    // Should have created attendance for 3 days
    $attendances = Attendance::where('employee_id', $this->employee->id)
        ->whereBetween('date', ['2026-11-10', '2026-11-12'])
        ->get();

    expect($attendances->count())->toBe(3);

    // All should be 'leave' status
    foreach ($attendances as $attendance) {
        expect($attendance->status)->toBe('leave')
            ->and($attendance->notes)->toBe('Izin: Cuti tahunan');
    }
});

it('creates attendance with sick status for sakit leave type', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'sakit',
        'start_date' => '2026-11-10',
        'end_date' => '2026-11-10',
        'reason' => 'Periksa dokter',
        'status' => 'pending',
    ]);

    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    $attendance = Attendance::where('employee_id', $this->employee->id)
        ->where('date', '2026-11-10')
        ->first();

    expect($attendance->status)->toBe('sick');
});

it('creates attendance with present status for izin_setengah_hari', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'izin_setengah_hari',
        'start_date' => '2026-11-10',
        'reason' => 'Sedang di rumah sakit',
        'status' => 'pending',
    ]);

    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    $attendance = Attendance::where('employee_id', $this->employee->id)
        ->where('date', '2026-11-10')
        ->first();

    expect($attendance->status)->toBe('present');
});

it('creates attendance with start_time and end_time when provided', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'end_date' => '2026-11-10',
        'start_time' => '08:00',
        'end_time' => '12:00',
        'reason' => 'Cuti pagi',
        'status' => 'pending',
    ]);

    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    $attendance = Attendance::where('employee_id', $this->employee->id)
        ->where('date', '2026-11-10')
        ->first();

    expect($attendance->check_in)->toBe('08:00')
        ->and($attendance->check_out)->toBe('12:00');
});

// ============================================================
// Rejection Tests
// ============================================================

it('does not create attendance records when leave is rejected', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'reason' => 'Cuti tahunan',
        'status' => 'pending',
    ]);

    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'rejected',
        'approval_note' => 'Tidak disetujui',
    ]);

    expect(LeaveRequest::first()->status)->toBe('rejected')
        ->and(Attendance::where('employee_id', $this->employee->id)->count())->toBe(0);
});

// ============================================================
// Update Status Tests
// ============================================================

it('updates existing attendance when leave status changes to approved', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'reason' => 'Cuti awal',
        'status' => 'pending',
    ]);

    // Approve the leave
    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    expect(Attendance::count())->toBe(1);

    // Change to rejected
    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'rejected',
    ]);

    // Attendance should still exist (not deleted on rejection)
    expect(Attendance::count())->toBe(1);
});

// ============================================================
// Cancellation Tests
// ============================================================

it('removes synchronized attendance when leave is cancelled', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'end_date' => '2026-11-12',
        'reason' => 'Cuti batal',
        'status' => 'pending',
    ]);

    // Approve
    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    expect(Attendance::whereBetween('date', ['2026-11-10', '2026-11-12'])->count())->toBe(3);

    // Cancel
    $this->post(route('admin.leave-requests.cancel', $leaveRequest), [
        'cancel_reason' => 'Berkencan',
    ]);

    $leaveRequest->refresh();
    expect($leaveRequest->status)->toBe('cancelled')
        ->and($leaveRequest->cancel_reason)->toBe('Berkencan')
        ->and($leaveRequest->cancelled_by)->toBe($this->admin->id);

    // Attendance should be removed
    expect(Attendance::whereBetween('date', ['2026-11-10', '2026-11-12'])->count())->toBe(0);
});

it('cannot cancel pending leave request', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'reason' => 'Cuti',
        'status' => 'pending',
    ]);

    $response = $this->post(route('admin.leave-requests.cancel', $leaveRequest), [
        'cancel_reason' => 'Batal',
    ]);

    $response->assertStatus(409)
        ->assertSessionHas('error', 'Hanya pengajuan izin yang sudah disetujui yang dapat dibatalkan.');

    $leaveRequest->refresh();
    expect($leaveRequest->status)->toBe('pending');
});

it('cannot cancel leave request when payroll period is approved', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'end_date' => '2026-11-12',
        'reason' => 'Cuti batal',
        'status' => 'pending',
    ]);

    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    // Create approved payroll covering the leave period
    PayrollRun::create([
        'month' => 11,
        'year' => 2026,
        'period_start' => '2026-10-26',
        'period_end' => '2026-11-25',
        'status' => 'approved',
        'generated_by' => $this->admin->id,
    ]);

    $response = $this->post(route('admin.leave-requests.cancel', $leaveRequest), [
        'cancel_reason' => 'Berkencan',
    ]);

    $response->assertStatus(409)
        ->assertSessionHas('error', 'Pengajuan izin tidak dapat dibatalkan karena penggajian periode tersebut sudah disetujui/dibayar.');
});

// ============================================================
// Delete Tests
// ============================================================

it('prevents deleting approved leave request', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'reason' => 'Cuti',
        'status' => 'approved',
    ]);

    $response = $this->delete(route('admin.leave-requests.destroy', $leaveRequest));

    $response->assertStatus(409)
        ->assertSessionHas('error', 'Pengajuan izin yang sudah disetujui tidak dapat dihapus.');
});

it('prevents deleting leave request with synchronized attendance', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'reason' => 'Cuti',
        'status' => 'pending',
    ]);

    // Approve first (creates attendance)
    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    $response = $this->delete(route('admin.leave-requests.destroy', $leaveRequest));

    $response->assertStatus(409)
        ->assertSessionHas('error', 'Pengajuan izin yang pernah disetujui dan tersinkron ke absensi tidak dapat dihapus.');
});

it('allows deleting pending leave request', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'reason' => 'Cuti',
        'status' => 'pending',
    ]);

    $response = $this->delete(route('admin.leave-requests.destroy', $leaveRequest));

    $response->assertRedirect(route('admin.leave-requests.index'))
        ->assertSessionHas('success', 'Pengajuan izin berhasil dihapus.');

    $this->assertDatabaseMissing('leave_requests', ['id' => $leaveRequest->id]);
});

// ============================================================
// Multi-day Leave Extension Tests
// ============================================================

it('creates attendance records for multi-day leave', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'end_date' => '2026-11-15', // 6 days
        'reason' => 'Cuti bersama keluarga',
        'status' => 'pending',
    ]);

    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    $attendanceCount = Attendance::where('employee_id', $this->employee->id)
        ->whereBetween('date', ['2026-11-10', '2026-11-15'])
        ->count();

    expect($attendanceCount)->toBe(6);
});

// ============================================================
// Edge Cases
// ============================================================

it('handles leave request without end_date (single day)', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'end_date' => null, // No end date = single day
        'reason' => 'Cuti mendadak',
        'status' => 'pending',
    ]);

    $this->post(route('admin.leave-requests.approve', $leaveRequest), [
        'status' => 'approved',
    ]);

    $attendance = Attendance::where('employee_id', $this->employee->id)
        ->where('date', '2026-11-10')
        ->first();

    expect($attendance)->not->toBeNull();
});

it('requires cancel reason when cancelling', function () {
    $leaveRequest = LeaveRequest::create([
        'employee_id' => $this->employee->id,
        'type' => 'cuti',
        'start_date' => '2026-11-10',
        'reason' => 'Cuti',
        'status' => 'pending',
    ]);

    $this->post(route('admin.leave-requests.approve', $leaveRequest), ['status' => 'approved']);

    $this->post(route('admin.leave-requests.cancel', $leaveRequest), [
        'cancel_reason' => '', // Empty reason
    ])->assertSessionHasErrors('cancel_reason');

    $leaveRequest->refresh();
    expect($leaveRequest->status)->toBe('approved');
});