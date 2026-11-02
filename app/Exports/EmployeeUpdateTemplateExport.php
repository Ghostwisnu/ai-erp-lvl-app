<?php

namespace App\Exports;

use App\Imports\EmployeeUpdateImport;
use Maatwebsite\Excel\Concerns\FromArray;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class EmployeeUpdateTemplateExport implements FromArray, WithHeadings, WithStyles
{
    public function array(): array
    {
        return [
            ['202401001', 'Budi Santoso', 'Bandung', '1990-05-20', 'L', '081234567890', 'Jl. Merdeka No. 1', 'Produksi', 'Operator', '2024-01-15'],
        ];
    }

    public function headings(): array
    {
        return ['kode_karyawan', ...array_keys(EmployeeUpdateImport::FIELDS)];
    }

    public function styles(Worksheet $sheet): array
    {
        return [
            1 => [
                'font' => ['bold' => true, 'color' => ['argb' => 'FFFFFFFF']],
                'fill' => [
                    'fillType' => Fill::FILL_SOLID,
                    'startColor' => ['argb' => 'FF4F81BD'],
                ],
            ],
        ];
    }
}
