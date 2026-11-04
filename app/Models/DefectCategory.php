<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class DefectCategory extends Model
{
    // IZINKAN SEMUA KOLOM KECUALI ID UNTUK DIISI
    protected $guarded = ['id'];

    /** @return BelongsTo<Brand, $this> */
    public function brand(): BelongsTo
    {
        return $this->belongsTo(Brand::class);
    }

    /** @return HasMany<ProductionDefect, $this> */
    public function productionDefects(): HasMany
    {
        return $this->hasMany(ProductionDefect::class);
    }
}
