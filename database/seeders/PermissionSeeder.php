<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;

class PermissionSeeder extends Seeder
{
    public function run(): void
    {
        // Daftar permission yang kita butuhkan
        $permissions = [
            'manage-users',
            'manage-roles',
            'manage-menus',
            'manage-submenus',
            'view-profile',
        ];

        foreach ($permissions as $permission) {
            Permission::firstOrCreate(['name' => $permission]);
        }
    }
}
