<?php

namespace App\Http\Controllers\Admin;

use App\Models\Attendance;
use App\Models\Employee;
use App\Models\LeaveRequest;
use App\Models\PayrollRun;
use Carbon\Carbon;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\Response;

class LeaveRequestController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        // Ambil semua pengajuan izin beserta data karyawan
        $leaveRequests = LeaveRequest::with('employee')->orderBy('created_at', 'desc')->paginate(10);

        return $this->renderAdminPage('Admin/LeaveRequests/Index', [
            'leaveRequests' => $leaveRequests,
        ]);
    }

    /** @return Responsable|Response */
    public function create()
    {
        // Ambil semua karyawan untuk dropdown
        $employees = Employee::orderBy('full_name')->get();

        return $this->renderAdminPage('Admin/LeaveRequests/Create', [
            'employees' => $employees,
        ]);
    }

    /** @return Responsable|Response */
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

    /** @return Responsable|Response */
    public function show(LeaveRequest $leaveRequest)
    {
        return $this->renderAdminPage('Admin/LeaveRequests/Show', [
            'leaveRequest' => $leaveRequest->load('employee', 'approver'),
        ]);
    }

    /** @return Responsable|Response */
    public function edit(LeaveRequest $leaveRequest)
    {
        $employees = Employee::orderBy('full_name')->get();

        return $this->renderAdminPage('Admin/LeaveRequests/Edit', [
            'leaveRequest' => $leaveRequest,
            'employees' => $employees,
        ]);
    }

    /** @return Responsable|Response */
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

    /** @return Responsable|Response */
    public function destroy(LeaveRequest $leaveRequest)
    {
        $attachmentPath = DB::transaction(function () use ($leaveRequest) {
            $lockedRequest = LeaveRequest::query()
                ->lockForUpdate()
                ->findOrFail($leaveRequest->id);

            abort_unless(
                $lockedRequest->status !== 'approved',
                409,
                'Pengajuan izin yang sudah disetujui tidak dapat dihapus.',
            );

            $hasSynchronizedAttendance = Attendance::query()
                ->where('employee_id', $lockedRequest->employee_id)
                ->whereBetween('date', [
                    $lockedRequest->start_date,
                    $lockedRequest->end_date ?? $lockedRequest->start_date,
                ])
                ->where('notes', 'Izin: '.$lockedRequest->reason)
                ->exists();

            abort_unless(
                ! $hasSynchronizedAttendance,
                409,
                'Pengajuan izin yang pernah disetujui dan tersinkron ke absensi tidak dapat dihapus.',
            );

            $path = $lockedRequest->attachment_path;
            $lockedRequest->delete();

            return $path;
        });

        if ($attachmentPath) {
            Storage::disk('public')->delete($attachmentPath);
        }

        return redirect()->route('admin.leave-requests.index')
            ->with('success', 'Pengajuan izin berhasil dihapus.');
    }

    /** @return Responsable|Response */
    public function cancel(Request $request, LeaveRequest $leaveRequest)
    {
        $validated = $request->validate([
            'cancel_reason' => 'required|string|max:1000',
        ]);

        DB::transaction(function () use ($leaveRequest, $validated) {
            $lockedRequest = LeaveRequest::query()
                ->lockForUpdate()
                ->findOrFail($leaveRequest->id);

            abort_unless(
                $lockedRequest->status === 'approved',
                409,
                'Hanya pengajuan izin yang sudah disetujui yang dapat dibatalkan.',
            );

            $startDate = Carbon::parse($lockedRequest->start_date);
            $endDate = $lockedRequest->end_date
                ? Carbon::parse($lockedRequest->end_date)
                : $startDate->copy();

            $payrollLocked = PayrollRun::query()
                ->whereIn('status', ['approved', 'paid'])
                ->whereDate('period_start', '<=', $endDate->toDateString())
                ->whereDate('period_end', '>=', $startDate->toDateString())
                ->exists();

            abort_if(
                $payrollLocked,
                409,
                'Pengajuan izin tidak dapat dibatalkan karena penggajian periode tersebut sudah disetujui/dibayar.',
            );

            // Hapus absensi yang dibuat otomatis saat izin disetujui.
            Attendance::query()
                ->where('employee_id', $lockedRequest->employee_id)
                ->whereBetween('date', [$startDate->toDateString(), $endDate->toDateString()])
                ->where('notes', 'Izin: '.$lockedRequest->reason)
                ->delete();

            $lockedRequest->update([
                'status' => 'cancelled',
                'cancelled_by' => Auth::id(),
                'cancelled_at' => now(),
                'cancel_reason' => $validated['cancel_reason'],
            ]);
        });

        return redirect()->back()->with('success', 'Pengajuan izin berhasil dibatalkan.');
    }

    // Method Tambahan untuk Approve/Reject
    /** @return Responsable|Response */
    public function approve(Request $request, LeaveRequest $leaveRequest)
    {
        $validated = $request->validate([
            'status' => 'required|in:approved,rejected',
            'approval_note' => 'nullable|string',
        ]);

        DB::transaction(function () use ($leaveRequest, $validated) {
            $lockedRequest = LeaveRequest::query()
                ->lockForUpdate()
                ->findOrFail($leaveRequest->id);

            $lockedRequest->update([
                'status' => $validated['status'],
                'approved_by' => Auth::id(),
                'approval_note' => $validated['approval_note'],
            ]);

            if ($validated['status'] !== 'approved') {
                return;
            }

            $startDate = Carbon::parse($lockedRequest->start_date);
            $endDate = $lockedRequest->end_date
                ? Carbon::parse($lockedRequest->end_date)
                : $startDate->copy();

            for ($date = $startDate; $date->lte($endDate); $date->addDay()) {
                $attendanceStatus = match ($lockedRequest->type) {
                    'sakit' => 'sick',
                    'cuti' => 'leave',
                    'izin_setengah_hari' => 'present',
                    default => 'absent',
                };

                Attendance::updateOrCreate(
                    ['employee_id' => $lockedRequest->employee_id, 'date' => $date->toDateString()],
                    [
                        'status' => $attendanceStatus,
                        'check_in' => $lockedRequest->start_time,
                        'check_out' => $lockedRequest->end_time,
                        'notes' => 'Izin: '.$lockedRequest->reason,
                    ]
                );
            }
        });

        return redirect()->back()->with('success', 'Status pengajuan berhasil diperbarui.');
    }
}
