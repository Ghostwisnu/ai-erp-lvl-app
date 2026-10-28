import { Head, router } from '@inertiajs/react';
import { useState, useMemo } from 'react';

export default function Index({ attendanceData = [], overtimeData = [], dates, month, year, period, departments = [] }: any) {
    const [activeTab, setActiveTab] = useState<'attendance' | 'overtime'>('attendance');
    const [selectedMonth, setSelectedMonth] = useState(month);
    const [selectedYear, setSelectedYear] = useState(year);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedDept, setSelectedDept] = useState('');

    const handleFilter = () => {
        router.get('/admin/reports', { month: selectedMonth, year: selectedYear });
    };

    const activeData = activeTab === 'attendance' ? attendanceData : overtimeData;

    const filteredData = useMemo(() => {
        return activeData.filter((row: any) => {
            const matchSearch = row.name.toLowerCase().includes(searchTerm.toLowerCase()) || row.code.toLowerCase().includes(searchTerm.toLowerCase());
            const matchDept = selectedDept ? row.department === selectedDept : true;
            return matchSearch && matchDept;
        });
    }, [activeData, searchTerm, selectedDept]);

    const getStatusColor = (status: string | null) => {
        switch (status) {
            case 'present': return 'bg-green-100 text-green-700';
            case 'sick': return 'bg-yellow-100 text-yellow-700';
            case 'leave': return 'bg-blue-100 text-blue-700';
            case 'absent': return 'bg-red-100 text-red-700';
            default: return 'bg-gray-100 text-gray-400';
        }
    };

    const getStatusLabel = (status: string | null) => {
        switch (status) {
            case 'present': return 'H';
            case 'sick': return 'S';
            case 'leave': return 'C';
            case 'absent': return 'A';
            default: return '-';
        }
    };

    return (
        <>
            <Head title="Laporan Bulanan" />
            <div className="py-6 bg-gray-50 min-h-screen">
                <div className="max-w-full mx-auto px-4">

                    {/* Header & Tabs */}
                    <div className="bg-white p-4 rounded-t-lg border-b">
                        <div className="flex space-x-4 items-center mb-4 border-b">
                            <h1
                                className={`text-xl font-bold pb-2 cursor-pointer ${activeTab === 'attendance' ? 'text-green-700 border-b-2 border-green-600' : 'text-gray-500'}`}
                                onClick={() => setActiveTab('attendance')}
                            >
                                Absensi
                            </h1>
                            <h1
                                className={`text-xl font-bold pb-2 cursor-pointer ${activeTab === 'overtime' ? 'text-green-700 border-b-2 border-green-600' : 'text-gray-500'}`}
                                onClick={() => setActiveTab('overtime')}
                            >
                                Lembur
                            </h1>
                        </div>

                        <div className="flex flex-wrap gap-2 items-center">
                            <select value={selectedMonth} onChange={e => setSelectedMonth(e.target.value)} className="border p-2 rounded text-sm">
                                {Array.from({ length: 12 }, (_, i) => {
                                    const m = i + 1;
                                    const monthName = new Date(2000, i, 1).toLocaleString('id-ID', { month: 'long' });
                                    const prevMonth = m === 1 ? 12 : m - 1;
                                    const prevMonthName = new Date(2000, prevMonth - 1, 1).toLocaleString('id-ID', { month: 'short' });
                                    return <option key={m} value={m}>{monthName} (Cut-off 26 {prevMonthName})</option>;
                                })}
                            </select>
                            <select value={selectedYear} onChange={e => setSelectedYear(e.target.value)} className="border p-2 rounded text-sm">
                                <option value="2025">2025</option>
                                <option value="2026">2026</option>
                                <option value="2027">2027</option>
                            </select>
                            <button onClick={handleFilter} className="bg-green-700 text-white px-4 py-2 rounded hover:bg-green-800 flex items-center text-sm">
                                🔍 Tampilkan
                            </button>
                        </div>
                    </div>

                    {/* Info Periode & Filter */}
                    <div className="bg-green-50 p-3 border-b flex flex-wrap items-center justify-between text-sm gap-4">
                        <div className="flex items-center">
                            <span className="mr-4 font-semibold">Periode: <span className="text-green-700">{period}</span></span>
                            <span className="bg-green-800 text-white px-2 py-1 rounded text-xs mr-4">Cut off: 26-25</span>
                        </div>
                        <div className="flex items-center gap-2">
                            <input type="text" placeholder="Cari Nama / NIK..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} className="border p-1.5 rounded text-sm w-48" />
                            <select value={selectedDept} onChange={(e) => setSelectedDept(e.target.value)} className="border p-1.5 rounded text-sm w-40">
                                <option value="">Semua Departemen</option>
                                {departments.map((dept: string, i: number) => <option key={i} value={dept}>{dept}</option>)}
                            </select>
                        </div>
                    </div>

                    {/* Tabel Pivot */}
                    <div className="bg-white overflow-x-auto border">
                        <table className="w-full text-sm text-center border-collapse">
                            <thead>
                                <tr className="bg-gray-100 border-b">
                                    <th rowSpan={2} className="border-r p-2 w-10">NO</th>
                                    <th rowSpan={2} className="border-r p-2 text-left min-w-[150px]">NAMA KARYAWAN</th>
                                    <th rowSpan={2} className="border-r p-2">NIK</th>
                                    <th rowSpan={2} className="border-r p-2">Dept</th>
                                    {activeTab === 'attendance' && <th rowSpan={2} className="border-r p-2">Tgl Bergabung</th>}

                                    <th colSpan={dates.length} className="border-r p-1 bg-gray-200">
                                        {activeTab === 'attendance' ? 'TANGGAL (STATUS)' : 'TANGGAL (JAM LEMBUR)'}
                                    </th>

                                    <th rowSpan={2} className="border-r p-2 font-bold bg-gray-200">
                                        {activeTab === 'attendance' ? 'JML HADIR' : 'TOTAL LEMBUR'}
                                    </th>
                                </tr>
                                <tr className="border-b text-xs bg-gray-50">
                                    {dates.map((d: any) => (
                                        <th key={d.date} className={`border-r p-1 w-8 ${d.is_weekend ? 'bg-red-50 text-red-600' : ''}`}>
                                            {d.day}<br />{d.day_name}
                                        </th>
                                    ))}
                                </tr>
                            </thead>
                            <tbody>
                                {filteredData.map((row: any, index: number) => {
                                    let total = 0;
                                    if (activeTab === 'attendance') {
                                        total = row.daily.filter((d: any) => d.status === 'present').length;
                                    } else {
                                        total = row.daily.reduce((acc: number, curr: any) => acc + (curr.hours || 0), 0);
                                    }

                                    return (
                                        <tr key={row.id} className="border-b hover:bg-gray-50">
                                            <td className="border-r p-2">{index + 1}</td>
                                            <td className="border-r p-2 text-left font-medium">{row.name}</td>
                                            <td className="border-r p-2">{row.code}</td>
                                            <td className="border-r p-2">{row.department || '-'}</td>
                                            {activeTab === 'attendance' && <td className="border-r p-2">{row.join_date}</td>}

                                            {row.daily.map((day: any) => (
                                                <td
                                                    key={day.date}
                                                    className={`border-r p-1 font-bold ${activeTab === 'attendance'
                                                            ? getStatusColor(day.status)
                                                            : (day.hours > 0 ? 'bg-green-50 text-green-700' : 'bg-gray-50 text-gray-400')
                                                        } ${day.is_leave ? 'underline decoration-2 decoration-blue-500' : ''}`} // <-- Indikator Izin
                                                    title={day.is_leave ? 'Berasal dari Pengajuan Izin' : ''}
                                                >
                                                    {activeTab === 'attendance'
                                                        ? getStatusLabel(day.status)
                                                        : (day.hours > 0 ? day.hours : '-')}
                                                </td>
                                            ))}

                                            <td className="p-2 font-bold bg-gray-50">{total}</td>
                                        </tr>
                                    );
                                })}
                                {filteredData.length === 0 && (
                                    <tr>
                                        <td colSpan={dates.length + 6} className="p-4 text-center text-gray-500">
                                            Tidak ada data yang sesuai dengan filter.
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