<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use HafizAsifAli\ZkTeco\ZkDevice;
use App\Models\Attendance;
use App\Models\Employee;
use App\Models\FingerLog;
use Carbon\Carbon;

class TarikAbsensiFinger extends Command
{
    protected $signature = 'finger:tarik';
    protected $description = 'Menarik data absensi dari beberapa mesin finger Solution';

    public function handle()
    {
        // DAFTAR IP MESIN FINGER
        $machines = [
            '192.168.100.201',
            '192.168.100.29',
            '192.168.100.78',
        ];

        foreach ($machines as $ip) {
            $this->info("==================================================");
            $this->info("Mencoba terhubung ke mesin: {$ip}");

            try {
                // Kembali ke TCP (karena tes koneksi awal sukses), timeout diperbesar
                $device = ZkDevice::make(
                    $ip,
                    commKey: 0,
                    transport: 'tcp',     // Coba TCP dulu
                    timezone: 'Asia/Jakarta',
                    timeout: 30           // Perbesar timeout
                );

                // Ambil data 2 hari terakhir saja untuk testing (kurangi beban)
                $punches = $device->session(function ($d) {
                    return $d->attendance()->since('-2 days');
                });

                $count = 0;
                foreach ($punches as $punch) {
                    // ... (logika penyimpanan Anda tetap sama)
                    FingerLog::firstOrCreate([
                        'pin' => $punch->userId,
                        'scan_time' => Carbon::parse($punch->timestamp),
                    ]);

                    $employee = Employee::where('employee_code', $punch->userId)->first();
                    if ($employee) {
                        $timestamp = Carbon::parse($punch->timestamp);
                        $date = $timestamp->toDateString();
                        $time = $timestamp->toTimeString();

                        $attendance = Attendance::firstOrNew([
                            'employee_id' => $employee->id,
                            'date' => $date,
                        ]);

                        if (!$attendance->check_in) {
                            $attendance->check_in = $time;
                        } else {
                            $attendance->check_out = $time;
                        }
                        $attendance->status = 'present';
                        $attendance->save();
                        $count++;
                    }
                }

                $this->info("Mesin {$ip}: Berhasil memproses {$count} data absensi.");
            } catch (\Exception $e) {
                $this->error("Mesin {$ip}: Gagal ditarik. Error: " . $e->getMessage());
            }
        }

        $this->info("==================================================");
        $this->info("Proses penarikan data dari semua mesin selesai.");
    }
}
