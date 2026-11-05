<?php

namespace App\Imports;

use App\Models\Employee;
use Carbon\Carbon;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;
use PhpOffice\PhpSpreadsheet\Shared\Date as ExcelDate;

/**
 * Pembaruan massal data karyawan. Kolom gaji sengaja tidak didukung,
 * dan sel kosong berarti data lama tidak diubah.
 */
class EmployeeUpdateImport implements ToCollection, WithHeadingRow
{
    public const FIELDS = [
        'nama' => ['column' => 'full_name', 'label' => 'Nama', 'max' => 255],
        'tempat_lahir' => ['column' => 'birth_place', 'label' => 'Tempat Lahir', 'max' => 255],
        'tanggal_lahir' => ['column' => 'birth_date', 'label' => 'Tanggal Lahir', 'type' => 'date'],
        'jenis_kelamin' => ['column' => 'gender', 'label' => 'Jenis Kelamin', 'type' => 'gender'],
        'no_telepon' => ['column' => 'phone_number', 'label' => 'No. Telepon', 'max' => 20],
        'alamat' => ['column' => 'address', 'label' => 'Alamat'],
        'departemen' => ['column' => 'department', 'label' => 'Departemen', 'max' => 255],
        'posisi' => ['column' => 'position', 'label' => 'Posisi', 'max' => 255],
        'tanggal_bergabung' => ['column' => 'join_date', 'label' => 'Tanggal Bergabung', 'type' => 'date'],
    ];

    /** @var list<array{row_number: int, employee_code: string, full_name: string|null, changes: array<string, array{label: string, old: mixed, new: string}>, status: string, is_valid: bool}> */
    public array $previewData = [];

    /** @param Collection<int, array<string, mixed>> $rows */
    public function collection(Collection $rows): void
    {
        $rows = $rows->map(fn ($row, $index) => [
            'row_number' => $index + 2,
            'data' => $row instanceof Collection ? $row->all() : (array) $row,
            'code' => trim((string) ($row['kode_karyawan'] ?? '')),
        ])->filter(fn (array $row) => $row['code'] !== '' || $this->hasAnyValue($row['data']));

        $employees = Employee::query()
            ->whereIn('employee_code', $rows->pluck('code')->filter()->unique())
            ->get()
            ->keyBy('employee_code');

        $seenCodes = [];

        foreach ($rows as $row) {
            $code = $row['code'];
            $employee = $employees->get($code);
            $errors = [];
            $changes = [];

            if ($code === '') {
                $errors[] = 'Kode karyawan wajib diisi.';
            } elseif (isset($seenCodes[$code])) {
                $errors[] = 'Kode karyawan duplikat di dalam file.';
            } elseif (! $employee) {
                $errors[] = 'Karyawan tidak ditemukan.';
            }

            if ($code !== '') {
                $seenCodes[$code] = true;
            }

            foreach (self::FIELDS as $header => $field) {
                $raw = $row['data'][$header] ?? null;

                if ($raw === null || trim((string) $raw) === '') {
                    continue;
                }

                [$value, $error] = $this->normalize($raw, $field);

                if ($error) {
                    $errors[] = $field['label'].' '.$error;

                    continue;
                }

                $current = $employee?->{$field['column']};
                if ($employee && (string) $current !== (string) $value) {
                    $changes[$field['column']] = [
                        'label' => $field['label'],
                        'old' => $current,
                        'new' => $value,
                    ];
                }
            }

            $this->previewData[] = [
                'row_number' => $row['row_number'],
                'employee_code' => $code,
                'full_name' => $employee?->full_name,
                'changes' => $changes,
                'status' => $errors
                    ? implode(' ', $errors)
                    : ($changes === [] ? 'Tidak ada perubahan' : 'Siap diperbarui'),
                'is_valid' => $errors === [],
            ];
        }
    }

    /** @param array<string, mixed> $row */
    private function hasAnyValue(array $row): bool
    {
        foreach (array_keys(self::FIELDS) as $header) {
            if (trim((string) ($row[$header] ?? '')) !== '') {
                return true;
            }
        }

        return false;
    }

    /**
     * @param  array{column: string, label: string, max?: int, type?: string}  $field
     * @return array{string|null, string|null}
     */
    private function normalize(mixed $raw, array $field): array
    {
        $type = $field['type'] ?? 'text';

        if ($type === 'date') {
            $date = $this->parseDate($raw);

            return $date ? [$date, null] : [null, 'harus berupa tanggal valid (YYYY-MM-DD atau DD/MM/YYYY).'];
        }

        $text = trim((string) $raw);

        if ($type === 'gender') {
            $gender = match (strtolower($text)) {
                'l', 'laki-laki', 'laki laki', 'pria' => 'L',
                'p', 'perempuan', 'wanita' => 'P',
                default => null,
            };

            return $gender ? [$gender, null] : [null, 'harus L atau P.'];
        }

        if (isset($field['max']) && mb_strlen($text) > $field['max']) {
            return [null, 'maksimal '.$field['max'].' karakter.'];
        }

        return [$text, null];
    }

    private function parseDate(mixed $value): ?string
    {
        try {
            if (is_numeric($value)) {
                return ExcelDate::excelToDateTimeObject((float) $value)->format('Y-m-d');
            }

            $text = trim((string) $value);

            foreach (['Y-m-d', 'd/m/Y'] as $format) {
                if (Carbon::canBeCreatedFromFormat($text, '!'.$format)) {
                    $date = Carbon::createFromFormat('!'.$format, $text);

                    if ($date->format($format) === $text) {
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
