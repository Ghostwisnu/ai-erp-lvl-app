<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductionScan extends Model
{
    protected $guarded = ['id'];

    public function spkDetail()
    {
        return $this->belongsTo(SpkDetail::class);
    }
}
