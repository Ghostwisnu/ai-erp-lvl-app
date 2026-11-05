<?php

namespace App\Services;

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\FingerLog;
use Carbon\Carbon;

class FingerPunchService
{
    // Mengembalikan true jika scan baru tersimpan, false jika sudah pernah ada
    public function store(string $pin, Carbon $timestamp): bool
    {
        $log = FingerLog::firstOrCreate(['pin' => $pin, 'scan_time' => $timestamp]);
        if (! $log->wasRecentlyCreated) {
            return false;
        }

        $employee = Employee::where('employee_code', $pin)->first();
        if (! $employee) {
            return true;
        }

        $attendance = Attendance::firstOrNew([
            'employee_id' => $employee->id,
            'date' => $timestamp->toDateString(),
        ]);

        $time = $timestamp->toTimeString();
        if (! $attendance->check_in) {
            $attendance->check_in = $time;
        } else {
            $attendance->check_out = $time;
        }
        $attendance->status = 'present';
        $attendance->save();

        return true;
    }
}
