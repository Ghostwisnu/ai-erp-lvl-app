import { Head, Link } from '@inertiajs/react';

export default function Show({ overtime }: any) {
    return (
        <>
            <Head title="Detail Lembur" />
            <div className="py-8">
                <div className="max-w-4xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <div className="flex justify-between items-center mb-6">
                            <h2 className="font-semibold text-xl">Detail Form Lembur</h2>
                            <Link href="/admin/overtimes" className="text-blue-600 font-medium hover:underline">&larr; Kembali ke List</Link>
                        </div>

                        <div className="grid grid-cols-2 gap-4 mb-8 bg-blue-50 p-4 rounded border border-blue-100">
                            <div><span className="text-gray-600 text-sm block">Tanggal</span> <span className="font-medium text-lg">{overtime.date}</span></div>
                            <div><span className="text-gray-600 text-sm block">Departemen</span> <span className="font-medium">{overtime.department}</span></div>
                            <div><span className="text-gray-600 text-sm block">Tujuan Lembur</span> <span className="font-medium">{overtime.purpose}</span></div>
                            <div><span className="text-gray-600 text-sm block">PIC</span> <span className="font-medium">{overtime.pic}</span></div>
                        </div>

                        <h3 className="font-medium text-lg mb-3">Daftar Peserta Lembur ({overtime.employees.length} Orang)</h3>
                        <table className="w-full text-left border-collapse border text-sm">
                            <thead>
                                <tr className="bg-gray-50 border-b">
                                    <th className="p-2 border-r">NIK</th>
                                    <th className="p-2 border-r">Nama Karyawan</th>
                                    <th className="p-2 border-r">Departemen</th>
                                    <th className="p-2 border-r">Tipe</th>
                                    <th className="p-2 border-r">Durasi</th>
                                    <th className="p-2">Keterangan Mutasi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {overtime.employees.map((emp: any) => (
                                    <tr key={emp.id} className="border-b">
                                        <td className="p-2 border-r">{emp.employee_code}</td>
                                        <td className="p-2 border-r font-medium">{emp.full_name}</td>
                                        <td className="p-2 border-r">{emp.department}</td>
                                        <td className="p-2 border-r capitalize">{emp.pivot.type}</td>
                                        <td className="p-2 border-r font-bold">
                                            {/* PROTEKSI DARI NaN */}
                                            {parseFloat(emp.pivot?.duration || 0)} Jam
                                        </td>
                                        <td className="p-2">{emp.pivot.mutation_reason || '-'}</td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </>
    );
}