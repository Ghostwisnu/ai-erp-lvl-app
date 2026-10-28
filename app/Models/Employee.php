<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Employee extends Model
{
    protected $guarded = ['id'];

    // Relasi ke Absensi
    public function attendances()
    {
        return $this->hasMany(Attendance::class);
    }

    // Relasi ke Pengajuan Izin
    public function leaveRequests()
    {
        return $this->hasMany(LeaveRequest::class);
    }

    // Relasi ke User (jika ada)
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // TAMBAHKAN RELASI INI UNTUK FINGER LOG
    // Menghubungkan kolom 'employee_code' di tabel employees 
    // dengan kolom 'pin' di tabel finger_logs
    public function fingerLogs()
    {
        return $this->hasMany(FingerLog::class, 'pin', 'employee_code');
    }
}
