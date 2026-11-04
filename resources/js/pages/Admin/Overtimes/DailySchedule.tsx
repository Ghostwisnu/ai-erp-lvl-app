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
            <div className="mx-auto min-h-screen max-w-7xl py-8 sm:px-6 lg:px-8">
                {/* Header & Filter Tanggal */}
                <div className="mb-8 flex flex-col items-center justify-between rounded-lg border bg-white p-4 shadow-sm md:flex-row">
                    <div>
                        <h1 className="text-2xl font-bold text-gray-800">
                            📋 Jadwal Lembur Harian
                        </h1>
                        <p className="mt-1 text-sm text-gray-500">
                            Daftar pengumuman lembur karyawan berdasarkan
                            tanggal.
                        </p>
                    </div>

                    <div className="mt-4 flex items-center gap-3 md:mt-0">
                        <label className="text-sm font-medium text-gray-700">
                            Pilih Tanggal:
                        </label>
                        <input
                            type="date"
                            value={selectedDate}
                            onChange={handleDateChange}
                            className="rounded-md border p-2 text-sm shadow-sm focus:border-blue-500 focus:ring-blue-500"
                        />
                        <Link
                            href="/admin/overtimes"
                            className="ml-2 rounded-md bg-gray-100 px-4 py-2 text-sm text-gray-700 transition hover:bg-gray-200"
                        >
                            Lihat Semua Data
                        </Link>
                    </div>
                </div>

                {/* Daftar Kartu Pengumuman */}
                {overtimes.length > 0 ? (
                    <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
                        {overtimes.map((ot: any) => (
                            <div
                                key={ot.id}
                                className="flex flex-col overflow-hidden rounded-xl border border-gray-100 bg-white shadow-md transition-shadow duration-300 hover:shadow-lg"
                            >
                                {/* Header Kartu */}
                                <div className="bg-blue-600 p-4 text-white">
                                    <h3 className="text-lg font-bold">
                                        {ot.department}
                                    </h3>
                                    <p className="mt-1 text-sm text-blue-100">
                                        PIC: {ot.pic}
                                    </p>
                                </div>

                                {/* Body Kartu */}
                                <div className="flex-1 p-4">
                                    <div className="mb-4">
                                        <span className="text-xs font-semibold tracking-wider text-gray-500 uppercase">
                                            Tujuan Lembur
                                        </span>
                                        <p className="mt-1 font-medium text-gray-800">
                                            {ot.purpose}
                                        </p>
                                    </div>

                                    <div className="mb-2 flex items-center justify-between border-b pb-2">
                                        <span className="text-sm font-semibold text-gray-700">
                                            Daftar Peserta (
                                            {ot.employees.length} Orang)
                                        </span>
                                    </div>

                                    <ul className="custom-scrollbar max-h-48 space-y-2 overflow-y-auto pr-2">
                                        {ot.employees.map((emp: any) => (
                                            <li
                                                key={emp.id}
                                                className="flex items-center justify-between text-sm"
                                            >
                                                <span className="mr-2 truncate text-gray-700">
                                                    {emp.full_name}
                                                </span>
                                                <span className="font-bold whitespace-nowrap text-blue-600">
                                                    {emp.pivot.duration} Jam
                                                </span>
                                            </li>
                                        ))}
                                    </ul>
                                </div>

                                {/* Footer Kartu */}
                                <div className="mt-auto flex justify-end border-t bg-gray-50 px-4 py-3">
                                    <Link
                                        href={`/admin/overtimes/${ot.id}`}
                                        className="text-sm font-medium text-blue-600 hover:text-blue-800"
                                    >
                                        Lihat Detail &rarr;
                                    </Link>
                                </div>
                            </div>
                        ))}
                    </div>
                ) : (
                    <div className="rounded-xl border bg-white p-12 text-center shadow-sm">
                        <div className="mb-4 text-6xl">📭</div>
                        <h3 className="mb-2 text-xl font-bold text-gray-700">
                            Belum Ada Jadwal Lembur
                        </h3>
                        <p className="text-gray-500">
                            Tidak ada form lembur yang dibuat pada tanggal ini.
                        </p>
                        <Link
                            href="/admin/overtimes/create"
                            className="mt-6 inline-block rounded-lg bg-blue-600 px-6 py-2 font-medium text-white transition hover:bg-blue-700"
                        >
                            + Buat Form Lembur
                        </Link>
                    </div>
                )}
            </div>
        </>
    );
}
