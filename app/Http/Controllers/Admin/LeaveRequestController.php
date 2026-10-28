<?php

namespace App\Http\Controllers\Admin;

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\LeaveRequest;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class LeaveRequestController extends BaseAdminController
{
    public function index()
    {
        // Ambil semua pengajuan izin beserta data karyawan
        $leaveRequests = LeaveRequest::with('employee')->orderBy('created_at', 'desc')->paginate(10);
        return $this->renderAdminPage('Admin/LeaveRequests/Index', [
            'leaveRequests' => $leaveRequests
        ]);
    }

    public function create()
    {
        // Ambil semua karyawan untuk dropdown
        $employees = Employee::orderBy('full_name')->get();
        return $this->renderAdminPage('Admin/LeaveRequests/Create', [
            'employees' => $employees
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'employee_id' => 'required|exists:employees,id',
            'type' => 'required|in:sakit,cuti,izin_setengah_hari',
            'start_date' => 'required|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'start_time' => 'nullable|date_format:H:i',
            'end_time' => 'nullable|date_format:H:i',
            'reason' => 'required|string',
            'attachment' => 'nullable|file|mimes:pdf,jpg,png|max:2048', // Maks 2MB
        ]);

        if ($request->hasFile('attachment')) {
            $validated['attachment_path'] = $request->file('attachment')->store('leave_attachments', 'public');
        }

        // Set status default pending
        $validated['status'] = 'pending';

        LeaveRequest::create($validated);

        return redirect()->route('admin.leave-requests.index')
            ->with('success', 'Pengajuan izin berhasil dibuat.');
    }

    public function show(LeaveRequest $leaveRequest)
    {
        return $this->renderAdminPage('Admin/LeaveRequests/Show', [
            'leaveRequest' => $leaveRequest->load('employee', 'approver')
        ]);
    }

    public function edit(LeaveRequest $leaveRequest)
    {
        $employees = Employee::orderBy('full_name')->get();
        return $this->renderAdminPage('Admin/LeaveRequests/Edit', [
            'leaveRequest' => $leaveRequest,
            'employees' => $employees
        ]);
    }

    public function update(Request $request, LeaveRequest $leaveRequest)
    {
        $validated = $request->validate([
            'employee_id' => 'required|exists:employees,id',
            'type' => 'required|in:sakit,cuti,izin_setengah_hari',
            'start_date' => 'required|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'start_time' => 'nullable|date_format:H:i',
            'end_time' => 'nullable|date_format:H:i',
            'reason' => 'required|string',
            'attachment' => 'nullable|file|mimes:pdf,jpg,png|max:2048',
        ]);

        if ($request->hasFile('attachment')) {
            // Hapus file lama jika ada
            if ($leaveRequest->attachment_path) {
                Storage::disk('public')->delete($leaveRequest->attachment_path);
            }
            $validated['attachment_path'] = $request->file('attachment')->store('leave_attachments', 'public');
        }

        $leaveRequest->update($validated);

        return redirect()->route('admin.leave-requests.index')
            ->with('success', 'Pengajuan izin berhasil diupdate.');
    }

    public function destroy(LeaveRequest $leaveRequest)
    {
        if ($leaveRequest->attachment_path) {
            Storage::disk('public')->delete($leaveRequest->attachment_path);
        }
        $leaveRequest->delete();
        return redirect()->route('admin.leave-requests.index')
            ->with('success', 'Pengajuan izin berhasil dihapus.');
    }

    // Method Tambahan untuk Approve/Reject
    public function approve(Request $request, LeaveRequest $leaveRequest)
    {
        $validated = $request->validate([
            'status' => 'required|in:approved,rejected',
            'approval_note' => 'nullable|string'
        ]);

        $leaveRequest->update([
            'status' => $validated['status'],
            'approved_by' => Auth::id(),
            'approval_note' => $validated['approval_note']
        ]);

        // SINKRONISASI KE TABEL ABSENSI (Hanya jika di-approve)
        if ($validated['status'] === 'approved') {
            $startDate = Carbon::parse($leaveRequest->start_date);
            $endDate = $leaveRequest->end_date ? Carbon::parse($leaveRequest->end_date) : $startDate;

            for ($date = $startDate; $date->lte($endDate); $date->addDay()) {
                // Tentukan status absensi
                $attendanceStatus = match ($leaveRequest->type) {
                    'sakit' => 'sick',
                    'cuti' => 'leave',
                    'izin_setengah_hari' => 'present', // Izin setengah hari dihitung hadir
                    default => 'absent',
                };

                Attendance::updateOrCreate(
                    ['employee_id' => $leaveRequest->employee_id, 'date' => $date->toDateString()],
                    [
                        'status' => $attendanceStatus,
                        'check_in' => $leaveRequest->start_time,
                        'check_out' => $leaveRequest->end_time,
                        'notes' => 'Izin: ' . $leaveRequest->reason,
                    ]
                );
            }
        }

        return redirect()->back()->with('success', 'Status pengajuan berhasil diperbarui.');
    }
}
