import { Head, Link } from '@inertiajs/react';

export default function Show({ overtime }: any) {
    return (
        <>
            <Head title="Detail Lembur" />
            <div className="py-8">
                <div className="mx-auto max-w-4xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <div className="mb-6 flex items-center justify-between">
                            <h2 className="text-xl font-semibold">
                                Detail Form Lembur
                            </h2>
                            <Link
                                href="/admin/overtimes"
                                className="font-medium text-blue-600 hover:underline"
                            >
                                &larr; Kembali ke List
                            </Link>
                        </div>

                        <div className="mb-8 grid grid-cols-2 gap-4 rounded border border-blue-100 bg-blue-50 p-4">
                            <div>
                                <span className="block text-sm text-gray-600">
                                    Tanggal
                                </span>{' '}
                                <span className="text-lg font-medium">
                                    {overtime.date}
                                </span>
                            </div>
                            <div>
                                <span className="block text-sm text-gray-600">
                                    Departemen
                                </span>{' '}
                                <span className="font-medium">
                                    {overtime.department}
                                </span>
                            </div>
                            <div>
                                <span className="block text-sm text-gray-600">
                                    Tujuan Lembur
                                </span>{' '}
                                <span className="font-medium">
                                    {overtime.purpose}
                                </span>
                            </div>
                            <div>
                                <span className="block text-sm text-gray-600">
                                    PIC
                                </span>{' '}
                                <span className="font-medium">
                                    {overtime.pic}
                                </span>
                            </div>
                        </div>

                        <h3 className="mb-3 text-lg font-medium">
                            Daftar Peserta Lembur ({overtime.employees.length}{' '}
                            Orang)
                        </h3>
                        <table className="w-full border-collapse border text-left text-sm">
                            <thead>
                                <tr className="border-b bg-gray-50">
                                    <th className="border-r p-2">NIK</th>
                                    <th className="border-r p-2">
                                        Nama Karyawan
                                    </th>
                                    <th className="border-r p-2">Departemen</th>
                                    <th className="border-r p-2">Tipe</th>
                                    <th className="border-r p-2">Durasi</th>
                                    <th className="p-2">Keterangan Mutasi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {overtime.employees.map((emp: any) => (
                                    <tr key={emp.id} className="border-b">
                                        <td className="border-r p-2">
                                            {emp.employee_code}
                                        </td>
                                        <td className="border-r p-2 font-medium">
                                            {emp.full_name}
                                        </td>
                                        <td className="border-r p-2">
                                            {emp.department}
                                        </td>
                                        <td className="border-r p-2 capitalize">
                                            {emp.pivot.type}
                                        </td>
                                        <td className="border-r p-2 font-bold">
                                            {/* PROTEKSI DARI NaN */}
                                            {parseFloat(
                                                emp.pivot?.duration || 0,
                                            )}{' '}
                                            Jam
                                        </td>
                                        <td className="p-2">
                                            {emp.pivot.mutation_reason || '-'}
                                        </td>
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
