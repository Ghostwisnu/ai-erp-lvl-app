<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RoleSeeder extends Seeder
{
    public function run(): void
    {
        // Buat role super-admin
        $superAdmin = Role::firstOrCreate(['name' => 'super-admin']);

        // Berikan SEMUA permission yang ada ke super-admin
        $superAdmin->givePermissionTo(Permission::all());

        // Kamu bisa tambah role lain di sini, misal 'staff'
        // $staff = Role::firstOrCreate(['name' => 'staff']);
        // $staff->givePermissionTo('manage-users'); 
    }
}
