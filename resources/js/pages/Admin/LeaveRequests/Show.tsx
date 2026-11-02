import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

export default function Show({ leaveRequest }: any) {
    const { data, setData, post, processing } = useForm({
        status: leaveRequest.status,
        approval_note: leaveRequest.approval_note || '',
    });

    const submitApproval = (e: FormEvent, status: 'approved' | 'rejected') => {
        e.preventDefault();
        setData('status', status);
        post(`/admin/leave-requests/${leaveRequest.id}/approve`);
    };

    const cancelForm = useForm({ cancel_reason: '' });

    const submitCancel = (e: FormEvent) => {
        e.preventDefault();
        if (
            !window.confirm('Batalkan pengajuan izin yang sudah disetujui ini?')
        ) {
            return;
        }
        cancelForm.post(`/admin/leave-requests/${leaveRequest.id}/cancel`, {
            preserveScroll: true,
        });
    };

    return (
        <>
            <Head title="Detail Pengajuan Izin" />
            <div className="mx-auto max-w-4xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <h2 className="text-xl font-semibold">
                            Detail Pengajuan Izin
                        </h2>
                        <Link
                            href="/admin/leave-requests"
                            className="text-blue-600"
                        >
                            &larr; Kembali
                        </Link>
                    </div>

                    <div className="mb-8 grid grid-cols-2 gap-4 rounded bg-gray-50 p-4">
                        <div>
                            <span className="block text-sm text-gray-500">
                                Karyawan
                            </span>{' '}
                            <span className="font-medium">
                                {leaveRequest.employee.full_name}
                            </span>
                        </div>
                        <div>
                            <span className="block text-sm text-gray-500">
                                Jenis Izin
                            </span>{' '}
                            <span className="font-medium capitalize">
                                {leaveRequest.type.replace('_', ' ')}
                            </span>
                        </div>
                        <div>
                            <span className="block text-sm text-gray-500">
                                Tanggal
                            </span>{' '}
                            <span className="font-medium">
                                {leaveRequest.start_date} s/d{' '}
                                {leaveRequest.end_date ||
                                    leaveRequest.start_date}
                            </span>
                        </div>
                        <div>
                            <span className="block text-sm text-gray-500">
                                Alasan
                            </span>{' '}
                            <span className="font-medium">
                                {leaveRequest.reason}
                            </span>
                        </div>
                        {leaveRequest.attachment_path && (
                            <div className="col-span-2">
                                <span className="block text-sm text-gray-500">
                                    Lampiran
                                </span>
                                <a
                                    href={`/storage/${leaveRequest.attachment_path}`}
                                    target="_blank"
                                    className="text-blue-600 hover:underline"
                                >
                                    Lihat Surat/Lampiran
                                </a>
                            </div>
                        )}
                    </div>

                    {leaveRequest.status === 'pending' ? (
                        <div className="border-t pt-6">
                            <h3 className="mb-4 text-lg font-medium">
                                Tindakan Persetujuan
                            </h3>
                            <textarea
                                value={data.approval_note}
                                onChange={(e) =>
                                    setData('approval_note', e.target.value)
                                }
                                placeholder="Catatan persetujuan (opsional)..."
                                className="mb-4 w-full rounded border p-2"
                                rows={3}
                            />
                            <div className="flex space-x-2">
                                <button
                                    onClick={(e) =>
                                        submitApproval(e, 'approved')
                                    }
                                    disabled={processing}
                                    className="rounded bg-green-600 px-4 py-2 text-white"
                                >
                                    Setujui (Approve)
                                </button>
                                <button
                                    onClick={(e) =>
                                        submitApproval(e, 'rejected')
                                    }
                                    disabled={processing}
                                    className="rounded bg-red-600 px-4 py-2 text-white"
                                >
                                    Tolak (Reject)
                                </button>
                            </div>
                        </div>
                    ) : (
                        <div className="border-t pt-6">
                            <h3 className="mb-2 text-lg font-medium">
                                Status:
                                <span
                                    className={`ml-2 rounded px-2 py-1 text-sm ${
                                        leaveRequest.status === 'approved'
                                            ? 'bg-green-100 text-green-700'
                                            : leaveRequest.status ===
                                                'cancelled'
                                              ? 'bg-gray-200 text-gray-700'
                                              : 'bg-red-100 text-red-700'
                                    }`}
                                >
                                    {leaveRequest.status.toUpperCase()}
                                </span>
                            </h3>
                            <p className="text-sm text-gray-600">
                                Catatan: {leaveRequest.approval_note || '-'}
                            </p>

                            {leaveRequest.status === 'cancelled' && (
                                <p className="mt-1 text-sm text-gray-600">
                                    Alasan pembatalan:{' '}
                                    {leaveRequest.cancel_reason || '-'}
                                </p>
                            )}

                            {leaveRequest.status === 'approved' && (
                                <div className="mt-6 border-t pt-4">
                                    <h3 className="mb-2 text-lg font-medium">
                                        Batalkan Pengajuan
                                    </h3>
                                    <p className="mb-2 text-sm text-gray-600">
                                        Pembatalan akan menghapus data absensi
                                        izin yang dibuat saat pengajuan
                                        disetujui.
                                    </p>
                                    <textarea
                                        value={cancelForm.data.cancel_reason}
                                        onChange={(e) =>
                                            cancelForm.setData(
                                                'cancel_reason',
                                                e.target.value,
                                            )
                                        }
                                        placeholder="Alasan pembatalan (wajib)..."
                                        className="mb-1 w-full rounded border p-2"
                                        rows={3}
                                    />
                                    {cancelForm.errors.cancel_reason && (
                                        <p className="mb-2 text-sm text-red-600">
                                            {cancelForm.errors.cancel_reason}
                                        </p>
                                    )}
                                    <button
                                        onClick={submitCancel}
                                        disabled={cancelForm.processing}
                                        className="rounded bg-red-600 px-4 py-2 text-white disabled:opacity-50"
                                    >
                                        Batalkan Pengajuan
                                    </button>
                                </div>
                            )}
                        </div>
                    )}
                </div>
            </div>
        </>
    );
}
