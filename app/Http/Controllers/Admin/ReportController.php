<?php

namespace App\Http\Controllers\Admin;

use App\Models\Employee;
use App\Models\LeaveRequest;
use App\Models\Overtime;
use Illuminate\Http\Request;
use Carbon\Carbon;

class ReportController extends BaseAdminController
{
    public function index(Request $request)
    {
        $inputMonth = (int) $request->input('month', Carbon::now()->month);
        $inputYear = (int) $request->input('year', Carbon::now()->year);

        if (!$request->has('month') && Carbon::now()->day >= 26) {
            $nextMonth = Carbon::now()->addMonth();
            $inputMonth = $nextMonth->month;
            $inputYear = $nextMonth->year;
        }

        $startDate = Carbon::createFromDate($inputYear, $inputMonth, 26)->subMonth();
        $endDate = Carbon::createFromDate($inputYear, $inputMonth, 25);

        $departments = Employee::whereNotNull('department')->distinct()->pluck('department')->toArray();
        $employees = Employee::orderBy('full_name')->get();

        $dates = [];
        $currentDate = $startDate->copy();
        while ($currentDate <= $endDate) {
            $dates[] = [
                'date' => $currentDate->toDateString(),
                'day' => $currentDate->format('d'),
                'day_name' => $currentDate->translatedFormat('D'),
                'is_weekend' => in_array($currentDate->dayOfWeek, [Carbon::SATURDAY, Carbon::SUNDAY]),
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
                        ];
                    }

                    return [
                        'date' => $dateStr,
                        'status' => $attendance ? $attendance->status : null,
                        'is_leave' => false,
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
                    $overtimeMap[$ot->date] = (float) $empOvertime->pivot->duration;
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

        return $this->renderAdminPage('Admin/Reports/Index', [
            'attendanceData' => $attendanceData,
            'overtimeData' => $overtimeData,
            'dates' => $dates,
            'month' => $inputMonth,
            'year' => $inputYear,
            'period' => $startDate->format('d/m/Y') . ' - ' . $endDate->format('d/m/Y'),
            'departments' => $departments,
        ]);
    }
}
