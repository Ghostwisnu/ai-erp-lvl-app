<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Asset extends Model
{
    protected $fillable = [
        'code',
        'name',
        'asset_category_id',
        'asset_location_id',
        'serial_number',
        'brand',
        'model',
        'acquisition_date',
        'acquisition_cost',
        'salvage_value',
        'useful_life_months',
        'condition',
        'status',
        'assigned_to',
        'description',
    ];

    protected function casts(): array
    {
        return [
            'acquisition_date' => 'date',
            'acquisition_cost' => 'decimal:2',
            'salvage_value' => 'decimal:2',
        ];
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(AssetCategory::class, 'asset_category_id');
    }

    public function location(): BelongsTo
    {
        return $this->belongsTo(AssetLocation::class, 'asset_location_id');
    }

    public function assignee(): BelongsTo
    {
        return $this->belongsTo(User::class, 'assigned_to');
    }

    public function movements(): HasMany
    {
        return $this->hasMany(AssetMovement::class)->latest('occurred_at');
    }

    public function maintenances(): HasMany
    {
        return $this->hasMany(AssetMaintenance::class)->latest('service_date');
    }

    public function getCurrentBookValueAttribute(): float
    {
        $cost = (float) $this->acquisition_cost;
        $salvageValue = min($cost, (float) $this->salvage_value);
        $lifeMonths = max(1, (int) $this->useful_life_months);
        $monthsInService = min($lifeMonths, max(0, Carbon::parse($this->acquisition_date)->diffInMonths(now())));
        $monthlyDepreciation = ($cost - $salvageValue) / $lifeMonths;

        return round(max($salvageValue, $cost - ($monthlyDepreciation * $monthsInService)), 2);
    }
}
