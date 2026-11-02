<?php

namespace App\Http\Controllers\Admin;

use App\Exports\PayrollExport;
use App\Models\Attendance;
use App\Models\Employee;
use App\Models\Holiday;
use App\Models\LeaveRequest;
use App\Models\PayrollAdjustment;
use App\Models\PayrollItem;
use App\Models\PayrollRun;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;

class PayrollController extends BaseAdminController
{
    public function index()
    {
        $payrollRuns = PayrollRun::query()
            ->with('items.adjustments')
            ->orderByDesc('year')
            ->orderByDesc('month')
            ->get()
            ->map(fn (PayrollRun $run) => [
                'id' => $run->id,
                'month' => $run->month,
                'year' => $run->year,
                'period_start' => $run->period_start->toDateString(),
                'period_end' => $run->period_end->toDateString(),
                'status' => $run->status,
                'items_count' => $run->items->count(),
                'net_pay_total' => round($run->items
                    ->sum(fn (PayrollItem $item) => $this->netPay($item)), 2),
            ]);

        $month = Carbon::today()->day >= 26
            ? Carbon::today()->addMonth()->month
            : Carbon::today()->month;
        $year = Carbon::today()->day >= 26
            ? Carbon::today()->addMonth()->year
            : Carbon::today()->year;

        return $this->renderAdminPage('Admin/Payroll/Index', [
            'payrollRuns' => $payrollRuns,
            'defaultMonth' => $month,
            'defaultYear' => $year,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'month' => ['required', 'integer', 'between:1,12'],
            'year' => ['required', 'integer', 'between:2000,2100'],
        ]);

        $month = (int) $validated['month'];
        $year = (int) $validated['year'];

        if (PayrollRun::where(compact('month', 'year'))->exists()) {
            return redirect()->route('admin.payroll.index')
                ->with('error', 'Penggajian untuk periode tersebut sudah pernah dibuat.');
        }

        $periodStart = Carbon::createFromDate($year, $month, 26)->subMonth();
        $periodEnd = Carbon::createFromDate($year, $month, 25);
        $startDate = $periodStart->toDateString();
        $endDate = $periodEnd->toDateString();

        $employees = Employee::query()
            ->with(['attendances' => fn ($query) => $query->whereBetween('date', [$startDate, $endDate])])
            ->orderBy('full_name')
            ->get();
        $approvedLeaves = LeaveRequest::query()
            ->where('status', 'approved')
            ->where('start_date', '<=', $endDate)
            ->where(fn ($query) => $query
                ->where('end_date', '>=', $startDate)
                ->orWhereNull('end_date'))
            ->get()
            ->groupBy('employee_id');
        $holidayDates = Holiday::query()
            ->whereBetween('date', [$startDate, $endDate])
            ->pluck('date')
            ->map(fn ($date) => Carbon::parse($date)->toDateString())
            ->flip();
        $overtimeHours = DB::table('overtime_employees')
            ->join('overtimes', 'overtimes.id', '=', 'overtime_employees.overtime_id')
            ->whereBetween('overtimes.date', [$startDate, $endDate])
            ->select('overtime_employees.employee_id', DB::raw('SUM(overtime_employees.duration) as hours'))
            ->groupBy('overtime_employees.employee_id')
            ->pluck('hours', 'employee_id');

        $payrollRun = DB::transaction(function () use (
            $month,
            $year,
            $periodStart,
            $periodEnd,
            $employees,
            $approvedLeaves,
            $holidayDates,
            $overtimeHours
        ) {
            $run = PayrollRun::create([
                'month' => $month,
                'year' => $year,
                'period_start' => $periodStart->toDateString(),
                'period_end' => $periodEnd->toDateString(),
                'overtime_hourly_rate' => 0,
                'status' => 'draft',
                'generated_by' => Auth::id(),
            ]);

            foreach ($employees as $employee) {
                $unpaidAbsenceDays = $employee->attendances
                    ->filter(function (Attendance $attendance) use ($employee, $approvedLeaves, $holidayDates) {
                        if (! in_array($attendance->status, ['absent', 'sick', 'leave'], true)) {
                            return false;
                        }

                        $date = Carbon::parse($attendance->date);
                        if ($date->isWeekend() || $holidayDates->has($date->toDateString())) {
                            return false;
                        }

                        return ! $approvedLeaves->get($employee->id, collect())->contains(
                            fn (LeaveRequest $leave) => $date->between(
                                Carbon::parse($leave->start_date)->startOfDay(),
                                Carbon::parse($leave->end_date ?? $leave->start_date)->endOfDay(),
                            ),
                        );
                    })
                    ->count();

                $basicSalary = round((float) $employee->basic_salary, 2);
                $dailyRate = round($basicSalary / 30, 2);
                $overtimeHourlyRate = round($basicSalary / 30 / 8, 2);
                $absenceDeduction = min(
                    $basicSalary,
                    round($dailyRate * $unpaidAbsenceDays, 2),
                );
                $hours = round((float) ($overtimeHours->get($employee->id) ?? 0), 2);

                $run->items()->create([
                    'employee_id' => $employee->id,
                    'employee_code' => $employee->employee_code,
                    'employee_name' => $employee->full_name,
                    'department' => $employee->department,
                    'basic_salary' => $basicSalary,
                    'daily_rate' => $dailyRate,
                    'unpaid_absence_days' => $unpaidAbsenceDays,
                    'absence_deduction' => $absenceDeduction,
                    'overtime_hours' => $hours,
                    'overtime_hourly_rate' => $overtimeHourlyRate,
                    'overtime_amount' => round($hours * $overtimeHourlyRate, 2),
                ]);
            }

            return $run;
        });

        return redirect()->route('admin.payroll.show', $payrollRun)
            ->with('success', 'Draft penggajian berhasil dibuat.');
    }

    public function show(PayrollRun $payrollRun)
    {
        $items = $payrollRun->items()
            ->with('adjustments')
            ->orderBy('employee_name')
            ->get()
            ->map(function (PayrollItem $item) {
                $allowances = $item->adjustments->where('type', 'allowance')->values();
                $deductions = $item->adjustments->where('type', 'deduction')->values();

                return [
                    'id' => $item->id,
                    'employee_code' => $item->employee_code,
                    'employee_name' => $item->employee_name,
                    'department' => $item->department,
                    'basic_salary' => (float) $item->basic_salary,
                    'daily_rate' => (float) $item->daily_rate,
                    'unpaid_absence_days' => $item->unpaid_absence_days,
                    'absence_deduction' => (float) $item->absence_deduction,
                    'overtime_hours' => (float) $item->overtime_hours,
                    'overtime_hourly_rate' => (float) $item->overtime_hourly_rate,
                    'overtime_amount' => (float) $item->overtime_amount,
                    'adjustments' => $item->adjustments->map(fn (PayrollAdjustment $adjustment) => [
                        'id' => $adjustment->id,
                        'type' => $adjustment->type,
                        'description' => $adjustment->description,
                        'amount' => (float) $adjustment->amount,
                    ])->values(),
                    'allowance_total' => round($allowances->sum('amount'), 2),
                    'deduction_total' => round($deductions->sum('amount'), 2),
                    'net_pay' => $this->netPay($item),
                ];
            });

        return $this->renderAdminPage('Admin/Payroll/Show', [
            'payrollRun' => [
                'id' => $payrollRun->id,
                'month' => $payrollRun->month,
                'year' => $payrollRun->year,
                'period_start' => $payrollRun->period_start->toDateString(),
                'period_end' => $payrollRun->period_end->toDateString(),
                'status' => $payrollRun->status,
            ],
            'items' => $items,
            'totals' => [
                'basic_salary' => round($items->sum('basic_salary'), 2),
                'absence_deduction' => round($items->sum('absence_deduction'), 2),
                'overtime_amount' => round($items->sum('overtime_amount'), 2),
                'allowance_total' => round($items->sum('allowance_total'), 2),
                'deduction_total' => round($items->sum('deduction_total'), 2),
                'net_pay' => round($items->sum('net_pay'), 2),
            ],
        ]);
    }

    public function destroy(PayrollRun $payrollRun)
    {
        $deleted = DB::transaction(function () use ($payrollRun) {
            $lockedRun = PayrollRun::query()
                ->lockForUpdate()
                ->findOrFail($payrollRun->id);

            if ($lockedRun->status !== 'draft') {
                return false;
            }

            $lockedRun->delete();

            return true;
        });

        if (! $deleted) {
            return redirect()->back()->with('error', 'Hanya draft penggajian yang dapat dihapus.');
        }

        return redirect()->route('admin.payroll.index')
            ->with('success', 'Draft penggajian berhasil dihapus.');
    }

    public function storeAdjustment(Request $request, PayrollRun $payrollRun, PayrollItem $payrollItem)
    {
        abort_unless($payrollItem->payroll_run_id === $payrollRun->id, 404);
        abort_unless($payrollRun->status === 'draft', 409, 'Penggajian yang sudah disetujui tidak dapat diubah.');

        $validated = $request->validate([
            'type' => ['required', 'in:allowance,deduction'],
            'description' => ['required', 'string', 'max:120'],
            'amount' => ['required', 'numeric', 'gt:0', 'max:999999999999.99'],
        ]);

        $adjustments = $payrollItem->adjustments;
        $allowances = $adjustments->where('type', 'allowance')->sum('amount');
        $deductions = $adjustments->where('type', 'deduction')->sum('amount');
        $basePay = (float) $payrollItem->basic_salary
            - (float) $payrollItem->absence_deduction
            + (float) $payrollItem->overtime_amount;
        $newDeduction = $validated['type'] === 'deduction' ? (float) $validated['amount'] : 0;

        if ($basePay + $allowances - $deductions - $newDeduction < 0) {
            return redirect()->back()->with('error', 'Total potongan tidak boleh melebihi gaji yang diterima.');
        }

        $payrollItem->adjustments()->create($validated);

        return redirect()->back()->with('success', 'Komponen penggajian berhasil ditambahkan.');
    }

    public function destroyAdjustment(PayrollRun $payrollRun, PayrollItem $payrollItem, PayrollAdjustment $payrollAdjustment)
    {
        abort_unless($payrollItem->payroll_run_id === $payrollRun->id, 404);
        abort_unless($payrollAdjustment->payroll_item_id === $payrollItem->id, 404);
        abort_unless($payrollRun->status === 'draft', 409, 'Penggajian yang sudah disetujui tidak dapat diubah.');

        $payrollAdjustment->delete();

        return redirect()->back()->with('success', 'Komponen penggajian berhasil dihapus.');
    }

    public function approve(PayrollRun $payrollRun)
    {
        if ($payrollRun->status !== 'draft') {
            return redirect()->back()->with('error', 'Hanya draft penggajian yang dapat disetujui.');
        }

        $payrollRun->update([
            'status' => 'approved',
            'approved_by' => Auth::id(),
            'approved_at' => now(),
        ]);

        return redirect()->back()->with('success', 'Penggajian berhasil disetujui.');
    }

    public function markPaid(PayrollRun $payrollRun)
    {
        if ($payrollRun->status !== 'approved') {
            return redirect()->back()->with('error', 'Hanya penggajian yang sudah disetujui yang dapat ditandai dibayar.');
        }

        $payrollRun->update([
            'status' => 'paid',
            'paid_by' => Auth::id(),
            'paid_at' => now(),
        ]);

        return redirect()->back()->with('success', 'Penggajian berhasil ditandai sudah dibayar.');
    }

    public function export(PayrollRun $payrollRun, string $format)
    {
        abort_unless(in_array($format, ['csv', 'xlsx'], true), 404);

        $filename = "penggajian-{$payrollRun->year}-".str_pad((string) $payrollRun->month, 2, '0', STR_PAD_LEFT).".{$format}";
        $writerType = $format === 'csv'
            ? \Maatwebsite\Excel\Excel::CSV
            : \Maatwebsite\Excel\Excel::XLSX;

        return Excel::download(new PayrollExport($payrollRun), $filename, $writerType);
    }

    private function netPay(PayrollItem $item): float
    {
        $item->loadMissing('adjustments');
        $allowances = (float) $item->adjustments->where('type', 'allowance')->sum('amount');
        $deductions = (float) $item->adjustments->where('type', 'deduction')->sum('amount');

        return round(max(
            0,
            (float) $item->basic_salary
                - (float) $item->absence_deduction
                + (float) $item->overtime_amount
                + $allowances
                - $deductions,
        ), 2);
    }
}
