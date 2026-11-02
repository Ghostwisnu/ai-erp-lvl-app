<?php

namespace App\Http\Controllers\Admin;

use App\Models\Employee;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\Models\Role;
use App\Imports\EmployeesImport;
use App\Imports\EmployeeSalaryImport;
use App\Imports\EmployeeUpdateImport;
use App\Exports\EmployeeUpdateTemplateExport;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\Hash;
use App\Exports\EmployeeTemplateExport;
use App\Exports\EmployeeSalaryTemplateExport;


class EmployeeController extends BaseAdminController
{
    public function index(Request $request)
    {
        // Ambil daftar departemen unik untuk filter
        $departments = \App\Models\Employee::whereNotNull('department')
            ->where('department', '!=', '')
            ->distinct()
            ->pluck('department')
            ->toArray();

        $search = trim((string) $request->query('search', ''));
        $department = (string) $request->query('department', '');

        $employees = \App\Models\Employee::with('user')
            ->when($search !== '', function ($query) use ($search) {
                $like = '%' . addcslashes($search, '\\%_') . '%';
                $query->where(fn ($q) => $q->where('full_name', 'like', $like)->orWhere('employee_code', 'like', $like));
            })
            ->when($department !== '', fn ($query) => $query->where('department', $department))
            ->latest()
            ->paginate(10)
            ->withQueryString()
            ->through(fn (Employee $employee) => $this->hideSalaryUnlessAllowed($employee));

        return $this->renderAdminPage('Admin/Employees/Index', [
            'employees' => $employees,
            'departments' => $departments, // <-- Kirim data departemen
            'filters' => ['search' => $search, 'department' => $department],
        ]);
    }

    public function create()
    {
        // Hanya tampilkan user yang BELUM punya data karyawan
        $users = User::doesntHave('employee')->orderBy('name')->get();

        return $this->renderAdminPage('Admin/Employees/Create', [
            'users' => $users,
            'canViewSalary' => $this->canViewSalary(),
        ]);
    }

    // 1. Tampilkan Form Upload
    public function importForm()
    {
        return $this->renderAdminPage('Admin/Employees/Import');
    }

    // 2. Proses Preview (Baca File)
    public function importPreview(Request $request)
    {
        $request->validate([
            'file' => 'required|mimes:xlsx,xls,csv|max:2048'
        ]);

        $import = new EmployeesImport();
        Excel::import($import, $request->file('file'));

        // Simpan data preview ke session sementara
        session(['import_employees_preview' => $import->previewData]);

        // PERBAIKAN: Arahkan ke route GET yang benar
        return redirect()->route('admin.employees.import-confirm');
    }

    // 3. Tampilkan Halaman Preview (Konfirmasi)
    public function importPreviewPage()
    {
        $previewData = session('import_employees_preview', []);

        if (empty($previewData)) {
            return redirect()->route('admin.employees.import-form')->with('error', 'Tidak ada data untuk dipreview.');
        }

        return $this->renderAdminPage('Admin/Employees/ImportPreview', [
            'previewData' => $previewData
        ]);
    }

    // 4. Proses Simpan (Konfirmasi)
    public function importStore(Request $request)
    {
        $previewData = session('import_employees_preview', []);

        if (empty($previewData)) {
            return redirect()->route('admin.employees.import-form')->with('error', 'Sesi data preview habis.');
        }

        DB::transaction(function () use ($previewData) {
            foreach ($previewData as $data) {
                if (!$data['is_valid']) continue;

                // 1. Buat User Baru
                $generatedEmail = 'employee-' . hash('sha256', strtolower($data['employee_code'])) . '@employees.invalid';
                $user = User::create([
                    'name' => $data['name'],
                    'email' => $generatedEmail,
                    'password' => Hash::make($data['employee_code']),
                    'email_verified_at' => now(),
                ]);

                // Assign Role
                $roleName = strtolower($data['role']);
                $role = Role::firstOrCreate(['name' => $roleName]);
                $user->assignRole($role);

                // 2. Buat Data Karyawan (Tambahkan nilai default untuk kolom wajib)
                Employee::create([
                    'user_id' => $user->id,
                    'employee_code' => $data['employee_code'],
                    'full_name' => $data['name'],
                    'department' => $data['department'] ?: null,
                    'position' => $data['position'] ?: null,
                    'join_date' => $data['join_date'],

                    // KOLOM WAJIB YANG HARUS DIISI DEFAULT:
                    'birth_place' => '-', // Atau 'Tidak Diketahui'
                    'birth_date' => now()->toDateString(), // Default hari ini
                    'gender' => 'L', // Default Laki-laki
                    'basic_salary' => 0, // Default 0
                ]);
            }
        });

        session()->forget('import_employees_preview');

        return redirect()->route('admin.employees.index')->with('success', 'Data Karyawan & User berhasil diimport.');
    }

    public function downloadTemplate()
    {
        return Excel::download(new EmployeeTemplateExport, 'template_import_karyawan.xlsx');
    }

    public function bulkUpdateForm()
    {
        return $this->renderAdminPage('Admin/Employees/BulkUpdate');
    }

    public function bulkUpdatePreview(Request $request)
    {
        $request->validate([
            'file' => 'required|mimes:xlsx,xls,csv|max:2048',
        ]);

        $import = new EmployeeUpdateImport();
        Excel::import($import, $request->file('file'));

        if ($import->previewData === []) {
            return redirect()->route('admin.employees.bulk-update')
                ->with('error', 'File tidak berisi baris data karyawan.');
        }

        session(['import_employee_updates_preview' => $import->previewData]);

        return redirect()->route('admin.employees.bulk-update.confirm');
    }

    public function bulkUpdatePreviewPage()
    {
        $previewData = session('import_employee_updates_preview', []);

        if ($previewData === []) {
            return redirect()->route('admin.employees.bulk-update')
                ->with('error', 'Tidak ada data untuk dipreview. Silakan unggah file.');
        }

        return $this->renderAdminPage('Admin/Employees/BulkUpdatePreview', [
            'previewData' => $previewData,
        ]);
    }

    public function bulkUpdateStore()
    {
        $previewData = session('import_employee_updates_preview', []);

        if ($previewData === [] || collect($previewData)->contains(fn ($row) => !($row['is_valid'] ?? false))) {
            return redirect()->route('admin.employees.bulk-update.confirm')
                ->with('error', 'Perbaiki semua baris yang tidak valid sebelum menyimpan.');
        }

        $allowedColumns = array_column(EmployeeUpdateImport::FIELDS, 'column');

        $updated = DB::transaction(function () use ($previewData, $allowedColumns) {
            $employees = Employee::query()
                ->whereIn('employee_code', array_column($previewData, 'employee_code'))
                ->lockForUpdate()
                ->get()
                ->keyBy('employee_code');

            if ($employees->count() !== count($previewData)) {
                return null;
            }

            $count = 0;

            foreach ($previewData as $row) {
                $values = collect($row['changes'])
                    ->only($allowedColumns)
                    ->map(fn ($change) => $change['new'])
                    ->all();

                if ($values === []) {
                    continue;
                }

                $employee = $employees->get($row['employee_code']);
                $employee->update($values);

                if (isset($values['full_name']) && $employee->user) {
                    $employee->user->update(['name' => $values['full_name']]);
                }

                $count++;
            }

            return $count;
        });

        session()->forget('import_employee_updates_preview');

        if ($updated === null) {
            return redirect()->route('admin.employees.bulk-update')
                ->with('error', 'Ada karyawan yang tidak ditemukan lagi. Silakan unggah ulang file.');
        }

        return redirect()->route('admin.employees.index')
            ->with('success', "Data $updated karyawan berhasil diperbarui.");
    }

    public function downloadBulkUpdateTemplate()
    {
        return Excel::download(new EmployeeUpdateTemplateExport, 'template_update_karyawan.xlsx');
    }

    public function salaryImportForm()
    {
        return $this->renderAdminPage('Admin/Employees/SalaryImport');
    }

    public function salaryImportPreview(Request $request)
    {
        $request->validate([
            'file' => 'required|mimes:xlsx,xls,csv|max:2048',
        ]);

        $import = new EmployeeSalaryImport();
        Excel::import($import, $request->file('file'));

        if ($import->previewData === []) {
            return redirect()->route('admin.employees.salary-import')
                ->with('error', 'File tidak berisi baris data gaji.');
        }

        session(['import_employee_salaries_preview' => $import->previewData]);

        return redirect()->route('admin.employees.salary-import.confirm');
    }

    public function salaryImportPreviewPage()
    {
        $previewData = session('import_employee_salaries_preview', []);

        if ($previewData === []) {
            return redirect()->route('admin.employees.salary-import')
                ->with('error', 'Tidak ada data gaji untuk dipreview. Silakan unggah file.');
        }

        return $this->renderAdminPage('Admin/Employees/SalaryImportPreview', [
            'previewData' => $previewData,
        ]);
    }

    public function salaryImportStore()
    {
        $previewData = session('import_employee_salaries_preview', []);

        if ($previewData === [] || collect($previewData)->contains(fn ($row) => !($row['is_valid'] ?? false))) {
            return redirect()->route('admin.employees.salary-import.confirm')
                ->with('error', 'Perbaiki semua baris yang tidak valid sebelum menyimpan data gaji.');
        }

        validator(['rows' => $previewData], [
            'rows' => 'required|array|min:1',
            'rows.*.employee_code' => 'required|string',
            'rows.*.new_salary' => 'required|numeric|min:0',
            'rows.*.current_salary' => 'required|numeric|min:0',
        ])->validate();

        $updated = DB::transaction(function () use ($previewData) {
            $employees = Employee::query()
                ->whereIn('employee_code', array_column($previewData, 'employee_code'))
                ->lockForUpdate()
                ->get()
                ->keyBy('employee_code');

            foreach ($previewData as $row) {
                $employee = $employees->get($row['employee_code']);

                if (!$employee || round((float) $employee->basic_salary, 2) !== round((float) $row['current_salary'], 2)) {
                    return false;
                }
            }

            foreach ($previewData as $row) {
                $employee = $employees->get($row['employee_code']);
                $employee->basic_salary = $row['new_salary'];
                $employee->save();
            }

            return true;
        });

        session()->forget('import_employee_salaries_preview');

        if (!$updated) {
            return redirect()->route('admin.employees.salary-import')
                ->with('error', 'Data karyawan atau gaji berubah setelah pratinjau. Silakan unggah ulang file.');
        }

        return redirect()->route('admin.employees.index')
            ->with('success', 'Data gaji ' . count($previewData) . ' karyawan berhasil diperbarui.');
    }

    public function downloadSalaryTemplate()
    {
        return Excel::download(new EmployeeSalaryTemplateExport, 'template_import_gaji_karyawan.xlsx');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id|unique:employees,user_id',
            'employee_code' => 'nullable|string', // <-- Ubah jadi nullable, karena akan digenerate
            'full_name' => 'required|string|max:255',
            'birth_place' => 'required|string|max:255',
            'birth_date' => 'required|date',
            'gender' => 'required|in:L,P',
            'phone_number' => 'nullable|string|max:20',
            'address' => 'nullable|string',
            'department' => 'nullable|string|max:255',
            'position' => 'nullable|string|max:255',
            'join_date' => 'required|date',
            'start_time' => 'nullable',
            'end_time' => 'nullable',
            'basic_salary' => ($this->canViewSalary() ? 'required' : 'exclude') . '|numeric|min:0',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        $validated['basic_salary'] ??= 0;

        // --- GENERATE KODE KARYAWAN OTOMATIS ---
        // Format: YYYYMMXXX (4 Tahun, 2 Bulan, 3 Nomor Urut)
        $joinDate = \Carbon\Carbon::parse($validated['join_date']);
        $year = $joinDate->format('Y'); // Contoh: 2024
        $month = $joinDate->format('m'); // Contoh: 01
        $prefix = $year . $month; // Hasil: 202401

        // Cari kode terakhir di bulan dan tahun yang sama
        $lastEmployee = Employee::where('employee_code', 'LIKE', $prefix . '%')
            ->orderBy('employee_code', 'desc')
            ->first();

        if ($lastEmployee) {
            // Ambil 3 digit terakhir, tambah 1
            $lastSequence = (int) substr($lastEmployee->employee_code, -3);
            $newSequence = $lastSequence + 1;
        } else {
            // Jika belum ada di bulan ini, mulai dari 1
            $newSequence = 1;
        }

        // Format nomor urut jadi 3 digit (001, 002, dst)
        $sequence = str_pad($newSequence, 3, '0', STR_PAD_LEFT);

        // Gabungkan semua
        $validated['employee_code'] = $prefix . $sequence;
        // ---------------------------------------

        if ($request->hasFile('photo')) {
            $validated['photo_path'] = $request->file('photo')->store('employees', 'public');
        }

        Employee::create($validated);

        return redirect()->route('admin.employees.index')
            ->with('success', 'Data Karyawan berhasil ditambahkan dengan Kode: ' . $validated['employee_code']);
    }

    public function show(Employee $employee)
    {
        return $this->renderAdminPage('Admin/Employees/Show', [
            'employee' => $this->hideSalaryUnlessAllowed($employee->load('user')),
            'canViewSalary' => $this->canViewSalary(),
        ]);
    }

    public function edit(Employee $employee)
    {
        return $this->renderAdminPage('Admin/Employees/Edit', [
            'employee' => $this->hideSalaryUnlessAllowed($employee->load('user')),
            'users' => User::doesntHave('employee')->orWhere('id', $employee->user_id)->orderBy('name')->get(),
            'canViewSalary' => $this->canViewSalary(),
        ]);
    }

    private function canViewSalary(): bool
    {
        return (bool) auth()->user()?->can('view-employee-salary');
    }

    private function hideSalaryUnlessAllowed(Employee $employee): Employee
    {
        return $this->canViewSalary() ? $employee : $employee->makeHidden('basic_salary');
    }

    public function update(Request $request, Employee $employee)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id|unique:employees,user_id,' . $employee->id,
            // 'employee_code' => 'required|string|unique:employees,employee_code,' . $employee->id,
            'full_name' => 'required|string|max:255',
            'birth_place' => 'required|string|max:255',
            'birth_date' => 'required|date',
            'gender' => 'required|in:L,P',
            'phone_number' => 'nullable|string|max:20',
            'address' => 'nullable|string',
            'department' => 'nullable|string|max:255',
            'position' => 'nullable|string|max:255',
            'join_date' => 'required|date',
            'start_time' => 'nullable',
            'end_time' => 'nullable',
            'basic_salary' => ($this->canViewSalary() ? 'required' : 'exclude') . '|numeric|min:0',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        unset($validated['employee_code']);
        if ($request->hasFile('photo')) {
            // Hapus foto lama jika ada
            if ($employee->photo_path) {
                Storage::disk('public')->delete($employee->photo_path);
            }
            $validated['photo_path'] = $request->file('photo')->store('employees', 'public');
        }

        $employee->update($validated);

        return redirect()->route('admin.employees.index')
            ->with('success', 'Data Karyawan berhasil diupdate.');
    }

    public function destroy(Employee $employee)
    {
        if ($employee->photo_path) {
            Storage::disk('public')->delete($employee->photo_path);
        }
        $employee->delete();

        return redirect()->route('admin.employees.index')
            ->with('success', 'Data Karyawan berhasil dihapus.');
    }
}
