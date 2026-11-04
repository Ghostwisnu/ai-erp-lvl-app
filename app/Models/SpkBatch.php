<?php

// app/Models/SpkBatch.php

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * @property int $id
 * @property int $spk_id
 * @property string $batch_code
 * @property int $qty
 * @property array<int, array{size_name: string, qty: int}>|null $sizes
 * @property string|null $status
 * @property string|null $current_department
 * @property-read Spk $spk
 * @property-read Collection<int, SpkBatchTrack> $tracks
 * @property-read Collection<int, ProductionDaily> $dailies
 */
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

    /** @return BelongsTo<Spk, $this> */
    public function spk(): BelongsTo
    {
        return $this->belongsTo(Spk::class);
    }

    /** @return HasMany<SpkBatchTrack, $this> */
    public function tracks(): HasMany
    {
        return $this->hasMany(SpkBatchTrack::class);
    }

    /** @return HasMany<ProductionDaily, $this> */
    public function dailies(): HasMany
    {
        return $this->hasMany(ProductionDaily::class);
    }
}
