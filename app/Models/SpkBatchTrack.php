<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SpkBatchTrack extends Model
{
    protected $guarded = ['id'];

    public function batch()
    {
        return $this->belongsTo(SpkBatch::class, 'spk_batch_id');
    }
}
