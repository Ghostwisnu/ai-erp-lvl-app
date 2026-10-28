<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Spk extends Model
{
    protected $guarded = ['id'];

    public function brand()
    {
        return $this->belongsTo(Brand::class);
    }

    public function details()
    {
        return $this->hasMany(SpkDetail::class);
    }
    // TAMBAHKAN RELASI DEFECTS
    public function defects()
    {
        return $this->hasMany(ProductionDefect::class);
    }

    // TAMBAHKAN RELASI SCANS (Jika belum ada)
    public function scans()
    {
        return $this->hasManyThrough(ProductionScan::class, SpkDetail::class);
    }
}
