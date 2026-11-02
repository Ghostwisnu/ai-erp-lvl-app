<?php

use App\Exports\AttendanceSummaryExport;
use App\Models\Attendance;
use App\Models\Employee;
use App\Models\FingerLog;
use App\Models\Holiday;
use App\Models\Overtime;
use App\Models\User;
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
});

it('shows daily attendance times from manual records and finger scans', function () {
    $date = '2026-10-30';
    $manualEmployee = createEmployeeForDailyAttendanceReport('EMP-001', 'Ayu');
    $fingerEmployee = createEmployeeForDailyAttendanceReport('EMP-002', 'Bima');
    $singleScanEmployee = createEmployeeForDailyAttendanceReport('EMP-003', 'Citra');
    createEmployeeForDailyAttendanceReport('EMP-004', 'Deni');

    Attendance::create([
        'employee_id' => $manualEmployee->id,
        'date' => $date,
        'check_in' => '08:15:00',
        'check_out' => '17:05:00',
        'status' => 'present',
    ]);

    FingerLog::create(['pin' => $fingerEmployee->employee_code, 'scan_time' => "$date 07:55:00"]);
    FingerLog::create(['pin' => $fingerEmployee->employee_code, 'scan_time' => "$date 17:12:00"]);
    FingerLog::create(['pin' => $singleScanEmployee->employee_code, 'scan_time' => "$date 08:05:00"]);

    $this->get(route('admin.reports.attendance-daily', ['date' => $date]))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('Admin/Reports/AttendanceDaily')
            ->where('date', $date)
            ->has('attendanceData', 4)
            ->where('attendanceData.0.check_in', '08:15')
            ->where('attendanceData.0.check_out', '17:05')
            ->where('attendanceData.1.check_in', '07:55')
            ->where('attendanceData.1.check_out', '17:12')
            ->where('attendanceData.1.total_scan', 2)
            ->where('attendanceData.2.check_in', '08:05')
            ->where('attendanceData.2.check_out', null)
            ->where('attendanceData.3.status', 'absent')
        );
});

it('shows weekends and public holidays as present in the daily report', function () {
    $employee = createEmployeeForDailyAttendanceReport('EMP-005', 'Eka');
    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-02',
        'status' => 'absent',
    ]);
    Holiday::create([
        'date' => '2026-11-02',
        'name' => 'Hari Libur Nasional',
        'is_national' => true,
    ]);

    $this->get(route('admin.reports.attendance-daily', ['date' => '2026-11-02']))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('dayOffLabel', 'Tanggal merah: Hari Libur Nasional')
            ->where('attendanceData.0.status', 'present')
        );

    $this->get(route('admin.reports.attendance-daily', ['date' => '2026-11-01']))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('dayOffLabel', 'Akhir pekan')
            ->where('attendanceData.0.status', 'present')
        );
});

it('counts Saturdays Sundays and public holidays as present in the monthly report', function () {
    $employee = createEmployeeForDailyAttendanceReport('EMP-006', 'Fajar');

    foreach (['2026-10-31', '2026-11-01', '2026-11-02', '2026-11-03'] as $date) {
        Attendance::create([
            'employee_id' => $employee->id,
            'date' => $date,
            'status' => 'absent',
        ]);
    }

    Holiday::create([
        'date' => '2026-11-02',
        'name' => 'Hari Libur Nasional',
        'is_national' => true,
    ]);

    $this->get(route('admin.reports.index', ['month' => 11, 'year' => 2026]))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('Admin/Reports/Index')
            ->where('attendanceData.0.daily.5.status', 'present')
            ->where('attendanceData.0.daily.5.is_day_off', true)
            ->where('attendanceData.0.daily.6.status', 'present')
            ->where('attendanceData.0.daily.7.status', 'present')
            ->where('attendanceData.0.daily.7.day_off_label', 'Tanggal merah: Hari Libur Nasional')
            ->where('attendanceData.0.daily.8.status', 'absent')
        );
});

it('exports monthly attendance days worked hours and overtime hours', function () {
    $employee = createEmployeeForDailyAttendanceReport('EMP-007', 'Gita');

    Attendance::create([
        'employee_id' => $employee->id,
        'date' => '2026-11-02',
        'check_in' => '08:00:00',
        'check_out' => '16:00:00',
        'status' => 'present',
    ]);
    FingerLog::create(['pin' => $employee->employee_code, 'scan_time' => '2026-11-03 07:00:00']);
    FingerLog::create(['pin' => $employee->employee_code, 'scan_time' => '2026-11-03 16:00:00']);
    $overtime = Overtime::create([
        'date' => '2026-11-03',
        'department' => 'Produksi',
        'purpose' => 'Pengujian laporan',
        'pic' => 'Admin',
    ]);
    $overtime->employees()->attach($employee->id, ['duration' => 2.5]);

    $this->get(route('admin.reports.export', ['month' => 11, 'year' => 2026]))
        ->assertOk()
        ->assertHeader('content-disposition', 'attachment; filename=laporan-absensi-2026-11.xlsx');

    $row = (new AttendanceSummaryExport(11, 2026))->collection()->first();
    expect($row[0])->toBe('EMP-007')
        ->and($row[3])->toBe(9)
        ->and($row[4])->toBe(17.0)
        ->and($row[5])->toBe(2.5);
});

function createEmployeeForDailyAttendanceReport(string $code, string $name): Employee
{
    $user = User::factory()->create();

    return Employee::create([
        'user_id' => $user->id,
        'employee_code' => $code,
        'full_name' => $name,
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'Produksi',
        'join_date' => '2020-01-01',
    ]);
}
