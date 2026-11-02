<?php

namespace App\Exports;

use App\Models\Employee;
use App\Models\Holiday;
use App\Models\Overtime;
use Carbon\Carbon;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class AttendanceSummaryExport implements FromCollection, WithHeadings
{
    private readonly Carbon $startDate;

    private readonly Carbon $endDate;

    public function __construct(
        private readonly int $month,
        private readonly int $year,
        private readonly ?string $department = null,
        private readonly ?string $search = null,
    ) {
        $this->startDate = Carbon::createFromDate($year, $month, 26)->subMonth();
        $this->endDate = Carbon::createFromDate($year, $month, 25);
    }

    public function collection(): Collection
    {
        $employees = Employee::query()
            ->with([
                'attendances' => fn ($query) => $query->whereBetween('date', [
                    $this->startDate->toDateString(),
                    $this->endDate->toDateString(),
                ]),
                'fingerLogs' => fn ($query) => $query
                    ->whereBetween('scan_time', [
                        $this->startDate->copy()->startOfDay(),
                        $this->endDate->copy()->endOfDay(),
                    ])
                    ->orderBy('scan_time'),
                'leaveRequests' => fn ($query) => $query
                    ->where('status', 'approved')
                    ->where('start_date', '<=', $this->endDate->toDateString())
                    ->where(fn ($leaveQuery) => $leaveQuery
                        ->where('end_date', '>=', $this->startDate->toDateString())
                        ->orWhereNull('end_date')),
            ])
            ->when($this->department, fn ($query) => $query->where('department', $this->department))
            ->when($this->search, fn ($query) => $query->where(function ($employeeQuery) {
                $employeeQuery
                    ->where('full_name', 'like', '%' . $this->search . '%')
                    ->orWhere('employee_code', 'like', '%' . $this->search . '%');
            }))
            ->orderBy('full_name')
            ->get();

        $holidayDates = Holiday::query()
            ->whereBetween('date', [$this->startDate->toDateString(), $this->endDate->toDateString()])
            ->pluck('date')
            ->map(fn ($date) => Carbon::parse($date)->toDateString())
            ->flip();

        $overtimeHours = Overtime::query()
            ->whereBetween('date', [$this->startDate->toDateString(), $this->endDate->toDateString()])
            ->with(['employees' => fn ($query) => $query->withPivot('duration')])
            ->get()
            ->flatMap(fn ($overtime) => $overtime->employees->map(fn ($employee) => [
                'employee_id' => $employee->id,
                'duration' => (float) $employee->pivot->duration,
            ]))
            ->groupBy('employee_id')
            ->map(fn ($entries) => $entries->sum('duration'));

        return $employees->map(function (Employee $employee) use ($holidayDates, $overtimeHours) {
            $attendanceMap = $employee->attendances->keyBy(
                fn ($attendance) => Carbon::parse($attendance->date)->toDateString(),
            );
            $logsByDate = $employee->fingerLogs->groupBy(
                fn ($log) => Carbon::parse($log->scan_time)->toDateString(),
            );
            $presentDays = 0;
            $attendanceHours = 0.0;

            for ($date = $this->startDate->copy(); $date <= $this->endDate; $date->addDay()) {
                $dateString = $date->toDateString();
                $attendance = $attendanceMap->get($dateString);
                $logs = $logsByDate->get($dateString, collect());
                $isDayOff = $date->isWeekend() || $holidayDates->has($dateString);
                $leave = $employee->leaveRequests->first(function ($request) use ($date) {
                    $start = Carbon::parse($request->start_date);
                    $end = $request->end_date ? Carbon::parse($request->end_date) : $start;

                    return $date->between($start, $end);
                });
                $isPresent = $isDayOff || ($leave
                    ? $leave->type === 'izin_setengah_hari'
                    : $attendance?->status === 'present');

                if ($isPresent) {
                    $presentDays++;
                }

                $checkIn = $attendance?->check_in
                    ?: ($logs->first()?->scan_time
                        ? Carbon::parse($logs->first()->scan_time)->format('H:i:s')
                        : null);
                $checkOut = $attendance?->check_out
                    ?: ($logs->count() > 1
                        ? Carbon::parse($logs->last()->scan_time)->format('H:i:s')
                        : null);
                if ($checkIn && $checkOut) {
                    $start = Carbon::parse($dateString . ' ' . $checkIn);
                    $end = Carbon::parse($dateString . ' ' . $checkOut);
                    if ($end->greaterThan($start)) {
                        $attendanceHours += $start->floatDiffInHours($end);
                    }
                }
            }

            return [
                $employee->employee_code,
                $employee->full_name,
                $employee->department ?? '-',
                $presentDays,
                round($attendanceHours, 2),
                round((float) ($overtimeHours->get($employee->id, 0)), 2),
            ];
        });
    }

    public function headings(): array
    {
        return [
            'NIK',
            'Nama Karyawan',
            'Departemen',
            'Total Hari Hadir',
            'Total Jam Absensi',
            'Total Jam Lembur',
        ];
    }
}
