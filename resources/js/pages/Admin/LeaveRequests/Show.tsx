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

    return (
        <>
            <Head title="Detail Pengajuan Izin" />
            <div className="py-8 max-w-4xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="font-semibold text-xl">Detail Pengajuan Izin</h2>
                        <Link href="/admin/leave-requests" className="text-blue-600">&larr; Kembali</Link>
                    </div>

                    <div className="grid grid-cols-2 gap-4 mb-8 bg-gray-50 p-4 rounded">
                        <div><span className="text-gray-500 text-sm block">Karyawan</span> <span className="font-medium">{leaveRequest.employee.full_name}</span></div>
                        <div><span className="text-gray-500 text-sm block">Jenis Izin</span> <span className="font-medium capitalize">{leaveRequest.type.replace('_', ' ')}</span></div>
                        <div><span className="text-gray-500 text-sm block">Tanggal</span> <span className="font-medium">{leaveRequest.start_date} s/d {leaveRequest.end_date || leaveRequest.start_date}</span></div>
                        <div><span className="text-gray-500 text-sm block">Alasan</span> <span className="font-medium">{leaveRequest.reason}</span></div>
                        {leaveRequest.attachment_path && (
                            <div className="col-span-2">
                                <span className="text-gray-500 text-sm block">Lampiran</span>
                                <a href={`/storage/${leaveRequest.attachment_path}`} target="_blank" className="text-blue-600 hover:underline">Lihat Surat/Lampiran</a>
                            </div>
                        )}
                    </div>

                    {leaveRequest.status === 'pending' ? (
                        <div className="border-t pt-6">
                            <h3 className="font-medium text-lg mb-4">Tindakan Persetujuan</h3>
                            <textarea
                                value={data.approval_note}
                                onChange={e => setData('approval_note', e.target.value)}
                                placeholder="Catatan persetujuan (opsional)..."
                                className="w-full border p-2 rounded mb-4"
                                rows={3}
                            />
                            <div className="flex space-x-2">
                                <button onClick={(e) => submitApproval(e, 'approved')} disabled={processing} className="px-4 py-2 bg-green-600 text-white rounded">
                                    Setujui (Approve)
                                </button>
                                <button onClick={(e) => submitApproval(e, 'rejected')} disabled={processing} className="px-4 py-2 bg-red-600 text-white rounded">
                                    Tolak (Reject)
                                </button>
                            </div>
                        </div>
                    ) : (
                        <div className="border-t pt-6">
                            <h3 className="font-medium text-lg mb-2">Status:
                                <span className={`ml-2 px-2 py-1 rounded text-sm ${leaveRequest.status === 'approved' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                                    }`}>
                                    {leaveRequest.status.toUpperCase()}
                                </span>
                            </h3>
                            <p className="text-sm text-gray-600">Catatan: {leaveRequest.approval_note || '-'}</p>
                        </div>
                    )}
                </div>
            </div>
        </>
    );
}