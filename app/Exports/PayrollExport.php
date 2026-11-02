<?php

namespace App\Exports;

use App\Models\PayrollRun;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class PayrollExport implements FromCollection, WithHeadings
{
    public function __construct(private readonly PayrollRun $payrollRun) {}

    public function collection(): Collection
    {
        return $this->payrollRun->items()
            ->with('adjustments')
            ->orderBy('employee_name')
            ->get()
            ->map(function ($item) {
                $allowances = $item->adjustments->where('type', 'allowance');
                $deductions = $item->adjustments->where('type', 'deduction');
                $allowanceTotal = $allowances->sum('amount');
                $deductionTotal = $deductions->sum('amount');
                $netPay = (float) $item->basic_salary
                    - (float) $item->absence_deduction
                    + (float) $item->overtime_amount
                    + $allowanceTotal
                    - $deductionTotal;

                return [
                    $item->employee_code,
                    $item->employee_name,
                    $item->department,
                    (float) $item->basic_salary,
                    (float) $item->daily_rate,
                    $item->unpaid_absence_days,
                    (float) $item->absence_deduction,
                    (float) $item->overtime_hours,
                    (float) $item->overtime_hourly_rate,
                    (float) $item->overtime_amount,
                    $allowances->map(fn ($adjustment) => "{$adjustment->description}: {$adjustment->amount}")->implode('; '),
                    $allowanceTotal,
                    $deductions->map(fn ($adjustment) => "{$adjustment->description}: {$adjustment->amount}")->implode('; '),
                    $deductionTotal,
                    max(0, $netPay),
                ];
            });
    }

    public function headings(): array
    {
        return [
            'NIK',
            'Nama Karyawan',
            'Departemen',
            'Gaji Pokok',
            'Tarif Harian (Gaji/30)',
            'Hari Potongan',
            'Potongan Absensi',
            'Jam Lembur',
            'Tarif lembur per Jam (Gaji/30/8)',
            'Uang Lembur',
            'Rincian Tunjangan',
            'Total Tunjangan',
            'Rincian Potongan',
            'Total Potongan Tambahan',
            'Gaji Bersih',
        ];
    }
}
