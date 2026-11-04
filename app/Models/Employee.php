<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Employee extends Model
{
    protected $guarded = ['id'];

    // Relasi ke Absensi
    /** @return HasMany<Attendance, $this> */
    public function attendances(): HasMany
    {
        return $this->hasMany(Attendance::class);
    }

    // Relasi ke Pengajuan Izin
    /** @return HasMany<LeaveRequest, $this> */
    public function leaveRequests(): HasMany
    {
        return $this->hasMany(LeaveRequest::class);
    }

    // Relasi ke User (jika ada)
    /** @return BelongsTo<User, $this> */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // TAMBAHKAN RELASI INI UNTUK FINGER LOG
    // Menghubungkan kolom 'employee_code' di tabel employees
    // dengan kolom 'pin' di tabel finger_logs
    /** @return HasMany<FingerLog, $this> */
    public function fingerLogs(): HasMany
    {
        return $this->hasMany(FingerLog::class, 'pin', 'employee_code');
    }
}
