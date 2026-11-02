<?php

namespace App\Imports;

use App\Models\Employee;
use Carbon\Carbon;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;
use PhpOffice\PhpSpreadsheet\Shared\Date as ExcelDate;

class EmployeesImport implements ToCollection, WithHeadingRow
{
    public $previewData = [];

    public function collection(Collection $rows): void
    {
        $seenCodes = [];

        foreach ($rows as $index => $row) {
            $name = trim((string) ($row['nama'] ?? ''));
            $employeeCode = trim((string) ($row['kode_karyawan'] ?? ''));
            $joinDate = $this->parseJoinDate($row['tanggal_bergabung'] ?? null);

            if ($name === '' && $employeeCode === '' && empty($row['tanggal_bergabung'])) {
                continue;
            }

            $errors = [];

            if ($name === '') {
                $errors[] = 'Nama wajib diisi.';
            }

            if ($employeeCode === '') {
                $errors[] = 'Kode karyawan wajib diisi.';
            } elseif (isset($seenCodes[$employeeCode])) {
                $errors[] = 'Kode karyawan duplikat di dalam file.';
            } elseif (Employee::where('employee_code', $employeeCode)->exists()) {
                $errors[] = 'Kode karyawan sudah terdaftar.';
            }

            if ($employeeCode !== '') {
                $seenCodes[$employeeCode] = true;
            }

            if (!$joinDate) {
                $errors[] = 'Tanggal bergabung wajib diisi dengan tanggal yang valid.';
            }

            $this->previewData[] = [
                'name' => $name,
                'employee_code' => $employeeCode,
                'department' => $row['departemen'] ?? '-',
                'position' => $row['jabatan'] ?? '-',
                'role' => $row['role'] ?? 'operator',
                'join_date' => $joinDate,
                'status' => $errors ? implode(' ', $errors) : 'Siap Diimport',
                'is_valid' => $errors === [],
            ];
        }
    }

    private function parseJoinDate(mixed $value): ?string
    {
        if ($value === null || trim((string) $value) === '') {
            return null;
        }

        try {
            if (is_numeric($value)) {
                return ExcelDate::excelToDateTimeObject((float) $value)->format('Y-m-d');
            }

            $dateValue = trim((string) $value);

            foreach (['Y-m-d', 'd/m/Y'] as $format) {
                if (Carbon::canBeCreatedFromFormat($dateValue, '!' . $format)) {
                    $date = Carbon::createFromFormat('!' . $format, $dateValue);

                    if ($date->format($format) === $dateValue) {
                        return $date->toDateString();
                    }
                }
            }

            return null;
        } catch (\Exception) {
            return null;
        }
    }
}
