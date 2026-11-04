<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * @property int $id
 * @property int $payroll_run_id
 * @property int|null $employee_id
 * @property string $employee_code
 * @property string $employee_name
 * @property string|null $department
 * @property numeric-string $basic_salary
 * @property numeric-string $daily_rate
 * @property int $unpaid_absence_days
 * @property numeric-string $absence_deduction
 * @property numeric-string $overtime_hours
 * @property numeric-string $overtime_hourly_rate
 * @property numeric-string $overtime_amount
 * @property-read Collection<int, PayrollAdjustment> $adjustments
 */
class PayrollItem extends Model
{
    protected $guarded = ['id'];

    /** @return BelongsTo<PayrollRun, $this> */
    public function payrollRun(): BelongsTo
    {
        return $this->belongsTo(PayrollRun::class);
    }

    /** @return BelongsTo<Employee, $this> */
    public function employee(): BelongsTo
    {
        return $this->belongsTo(Employee::class);
    }

    /** @return HasMany<PayrollAdjustment, $this> */
    public function adjustments(): HasMany
    {
        return $this->hasMany(PayrollAdjustment::class);
    }
}
