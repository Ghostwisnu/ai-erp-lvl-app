import { Head, Link, router } from '@inertiajs/react';
import { useMemo, useState } from 'react';

interface AttendanceRow {
    employee_id: number;
    code: string;
    name: string;
    department: string | null;
    check_in: string | null;
    check_out: string | null;
    total_scan: number;
    status: 'present' | 'sick' | 'leave' | 'absent';
}

interface Props {
    attendanceData: AttendanceRow[];
    date: string;
    dayOffLabel: string | null;
}

const statusLabels: Record<AttendanceRow['status'], string> = {
    present: 'Hadir',
    sick: 'Sakit',
    leave: 'Izin/Cuti',
    absent: 'Tidak hadir',
};

const statusColors: Record<AttendanceRow['status'], string> = {
    present: 'bg-green-100 text-green-700',
    sick: 'bg-yellow-100 text-yellow-700',
    leave: 'bg-blue-100 text-blue-700',
    absent: 'bg-red-100 text-red-700',
};

export default function AttendanceDaily({
    attendanceData,
    date,
    dayOffLabel,
}: Props) {
    const [search, setSearch] = useState('');
    const [department, setDepartment] = useState('');

    const departments = useMemo(
        () =>
            [
                ...new Set(
                    attendanceData
                        .map((row) => row.department)
                        .filter((item): item is string => Boolean(item)),
                ),
            ].sort(),
        [attendanceData],
    );
    const filteredData = useMemo(() => {
        const searchTerm = search.trim().toLocaleLowerCase();

        return attendanceData.filter((row) => {
            const matchesSearch =
                row.name.toLocaleLowerCase().includes(searchTerm) ||
                row.code.toLocaleLowerCase().includes(searchTerm);
            const matchesDepartment =
                !department || row.department === department;

            return matchesSearch && matchesDepartment;
        });
    }, [attendanceData, department, search]);

    const handleDateChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        router.get(
            '/admin/reports/attendance-daily',
            { date: event.target.value },
            { preserveState: true, preserveScroll: true },
        );
    };

    return (
        <>
            <Head title="Rekap Jam Absensi Harian" />
            <div className="mx-auto max-w-7xl space-y-6 px-4 py-8 sm:px-6 lg:px-8">
                <div className="flex flex-wrap items-center justify-between gap-4">
                    <div>
                        <h1 className="text-2xl font-semibold text-gray-900">
                            Rekap Jam Absensi Harian
                        </h1>
                        <p className="mt-1 text-sm text-gray-600">
                            Jam masuk dan jam keluar karyawan pada tanggal yang
                            dipilih.
                        </p>
                    </div>
                    <Link
                        href="/admin/reports"
                        className="rounded border px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
                    >
                        Kembali ke Laporan
                    </Link>
                </div>

                <section className="space-y-4 rounded-lg border bg-white p-5 shadow-sm">
                    <div className="flex flex-wrap items-end gap-3">
                        <label className="flex flex-col gap-1 text-sm font-medium text-gray-700">
                            Tanggal absensi
                            <input
                                type="date"
                                value={date}
                                onChange={handleDateChange}
                                className="rounded-md border px-3 py-2 font-normal"
                            />
                        </label>
                        <label className="flex flex-col gap-1 text-sm font-medium text-gray-700">
                            Cari karyawan
                            <input
                                type="search"
                                value={search}
                                onChange={(event) =>
                                    setSearch(event.target.value)
                                }
                                placeholder="Nama atau NIK"
                                className="rounded-md border px-3 py-2 font-normal"
                            />
                        </label>
                        <label className="flex flex-col gap-1 text-sm font-medium text-gray-700">
                            Departemen
                            <select
                                value={department}
                                onChange={(event) =>
                                    setDepartment(event.target.value)
                                }
                                className="rounded-md border px-3 py-2 font-normal"
                            >
                                <option value="">Semua departemen</option>
                                {departments.map((item) => (
                                    <option key={item} value={item ?? ''}>
                                        {item}
                                    </option>
                                ))}
                            </select>
                        </label>
                    </div>

                    {dayOffLabel && (
                        <p className="rounded-md bg-green-50 px-3 py-2 text-sm font-medium text-green-800">
                            {dayOffLabel}: status absensi otomatis ditampilkan
                            sebagai Hadir.
                        </p>
                    )}

                    <div className="overflow-x-auto">
                        <table className="w-full min-w-[760px] border-collapse text-left text-sm">
                            <thead>
                                <tr className="border-b bg-gray-50 text-gray-700">
                                    <th className="p-3">No.</th>
                                    <th className="p-3">NIK</th>
                                    <th className="p-3">Nama karyawan</th>
                                    <th className="p-3">Departemen</th>
                                    <th className="p-3 text-center">
                                        Jam masuk
                                    </th>
                                    <th className="p-3 text-center">
                                        Jam keluar
                                    </th>
                                    <th className="p-3 text-center">
                                        Jumlah scan
                                    </th>
                                    <th className="p-3 text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredData.map((row, index) => (
                                    <tr
                                        key={row.employee_id}
                                        className="border-b last:border-0 hover:bg-gray-50"
                                    >
                                        <td className="p-3">{index + 1}</td>
                                        <td className="p-3 font-medium">
                                            {row.code}
                                        </td>
                                        <td className="p-3">{row.name}</td>
                                        <td className="p-3">
                                            {row.department || '-'}
                                        </td>
                                        <td className="p-3 text-center font-semibold">
                                            {row.check_in || '-'}
                                        </td>
                                        <td className="p-3 text-center font-semibold">
                                            {row.check_out || '-'}
                                        </td>
                                        <td className="p-3 text-center">
                                            {row.total_scan}
                                        </td>
                                        <td className="p-3 text-center">
                                            <span
                                                className={`inline-flex rounded-full px-2.5 py-1 text-xs font-semibold ${statusColors[row.status]}`}
                                            >
                                                {statusLabels[row.status]}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                                {filteredData.length === 0 && (
                                    <tr>
                                        <td
                                            colSpan={8}
                                            className="p-8 text-center text-gray-500"
                                        >
                                            Tidak ada karyawan yang sesuai
                                            dengan filter.
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                    <p className="text-sm text-gray-500">
                        Menampilkan {filteredData.length} dari{' '}
                        {attendanceData.length} karyawan.
                    </p>
                </section>
            </div>
        </>
    );
}
