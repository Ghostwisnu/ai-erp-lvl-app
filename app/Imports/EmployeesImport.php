<?php

namespace App\Imports;

use App\Models\Employee;
use App\Models\User;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class EmployeesImport implements ToCollection, WithHeadingRow
{
    public $previewData = [];

    public function collection(Collection $rows): void
    {
        foreach ($rows as $row) {
            // 1. Validasi Kolom Wajib (Nama, Email, Kode Karyawan)
            // Jika ada yang kosong, lewati baris ini.
            if (empty($row['nama']) || empty($row['email']) || empty($row['kode_karyawan'])) {
                continue;
            }

            // 2. Cek Duplikasi di Database
            $userExists = User::where('email', $row['email'])->exists();
            $empExists = Employee::where('employee_code', $row['kode_karyawan'])->exists();

            // 3. Susun Data Preview
            $this->previewData[] = [
                'name' => $row['nama'],
                'email' => $row['email'],
                'employee_code' => $row['kode_karyawan'],
                'department' => $row['departemen'] ?? '-',
                'position' => $row['jabatan'] ?? '-',
                'role' => $row['role'] ?? 'operator',
                'status' => ($userExists || $empExists) ? 'Gagal (Data sudah ada)' : 'Siap Diimport',
                'is_valid' => !$userExists && !$empExists
            ];
        }
    }
}
