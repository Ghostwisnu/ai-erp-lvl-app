<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property int|null $spk_batch_id
 * @property int|null $spk_id
 * @property string $department
 * @property string $report_date
 * @property int $qty
 */
class ProductionDaily extends Model
{
    // IZINKAN SEMUA KOLOM KECUALI ID UNTUK DIISI
    protected $guarded = ['id'];

    // Relasi ke SPK
    /** @return BelongsTo<Spk, $this> */
    public function spk(): BelongsTo
    {
        return $this->belongsTo(Spk::class);
    }

    // Relasi ke Batch
    /** @return BelongsTo<SpkBatch, $this> */
    public function batch(): BelongsTo
    {
        return $this->belongsTo(SpkBatch::class, 'spk_batch_id');
    }
}
