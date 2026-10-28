<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductionDefect extends Model
{
    protected $guarded = ['id'];

    public function spk()
    {
        return $this->belongsTo(Spk::class);
    }

    public function defectCategory()
    {
        return $this->belongsTo(DefectCategory::class);
    }
}
