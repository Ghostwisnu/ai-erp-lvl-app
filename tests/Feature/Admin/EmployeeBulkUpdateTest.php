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
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo(Permission::findOrCreate('manage-employees', 'web'));
    $this->actingAs($this->admin);
});

function makeBulkUpdateEmployee(string $code): Employee
{
    return Employee::create([
        'user_id' => User::factory()->create(['name' => 'Lama '.$code])->id,
        'employee_code' => $code,
        'full_name' => 'Lama '.$code,
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'department' => 'Produksi',
        'position' => 'Operator',
        'join_date' => '2020-01-01',
        'basic_salary' => 3000000,
    ]);
}

function uploadBulkUpdate(string $csv): void
{
    test()->post(route('admin.employees.bulk-update.preview'), [
        'file' => UploadedFile::fake()->createWithContent('update.csv', $csv),
    ])->assertRedirect(route('admin.employees.bulk-update.confirm'));
}

it('updates only filled columns and never touches salary', function () {
    $employee = makeBulkUpdateEmployee('UPD-001');

    uploadBulkUpdate("kode_karyawan,nama,departemen,posisi,tanggal_bergabung,jenis_kelamin,gaji_pokok\nUPD-001,Nama Baru,Gudang,,15/03/2021,p,99999999\n");

    $this->get(route('admin.employees.bulk-update.confirm'))
        ->assertInertia(fn ($page) => $page
            ->component('Admin/Employees/BulkUpdatePreview')
            ->where('previewData.0.is_valid', true));

    $this->post(route('admin.employees.bulk-update.store'))
        ->assertRedirect(route('admin.employees.index'));

    $employee->refresh();
    expect($employee->full_name)->toBe('Nama Baru')
        ->and($employee->department)->toBe('Gudang')
        ->and($employee->position)->toBe('Operator')
        ->and($employee->gender)->toBe('P')
        ->and((string) $employee->join_date)->toStartWith('2021-03-15')
        ->and((float) $employee->basic_salary)->toBe(3000000.0)
        ->and($employee->user->name)->toBe('Nama Baru');
});

it('does not save anything when any row is invalid', function () {
    $employee = makeBulkUpdateEmployee('UPD-002');

    uploadBulkUpdate("kode_karyawan,nama,tanggal_lahir\nUPD-002,Nama Baru,\nUPD-NONE,X,\nUPD-002,Y,bukan-tanggal\n");

    $this->post(route('admin.employees.bulk-update.store'))
        ->assertRedirect(route('admin.employees.bulk-update.confirm'));

    expect($employee->fresh()->full_name)->toBe('Lama UPD-002');
});

it('flags invalid dates and gender values', function () {
    makeBulkUpdateEmployee('UPD-003');

    uploadBulkUpdate("kode_karyawan,tanggal_lahir,jenis_kelamin\nUPD-003,31/02/2020,Z\n");

    $this->get(route('admin.employees.bulk-update.confirm'))
        ->assertInertia(fn ($page) => $page->where('previewData.0.is_valid', false));
});

it('requires manage-employees permission', function () {
    $this->actingAs(User::factory()->create());

    $this->get(route('admin.employees.bulk-update'))->assertForbidden();
});
