<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property int $spk_batch_id
 * @property string $department
 * @property string $start_date
 * @property string|null $end_date
 */
class SpkBatchTrack extends Model
{
    protected $guarded = ['id'];

    /** @return BelongsTo<SpkBatch, $this> */
    public function batch(): BelongsTo
    {
        return $this->belongsTo(SpkBatch::class, 'spk_batch_id');
    }
}
