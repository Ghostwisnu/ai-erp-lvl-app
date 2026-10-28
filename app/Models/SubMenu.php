<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubMenu extends Model
{
    use HasFactory;

    protected $fillable = [
        'menu_id',
        'name',
        'route',
        'order',
        'permission_name',
    ];

    /**
     * Relasi: satu SubMenu milik satu Menu (kebalikan dari subMenus()).
     */
    public function menu()
    {
        return $this->belongsTo(Menu::class);
    }
}
