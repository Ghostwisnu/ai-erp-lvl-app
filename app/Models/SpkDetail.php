<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SpkDetail extends Model
{
    protected $guarded = ['id'];

    public function spk()
    {
        return $this->belongsTo(Spk::class);
    }

    // TAMBAHKAN RELASI INI
    public function scans()
    {
        return $this->hasMany(ProductionScan::class);
    }
}
