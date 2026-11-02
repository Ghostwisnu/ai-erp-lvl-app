<?php

use App\Models\Employee;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $permission = Permission::findOrCreate('manage-employees', 'web');
    $admin = User::factory()->create();
    $admin->givePermissionTo($permission);
    $this->actingAs($admin);
});

it('imports employees without email and uses the uploaded join date', function () {
    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent(
            'karyawan.csv',
            "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\nBudi Santoso,EMP-100,2026-10-15,IT,Staff,operator\n",
        ),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('Admin/Employees/ImportPreview')
            ->where('previewData.0.employee_code', 'EMP-100')
            ->where('previewData.0.join_date', '2026-10-15')
            ->where('previewData.0.is_valid', true)
            ->missing('previewData.0.email'));

    $this->post(route('admin.employees.import-store'))
        ->assertRedirect(route('admin.employees.index'));

    $employee = Employee::where('employee_code', 'EMP-100')->firstOrFail();

    expect($employee->join_date)->toBe('2026-10-15')
        ->and(str_ends_with($employee->user->email, '@employees.invalid'))->toBeTrue();
});

it('marks a missing join date as invalid during employee import preview', function () {
    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent(
            'karyawan.csv',
            "nama,kode_karyawan,tanggal_bergabung\nBudi Santoso,EMP-101,\n",
        ),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('previewData.0.is_valid', false)
            ->where('previewData.0.status', 'Tanggal bergabung wajib diisi dengan tanggal yang valid.'));
});
