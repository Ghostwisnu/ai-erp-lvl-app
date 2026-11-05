<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\FingerLog;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;

class AdmsController extends Controller
{
    // Handshake mesin (GET) dan penerimaan data (POST)
    public function cdata(Request $request): Response
    {
        if ($request->isMethod('get')) {
            $sn = $request->query('SN');

            return $this->plain(
                "GET OPTION FROM: {$sn}\n".
                "Stamp=9999\nOpLogStamp=9999\nErrorDelay=60\nDelay=30\n".
                "TransTimes=00:00;14:05\nTransInterval=1\n".
                "TransFlag=TransData AttLog\nRealtime=1\nEncrypt=0"
            );
        }

        if (strtoupper((string) $request->query('table')) === 'ATTLOG') {
            $count = 0;
            foreach (preg_split('/\r\n|\r|\n/', trim($request->getContent())) ?: [] as $line) {
                $cols = explode("\t", trim($line));
                if (count($cols) < 2 || $cols[0] === '') {
                    continue;
                }

                try {
                    $this->storePunch($cols[0], Carbon::parse($cols[1]));
                    $count++;
                } catch (\Throwable $e) {
                    Log::warning('ADMS gagal memproses baris: '.$line.' - '.$e->getMessage());
                }
            }

            return $this->plain("OK: {$count}");
        }

        return $this->plain('OK');
    }

    public function getrequest(): Response
    {
        return $this->plain('OK');
    }

    public function devicecmd(): Response
    {
        return $this->plain('OK');
    }

    private function storePunch(string $pin, Carbon $timestamp): void
    {
        $log = FingerLog::firstOrCreate(['pin' => $pin, 'scan_time' => $timestamp]);
        if (! $log->wasRecentlyCreated) {
            return;
        }

        $employee = Employee::where('employee_code', $pin)->first();
        if (! $employee) {
            return;
        }

        $attendance = Attendance::firstOrNew([
            'employee_id' => $employee->id,
            'date' => $timestamp->toDateString(),
        ]);

        $time = $timestamp->toTimeString();
        if (! $attendance->check_in) {
            $attendance->check_in = $time;
        } else {
            $attendance->check_out = $time;
        }
        $attendance->status = 'present';
        $attendance->save();
    }

    private function plain(string $body): Response
    {
        return response($body, 200)->header('Content-Type', 'text/plain');
    }
}
