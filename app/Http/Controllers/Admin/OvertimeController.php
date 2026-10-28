<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Employee;
use App\Models\Overtime;
use App\Models\OvertimeEmployee;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Illuminate\Support\Facades\Auth;

class OvertimeController extends BaseAdminController
{
    public function index()
    {
        $overtimes = Overtime::withCount('employees')->orderBy('date', 'desc')->paginate(10);
        return $this->renderAdminPage('Admin/Overtimes/Index', ['overtimes' => $overtimes]);
    }

    // METHOD UNTUK JADWAL HARIAN (Ini yang tadi error)
    public function dailySchedule(Request $request)
    {
        $date = $request->input('date', \Carbon\Carbon::today()->toDateString());

        $overtimes = Overtime::with(['employees' => function ($query) {
            $query->withPivot('duration', 'type', 'mutation_reason');
        }])
            ->where('date', $date)
            ->get();

        return $this->renderAdminPage('Admin/Overtimes/DailySchedule', [
            'overtimes' => $overtimes,
            'date' => $date,
        ]);
    }

    public function create()
    {
        $departments = Employee::whereNotNull('department')->where('department', '!=', '')->distinct()->pluck('department')->toArray();
        $employees = Employee::orderBy('full_name')->get();

        return $this->renderAdminPage('Admin/Overtimes/Create', [
            'departments' => $departments,
            'employees' => $employees,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'date' => 'required|date',
            'department' => 'required|string',
            'purpose' => 'required|string',
            'pic' => 'required|string',
            'employees' => 'required|array|min:1',
            'employees.*.id' => 'required|exists:employees,id',
            'employees.*.type' => 'required|in:reguler,mutasi',
            'employees.*.duration' => 'required|numeric|min:0.5|max:16',
            'employees.*.mutation_reason' => 'nullable|string',
        ]);

        DB::transaction(function () use ($validated) {
            $overtime = Overtime::create([
                'date' => $validated['date'],
                'department' => $validated['department'],
                'purpose' => $validated['purpose'],
                'pic' => $validated['pic'],
                'created_by' => Auth::id(),
            ]);

            foreach ($validated['employees'] as $emp) {
                OvertimeEmployee::create([
                    'overtime_id' => $overtime->id,
                    'employee_id' => $emp['id'],
                    'type' => $emp['type'],
                    'duration' => $emp['duration'],
                    'mutation_reason' => $emp['mutation_reason'] ?? null,
                ]);
            }
        });

        return redirect()->route('admin.overtimes.index')->with('success', 'Form Lembur berhasil dibuat.');
    }

    public function show(Overtime $overtime)
    {
        $overtime->load('employees');
        return $this->renderAdminPage('Admin/Overtimes/Show', ['overtime' => $overtime]);
    }

    public function edit(Overtime $overtime)
    {
        $overtime->load('employees');
        $departments = Employee::whereNotNull('department')->where('department', '!=', '')->distinct()->pluck('department')->toArray();
        $employees = Employee::orderBy('full_name')->get();

        return $this->renderAdminPage('Admin/Overtimes/Edit', [
            'overtime' => $overtime,
            'departments' => $departments,
            'employees' => $employees,
        ]);
    }

    public function update(Request $request, Overtime $overtime)
    {
        $validated = $request->validate([
            'date' => 'required|date',
            'department' => 'required|string',
            'purpose' => 'required|string',
            'pic' => 'required|string',
            'employees' => 'required|array|min:1',
            'employees.*.id' => 'required|exists:employees,id',
            'employees.*.type' => 'required|in:reguler,mutasi',
            'employees.*.duration' => 'required|numeric|min:0.5|max:16',
            'employees.*.mutation_reason' => 'nullable|string',
        ]);

        DB::transaction(function () use ($validated, $overtime) {
            $overtime->update([
                'date' => $validated['date'],
                'department' => $validated['department'],
                'purpose' => $validated['purpose'],
                'pic' => $validated['pic'],
            ]);

            $overtime->employees()->detach();

            foreach ($validated['employees'] as $emp) {
                OvertimeEmployee::create([
                    'overtime_id' => $overtime->id,
                    'employee_id' => $emp['id'],
                    'type' => $emp['type'],
                    'duration' => $emp['duration'],
                    'mutation_reason' => $emp['mutation_reason'] ?? null,
                ]);
            }
        });

        return redirect()->route('admin.overtimes.index')->with('success', 'Form Lembur berhasil diupdate.');
    }

    public function destroy(Overtime $overtime)
    {
        $overtime->delete();
        return redirect()->route('admin.overtimes.index')->with('success', 'Form Lembur berhasil dihapus.');
    }

    // METHOD PRINT: Menggunakan Inertia::render agar tidak memuat layout sidebar
    public function print(Overtime $overtime)
    {
        $overtime->load(['creator', 'employees' => function ($query) {
            $query->withPivot('duration', 'type', 'mutation_reason');
        }]);

        return Inertia::render('Admin/Overtimes/Print', [
            'overtime' => $overtime,
            'auth' => ['user' => Auth::user()]
        ]);
    }
}
