<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Menu;

class MenuSeeder extends Seeder
{
    public function run(): void
    {
        // Menu 1: Data User
        $menuUser = Menu::firstOrCreate(
            ['name' => 'Data User'],
            [
                'route' => 'admin.users.index',
                'icon' => 'users', // sesuaikan dengan icon library kamu
                'order' => 1,
                'permission_name' => 'manage-users',
            ]
        );

        // Submenu untuk Data User
        $menuUser->subMenus()->firstOrCreate(
            ['name' => 'Tambah User'],
            ['route' => 'admin.users.create', 'order' => 1, 'permission_name' => 'manage-users']
        );
        $menuUser->subMenus()->firstOrCreate(
            ['name' => 'Daftar User'],
            ['route' => 'admin.users.index', 'order' => 2, 'permission_name' => 'manage-users']
        );

        // Menu 2: My Profile
        Menu::firstOrCreate(
            ['name' => 'My Profile'],
            [
                'route' => 'profile.edit', // route bawaan starter kit
                'icon' => 'user',
                'order' => 2,
                'permission_name' => 'view-profile', // atau null jika semua bisa lihat
            ]
        );

        // Menu 3: Data Role
        Menu::firstOrCreate(
            ['name' => 'Data Role'],
            [
                'route' => 'admin.roles.index',
                'icon' => 'shield',
                'order' => 3,
                'permission_name' => 'manage-roles',
            ]
        );

        // Menu 4: Data Menu
        $menuMenu = Menu::firstOrCreate(
            ['name' => 'Data Menu'],
            [
                'route' => 'admin.menus.index',
                'icon' => 'menu',
                'order' => 4,
                'permission_name' => 'manage-menus',
            ]
        );

        // Menu 5: Data Sub Menu
        Menu::firstOrCreate(
            ['name' => 'Data Sub Menu'],
            [
                'route' => 'admin.submenus.index',
                'icon' => 'list',
                'order' => 5,
                'permission_name' => 'manage-submenus',
            ]
        );
    }
}
