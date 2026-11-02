import { Head, Link } from '@inertiajs/react';
import {
    PieChart,
    Pie,
    Cell,
    LineChart,
    Line,
    XAxis,
    YAxis,
    CartesianGrid,
    Tooltip,
    Legend,
    ResponsiveContainer,
} from 'recharts';

export default function Show({
    spk,
    stats,
    chartData = [],
    defectRanking = [],
    matrixData = [],
    dates = [],
}: any) {
    const statusLabels: Record<string, string> = {
        create: 'Draf',
        active: 'Aktif',
        finished: 'Selesai',
        closed: 'Ditutup',
    };
    // Pastikan stats tidak undefined
    const safeStats = stats || {
        totalPo: 0,
        totalPass: 0,
        totalDefect: 0,
        defectPercentage: 0,
        passPercentage: 0,
    };

    // Data untuk Pie Chart
    const pieData = [
        { name: 'Cacat', value: safeStats.defectPercentage, fill: '#e74c3c' },
        { name: 'Lolos', value: safeStats.passPercentage, fill: '#2ecc71' },
    ];

    // Warna Bar untuk Tabel Defect
    const barColors = [
        '#ef4444',
        '#f97316',
        '#f59e0b',
        '#84cc16',
        '#10b981',
        '#06b6d4',
    ];

    return (
        <>
            <Head
                title={`Laporan QC: ${spk?.po_number || 'Tidak diketahui'}`}
            />
            <div className="mx-auto max-w-7xl space-y-6 py-8 sm:px-6 lg:px-8">
                {/* Header */}
                <div className="flex items-center justify-between rounded-lg bg-white p-4 shadow-sm">
                    <div>
                        <h1 className="text-xl font-bold text-gray-800">
                            Laporan QC B — {spk?.po_number}
                        </h1>
                        <p className="text-sm text-gray-500">
                            Periode:{' '}
                            {dates.length > 0
                                ? new Date(dates[0]).toLocaleDateString('id-ID')
                                : '-'}{' '}
                            s/d{' '}
                            {dates.length > 0
                                ? new Date(
                                      dates[dates.length - 1],
                                  ).toLocaleDateString('id-ID')
                                : '-'}
                        </p>
                    </div>
                    <Link
                        href="/produksi/report-qc"
                        className="font-medium text-blue-600 hover:underline"
                    >
                        &larr; Kembali
                    </Link>
                </div>

                {/* Detail PO Card */}
                <div className="flex items-center justify-between rounded-lg border bg-white p-6 shadow-sm">
                    <div className="flex gap-6">
                        <div className="flex h-40 w-32 items-center justify-center overflow-hidden rounded border bg-gray-100 text-xs text-gray-400">
                            {spk?.image_path ? (
                                <img
                                    src={`/storage/${spk.image_path}`}
                                    alt="Gambar referensi SPK"
                                    className="h-full w-full object-cover"
                                />
                            ) : (
                                'Tidak ada gambar'
                            )}
                        </div>
                        <div className="space-y-2">
                            <div className="flex gap-4">
                                <span className="w-24 text-gray-400">
                                    MEREK
                                </span>{' '}
                                <span className="font-bold">
                                    {spk?.brand?.name || '-'}
                                </span>
                            </div>
                            <div className="flex gap-4">
                                <span className="w-24 text-gray-400">P.O.</span>{' '}
                                <span className="font-bold">
                                    {spk?.po_number || '-'}
                                </span>
                            </div>
                            <div className="flex gap-4">
                                <span className="w-24 text-gray-400">
                                    MODEL / WARNA
                                </span>{' '}
                                <span className="font-bold">
                                    {spk?.art_color || '-'}
                                </span>
                            </div>
                            <div className="flex gap-4">
                                <span className="w-24 text-gray-400">
                                    JUMLAH TOTAL
                                </span>{' '}
                                <span className="text-lg font-bold">
                                    {safeStats.totalPo}
                                </span>
                            </div>
                        </div>
                    </div>
                    <span
                        className={`rounded px-3 py-1 text-sm font-bold uppercase ${spk?.status === 'active' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-700'}`}
                    >
                        {statusLabels[spk?.status?.toLowerCase()] ??
                            spk?.status ??
                            'Tidak diketahui'}
                    </span>
                </div>

                {/* Ringkasan Statistik */}
                <div className="grid grid-cols-2 gap-6">
                    <div className="rounded-lg border-l-4 border-red-500 bg-white p-4 shadow-sm">
                        <span className="text-xs font-bold text-gray-500 uppercase">
                            Cacat
                        </span>
                        <div className="mt-2 text-4xl font-bold text-red-500">
                            {safeStats.defectPercentage}%
                        </div>
                        <p className="mt-1 text-sm text-gray-500">
                            Total cacat: {safeStats.totalDefect}
                        </p>
                    </div>
                    <div className="rounded-lg border-l-4 border-green-500 bg-white p-4 shadow-sm">
                        <span className="text-xs font-bold text-gray-500 uppercase">
                            Lolos
                        </span>
                        <div className="mt-2 text-4xl font-bold text-green-500">
                            {safeStats.passPercentage}%
                        </div>
                        <p className="mt-1 text-sm text-gray-500">
                            Total lolos: {safeStats.totalPass}
                        </p>
                    </div>
                </div>

                {/* Grafik */}
                <div className="grid grid-cols-2 gap-6">
                    {/* Pie Chart */}
                    <div className="rounded-lg border bg-white p-6 shadow-sm">
                        <h3 className="mb-4 text-sm font-bold text-gray-500 uppercase">
                            Cacat vs Lolos (%)
                        </h3>
                        <div className="flex h-64 flex-col items-center justify-center">
                            <ResponsiveContainer width="100%" height="100%">
                                <PieChart>
                                    <Pie
                                        data={pieData}
                                        dataKey="value"
                                        nameKey="name"
                                        cx="50%"
                                        cy="50%"
                                        outerRadius={80}
                                        label
                                    >
                                        {pieData.map((entry, index) => (
                                            <Cell
                                                key={`cell-${index}`}
                                                fill={entry.fill}
                                            />
                                        ))}
                                    </Pie>
                                    <Tooltip />
                                    <Legend
                                        verticalAlign="bottom"
                                        height={36}
                                    />
                                </PieChart>
                            </ResponsiveContainer>
                        </div>
                    </div>

                    {/* Line Chart */}
                    <div className="rounded-lg border bg-white p-6 shadow-sm">
                        <h3 className="mb-4 text-sm font-bold text-gray-500 uppercase">
                            Pemindaian vs Cacat per Tanggal
                        </h3>
                        <div className="h-64">
                            <ResponsiveContainer width="100%" height="100%">
                                <LineChart
                                    data={chartData}
                                    margin={{
                                        top: 5,
                                        right: 30,
                                        left: 20,
                                        bottom: 5,
                                    }}
                                >
                                    <CartesianGrid
                                        strokeDasharray="3 3"
                                        vertical={false}
                                    />
                                    <XAxis
                                        dataKey="date"
                                        tickFormatter={(date: string) =>
                                            new Date(date).toLocaleDateString(
                                                'id-ID',
                                                {
                                                    day: '2-digit',
                                                    month: 'short',
                                                },
                                            )
                                        }
                                    />
                                    <YAxis
                                        yAxisId="left"
                                        label={{
                                            value: 'Dipindai',
                                            angle: -90,
                                            position: 'insideLeft',
                                        }}
                                    />
                                    <YAxis
                                        yAxisId="right"
                                        orientation="right"
                                        label={{
                                            value: 'Cacat',
                                            angle: 90,
                                            position: 'insideRight',
                                        }}
                                    />
                                    <Tooltip />
                                    <Legend />
                                    <Line
                                        yAxisId="left"
                                        type="monotone"
                                        dataKey="scanned"
                                        stroke="#2ecc71"
                                        strokeWidth={2}
                                        name="Dipindai"
                                    />
                                    <Line
                                        yAxisId="right"
                                        type="monotone"
                                        dataKey="defect"
                                        stroke="#e74c3c"
                                        strokeWidth={2}
                                        name="Cacat"
                                    />
                                </LineChart>
                            </ResponsiveContainer>
                        </div>
                    </div>
                </div>

                {/* Peringkat kategori cacat */}
                <div className="rounded-lg border bg-white p-6 shadow-sm">
                    <h3 className="mb-4 text-sm font-bold text-gray-500 uppercase">
                        KATEGORI CACAT
                    </h3>
                    <div className="space-y-4">
                        {defectRanking.map((rank: any, index: number) => (
                            <div key={index} className="flex items-center">
                                <div className="w-8 text-center font-bold text-gray-400">
                                    {index + 1}
                                </div>
                                <div className="w-48 truncate text-sm font-medium">
                                    {rank.name || '-'}
                                </div>
                                <div className="w-12 text-sm font-bold text-red-500">
                                    {rank.total || 0}
                                </div>
                                <div className="ml-4 h-3 flex-1 rounded-full bg-gray-100">
                                    <div
                                        className="h-3 rounded-full"
                                        style={{
                                            width: `${safeStats.totalDefect > 0 ? (rank.total / safeStats.totalDefect) * 100 : 0}%`,
                                            backgroundColor:
                                                barColors[
                                                    index % barColors.length
                                                ],
                                        }}
                                    ></div>
                                </div>
                            </div>
                        ))}
                        {defectRanking.length === 0 && (
                            <p className="py-4 text-center text-gray-400">
                                Belum ada data cacat untuk PO ini.
                            </p>
                        )}
                    </div>
                </div>

                {/* Matriks cacat per hari */}
                <div className="rounded-lg border bg-white p-6 shadow-sm">
                    <h3 className="mb-4 text-sm font-bold text-gray-500 uppercase">
                        Matriks Cacat per Hari
                    </h3>
                    <div className="overflow-x-auto">
                        <table className="w-full border-collapse text-left text-sm">
                            <thead>
                                <tr className="border-b bg-gray-50">
                                    <th className="border-r p-2">CACAT</th>
                                    {dates.map((date: string) => (
                                        <th
                                            key={date}
                                            className="border-r p-2 text-center"
                                        >
                                            {new Date(date)
                                                .toLocaleDateString('id-ID', {
                                                    day: '2-digit',
                                                    month: 'short',
                                                })
                                                .toUpperCase()}
                                        </th>
                                    ))}
                                    <th className="bg-yellow-50 p-2 text-center font-bold text-yellow-600">
                                        JUMLAH
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                {matrixData.map((row: any, i: number) => (
                                    <tr
                                        key={i}
                                        className="border-b hover:bg-gray-50"
                                    >
                                        <td className="border-r p-2 font-medium">
                                            {row.defect}
                                        </td>
                                        {dates.map((date: string) => (
                                            <td
                                                key={date}
                                                className="border-r p-2 text-center"
                                            >
                                                {/*
                                                  PERBAIKAN: Panggil row[date] secara langsung.
                                                  Karena di Controller kita sudah menggunakan key 'Y-m-d' (2026-10-27)
                                                  dan variabel 'date' di sini juga berisi string '2026-10-27'.
                                                */}
                                                {row[date] || '-'}
                                            </td>
                                        ))}
                                        <td className="bg-yellow-50 p-2 text-center font-bold text-yellow-700">
                                            {row.total}
                                        </td>
                                    </tr>
                                ))}
                                {matrixData.length === 0 && (
                                    <tr>
                                        <td
                                            colSpan={dates.length + 2}
                                            className="p-4 text-center text-gray-500"
                                        >
                                            Belum ada data cacat.
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
