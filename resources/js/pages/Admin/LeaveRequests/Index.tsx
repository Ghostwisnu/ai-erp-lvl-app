import { Head, Link } from '@inertiajs/react';

export default function Index({ leaveRequests }: any) {
    return (
        <>
            <Head title="Data Pengajuan Izin" />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <div className="flex justify-between items-center mb-4">
                        <h2 className="font-semibold text-xl text-gray-800">Pengajuan Izin / Cuti</h2>
                        <Link href="/admin/leave-requests/create" className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm">
                            + Buat Pengajuan
                        </Link>
                    </div>
                    <table className="w-full text-left border-collapse">
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
                                    <td className="p-2 font-medium">{req.employee.full_name}</td>
                                    <td className="p-2 capitalize">{req.type.replace('_', ' ')}</td>
                                    <td className="p-2">{req.start_date} s/d {req.end_date || req.start_date}</td>
                                    <td className="p-2">
                                        <span className={`px-2 py-1 rounded text-xs font-bold ${req.status === 'approved' ? 'bg-green-100 text-green-700' :
                                                req.status === 'rejected' ? 'bg-red-100 text-red-700' :
                                                    'bg-yellow-100 text-yellow-700'
                                            }`}>
                                            {req.status.toUpperCase()}
                                        </span>
                                    </td>
                                    <td className="p-2 space-x-2">
                                        <Link href={`/admin/leave-requests/${req.id}`} className="text-gray-600">Lihat</Link>
                                        <Link href={`/admin/leave-requests/${req.id}/edit`} className="text-blue-600">Edit</Link>
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