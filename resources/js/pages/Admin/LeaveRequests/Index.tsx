import { Head, Link, router } from '@inertiajs/react';

export default function Index({ leaveRequests }: any) {
    return (
        <>
            <Head title="Data Pengajuan Izin" />
            <div className="mx-auto max-w-7xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-4 flex items-center justify-between">
                        <h2 className="text-xl font-semibold text-gray-800">
                            Pengajuan Izin / Cuti
                        </h2>
                        <Link
                            href="/admin/leave-requests/create"
                            className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700"
                        >
                            + Buat Pengajuan
                        </Link>
                    </div>
                    <table className="w-full border-collapse text-left">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2">Karyawan</th>
                                <th className="p-2">Tipe Izin</th>
                                <th className="p-2">Tanggal</th>
                                <th className="p-2">Status</th>
                                <th className="p-2">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {leaveRequests.data.map((req: any) => (
                                <tr key={req.id} className="border-b">
                                    <td className="p-2 font-medium">
                                        {req.employee.full_name}
                                    </td>
                                    <td className="p-2 capitalize">
                                        {req.type.replace('_', ' ')}
                                    </td>
                                    <td className="p-2">
                                        {req.start_date} s/d{' '}
                                        {req.end_date || req.start_date}
                                    </td>
                                    <td className="p-2">
                                        <span
                                            className={`rounded px-2 py-1 text-xs font-bold ${
                                                req.status === 'approved'
                                                    ? 'bg-green-100 text-green-700'
                                                    : req.status === 'rejected'
                                                      ? 'bg-red-100 text-red-700'
                                                      : req.status ===
                                                          'cancelled'
                                                        ? 'bg-gray-200 text-gray-700'
                                                        : 'bg-yellow-100 text-yellow-700'
                                            }`}
                                        >
                                            {req.status.toUpperCase()}
                                        </span>
                                    </td>
                                    <td className="space-x-2 p-2">
                                        <Link
                                            href={`/admin/leave-requests/${req.id}`}
                                            className="text-gray-600"
                                        >
                                            Lihat
                                        </Link>
                                        <Link
                                            href={`/admin/leave-requests/${req.id}/edit`}
                                            className="text-blue-600"
                                        >
                                            Ubah
                                        </Link>
                                        {req.status !== 'approved' && (
                                            <button
                                                type="button"
                                                onClick={() => {
                                                    if (
                                                        window.confirm(
                                                            'Hapus pengajuan izin ini?',
                                                        )
                                                    ) {
                                                        router.delete(
                                                            `/admin/leave-requests/${req.id}`,
                                                        );
                                                    }
                                                }}
                                                className="text-red-600"
                                            >
                                                Hapus
                                            </button>
                                        )}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </>
    );
}
