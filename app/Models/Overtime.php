<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Overtime extends Model
{
    protected $guarded = ['id'];

    // Relasi ke Karyawan yang lembur
    /** @return BelongsToMany<Employee, $this> */
    public function employees(): BelongsToMany
    {
        return $this->belongsToMany(Employee::class, 'overtime_employees')
            ->withPivot('type', 'duration', 'mutation_reason')
            ->withTimestamps();
    }

    // TAMBAHKAN RELASI INI UNTUK PEMBUAT FORM
    /** @return BelongsTo<User, $this> */
    public function creator(): BelongsTo
    {
        // Menghubungkan 'created_by' di tabel overtimes dengan 'id' di tabel users
        return $this->belongsTo(User::class, 'created_by');
    }
}
