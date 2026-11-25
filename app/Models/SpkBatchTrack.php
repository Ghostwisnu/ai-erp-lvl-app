<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property int $spk_batch_id
 * @property string $department
 * @property \Illuminate\Support\Carbon|null $start_date
 * @property \Illuminate\Support\Carbon|null $end_date
 */
class SpkBatchTrack extends Model
{
    protected $guarded = ['id'];

    protected $casts = [
        'start_date' => 'datetime',
        'end_date' => 'datetime',
    ];

    /** @return BelongsTo<SpkBatch, $this> */
    public function batch(): BelongsTo
    {
        return $this->belongsTo(SpkBatch::class, 'spk_batch_id');
    }
}
