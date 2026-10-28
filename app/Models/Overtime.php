<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Overtime extends Model
{
    protected $guarded = ['id'];

    // Relasi ke Karyawan yang lembur
    public function employees()
    {
        return $this->belongsToMany(Employee::class, 'overtime_employees')
            ->withPivot('type', 'duration', 'mutation_reason')
            ->withTimestamps();
    }

    // TAMBAHKAN RELASI INI UNTUK PEMBUAT FORM
    public function creator()
    {
        // Menghubungkan 'created_by' di tabel overtimes dengan 'id' di tabel users
        return $this->belongsTo(User::class, 'created_by');
    }
}
