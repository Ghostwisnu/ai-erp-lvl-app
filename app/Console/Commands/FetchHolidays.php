<?php

namespace App\Console\Commands;

use App\Models\Holiday;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;

class FetchHolidays extends Command
{
    // Nama perintah yang akan dipanggil
    protected $signature = 'holidays:fetch {year?}';
    protected $description = 'Fetch national holidays from Nager.Date API';

    public function handle()
    {
        $year = $this->argument('year') ?? date('Y');

        $this->info("Mengambil data libur nasional tahun {$year}...");

        // Ambil data dari API Nager.Date untuk Indonesia (ID)
        $response = Http::get("https://date.nager.at/api/v3/PublicHolidays/{$year}/ID");

        if ($response->failed()) {
            $this->error('Gagal mengambil data dari API.');
            return;
        }

        $holidays = $response->json();
        $count = 0;

        foreach ($holidays as $holiday) {
            // Simpan jika belum ada (mencegah duplikat)
            Holiday::firstOrCreate(
                ['date' => $holiday['date']],
                [
                    'name' => $holiday['localName'] ?? $holiday['name'],
                    'is_national' => true,
                ]
            );
            $count++;
        }

        $this->info("Berhasil! {$count} hari libur diproses.");
    }
}
