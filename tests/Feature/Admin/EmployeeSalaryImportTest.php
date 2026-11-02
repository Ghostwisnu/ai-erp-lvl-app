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
    $this->admin = User::factory()->create();
    $this->admin->givePermissionTo($permission, Permission::findOrCreate('view-employee-salary', 'web'));
    $this->actingAs($this->admin);
});

it('previews and updates employee salaries from an uploaded CSV', function () {
    $employee = makeSalaryImportEmployee('SAL-001', 'Sari', 3500000);

    $this->post(route('admin.employees.salary-import.preview'), [
        'file' => UploadedFile::fake()->createWithContent(
            'gaji.csv',
            "kode_karyawan,gaji_pokok_baru\nSAL-001,4200000\n",
        ),
    ])->assertRedirect(route('admin.employees.salary-import.confirm'));

    $this->get(route('admin.employees.salary-import.confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('Admin/Employees/SalaryImportPreview')
            ->where('previewData.0.employee_code', 'SAL-001')
            ->where('previewData.0.new_salary', 4200000)
            ->where('previewData.0.is_valid', true));

    $this->post(route('admin.employees.salary-import.store'))
        ->assertRedirect(route('admin.employees.index'));

    $this->assertDatabaseHas('employees', [
        'id' => $employee->id,
        'basic_salary' => 4200000,
    ]);
});

it('does not partially update salaries when a row is invalid', function () {
    $employee = makeSalaryImportEmployee('SAL-002', 'Dewi', 3500000);

    $this->post(route('admin.employees.salary-import.preview'), [
        'file' => UploadedFile::fake()->createWithContent(
            'gaji.csv',
            "kode_karyawan,gaji_pokok_baru\nSAL-002,4200000\nSAL-UNKNOWN,5000000\n",
        ),
    ])->assertRedirect(route('admin.employees.salary-import.confirm'));

    $this->post(route('admin.employees.salary-import.store'))
        ->assertRedirect(route('admin.employees.salary-import.confirm'));

    $this->assertDatabaseHas('employees', [
        'id' => $employee->id,
        'basic_salary' => 3500000,
    ]);
});

function makeSalaryImportEmployee(string $code, string $name, int $salary): Employee
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
