<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * @property int $id
 * @property int $spk_id
 * @property string $size_name
 * @property int $qty
 * @property string|null $barcode
 * @property-read Spk $spk
 * @property-read Collection<int, ProductionScan> $scans
 */
class SpkDetail extends Model
{
    protected $guarded = ['id'];

    /** @return BelongsTo<Spk, $this> */
    public function spk(): BelongsTo
    {
        return $this->belongsTo(Spk::class);
    }

    // TAMBAHKAN RELASI INI
    /** @return HasMany<ProductionScan, $this> */
    public function scans(): HasMany
    {
        return $this->hasMany(ProductionScan::class);
    }
}
