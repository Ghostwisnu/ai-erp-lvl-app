<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Brand extends Model
{
    protected $guarded = ['id'];

    public function sizeRuns()
    {
        return $this->hasMany(SizeRun::class)->orderBy('order');
    }
}
