<?php

namespace App\Http\Controllers\Admin;

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\FingerLog;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\Artisan;

class RekapAbsensiController extends BaseAdminController
{
    public function index(Request $request)
    {
        $date = $request->input('date', Carbon::today()->toDateString());

        $employees = Employee::whereHas('attendances', function ($q) use ($date) {
            $q->whereDate('date', $date);
        })->orWhereHas('fingerLogs', function ($q) use ($date) {
            $q->whereDate('scan_time', $date);
        })->get();

        $rekapData = $employees->map(function ($emp) use ($date) {
            $logs = FingerLog::where('pin', $emp->employee_code)
                ->whereDate('scan_time', $date)
                ->orderBy('scan_time')
                ->get();

            $firstScan = $logs->first()?->scan_time;
            $lastScan = $logs->last()?->scan_time;

            $attendance = Attendance::where('employee_id', $emp->id)
                ->whereDate('date', $date)
                ->first();

            // AMANKAN FORMAT JAM
            $checkIn = $attendance?->check_in;
            if (!$checkIn && $firstScan) {
                $checkIn = Carbon::parse($firstScan)->format('H:i:s');
            }

            $checkOut = $attendance?->check_out;
            if (!$checkOut && $lastScan) {
                $checkOut = Carbon::parse($lastScan)->format('H:i:s');
            }

            return [
                'employee_id' => $emp->id,
                'name' => $emp->full_name,
                'code' => $emp->employee_code,
                'department' => $emp->department,
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'total_scan' => $logs->count(),
                'status' => $attendance?->status ?? ($logs->count() > 0 ? 'present' : 'absent'),
            ];
        });

        return $this->renderAdminPage('Admin/RekapAbsensi/Index', [
            'rekapData' => $rekapData,
            'date' => $date,
        ]);
    }

    public function tarikData()
    {
        try {
            Artisan::call('finger:tarik');
            return redirect()->back()->with('success', 'Data absensi berhasil ditarik dari mesin finger!');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Gagal menarik data: ' . $e->getMessage());
        }
    }
}
