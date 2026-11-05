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
            'manage-absen',
            'manage-permissions',
            'manage-employees',
            'manage-attendances',
            'manage-overtimes',
            'manage-holidays',
            'manage-leave-requests',
            'manage-overtimes-daily',
            'manage-brands',
            'manage-spk',
            'manage-scans',
            'manage-defect-categories',
            'manage-defects',
            'manage-report-qc',
            'manage-monitor-qc',
            'manage-rekap-absensi',
            'manage-koneksi',
            'manage-master-data',
            'manage-produksi',
            'manage-hris',
        ];

        foreach ($permissions as $permission) {
            Permission::firstOrCreate(['name' => $permission]);
        }
    }
}
