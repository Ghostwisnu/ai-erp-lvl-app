<?php

namespace App\Console\Commands;

use Carbon\Carbon;
use HafizAsifAli\ZkTeco\ZkDevice;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;
use RuntimeException;
use Throwable;

class KirimAbsensiFinger extends Command
{
    protected $signature = 'finger:kirim {--since=-2 days : Rentang waktu penarikan} {--timeout=90 : Timeout koneksi (detik)} {--retry=3 : Jumlah percobaan}';

    protected $description = 'Tarik data dari mesin finger (jaringan lokal) lalu kirim ke server hosting';

    public function handle(): int
    {
        $url = config('services.finger.remote_url');
        $token = config('services.finger.token');
        $machines = array_filter(array_map('trim', explode(',', (string) config('services.finger.machines'))));

        if (! $url || ! $token || ! $machines) {
            $this->error('Isi FINGER_REMOTE_URL, FINGER_API_TOKEN, dan FINGER_MACHINES di .env');

            return self::FAILURE;
        }

        $failed = false;

        foreach ($machines as $ip) {
            $this->info("Menarik data dari {$ip}");

            try {
                $punches = null;
                $attempts = max(1, (int) $this->option('retry'));
                for ($i = 1; $i <= $attempts; $i++) {
                    try {
                        $device = ZkDevice::make($ip, commKey: 0, transport: 'tcp', timezone: 'Asia/Jakarta', timeout: (int) $this->option('timeout'));
                        $punches = $device->session(fn ($d) => $d->attendance()->since($this->option('since')));
                        break;
                    } catch (Throwable $e) {
                        if ($i === $attempts) {
                            throw $e;
                        }
                        $this->warn("  percobaan {$i} gagal, mengulang...");
                        sleep(3);
                    }
                }

                $payload = [];
                foreach ($punches as $punch) {
                    $payload[] = [
                        'pin' => (string) $punch->userId,
                        'scan_time' => Carbon::parse($punch->timestamp)->format('Y-m-d H:i:s'),
                    ];
                }

                foreach (array_chunk($payload, 500) as $chunk) {
                    $response = Http::withToken($token)->acceptJson()->timeout(60)
                        ->post($url, ['punches' => $chunk]);

                    if ($response->failed()) {
                        throw new RuntimeException('Server menolak: HTTP '.$response->status().' '.$response->body());
                    }

                    $this->info("  terkirim {$response->json('received')}, baru {$response->json('saved')}");
                }

                if (! $payload) {
                    $this->info('  tidak ada data');
                }
            } catch (Throwable $e) {
                $failed = true;
                $this->error("  Gagal ({$ip}): ".$e->getMessage());
            }
        }

        return $failed ? self::FAILURE : self::SUCCESS;
    }
}
