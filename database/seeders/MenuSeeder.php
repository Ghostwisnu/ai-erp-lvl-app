<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Menu;
use App\Models\SubMenu;

class MenuSeeder extends Seeder
{
    public function run(): void
    {
        // Menu 1: Data User
        $menuUser = $this->syncMenu('Data User', 'Data Pengguna', [
            'route' => '/admin/users',
            'icon' => 'users',
            'order' => 1,
            'permission_name' => 'manage-users',
        ]);

        // Submenu untuk Data User
        $this->syncSubMenu($menuUser, 'Tambah User', 'Tambah Pengguna', [
            'route' => '/admin/users/create',
            'order' => 1,
            'permission_name' => 'manage-users',
        ]);
        $this->syncSubMenu($menuUser, 'Daftar User', 'Daftar Pengguna', [
            'route' => '/admin/users',
            'order' => 2,
            'permission_name' => 'manage-users',
        ]);

        // Menu 2: My Profile
        $this->syncMenu('My Profile', 'Profil Saya', [
            'route' => '/settings/profile',
            'icon' => 'user',
            'order' => 2,
            'permission_name' => 'view-profile',
        ]);

        // Menu 3: Data Role
        $this->syncMenu('Data Role', 'Data Peran', [
            'route' => '/admin/roles',
            'icon' => 'shield',
            'order' => 3,
            'permission_name' => 'manage-roles',
        ]);

        // Menu 4: Data Menu
        $this->syncMenu('Data Menu', 'Data Menu', [
            'route' => '/admin/menus',
            'icon' => 'menu',
            'order' => 4,
            'permission_name' => 'manage-menus',
        ]);

        // Menu 5: Data Sub Menu
        $this->syncMenu('Data Sub Menu', 'Data Submenu', [
            'route' => '/admin/submenus',
            'icon' => 'list',
            'order' => 5,
            'permission_name' => 'manage-submenus',
        ]);

        $assetMenu = $this->syncMenu('Inventory Aset', 'Inventaris Aset', [
            'route' => '/admin/assets',
            'icon' => 'package',
            'order' => 6,
            'permission_name' => 'manage-assets',
        ]);

        $this->syncSubMenu($assetMenu, 'Daftar Aset', 'Daftar Aset', [
            'route' => '/admin/assets',
            'order' => 1,
            'permission_name' => 'manage-assets',
        ]);
        $this->syncSubMenu($assetMenu, 'Kategori & Lokasi', 'Kategori & Lokasi', [
            'route' => '/admin/assets/catalog',
            'order' => 2,
            'permission_name' => 'manage-assets',
        ]);
        $this->syncSubMenu($assetMenu, 'Laporan & Penyusutan', 'Laporan & Penyusutan', [
            'route' => '/admin/assets/reports',
            'order' => 3,
            'permission_name' => 'manage-assets',
        ]);

        $this->syncMenu('Payroll', 'Penggajian', [
            'route' => '/admin/payroll',
            'icon' => 'banknote',
            'order' => 7,
            'permission_name' => 'manage-payroll',
        ]);
    }

    private function syncMenu(string $legacyName, string $name, array $attributes): Menu
    {
        $menu = Menu::query()
            ->whereIn('name', array_unique([$legacyName, $name]))
            ->first() ?? new Menu();

        $menu->fill(['name' => $name, ...$attributes])->save();

        return $menu;
    }

    private function syncSubMenu(Menu $menu, string $legacyName, string $name, array $attributes): void
    {
        $submenu = $menu->subMenus()
            ->whereIn('name', array_unique([$legacyName, $name]))
            ->first() ?? new SubMenu();

        $submenu->fill([
            'menu_id' => $menu->id,
            'name' => $name,
            ...$attributes,
        ])->save();
    }
}
