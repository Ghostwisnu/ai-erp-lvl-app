<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property string $type
 * @property string $description
 * @property numeric-string $amount
 */
class PayrollAdjustment extends Model
{
    protected $guarded = ['id'];

    /** @return BelongsTo<PayrollItem, $this> */
    public function payrollItem(): BelongsTo
    {
        return $this->belongsTo(PayrollItem::class);
    }
}
