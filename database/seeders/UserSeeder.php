<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        $admin = User::firstOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'Super Admin',
                'password' => Hash::make('password'), // ganti dengan password aman
                'email_verified_at' => now(), // anggap sudah verifikasi
            ]
        );

        // Berikan role super-admin
        $admin->assignRole('super-admin');
    }
}
