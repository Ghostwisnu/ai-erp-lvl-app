<?php

namespace App\Http\Controllers\Admin;

use App\Models\Employee;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\Models\Role;
use App\Imports\EmployeesImport;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\Hash;
use App\Exports\EmployeeTemplateExport;


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

        return $this->renderAdminPage('Admin/Employees/Index', [
            'employees' => \App\Models\Employee::with('user')->latest()->paginate(10),
            'departments' => $departments, // <-- Kirim data departemen
        ]);
    }

    public function create()
    {
        // Hanya tampilkan user yang BELUM punya data karyawan
        $users = User::doesntHave('employee')->get();

        return $this->renderAdminPage('Admin/Employees/Create', [
            'users' => $users,
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
                $user = User::create([
                    'name' => $data['name'],
                    'email' => $data['email'],
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
                    'department' => $data['department'],
                    'position' => $data['position'],
                    'join_date' => now()->toDateString(),

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
            'basic_salary' => 'required|numeric|min:0',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

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
            'employee' => $employee->load('user'),
        ]);
    }

    public function edit(Employee $employee)
    {
        return $this->renderAdminPage('Admin/Employees/Edit', [
            'employee' => $employee->load('user'),
            'users' => User::all(), // Bisa ganti user jika diperlukan
        ]);
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
            'basic_salary' => 'required|numeric|min:0',
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
