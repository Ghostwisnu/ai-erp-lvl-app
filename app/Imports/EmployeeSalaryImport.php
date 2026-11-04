<?php

namespace App\Imports;

use App\Models\Employee;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class EmployeeSalaryImport implements ToCollection, WithHeadingRow
{
    /** @var list<array{row_number: int, employee_code: string, full_name: string|null, current_salary: numeric-string|int|float|null, new_salary: float|null, status: string, is_valid: bool}> */
    public array $previewData = [];

    /** @param Collection<int, array<string, mixed>> $rows */
    public function collection(Collection $rows): void
    {
        $normalizedRows = $rows->map(function ($row, $index) {
            return [
                'row_number' => $index + 2,
                'employee_code' => trim((string) ($row['kode_karyawan'] ?? '')),
                'new_salary' => $row['gaji_pokok_baru'] ?? null,
            ];
        })->filter(fn (array $row) => $row['employee_code'] !== '' || $row['new_salary'] !== null);

        $employees = Employee::query()
            ->whereIn('employee_code', $normalizedRows->pluck('employee_code')->filter()->unique())
            ->get(['id', 'employee_code', 'full_name', 'basic_salary'])
            ->keyBy('employee_code');

        $seenCodes = [];

        foreach ($normalizedRows as $row) {
            $employee = $employees->get($row['employee_code']);
            $salary = $row['new_salary'];
            $errors = [];

            if ($row['employee_code'] === '') {
                $errors[] = 'Kode karyawan wajib diisi.';
            } elseif (isset($seenCodes[$row['employee_code']])) {
                $errors[] = 'Kode karyawan duplikat di dalam file.';
            }

            if ($row['employee_code'] !== '') {
                $seenCodes[$row['employee_code']] = true;
            }

            if (! $employee && $row['employee_code'] !== '') {
                $errors[] = 'Karyawan tidak ditemukan.';
            }

            if (! is_numeric($salary) || ! is_finite((float) $salary) || (float) $salary < 0) {
                $errors[] = 'Gaji pokok harus berupa angka nol atau lebih.';
            }

            $this->previewData[] = [
                'row_number' => $row['row_number'],
                'employee_code' => $row['employee_code'],
                'full_name' => $employee?->full_name,
                'current_salary' => $employee?->basic_salary,
                'new_salary' => is_numeric($salary) ? (float) $salary : null,
                'status' => $errors ? implode(' ', $errors) : 'Siap diperbarui',
                'is_valid' => $errors === [],
            ];
        }
    }
}
