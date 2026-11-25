<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\LeaveRequest;
use App\Models\PayrollRun;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class LeaveRequestController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $leaveRequests = LeaveRequest::with(['employee.user', 'employee.department'])
            ->filter(request(['search', 'status']))
            ->latest()
            ->paginate(10)
            ->appends(request()->query());

        return $this->renderAdminPage('Admin/LeaveRequests/Index', [
            'leaveRequests' => $leaveRequests,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return $this->renderAdminPage('Admin/LeaveRequests/Create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'type' => 'required|in:cuti,sick,izin_setengah_hari',
            'start_date' => 'required|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'reason' => 'nullable|string|max:1000',
            'attachment_path' => 'nullable|file|mimes:pdf,doc,docx|max:2048',
        ]);

        if ($request->hasFile('attachment_path')) {
            $validated['attachment_path'] = $request->file('attachment_path')->store('leave-attachments', 'public');
        }

        LeaveRequest::create($validated + [
            'employee_id' => Auth::user()->employee->id,
        ]);

        return redirect()->route('admin.leave-requests.index')
            ->with('success', 'Permohonan izin berhasil diajukan.');
    }

    /**
     * Display the specified resource.
     */
    public function show(LeaveRequest $leaveRequest)
    {
        return $this->renderAdminPage('Admin/LeaveRequests/Show', [
            'leaveRequest' => $leaveRequest->load('employee.user'),
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(LeaveRequest $leaveRequest)
    {
        abort_unless($leaveRequest->status === 'pending', 403);

        return $this->renderAdminPage('Admin/LeaveRequests/Edit', [
            'leaveRequest' => $leaveRequest->load('employee.user'),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, LeaveRequest $leaveRequest)
    {
        $validated = $request->validate([
            'type' => 'required|in:cuti,sick,izin_setengah_hari',
            'start_date' => 'required|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'reason' => 'nullable|string|max:1000',
        ]);

        $leaveRequest->update($validated);

        return redirect()->route('admin.leave-requests.index')
            ->with('success', 'Permohonan izin berhasil diperbarui.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(LeaveRequest $leaveRequest)
    {
        $lockedRequest = LeaveRequest::query()
            ->lockForUpdate()
            ->findOrFail($leaveRequest->id);

        if ($lockedRequest->status === 'approved') {
            return response('Pengajuan izin yang sudah disetujui tidak dapat dihapus.', 409);
        }

        $hasSynchronizedAttendance = Attendance::query()
            ->where('employee_id', $lockedRequest->employee_id)
            ->whereBetween('date', [
                $lockedRequest->start_date,
                $lockedRequest->end_date ?? $lockedRequest->start_date,
            ])
            ->where('notes', 'Izin: '.$lockedRequest->reason)
            ->exists();

        if ($hasSynchronizedAttendance) {
            return response('Pengajuan izin yang pernah disetujui dan tersinkron ke absensi tidak dapat dihapus.', 409);
        }

        $attachmentPath = $lockedRequest->attachment_path;
        $lockedRequest->delete();

        if ($attachmentPath) {
            Storage::disk('public')->delete($attachmentPath);
        }

        return redirect()->route('admin.leave-requests.index')
            ->with('success', 'Pengajuan izin berhasil dihapus.');
    }

    // Method Tambahan untuk Approve/Reject
    /** @return Responsable|Response */
    public function approve(Request $request, LeaveRequest $leaveRequest)
    {
        $validated = $request->validate([
            'status' => 'required|in:approved,rejected',
            'approval_note' => ['nullable', 'string'],
        ]);

        // Ensure approval_note exists in validated array (handle Laravel 12 edge case)
        if (! isset($validated['approval_note'])) {
            $validated['approval_note'] = null;
        }

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
                        'notes' => 'Izin: '.$lockedRequest->reason,
                    ]
                );
            }
        });

        return redirect()->route('admin.leave-requests.index')
            ->with('success', 'Permohonan izin berhasil disetujui.');
    }

    /**
     * Cancel a leave request.
     */
    /** @return Responsable|Response */
    public function cancel(Request $request, LeaveRequest $leaveRequest)
    {
        $validated = $request->validate([
            'cancel_reason' => 'required|string|max:1000',
        ]);

        $lockedRequest = LeaveRequest::query()
            ->lockForUpdate()
            ->findOrFail($leaveRequest->id);

        if ($lockedRequest->status !== 'approved') {
            return response('Hanya pengajuan izin yang sudah disetujui yang dapat dibatalkan.', 409);
        }

        $startDate = Carbon::parse($lockedRequest->start_date);
        $endDate = $lockedRequest->end_date
            ? Carbon::parse($lockedRequest->end_date)
            : $startDate->copy();

        $payrollLocked = PayrollRun::query()
            ->whereIn('status', ['approved', 'paid'])
            ->whereDate('period_start', '<=', $endDate->toDateString())
            ->whereDate('period_end', '>=', $startDate->toDateString())
            ->exists();

        if ($payrollLocked) {
            return response('Pengajuan izin tidak dapat dibatalkan karena penggajian periode tersebut sudah disetujui/dibayar.', 409);
        }

        DB::transaction(function () use ($lockedRequest, $validated, $startDate, $endDate) {
            // Hapus absensi yang dibuat otomatis saat izin disetujui.
            Attendance::query()
                ->where('employee_id', $lockedRequest->employee_id)
                ->whereBetween('date', [$startDate->
