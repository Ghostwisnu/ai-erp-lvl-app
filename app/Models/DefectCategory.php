<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DefectCategory extends Model
{
    // IZINKAN SEMUA KOLOM KECUALI ID UNTUK DIISI
    protected $guarded = ['id'];

    public function brand()
    {
        return $this->belongsTo(Brand::class);
    }

    public function productionDefects()
    {
        return $this->hasMany(ProductionDefect::class);
    }
}
