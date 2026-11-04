<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AssetMovement extends Model
{
    protected $fillable = [
        'asset_id',
        'action',
        'from_user_id',
        'to_user_id',
        'from_location_id',
        'to_location_id',
        'performed_by',
        'notes',
        'occurred_at',
    ];

    protected function casts(): array
    {
        return ['occurred_at' => 'datetime'];
    }

    /** @return BelongsTo<Asset, $this> */
    public function asset(): BelongsTo
    {
        return $this->belongsTo(Asset::class);
    }

    /** @return BelongsTo<User, $this> */
    public function fromUser(): BelongsTo
    {
        return $this->belongsTo(User::class, 'from_user_id');
    }

    /** @return BelongsTo<User, $this> */
    public function toUser(): BelongsTo
    {
        return $this->belongsTo(User::class, 'to_user_id');
    }

    /** @return BelongsTo<AssetLocation, $this> */
    public function fromLocation(): BelongsTo
    {
        return $this->belongsTo(AssetLocation::class, 'from_location_id');
    }

    /** @return BelongsTo<AssetLocation, $this> */
    public function toLocation(): BelongsTo
    {
        return $this->belongsTo(AssetLocation::class, 'to_location_id');
    }
}
