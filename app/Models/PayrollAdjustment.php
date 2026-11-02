<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PayrollAdjustment extends Model
{
    protected $guarded = ['id'];

    public function payrollItem(): BelongsTo
    {
        return $this->belongsTo(PayrollItem::class);
    }
}
