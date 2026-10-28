<?php

use App\Models\TeamInvitation;
use Illuminate\Support\Facades\Schedule;

Schedule::call(function () {
    TeamInvitation::query()
        ->whereNotNull('expires_at')
        ->where('expires_at', '<', now())
        ->delete();
})->daily()->description('Delete expired team invitations');


// Jalankan setiap tanggal 1 Januari jam 00:01 untuk mengambil libur tahun baru
Schedule::command('holidays:fetch')->yearlyOn(1, 1, '00:01');
Schedule::command('finger:tarik')->everyMinute();
