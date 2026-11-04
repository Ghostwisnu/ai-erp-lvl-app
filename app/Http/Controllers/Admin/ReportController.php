<?php

namespace App\Http\Controllers\Admin;

use App\Exports\AttendanceSummaryExport;
use App\Models\Employee;
use App\Models\Holiday;
use App\Models\LeaveRequest;
use App\Models\Overtime;
use Carbon\Carbon;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\HttpFoundation\Response;

class ReportController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function export(Request $request)
    {
        $validated = $request->validate([
            'month' => ['required', 'integer', 'between:1,12'],
            'year' => ['required', 'integer', 'between:2000,2100'],
            'department' => ['nullable', 'string', 'max:255'],
            'search' => ['nullable', 'string', 'max:255'],
        ]);
        $month = (int) $validated['month'];
        $year = (int) $validated['year'];
        $filename = sprintf('laporan-absensi-%04d-%02d.xlsx', $year, $month);

        return Excel::download(
            new AttendanceSummaryExport(
                $month,
                $year,
                $validated['department'] ?? null,
                $validated['search'] ?? null,
            ),
            $filename,
        );
    }

    /** @return Responsable|Response */
    public function dailyAttendance(Request $request)
    {
        $validated = $request->validate([
            'date' => ['nullable', 'date'],
        ]);
        $date = $validated['date'] ?? Carbon::today()->toDateString();
        $carbonDate = Carbon::parse($date);
        $holidayName = Holiday::query()->whereDate('date', $date)->value('name');
        $isDayOff = $carbonDate->isWeekend() || $holidayName !== null;

        $employees = Employee::query()
            ->with([
                'attendances' => fn ($query) => $query->whereDate('date', $date),
                'fingerLogs' => fn ($query) => $query->whereDate('scan_time', $date)->orderBy('scan_time'),
            ])
            ->orderBy('full_name')
            ->get();

        $attendanceData = $employees->map(function (Employee $employee) use ($isDayOff) {
            $attendance = $employee->attendances->first();
            $logs = $employee->fingerLogs;
            $firstScan = $logs->first()?->scan_time;
            $lastScan = $logs->count() > 1 ? $logs->last()?->scan_time : null;
            $checkIn = $attendance?->check_in ?: $firstScan;
            $checkOut = $attendance?->check_out ?: $lastScan;

            return [
                'employee_id' => $employee->id,
                'code' => $employee->employee_code,
                'name' => $employee->full_name,
                'department' => $employee->department,
                'check_in' => $checkIn ? Carbon::parse($checkIn)->format('H:i') : null,
                'check_out' => $checkOut ? Carbon::parse($checkOut)->format('H:i') : null,
                'total_scan' => $logs->count(),
                'status' => $isDayOff
                    ? 'present'
                    : ($attendance->status ?? ($logs->isNotEmpty() ? 'present' : 'absent')),
            ];
        });

        return $this->renderAdminPage('Admin/Reports/AttendanceDaily', [
            'attendanceData' => $attendanceData,
            'date' => $date,
            'dayOffLabel' => $holidayName
                ? "Tanggal merah: {$holidayName}"
                : ($carbonDate->isWeekend() ? 'Akhir pekan' : null),
        ]);
    }

    /** @return Responsable|Response */
    public function index(Request $request)
    {
        $inputMonth = (int) $request->input('month', Carbon::now()->month);
        $inputYear = (int) $request->input('year', Carbon::now()->year);

        if (! $request->has('month') && Carbon::now()->day >= 26) {
            $nextMonth = Carbon::now()->addMonth();
            $inputMonth = $nextMonth->month;
            $inputYear = $nextMonth->year;
        }

        $startDate = Carbon::createFromDate($inputYear, $inputMonth, 26)->subMonth();
        $endDate = Carbon::createFromDate($inputYear, $inputMonth, 25);

        $departments = Employee::whereNotNull('department')->distinct()->pluck('department')->toArray();
        $employees = Employee::orderBy('full_name')->get();

        $holidayNames = Holiday::query()
            ->whereBetween('date', [$startDate->toDateString(), $endDate->toDateString()])
            ->pluck('name', 'date');

        $dates = [];
        $currentDate = $startDate->copy();
        while ($currentDate <= $endDate) {
            $date = $currentDate->toDateString();
            $dates[] = [
                'date' => $date,
                'day' => $currentDate->format('d'),
                'day_name' => $currentDate->translatedFormat('D'),
                'is_weekend' => in_array($currentDate->dayOfWeek, [Carbon::SATURDAY, Carbon::SUNDAY]),
                'holiday_name' => $holidayNames->get($date),
            ];
            $currentDate->addDay();
        }

        // 1. Ambil Data Izin yang Approved
        $approvedLeaves = LeaveRequest::where('status', 'approved')
            ->where(function ($query) use ($startDate, $endDate) {
                $query->where('start_date', '<=', $endDate->toDateString())
                    ->where(function ($q) use ($startDate) {
                        $q->where('end_date', '>=', $startDate->toDateString())
                            ->orWhereNull('end_date');
                    });
            })->get();

        // 2. Load Data Absensi
        $employees->load(['attendances' => function ($query) use ($startDate, $endDate) {
            $query->whereBetween('date', [$startDate->toDateString(), $endDate->toDateString()]);
        }]);

        // 3. Gabungkan Data
        $attendanceData = $employees->map(function ($emp) use ($dates, $approvedLeaves) {
            $attendanceMap = $emp->attendances->keyBy('date');

            // Filter izin hanya untuk karyawan ini
            $empLeaves = $approvedLeaves->where('employee_id', $emp->id);

            return [
                'id' => $emp->id,
                'name' => $emp->full_name,
                'code' => $emp->employee_code,
                'department' => $emp->department,
                'join_date' => $emp->join_date,
                'daily' => collect($dates)->map(function ($dateInfo) use ($attendanceMap, $empLeaves) {
                    $dateStr = $dateInfo['date'];
                    $currentDate = Carbon::parse($dateStr);
                    $attendance = $attendanceMap->get($dateStr);
                    $isWeekend = $dateInfo['is_weekend'];
                    $isHoliday = $dateInfo['holiday_name'] !== null;

                    if ($isWeekend || $isHoliday) {
                        return [
                            'date' => $dateStr,
                            'status' => 'present',
                            'is_leave' => false,
                            'is_day_off' => true,
                            'day_off_label' => $dateInfo['holiday_name']
                                ? 'Tanggal merah: '.$dateInfo['holiday_name']
                                : 'Akhir pekan',
                        ];
                    }

                    // Cek apakah tanggal ini masuk dalam rentang izin (menggunakan Carbon)
                    $onLeave = $empLeaves->first(function ($leave) use ($currentDate) {
                        $start = Carbon::parse($leave->start_date);
                        $end = $leave->end_date ? Carbon::parse($leave->end_date) : $start;

                        return $currentDate->between($start, $end);
                    });

                    if ($onLeave) {
                        $status = match ($onLeave->type) {
                            'sakit' => 'sick',
                            'cuti' => 'leave',
                            'izin_setengah_hari' => 'present',
                            default => 'absent',
                        };

                        return [
                            'date' => $dateStr,
                            'status' => $status,
                            'is_leave' => true,
                            'is_day_off' => false,
                            'day_off_label' => null,
                        ];
                    }

                    return [
                        'date' => $dateStr,
                        'status' => $attendance ? $attendance->status : null,
                        'is_leave' => false,
                        'is_day_off' => false,
                        'day_off_label' => null,
                    ];
                }),
            ];
        });

        // 4. Data Lembur
        $overtimes = Overtime::with(['employees' => function ($query) {
            $query->withPivot('duration');
        }])->whereBetween('date', [$startDate->toDateString(), $endDate->toDateString()])->get();

        $overtimeData = $employees->map(function ($emp) use ($dates, $overtimes) {
            $overtimeMap = [];
            foreach ($overtimes as $ot) {
                $empOvertime = $ot->employees->firstWhere('id', $emp->id);
                if ($empOvertime) {
                    $overtimeMap[$ot->date] = (float) data_get($empOvertime, 'pivot.duration');
                }
            }

            return [
                'id' => $emp->id,
                'name' => $emp->full_name,
                'code' => $emp->employee_code,
                'department' => $emp->department,
                'daily' => collect($dates)->map(function ($dateInfo) use ($overtimeMap) {
                    return [
                        'date' => $dateInfo['date'],
                        'hours' => $overtimeMap[$dateInfo['date']] ?? 0,
                    ];
                }),
            ];
        });

        // 5. Data Izin / Cuti (hanya karyawan yang punya izin pada periode ini)
        $leaveData = $employees->map(function ($emp) use ($dates, $approvedLeaves) {
            $empLeaves = $approvedLeaves->where('employee_id', $emp->id);

            $daily = collect($dates)->map(function ($dateInfo) use ($empLeaves) {
                $currentDate = Carbon::parse($dateInfo['date']);

                $leave = $empLeaves->first(function ($leave) use ($currentDate) {
                    $start = Carbon::parse($leave->start_date);
                    $end = $leave->end_date ? Carbon::parse($leave->end_date) : $start;

                    return $currentDate->between($start, $end);
                });

                $isDayOff = $dateInfo['is_weekend'] || $dateInfo['holiday_name'] !== null;

                return [
                    'date' => $dateInfo['date'],
                    'leave_type' => ($leave && ! $isDayOff) ? $leave->type : null,
                    'reason' => ($leave && ! $isDayOff) ? $leave->reason : null,
                ];
            });

            return [
                'id' => $emp->id,
                'name' => $emp->full_name,
                'code' => $emp->employee_code,
                'department' => $emp->department,
                'daily' => $daily,
                'has_leave' => $daily->contains(fn ($day) => $day['leave_type'] !== null),
            ];
        })->filter(fn ($row) => $row['has_leave'])->values();

        return $this->renderAdminPage('Admin/Reports/Index', [
            'attendanceData' => $attendanceData,
            'overtimeData' => $overtimeData,
            'leaveData' => $leaveData,
            'dates' => $dates,
            'month' => $inputMonth,
            'year' => $inputYear,
            'period' => $startDate->format('d/m/Y').' - '.$endDate->format('d/m/Y'),
            'departments' => $departments,
        ]);
    }
}
