<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LeaveRequest extends Model
{
    protected $guarded = ['id'];

    // Relasi ke Karyawan yang mengajukan
    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }

    // Relasi ke User (HRD/Atasan) yang menyetujui
    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }
}
