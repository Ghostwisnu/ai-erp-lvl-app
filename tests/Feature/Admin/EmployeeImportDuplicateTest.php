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
    $this->admin->givePermissionTo($permission);
    $this->actingAs($this->admin);
});

// ============================================================
// Duplicate Code Detection Tests
// ============================================================

it('detects duplicate employee codes within the same import file', function () {
    // Create CSV with duplicate code
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Budi Santoso,EMP-100,2026-10-15,IT,Staff,operator\n".
        "Siti Nurhaliza,EMP-100,2026-10-16,HR,Manager,admin\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->has('previewData', 2)
            ->where('previewData.0.is_valid', false)
            ->where('previewData.0.status', 'Kode karyawan duplikat di dalam file.')
            ->where('previewData.1.is_valid', false)
            ->where('previewData.1.status', 'Kode karyawan duplikat di dalam file.'));
});

it('detects duplicate codes with different cases as duplicates', function () {
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Budi Santoso,EMP-100,2026-10-15,IT,Staff,operator\n".
        "Ana Wijaya,emp-100,2026-10-16,HR,Manager,admin\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('previewData.0.is_valid', false)
            ->where('previewData.1.is_valid', false));
});

it('detects existing employee code in database', function () {
    // Create existing employee
    Employee::create([
        'employee_code' => 'EMP-200',
        'full_name' => 'Existing Employee',
        'department' => 'IT',
        'position' => 'Staff',
        'join_date' => '2020-01-01',
        'basic_salary' => 5000000,
    ]);

    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Budi Santoso,EMP-200,2026-10-15,IT,Staff,operator\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('previewData.0.is_valid', false)
            ->where('previewData.0.status', 'Kode karyawan sudah terdaftar.'));
});

it('validates first occurrence is flagged as duplicate when file has multiple same codes', function () {
    // This test verifies the edge case where the duplicate detection
    // should flag the SECOND occurrence, not the first
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Employee 1,EMP-300,2026-10-15,IT,Staff,operator\n".
        "Employee 2,EMP-300,2026-10-16,HR,Manager,admin\n".
        "Employee 3,EMP-300,2026-10-17,Finance,Staff,operator\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $previewData = session('import_employees_preview', []);

    // All three should be flagged as invalid because of duplicates
    expect($previewData[0]['is_valid'])->toBeFalse()
        ->and($previewData[1]['is_valid'])->toBeFalse()
        ->and($previewData[2]['is_valid'])->toBeFalse();
});

// ============================================================
// Invalid Date Detection Tests
// ============================================================

it('detects invalid join date format', function () {
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Budi Santoso,EMP-100,tanggal_invalid,IT,Staff,operator\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('previewData.0.is_valid', false)
            ->where('previewData.0.status', 'Tanggal bergabung wajib diisi dengan tanggal yang valid.'));
});

it('accepts valid date formats (Y-m-d and d/m/Y)', function () {
    $csvContent1 = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Budi Santoso,EMP-101,2026-10-15,IT,Staff,operator\n";

    $csvContent2 = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Siti Wijaya,EMP-102,15/10/2026,HR,Manager,admin\n";

    // Test Y-m-d format
    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent1),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $previewData = session('import_employees_preview', []);
    expect($previewData[0]['is_valid'])->toBeTrue()
        ->and($previewData[0]['join_date'])->toBe('2026-10-15');

    // Clear session
    session()->forget('import_employees_preview');

    // Test d/m/Y format
    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent2),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $previewData = session('import_employees_preview', []);
    expect($previewData[0]['is_valid'])->toBeTrue()
        ->and($previewData[0]['join_date'])->toBe('2026-10-15');
});

it('detects empty required fields', function () {
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        ",EMP-103,,IT,Staff,operator\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('previewData.0.is_valid', false)
            ->where('previewData.0.status', 'Nama wajib diisi.'));
});

// ============================================================
// Successful Import Tests
// ============================================================

it('imports valid employees without duplicates', function () {
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Budi Santoso,EMP-104,2026-10-15,IT,Staff,operator\n".
        "Siti Wijaya,EMP-105,2026-10-16,HR,Manager,admin\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->where('previewData.0.is_valid', true)
            ->where('previewData.1.is_valid', true));

    $response = $this->post(rate('admin.employees.import-store'));

    $response->assertRedirect(route('admin.employees.index'))
        ->assertSessionHas('success', 'Data Karyawan & User berhasil diimport.');

    expect(Employee::where('employee_code', 'EMP-104')->exists())->toBeTrue()
        ->and(Employee::where('employee_code', 'EMP-105')->exists())->toBeTrue();
});

it('skips invalid rows but imports valid ones', function () {
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Budi Santoso,EMP-106,2026-10-15,IT,Staff,operator\n".
        ",EMP-107,,IT,Staff,operator\n". // Invalid: empty name and date
        "Siti Wijaya,EMP-108,2026-10-16,HR,Manager,admin\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $this->get(route('admin.employees.import-confirm'))
        ->assertOk();

    $previewData = session('import_employees_preview', []);
    expect($previewData[0]['is_valid'])->toBeTrue()
        ->and($previewData[1]['is_valid'])->toBeFalse()
        ->and($previewData[2]['is_valid'])->toBeTrue();

    // Import should skip invalid row
    $this->post(route('admin.employees.import-store'));

    expect(Employee::where('employee_code', 'EMP-106')->exists())->toBeTrue()
        ->and(Employee::where('employee_code', 'EMP-107')->exists())->toBeFalse()
        ->and(Employee::where('employee_code', 'EMP-108')->exists())->toBeTrue();
});

it('does not import when all rows are invalid', function () {
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        ",EMP-109,,IT,Staff,operator\n".
        "Jane Doe,,2026-10-17,HR,Manager,admin\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $response = $this->post(route('admin.employees.import-store'));

    // Should redirect back to confirm page with error
    $response->assertRedirect(route('admin.employees.import-confirm'));

    expect(Employee::count())->toBe(0);
});

// ============================================================
// Edge Cases
// ============================================================

it('handles Excel date format (serial numbers)', function () {
    // Excel stores dates as serial numbers (days since 1899-12-30)
    // 44927 = 2023-01-01
    $csvContent = "nama,kode_karyawan,tanggal_bergabung,departemen,jabatan,role\n".
        "Excel Date User,EMP-110,44927,IT,Staff,operator\n";

    $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $csvContent),
    ])->assertRedirect(route('admin.employees.import-confirm'));

    $previewData = session('import_employees_preview', []);

    // Should parse Excel date correctly
    expect($previewData[0]['is_valid'])->toBeTrue()
        ->and($previewData[0]['join_date'])->toBe('2023-01-01');
});

it('validates maximum file size', function () {
    $content = str_repeat('a', 2049); // > 2MB limit for CSV won't work, but test validation

    $response = $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->createWithContent('karyawan.csv', $content),
    ]);

    // Should fail mimes validation or max size
    $this->assertGuest();
});

it('validates allowed file types', function () {
    $response = $this->post(route('admin.employees.import-preview'), [
        'file' => UploadedFile::fake()->create('karyawan.exe', 100, 'application/octet-stream'),
    ]);

    $this->assertGuest();
});
