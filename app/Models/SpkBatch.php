<?php

// app/Models/SpkBatch.php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SpkBatch extends Model
{
    protected $fillable = [
        'spk_id',
        'batch_code',
        'qty',
        'sizes',
        'status',
        'current_department',
    ];

    protected $casts = [
        'sizes' => 'array',  // ✅ Auto encode/decode JSON
    ];

    public function spk()
    {
        return $this->belongsTo(Spk::class);
    }

    public function tracks()
    {
        return $this->hasMany(SpkBatchTrack::class);
    }

    public function dailies()
    {
        return $this->hasMany(ProductionDaily::class);
    }
}
