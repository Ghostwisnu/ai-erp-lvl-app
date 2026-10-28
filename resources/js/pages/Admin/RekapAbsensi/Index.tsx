import { Head, router } from '@inertiajs/react';
import { useState } from 'react';

export default function Index({ rekapData = [], date }: any) {
    const [isLoading, setIsLoading] = useState(false);

    const handleDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        router.get('/admin/rekap-absensi', { date: e.target.value }, { preserveState: true });
    };

    // Fungsi untuk tombol tarik data
    const handleTarikData = () => {
        setIsLoading(true);
        router.post('/admin/rekap-absensi/tarik', {}, {
            onFinish: () => setIsLoading(false),
        });
    };

    return (
        <>
            <Head title="Rekap Absensi Finger" />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">

                    {/* Header */}
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="font-semibold text-xl text-gray-800">Rekap Absensi Mesin Finger</h2>

                        <div className="flex items-center gap-3">
                            <label className="text-sm font-medium">Tanggal:</label>
                            <input
                                type="date"
                                value={date}
                                onChange={handleDateChange}
                                className="border p-2 rounded text-sm"
                            />

                            {/* TOMBOL TARIK DATA */}
                            <button
                                onClick={handleTarikData}
                                disabled={isLoading}
                                className={`px-4 py-2 rounded text-sm font-bold text-white transition ${isLoading ? 'bg-gray-400 cursor-not-allowed' : 'bg-blue-600 hover:bg-blue-700'
                                    }`}
                            >
                                {isLoading ? 'Menarik Data...' : 'Tarik Data Finger'}
                            </button>
                        </div>
                    </div>

                    {/* Tabel Rekap (Sama seperti sebelumnya) */}
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse text-sm">
                            <thead>
                                <tr className="bg-gray-100 border-b">
                                    <th className="p-3 border-r">No</th>
                                    <th className="p-3 border-r">NIK / PIN</th>
                                    <th className="p-3 border-r">Nama Karyawan</th>
                                    <th className="p-3 border-r">Departemen</th>
                                    <th className="p-3 border-r text-center">Jam Masuk</th>
                                    <th className="p-3 border-r text-center">Jam Keluar</th>
                                    <th className="p-3 border-r text-center">Total Scan</th>
                                    <th className="p-3 text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {rekapData.map((row: any, index: number) => (
                                    <tr key={row.employee_id} className="border-b hover:bg-gray-50">
                                        <td className="p-3 border-r">{index + 1}</td>
                                        <td className="p-3 border-r font-medium">{row.code}</td>
                                        <td className="p-3 border-r">{row.name}</td>
                                        <td className="p-3 border-r">{row.department || '-'}</td>
                                        <td className="p-3 border-r text-center font-bold text-blue-600">
                                            {row.check_in || '-'}
                                        </td>
                                        <td className="p-3 border-r text-center font-bold text-blue-600">
                                            {row.check_out || '-'}
                                        </td>
                                        <td className="p-3 border-r text-center">{row.total_scan}</td>
                                        <td className="p-3 text-center">
                                            <span className={`px-2 py-1 rounded text-xs font-bold uppercase ${row.status === 'present' ? 'bg-green-100 text-green-700' :
                                                    row.status === 'sick' ? 'bg-yellow-100 text-yellow-700' :
                                                        row.status === 'leave' ? 'bg-blue-100 text-blue-700' :
                                                            'bg-red-100 text-red-700'
                                                }`}>
                                                {row.status}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                                {rekapData.length === 0 && (
                                    <tr>
                                        <td colSpan={8} className="p-6 text-center text-gray-500">
                                            Tidak ada data absensi dari mesin finger pada tanggal ini.
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