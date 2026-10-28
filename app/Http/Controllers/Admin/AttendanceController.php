<?php

namespace App\Http\Controllers\Admin;

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\Holiday;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AttendanceController extends BaseAdminController
{
    public function index(Request $request)
    {
        $date = $request->input('date', Carbon::today()->toDateString());

        // 1. Ambil data karyawan beserta absensi di tanggal tersebut
        $employees = Employee::with(['attendances' => function ($query) use ($date) {
            $query->where('date', $date);
        }])->orderBy('full_name')->get();

        // 2. Ambil daftar departemen unik dari database (untuk dropdown filter)
        $departments = Employee::whereNotNull('department')
            ->where('department', '!=', '')
            ->distinct()
            ->pluck('department')
            ->toArray();

        // 3. Kirim employees, date, dan departments ke React
        return $this->renderAdminPage('Admin/Attendances/Index', [
            'employees' => $employees,
            'date' => $date,
            'departments' => $departments, // <-- Tambahkan ini
        ]);
    }

    public function store(Request $request)
    {
        $date = $request->input('date');
        $attendances = $request->input('attendances');

        // Cek apakah tanggal ini adalah hari libur (Sabtu/Minggu atau Tanggal Merah)
        $carbonDate = Carbon::parse($date);
        $isWeekend = $carbonDate->isWeekend();
        $isHoliday = Holiday::where('date', $date)->exists();
        $isOffDay = $isWeekend || $isHoliday;

        DB::transaction(function () use ($date, $attendances, $isOffDay) {
            foreach ($attendances as $empId => $data) {
                // Jika hari libur, paksa status menjadi 'present' (Hadir)
                $status = $isOffDay ? 'present' : $data['status'];

                // Jika hadir, jam masuk/keluar bisa dikosongkan atau diisi default
                $checkIn = $isOffDay ? null : ($data['check_in'] ?: null);
                $checkOut = $isOffDay ? null : ($data['check_out'] ?: null);

                Attendance::updateOrCreate(
                    ['employee_id' => $empId, 'date' => $date],
                    [
                        'status' => $status,
                        'check_in' => $checkIn,
                        'check_out' => $checkOut,
                        'notes' => $data['notes'] ?: null,
                    ]
                );
            }
        });

        return redirect()->back()->with('success', 'Absensi tanggal ' . $date . ' berhasil disimpan.');
    }
}
