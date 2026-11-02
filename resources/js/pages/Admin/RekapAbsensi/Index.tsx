import { Head, router } from '@inertiajs/react';
import { useState } from 'react';

export default function Index({ rekapData = [], date }: any) {
    const [isLoading, setIsLoading] = useState(false);

    const handleDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        router.get(
            '/admin/rekap-absensi',
            { date: e.target.value },
            { preserveState: true },
        );
    };

    // Fungsi untuk tombol tarik data
    const handleTarikData = () => {
        setIsLoading(true);
        router.post(
            '/admin/rekap-absensi/tarik',
            {},
            {
                onFinish: () => setIsLoading(false),
            },
        );
    };

    return (
        <>
            <Head title="Rekap Absensi Finger" />
            <div className="mx-auto max-w-7xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    {/* Header */}
                    <div className="mb-6 flex items-center justify-between">
                        <h2 className="text-xl font-semibold text-gray-800">
                            Rekap Absensi Mesin Finger
                        </h2>

                        <div className="flex items-center gap-3">
                            <label className="text-sm font-medium">
                                Tanggal:
                            </label>
                            <input
                                type="date"
                                value={date}
                                onChange={handleDateChange}
                                className="rounded border p-2 text-sm"
                            />

                            {/* TOMBOL TARIK DATA */}
                            <button
                                onClick={handleTarikData}
                                disabled={isLoading}
                                className={`rounded px-4 py-2 text-sm font-bold text-white transition ${
                                    isLoading
                                        ? 'cursor-not-allowed bg-gray-400'
                                        : 'bg-blue-600 hover:bg-blue-700'
                                }`}
                            >
                                {isLoading
                                    ? 'Menarik Data...'
                                    : 'Tarik Data Finger'}
                            </button>
                        </div>
                    </div>

                    {/* Tabel Rekap (Sama seperti sebelumnya) */}
                    <div className="overflow-x-auto">
                        <table className="w-full border-collapse text-left text-sm">
                            <thead>
                                <tr className="border-b bg-gray-100">
                                    <th className="border-r p-3">No</th>
                                    <th className="border-r p-3">NIK / PIN</th>
                                    <th className="border-r p-3">
                                        Nama Karyawan
                                    </th>
                                    <th className="border-r p-3">Departemen</th>
                                    <th className="border-r p-3 text-center">
                                        Jam Masuk
                                    </th>
                                    <th className="border-r p-3 text-center">
                                        Jam Keluar
                                    </th>
                                    <th className="border-r p-3 text-center">
                                        Total Pemindaian
                                    </th>
                                    <th className="p-3 text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {rekapData.map((row: any, index: number) => (
                                    <tr
                                        key={row.employee_id}
                                        className="border-b hover:bg-gray-50"
                                    >
                                        <td className="border-r p-3">
                                            {index + 1}
                                        </td>
                                        <td className="border-r p-3 font-medium">
                                            {row.code}
                                        </td>
                                        <td className="border-r p-3">
                                            {row.name}
                                        </td>
                                        <td className="border-r p-3">
                                            {row.department || '-'}
                                        </td>
                                        <td className="border-r p-3 text-center font-bold text-blue-600">
                                            {row.check_in || '-'}
                                        </td>
                                        <td className="border-r p-3 text-center font-bold text-blue-600">
                                            {row.check_out || '-'}
                                        </td>
                                        <td className="border-r p-3 text-center">
                                            {row.total_scan}
                                        </td>
                                        <td className="p-3 text-center">
                                            <span
                                                className={`rounded px-2 py-1 text-xs font-bold uppercase ${
                                                    row.status === 'present'
                                                        ? 'bg-green-100 text-green-700'
                                                        : row.status === 'sick'
                                                          ? 'bg-yellow-100 text-yellow-700'
                                                          : row.status ===
                                                              'leave'
                                                            ? 'bg-blue-100 text-blue-700'
                                                            : 'bg-red-100 text-red-700'
                                                }`}
                                            >
                                                {row.status}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                                {rekapData.length === 0 && (
                                    <tr>
                                        <td
                                            colSpan={8}
                                            className="p-6 text-center text-gray-500"
                                        >
                                            Tidak ada data absensi dari mesin
                                            finger pada tanggal ini.
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </>
    );
}
