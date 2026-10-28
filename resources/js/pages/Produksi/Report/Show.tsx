import { Head, Link } from '@inertiajs/react';
import { PieChart, Pie, Cell, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export default function Show({ spk, stats, chartData = [], defectRanking = [], matrixData = [], dates = [] }: any) {
    // Pastikan stats tidak undefined
    const safeStats = stats || { totalPo: 0, totalPass: 0, totalDefect: 0, defectPercentage: 0, passPercentage: 0 };

    // Data untuk Pie Chart
    const pieData = [
        { name: 'Defect', value: safeStats.defectPercentage, fill: '#e74c3c' },
        { name: 'Pass', value: safeStats.passPercentage, fill: '#2ecc71' },
    ];

    // Warna Bar untuk Tabel Defect
    const barColors = ['#ef4444', '#f97316', '#f59e0b', '#84cc16', '#10b981', '#06b6d4'];

    return (
        <>
            <Head title={`Report QC: ${spk?.po_number || 'Unknown'}`} />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">

                {/* Header */}
                <div className="flex justify-between items-center bg-white p-4 rounded-lg shadow-sm">
                    <div>
                        <h1 className="text-xl font-bold text-gray-800">Report QC B — {spk?.po_number}</h1>
                        <p className="text-sm text-gray-500">
                            Periode: {dates.length > 0 ? new Date(dates[0]).toLocaleDateString('id-ID') : '-'} s/d {dates.length > 0 ? new Date(dates[dates.length - 1]).toLocaleDateString('id-ID') : '-'}
                        </p>
                    </div>
                    <Link href="/produksi/report-qc" className="text-blue-600 hover:underline font-medium">&larr; Kembali</Link>
                </div>

                {/* Detail PO Card */}
                <div className="bg-white p-6 rounded-lg shadow-sm border flex justify-between items-center">
                    <div className="flex gap-6">
                        <div className="w-32 h-40 bg-gray-100 rounded border flex items-center justify-center text-xs text-gray-400 overflow-hidden">
                            {spk?.image_path ? (
                                <img src={`/storage/${spk.image_path}`} alt="Img" className="w-full h-full object-cover" />
                            ) : "No Image"}
                        </div>
                        <div className="space-y-2">
                            <div className="flex gap-4"><span className="text-gray-400 w-24">BRAND</span> <span className="font-bold">{spk?.brand?.name || '-'}</span></div>
                            <div className="flex gap-4"><span className="text-gray-400 w-24">P.O.</span> <span className="font-bold">{spk?.po_number || '-'}</span></div>
                            <div className="flex gap-4"><span className="text-gray-400 w-24">ART COLOR</span> <span className="font-bold">{spk?.art_color || '-'}</span></div>
                            <div className="flex gap-4"><span className="text-gray-400 w-24">TOTAL QTY</span> <span className="font-bold text-lg">{safeStats.totalPo}</span></div>
                        </div>
                    </div>
                    <span className={`px-3 py-1 rounded text-sm font-bold uppercase ${spk?.status === 'active' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-700'}`}>
                        {spk?.status || 'Unknown'}
                    </span>
                </div>

                {/* Ringkasan Statistik */}
                <div className="grid grid-cols-2 gap-6">
                    <div className="bg-white p-4 rounded-lg shadow-sm border-l-4 border-red-500">
                        <span className="text-xs text-gray-500 font-bold uppercase">Defect</span>
                        <div className="text-4xl font-bold text-red-500 mt-2">{safeStats.defectPercentage}%</div>
                        <p className="text-sm text-gray-500 mt-1">Total defect: {safeStats.totalDefect}</p>
                    </div>
                    <div className="bg-white p-4 rounded-lg shadow-sm border-l-4 border-green-500">
                        <span className="text-xs text-gray-500 font-bold uppercase">Pass</span>
                        <div className="text-4xl font-bold text-green-500 mt-2">{safeStats.passPercentage}%</div>
                        <p className="text-sm text-gray-500 mt-1">Total pass: {safeStats.totalPass}</p>
                    </div>
                </div>

                {/* Grafik */}
                <div className="grid grid-cols-2 gap-6">
                    {/* Pie Chart */}
                    <div className="bg-white p-6 rounded-lg shadow-sm border">
                        <h3 className="text-sm font-bold text-gray-500 uppercase mb-4">Defect VS Pass (%)</h3>
                        <div className="h-64 flex flex-col items-center justify-center">
                            <ResponsiveContainer width="100%" height="100%">
                                <PieChart>
                                    <Pie data={pieData} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80} label>
                                        {pieData.map((entry, index) => (
                                            <Cell key={`cell-${index}`} fill={entry.fill} />
                                        ))}
                                    </Pie>
                                    <Tooltip />
                                    <Legend verticalAlign="bottom" height={36} />
                                </PieChart>
                            </ResponsiveContainer>
                        </div>
                    </div>

                    {/* Line Chart */}
                    <div className="bg-white p-6 rounded-lg shadow-sm border">
                        <h3 className="text-sm font-bold text-gray-500 uppercase mb-4">Scanned VS Defect Per Tanggal</h3>
                        <div className="h-64">
                            <ResponsiveContainer width="100%" height="100%">
                                <LineChart data={chartData} margin={{ top: 5, right: 30, left: 20, bottom: 5 }}>
                                    <CartesianGrid strokeDasharray="3 3" vertical={false} />
                                    <XAxis dataKey="date" />
                                    <YAxis yAxisId="left" label={{ value: 'Scanned', angle: -90, position: 'insideLeft' }} />
                                    <YAxis yAxisId="right" orientation="right" label={{ value: 'Defect', angle: 90, position: 'insideRight' }} />
                                    <Tooltip />
                                    <Legend />
                                    <Line yAxisId="left" type="monotone" dataKey="scanned" stroke="#2ecc71" strokeWidth={2} name="Scanned" />
                                    <Line yAxisId="right" type="monotone" dataKey="defect" stroke="#e74c3c" strokeWidth={2} name="Defect" />
                                </LineChart>
                            </ResponsiveContainer>
                        </div>
                    </div>
                </div>

                {/* Ranking Defect */}
                <div className="bg-white p-6 rounded-lg shadow-sm border">
                    <h3 className="text-sm font-bold text-gray-500 uppercase mb-4">KATEGORI DEFECT</h3>
                    <div className="space-y-4">
                        {defectRanking.map((rank: any, index: number) => (
                            <div key={index} className="flex items-center">
                                <div className="w-8 text-center text-gray-400 font-bold">{index + 1}</div>
                                <div className="w-48 font-medium text-sm truncate">{rank.name || '-'}</div>
                                <div className="w-12 font-bold text-red-500 text-sm">{rank.total || 0}</div>
                                <div className="flex-1 ml-4 bg-gray-100 rounded-full h-3">
                                    <div
                                        className="h-3 rounded-full"
                                        style={{
                                            width: `${safeStats.totalDefect > 0 ? (rank.total / safeStats.totalDefect) * 100 : 0}%`,
                                            backgroundColor: barColors[index % barColors.length]
                                        }}
                                    ></div>
                                </div>
                            </div>
                        ))}
                        {defectRanking.length === 0 && <p className="text-center text-gray-400 py-4">Belum ada data defect untuk PO ini.</p>}
                    </div>
                </div>

                {/* Matrix Defect x Daily */}
                <div className="bg-white p-6 rounded-lg shadow-sm border">
                    <h3 className="text-sm font-bold text-gray-500 uppercase mb-4">Matrix Defect x Daily</h3>
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse text-sm">
                            <thead>
                                <tr className="border-b bg-gray-50">
                                    <th className="p-2 border-r">DEFECT</th>
                                    {dates.map((date: string) => (
                                        <th key={date} className="p-2 border-r text-center">
                                            {new Date(date).toLocaleDateString('id-ID', { day: '2-digit', month: 'short' }).toUpperCase()}
                                        </th>
                                    ))}
                                    <th className="p-2 text-center font-bold text-yellow-600 bg-yellow-50">TOTAL</th>
                                </tr>
                            </thead>
                            <tbody>
                                {matrixData.map((row: any, i: number) => (
                                    <tr key={i} className="border-b hover:bg-gray-50">
                                        <td className="p-2 border-r font-medium">{row.defect}</td>
                                        {dates.map((date: string) => (
                                            <td key={date} className="p-2 border-r text-center">
                                                {/* 
                                                  PERBAIKAN: Panggil row[date] secara langsung.
                                                  Karena di Controller kita sudah menggunakan key 'Y-m-d' (2026-10-27)
                                                  dan variabel 'date' di sini juga berisi string '2026-10-27'.
                                                */}
                                                {row[date] || '-'}
                                            </td>
                                        ))}
                                        <td className="p-2 text-center font-bold text-yellow-700 bg-yellow-50">{row.total}</td>
                                    </tr>
                                ))}
                                {matrixData.length === 0 && (
                                    <tr><td colSpan={dates.length + 2} className="p-4 text-center text-gray-500">Belum ada data defect.</td></tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </>
    );
}