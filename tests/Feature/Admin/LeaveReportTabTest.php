<?php

use App\Models\Employee;
use App\Models\LeaveRequest;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $admin = User::factory()->create();
    $admin->givePermissionTo(Permission::findOrCreate('manage-attendances', 'web'));
    $this->actingAs($admin);
});

it('lists only employees with approved leave in the report period', function () {
    $onLeave = leaveReportEmployee('LV-001', 'Rina');
    $other = leaveReportEmployee('LV-002', 'Joko');

    LeaveRequest::create([
        'employee_id' => $onLeave->id,
        'type' => 'cuti',
        'start_date' => '2026-11-03',
        'end_date' => '2026-11-04',
        'reason' => 'Acara keluarga',
        'status' => 'approved',
    ]);
    LeaveRequest::create([
        'employee_id' => $other->id,
        'type' => 'sakit',
        'start_date' => '2026-11-03',
        'end_date' => '2026-11-03',
        'reason' => 'Belum disetujui',
        'status' => 'pending',
    ]);

    $this->get(route('admin.reports.index', ['month' => 11, 'year' => 2026]))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('leaveData', 1)
            ->where('leaveData.0.code', 'LV-001')
            ->where('leaveData.0.daily.8.leave_type', 'cuti'));
});

function leaveReportEmployee(string $code, string $name): Employee
{
    return Employee::create([
        'user_id' => User::factory()->create()->id,
        'employee_code' => $code,
        'full_name' => $name,
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'P',
        'department' => 'Produksi',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);
}
