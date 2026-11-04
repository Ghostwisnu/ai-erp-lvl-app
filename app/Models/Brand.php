<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/** @property string $name */
class Brand extends Model
{
    protected $guarded = ['id'];

    /** @return HasMany<SizeRun, $this> */
    public function sizeRuns(): HasMany
    {
        return $this->hasMany(SizeRun::class)->orderBy('order');
    }
}
