<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromArray;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class EmployeeTemplateExport implements FromArray, WithHeadings, WithStyles
{
    public function array(): array
    {
        // Contoh baris data dummy sebagai panduan (opsional)
        return [
            [
                'Budi Santoso',
                'EMP-001',
                '2026-11-02',
                'IT',
                'Staff',
                'Operator',
            ],
        ];
    }

    public function headings(): array
    {
        // Tanda * menandakan kolom wajib isi
        return [
            'nama *',
            'kode_karyawan *',
            'tanggal_bergabung *',
            'departemen',
            'jabatan',
            'role',
        ];
    }

    public function styles(Worksheet $sheet): array
    {
        return [
            // Mengatur gaya untuk baris pertama (Heading)
            1 => [
                'font' => [
                    'bold' => true,
                    'color' => ['argb' => 'FFFFFFFF'], // Warna teks putih
                ],
                'fill' => [
                    'fillType' => Fill::FILL_SOLID,
                    'startColor' => ['argb' => 'FF4F81BD'], // Warna background biru
                ],
            ],
        ];
    }
}
