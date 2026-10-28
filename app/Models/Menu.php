<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Menu extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'route',
        'icon',
        'order',
        'permission_name',
    ];

    /**
     * Relasi: satu Menu punya banyak SubMenu.
     * Diurutkan berdasarkan kolom 'order' agar tampil rapi.
     */
    public function subMenus()
    {
        return $this->hasMany(SubMenu::class)->orderBy('order');
    }
}
