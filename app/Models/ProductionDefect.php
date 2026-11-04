<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductionDefect extends Model
{
    protected $guarded = ['id'];

    /** @return BelongsTo<Spk, $this> */
    public function spk(): BelongsTo
    {
        return $this->belongsTo(Spk::class);
    }

    /** @return BelongsTo<DefectCategory, $this> */
    public function defectCategory(): BelongsTo
    {
        return $this->belongsTo(DefectCategory::class);
    }
}
