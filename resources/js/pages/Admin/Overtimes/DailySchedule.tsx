import { Head, Link } from '@inertiajs/react';
import { useState } from 'react';

export default function DailySchedule({ overtimes = [], date }: any) {
    // State untuk filter tanggal
    const [selectedDate, setSelectedDate] = useState(date);

    const handleDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const newDate = e.target.value;
        setSelectedDate(newDate);
        // Redirect ke tanggal baru agar data di backend ter-refresh
        window.location.href = `/admin/overtimes/daily?date=${newDate}`;
    };

    return (
        <>
            <Head title="Jadwal Lembur Harian" />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8 min-h-screen">

                {/* Header & Filter Tanggal */}
                <div className="flex flex-col md:flex-row justify-between items-center mb-8 bg-white p-4 rounded-lg shadow-sm border">
                    <div>
                        <h1 className="text-2xl font-bold text-gray-800">📋 Jadwal Lembur Harian</h1>
                        <p className="text-gray-500 text-sm mt-1">Daftar pengumuman lembur karyawan berdasarkan tanggal.</p>
                    </div>

                    <div className="flex items-center gap-3 mt-4 md:mt-0">
                        <label className="text-sm font-medium text-gray-700">Pilih Tanggal:</label>
                        <input
                            type="date"
                            value={selectedDate}
                            onChange={handleDateChange}
                            className="border p-2 rounded-md text-sm shadow-sm focus:ring-blue-500 focus:border-blue-500"
                        />
                        <Link href="/admin/overtimes" className="bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-2 rounded-md text-sm ml-2 transition">
                            Lihat Semua Data
                        </Link>
                    </div>
                </div>

                {/* Daftar Kartu Pengumuman */}
                {overtimes.length > 0 ? (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        {overtimes.map((ot: any) => (
                            <div key={ot.id} className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100 hover:shadow-lg transition-shadow duration-300 flex flex-col">
                                {/* Header Kartu */}
                                <div className="bg-blue-600 p-4 text-white">
                                    <h3 className="font-bold text-lg">{ot.department}</h3>
                                    <p className="text-blue-100 text-sm mt-1">PIC: {ot.pic}</p>
                                </div>

                                {/* Body Kartu */}
                                <div className="p-4 flex-1">
                                    <div className="mb-4">
                                        <span className="text-xs font-semibold text-gray-500 uppercase tracking-wider">Tujuan Lembur</span>
                                        <p className="text-gray-800 font-medium mt-1">{ot.purpose}</p>
                                    </div>

                                    <div className="mb-2 flex justify-between items-center border-b pb-2">
                                        <span className="text-sm font-semibold text-gray-700">Daftar Peserta ({ot.employees.length} Orang)</span>
                                    </div>

                                    <ul className="space-y-2 max-h-48 overflow-y-auto pr-2 custom-scrollbar">
                                        {ot.employees.map((emp: any) => (
                                            <li key={emp.id} className="flex justify-between items-center text-sm">
                                                <span className="text-gray-700 truncate mr-2">{emp.full_name}</span>
                                                <span className="font-bold text-blue-600 whitespace-nowrap">{emp.pivot.duration} Jam</span>
                                            </li>
                                        ))}
                                    </ul>
                                </div>

                                {/* Footer Kartu */}
                                <div className="bg-gray-50 px-4 py-3 border-t flex justify-end mt-auto">
                                    <Link href={`/admin/overtimes/${ot.id}`} className="text-sm text-blue-600 hover:text-blue-800 font-medium">
                                        Lihat Detail &rarr;
                                    </Link>
                                </div>
                            </div>
                        ))}
                    </div>
                ) : (
                    <div className="bg-white rounded-xl shadow-sm border p-12 text-center">
                        <div className="text-6xl mb-4">📭</div>
                        <h3 className="text-xl font-bold text-gray-700 mb-2">Belum Ada Jadwal Lembur</h3>
                        <p className="text-gray-500">Tidak ada form lembur yang dibuat pada tanggal ini.</p>
                        <Link href="/admin/overtimes/create" className="inline-block mt-6 bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg font-medium transition">
                            + Buat Form Lembur
                        </Link>
                    </div>
                )}
            </div>
        </>
    );
}