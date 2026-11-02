<?php

use App\Models\Employee;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

uses(RefreshDatabase::class);

beforeEach(function () {
    app(PermissionRegistrar::class)->forgetCachedPermissions();
    $this->employee = Employee::create([
        'user_id' => User::factory()->create()->id,
        'employee_code' => 'SV-001',
        'full_name' => 'Budi',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'join_date' => '2020-01-01',
        'basic_salary' => 5000000,
    ]);
});

function salaryAdmin(bool $withSalary): User
{
    $user = User::factory()->create();
    $user->givePermissionTo(Permission::findOrCreate('manage-employees', 'web'));
    if ($withSalary) {
        $user->givePermissionTo(Permission::findOrCreate('view-employee-salary', 'web'));
    }

    return $user;
}

it('hides salary without permission', function () {
    $this->actingAs(salaryAdmin(false));

    $this->get(route('admin.employees.show', $this->employee))
        ->assertInertia(fn ($page) => $page->where('canViewSalary', false)->missing('employee.basic_salary'));
    $this->get(route('admin.employees.index'))
        ->assertInertia(fn ($page) => $page->missing('employees.data.0.basic_salary'));
});

it('shows salary with permission', function () {
    $this->actingAs(salaryAdmin(true));

    $this->get(route('admin.employees.show', $this->employee))
        ->assertInertia(fn ($page) => $page->where('canViewSalary', true)->has('employee.basic_salary'));
});

it('does not change salary on update without permission', function () {
    $this->actingAs(salaryAdmin(false));

    $this->put(route('admin.employees.update', $this->employee), [
        'user_id' => $this->employee->user_id,
        'full_name' => 'Budi Baru',
        'birth_place' => 'Bandung',
        'birth_date' => '1990-01-01',
        'gender' => 'L',
        'join_date' => '2020-01-01',
        'basic_salary' => 1,
    ])->assertRedirect();

    expect((float) $this->employee->fresh()->basic_salary)->toBe(5000000.0)
        ->and($this->employee->fresh()->full_name)->toBe('Budi Baru');
});

it('blocks salary import without permission', function () {
    $this->actingAs(salaryAdmin(false));

    $this->get(route('admin.employees.salary-import'))->assertForbidden();
});
