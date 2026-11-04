<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property string $type
 * @property string $status
 * @property string $start_date
 * @property string|null $end_date
 * @property string|null $start_time
 * @property string|null $end_time
 * @property int $employee_id
 */
class LeaveRequest extends Model
{
    protected $guarded = ['id'];

    // Relasi ke Karyawan yang mengajukan
    /** @return BelongsTo<Employee, $this> */
    public function employee(): BelongsTo
    {
        return $this->belongsTo(Employee::class);
    }

    // Relasi ke User (HRD/Atasan) yang menyetujui
    /** @return BelongsTo<User, $this> */
    public function approver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approved_by');
    }
}
