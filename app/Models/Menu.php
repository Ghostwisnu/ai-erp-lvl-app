<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Menu extends Model
{
    /** @use HasFactory<Factory<static>> */
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
    /** @return HasMany<SubMenu, $this> */
    public function subMenus(): HasMany
    {
        return $this->hasMany(SubMenu::class)->orderBy('order');
    }
}
