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
                // 1. Inisialisasi device
                $device = ZkDevice::make($ip, timezone: 'Asia/Jakarta');

                // 2. Ambil data absensi hari ini dari mesin
                $punches = $device->session(function ($d) {
                    return $d->attendance()->since(today());
                });

                $count = 0;
                foreach ($punches as $punch) {

                    // 3. SIMPAN KE TABEL RIWAYAT MENTAH (finger_logs)
                    FingerLog::firstOrCreate([
                        'pin' => $punch->userId,
                        'scan_time' => Carbon::parse($punch->timestamp),
                    ]);

                    // 4. REKAP KE TABEL ATTENDANCES
                    $employee = Employee::where('employee_code', $punch->userId)->first();

                    if ($employee) {
                        $timestamp = Carbon::parse($punch->timestamp);
                        $date = $timestamp->toDateString();
                        $time = $timestamp->toTimeString();

                        $attendance = Attendance::firstOrNew([
                            'employee_id' => $employee->id,
                            'date' => $date,
                        ]);

                        // Logika: Scan pertama = Check In, Scan berikutnya = Check Out
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
                // Jika satu mesin gagal, lanjut ke mesin berikutnya
                $this->error("Mesin {$ip}: Gagal ditarik. Error: " . $e->getMessage());
            }
        }

        $this->info("==================================================");
        $this->info("Proses penarikan data dari semua mesin selesai.");
    }
}
