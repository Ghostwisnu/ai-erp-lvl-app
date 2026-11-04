<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductionScan extends Model
{
    protected $guarded = ['id'];

    /** @return BelongsTo<SpkDetail, $this> */
    public function spkDetail(): BelongsTo
    {
        return $this->belongsTo(SpkDetail::class);
    }
}
