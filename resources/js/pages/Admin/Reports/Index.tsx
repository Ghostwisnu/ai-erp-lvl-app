import { Head, Link, router } from '@inertiajs/react';
import { useState, useMemo } from 'react';

export default function Index({
    attendanceData = [],
    overtimeData = [],
    leaveData = [],
    dates,
    month,
    year,
    period,
    departments = [],
}: any) {
    const [activeTab, setActiveTab] = useState<
        'attendance' | 'overtime' | 'leave'
    >('attendance');
    const [selectedMonth, setSelectedMonth] = useState(month);
    const [selectedYear, setSelectedYear] = useState(year);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedDept, setSelectedDept] = useState('');

    const handleFilter = () => {
        router.get('/admin/reports', {
            month: selectedMonth,
            year: selectedYear,
        });
    };

    const activeData =
        activeTab === 'attendance'
            ? attendanceData
            : activeTab === 'overtime'
              ? overtimeData
              : leaveData;

    const leaveStyles: Record<string, { label: string; className: string }> = {
        sakit: { label: 'S', className: 'bg-yellow-100 text-yellow-700' },
        cuti: { label: 'C', className: 'bg-blue-100 text-blue-700' },
        izin_setengah_hari: {
            label: 'I',
            className: 'bg-purple-100 text-purple-700',
        },
    };

    const leaveTitles: Record<string, string> = {
        sakit: 'Sakit',
        cuti: 'Cuti',
        izin_setengah_hari: 'Izin setengah hari',
    };

    const filteredData = useMemo(() => {
        return activeData.filter((row: any) => {
            const matchSearch =
                row.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                row.code.toLowerCase().includes(searchTerm.toLowerCase());
            const matchDept = selectedDept
                ? row.department === selectedDept
                : true;
            return matchSearch && matchDept;
        });
    }, [activeData, searchTerm, selectedDept]);

    const getStatusColor = (status: string | null) => {
        switch (status) {
            case 'present':
                return 'bg-green-100 text-green-700';
            case 'sick':
                return 'bg-yellow-100 text-yellow-700';
            case 'leave':
                return 'bg-blue-100 text-blue-700';
            case 'absent':
                return 'bg-red-100 text-red-700';
            default:
                return 'bg-gray-100 text-gray-400';
        }
    };

    const getStatusLabel = (status: string | null) => {
        switch (status) {
            case 'present':
                return 'H';
            case 'sick':
                return 'S';
            case 'leave':
                return 'C';
            case 'absent':
                return 'A';
            default:
                return '-';
        }
    };

    return (
        <>
            <Head title="Laporan Bulanan" />
            <div className="min-h-screen bg-gray-50 py-6">
                <div className="mx-auto max-w-full px-4">
                    {/* Header & Tabs */}
                    <div className="rounded-t-lg border-b bg-white p-4">
                        <div className="mb-4 flex items-center space-x-4 border-b">
                            <h1
                                className={`cursor-pointer pb-2 text-xl font-bold ${activeTab === 'attendance' ? 'border-b-2 border-green-600 text-green-700' : 'text-gray-500'}`}
                                onClick={() => setActiveTab('attendance')}
                            >
                                Absensi
                            </h1>
                            <h1
                                className={`cursor-pointer pb-2 text-xl font-bold ${activeTab === 'overtime' ? 'border-b-2 border-green-600 text-green-700' : 'text-gray-500'}`}
                                onClick={() => setActiveTab('overtime')}
                            >
                                Lembur
                            </h1>
                            <h1
                                className={`cursor-pointer pb-2 text-xl font-bold ${activeTab === 'leave' ? 'border-b-2 border-green-600 text-green-700' : 'text-gray-500'}`}
                                onClick={() => setActiveTab('leave')}
                            >
                                Izin / Cuti
                            </h1>
                        </div>

                        <div className="flex flex-wrap items-center gap-2">
                            <Link
                                href="/admin/reports/attendance-daily"
                                className="rounded bg-blue-700 px-4 py-2 text-sm text-white hover:bg-blue-800"
                            >
                                Rekap Jam Harian
                            </Link>
                            <a
                                href={`/admin/reports/export?month=${month}&year=${year}${selectedDept ? `&department=${encodeURIComponent(selectedDept)}` : ''}${searchTerm.trim() ? `&search=${encodeURIComponent(searchTerm.trim())}` : ''}`}
                                className="rounded bg-green-700 px-4 py-2 text-sm text-white hover:bg-green-800"
                            >
                                Export Excel
                            </a>
                            <select
                                value={selectedMonth}
                                onChange={(e) =>
                                    setSelectedMonth(e.target.value)
                                }
                                className="rounded border p-2 text-sm"
                            >
                                {Array.from({ length: 12 }, (_, i) => {
                                    const m = i + 1;
                                    const monthName = new Date(
                                        2000,
                                        i,
                                        1,
                                    ).toLocaleString('id-ID', {
                                        month: 'long',
                                    });
                                    const prevMonth = m === 1 ? 12 : m - 1;
                                    const prevMonthName = new Date(
                                        2000,
                                        prevMonth - 1,
                                        1,
                                    ).toLocaleString('id-ID', {
                                        month: 'short',
                                    });
                                    return (
                                        <option key={m} value={m}>
                                            {monthName} (Cut-off 26{' '}
                                            {prevMonthName})
                                        </option>
                                    );
                                })}
                            </select>
                            <select
                                value={selectedYear}
                                onChange={(e) =>
                                    setSelectedYear(e.target.value)
                                }
                                className="rounded border p-2 text-sm"
                            >
                                <option value="2025">2025</option>
                                <option value="2026">2026</option>
                                <option value="2027">2027</option>
                            </select>
                            <button
                                onClick={handleFilter}
                                className="flex items-center rounded bg-green-700 px-4 py-2 text-sm text-white hover:bg-green-800"
                            >
                                🔍 Tampilkan
                            </button>
                        </div>
                    </div>

                    {/* Info Periode & Filter */}
                    <div className="flex flex-wrap items-center justify-between gap-4 border-b bg-green-50 p-3 text-sm">
                        <div className="flex items-center">
                            <span className="mr-4 font-semibold">
                                Periode:{' '}
                                <span className="text-green-700">{period}</span>
                            </span>
                            <span className="mr-4 rounded bg-green-800 px-2 py-1 text-xs text-white">
                                Cut off: 26-25
                            </span>
                        </div>
                        <div className="flex items-center gap-2">
                            <input
                                type="text"
                                placeholder="Cari Nama / NIK..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="w-48 rounded border p-1.5 text-sm"
                            />
                            <select
                                value={selectedDept}
                                onChange={(e) =>
                                    setSelectedDept(e.target.value)
                                }
                                className="w-40 rounded border p-1.5 text-sm"
                            >
                                <option value="">Semua Departemen</option>
                                {departments.map((dept: string, i: number) => (
                                    <option key={i} value={dept}>
                                        {dept}
                                    </option>
                                ))}
                            </select>
                        </div>
                    </div>

                    {/* Keterangan Kode */}
                    {activeTab !== 'overtime' && (
                        <div className="flex flex-wrap items-center gap-2 border-b bg-white px-3 py-2 text-xs">
                            <span className="font-semibold text-gray-700">
                                Keterangan:
                            </span>
                            {(activeTab === 'attendance'
                                ? [
                                      [
                                          'H',
                                          'Hadir',
                                          'bg-green-100 text-green-700',
                                      ],
                                      [
                                          'S',
                                          'Sakit',
                                          'bg-yellow-100 text-yellow-700',
                                      ],
                                      [
                                          'C',
                                          'Cuti',
                                          'bg-blue-100 text-blue-700',
                                      ],
                                      [
                                          'A',
                                          'Alpha / Tanpa keterangan',
                                          'bg-red-100 text-red-700',
                                      ],
                                      [
                                          '-',
                                          'Belum ada data',
                                          'bg-gray-100 text-gray-400',
                                      ],
                                  ]
                                : [
                                      [
                                          'S',
                                          'Sakit',
                                          'bg-yellow-100 text-yellow-700',
                                      ],
                                      [
                                          'C',
                                          'Cuti',
                                          'bg-blue-100 text-blue-700',
                                      ],
                                      [
                                          'I',
                                          'Izin setengah hari',
                                          'bg-purple-100 text-purple-700',
                                      ],
                                  ]
                            ).map(([code, label, className]) => (
                                <span
                                    key={code}
                                    className="flex items-center gap-1"
                                >
                                    <span
                                        className={`inline-block w-6 rounded py-0.5 text-center font-bold ${className}`}
                                    >
                                        {code}
                                    </span>
                                    <span className="mr-2 text-gray-600">
                                        {label}
                                    </span>
                                </span>
                            ))}
                            {activeTab === 'attendance' && (
                                <span className="text-gray-500">
                                    | Garis bawah biru = berasal dari pengajuan
                                    izin. Akhir pekan dan tanggal merah otomatis
                                    dihitung hadir.
                                </span>
                            )}
                        </div>
                    )}

                    {/* Tabel Pivot */}
                    <div className="overflow-x-auto border bg-white">
                        <table className="w-full border-collapse text-center text-sm">
                            <thead>
                                <tr className="border-b bg-gray-100">
                                    <th
                                        rowSpan={2}
                                        className="w-10 border-r p-2"
                                    >
                                        NO
                                    </th>
                                    <th
                                        rowSpan={2}
                                        className="min-w-[150px] border-r p-2 text-left"
                                    >
                                        NAMA KARYAWAN
                                    </th>
                                    <th rowSpan={2} className="border-r p-2">
                                        NIK
                                    </th>
                                    <th rowSpan={2} className="border-r p-2">
                                        Dept
                                    </th>
                                    {activeTab === 'attendance' && (
                                        <th
                                            rowSpan={2}
                                            className="border-r p-2"
                                        >
                                            Tgl Bergabung
                                        </th>
                                    )}

                                    <th
                                        colSpan={dates.length}
                                        className="border-r bg-gray-200 p-1"
                                    >
                                        {activeTab === 'attendance'
                                            ? 'TANGGAL (STATUS)'
                                            : activeTab === 'overtime'
                                              ? 'TANGGAL (JAM LEMBUR)'
                                              : 'TANGGAL (S = Sakit, C = Cuti, I = Izin Setengah Hari)'}
                                    </th>

                                    <th
                                        rowSpan={2}
                                        className="border-r bg-gray-200 p-2 font-bold"
                                    >
                                        {activeTab === 'attendance'
                                            ? 'JML HADIR'
                                            : activeTab === 'overtime'
                                              ? 'TOTAL LEMBUR'
                                              : 'TOTAL HARI'}
                                    </th>
                                </tr>
                                <tr className="border-b bg-gray-50 text-xs">
                                    {dates.map((d: any) => (
                                        <th
                                            key={d.date}
                                            className={`w-8 border-r p-1 ${d.is_weekend || d.holiday_name ? 'bg-red-50 text-red-600' : ''}`}
                                            title={
                                                d.holiday_name
                                                    ? `Tanggal merah: ${d.holiday_name}`
                                                    : d.is_weekend
                                                      ? 'Akhir pekan — otomatis hadir'
                                                      : ''
                                            }
                                        >
                                            {d.day}
                                            <br />
                                            {d.day_name}
                                        </th>
                                    ))}
                                </tr>
                            </thead>
                            <tbody>
                                {filteredData.map((row: any, index: number) => {
                                    let total = 0;
                                    if (activeTab === 'attendance') {
                                        total = row.daily.filter(
                                            (d: any) => d.status === 'present',
                                        ).length;
                                    } else if (activeTab === 'leave') {
                                        total = row.daily.filter(
                                            (d: any) => d.leave_type,
                                        ).length;
                                    } else {
                                        total = row.daily.reduce(
                                            (acc: number, curr: any) =>
                                                acc + (curr.hours || 0),
                                            0,
                                        );
                                    }

                                    return (
                                        <tr
                                            key={row.id}
                                            className="border-b hover:bg-gray-50"
                                        >
                                            <td className="border-r p-2">
                                                {index + 1}
                                            </td>
                                            <td className="border-r p-2 text-left font-medium">
                                                {row.name}
                                            </td>
                                            <td className="border-r p-2">
                                                {row.code}
                                            </td>
                                            <td className="border-r p-2">
                                                {row.department || '-'}
                                            </td>
                                            {activeTab === 'attendance' && (
                                                <td className="border-r p-2">
                                                    {row.join_date}
                                                </td>
                                            )}

                                            {row.daily.map((day: any) => (
                                                <td
                                                    key={day.date}
                                                    className={`border-r p-1 font-bold ${
                                                        activeTab ===
                                                        'attendance'
                                                            ? getStatusColor(
                                                                  day.status,
                                                              )
                                                            : activeTab ===
                                                                'leave'
                                                              ? (leaveStyles[
                                                                    day
                                                                        .leave_type
                                                                ]?.className ??
                                                                'bg-gray-50 text-gray-400')
                                                              : day.hours > 0
                                                                ? 'bg-green-50 text-green-700'
                                                                : 'bg-gray-50 text-gray-400'
                                                    } ${day.is_leave ? 'underline decoration-blue-500 decoration-2' : ''}`} // <-- Indikator Izin
                                                    title={
                                                        activeTab === 'leave'
                                                            ? day.leave_type
                                                                ? `${leaveTitles[day.leave_type]}: ${day.reason}`
                                                                : ''
                                                            : day.day_off_label ||
                                                              (day.is_leave
                                                                  ? 'Berasal dari Pengajuan Izin'
                                                                  : '')
                                                    }
                                                >
                                                    {activeTab === 'attendance'
                                                        ? getStatusLabel(
                                                              day.status,
                                                          )
                                                        : activeTab === 'leave'
                                                          ? (leaveStyles[
                                                                day.leave_type
                                                            ]?.label ?? '-')
                                                          : day.hours > 0
                                                            ? day.hours
                                                            : '-'}
                                                </td>
                                            ))}

                                            <td className="bg-gray-50 p-2 font-bold">
                                                {total}
                                            </td>
                                        </tr>
                                    );
                                })}
                                {filteredData.length === 0 && (
                                    <tr>
                                        <td
                                            colSpan={dates.length + 6}
                                            className="p-4 text-center text-gray-500"
                                        >
                                            Tidak ada data yang sesuai dengan
                                            filter.
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
