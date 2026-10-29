<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductionDaily extends Model
{
    // IZINKAN SEMUA KOLOM KECUALI ID UNTUK DIISI
    protected $guarded = ['id'];

    // Relasi ke SPK
    public function spk()
    {
        return $this->belongsTo(Spk::class);
    }

    // Relasi ke Batch
    public function batch()
    {
        return $this->belongsTo(SpkBatch::class, 'spk_batch_id');
    }
}
