<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

/**
 * @property int $id
 * @property string $po_number
 * @property string $xfd_date
 * @property string|null $start_date
 * @property int $brand_id
 * @property string $art_color
 * @property string $status
 * @property string|null $department
 * @property string|null $image_path
 * @property-read Brand $brand
 * @property-read Collection<int, SpkDetail> $details
 * @property-read Collection<int, ProductionDefect> $defects
 * @property-read Collection<int, ProductionScan> $scans
 * @property-read Collection<int, SpkBatch> $batches
 * @property-read Collection<int, ProductionDaily> $dailies
 */
class Spk extends Model
{
    protected $guarded = ['id'];

    /** @return BelongsTo<Brand, $this> */
    public function brand(): BelongsTo
    {
        return $this->belongsTo(Brand::class);
    }

    /** @return HasMany<SpkDetail, $this> */
    public function details(): HasMany
    {
        return $this->hasMany(SpkDetail::class);
    }

    // TAMBAHKAN RELASI DEFECTS
    /** @return HasMany<ProductionDefect, $this> */
    public function defects(): HasMany
    {
        return $this->hasMany(ProductionDefect::class);
    }

    // TAMBAHKAN RELASI SCANS (Jika belum ada)
    /** @return HasManyThrough<ProductionScan, SpkDetail, $this> */
    public function scans(): HasManyThrough
    {
        return $this->hasManyThrough(ProductionScan::class, SpkDetail::class);
    }

    /** @return HasMany<SpkBatch, $this> */
    public function batches(): HasMany
    {
        return $this->hasMany(SpkBatch::class);
    }

    /** @return HasMany<ProductionDaily, $this> */
    public function dailies(): HasMany
    {
        return $this->hasMany(ProductionDaily::class);
    }
}
