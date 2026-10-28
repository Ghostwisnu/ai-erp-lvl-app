import { Head, router, Link } from '@inertiajs/react';
import { useState, useEffect } from 'react';

export default function Index({
    activeSpks,
    selectedSpk,
    date,
    timeSlots,
    monitorData,
    totalPerSlot,
    grandTotal,
    stats
}: any) {
    const [isFullscreen, setIsFullscreen] = useState(false);
    const [isClient, setIsClient] = useState(false);
    const [isRefreshing, setIsRefreshing] = useState(false);

    useEffect(() => {
        setIsClient(true);
    }, []);

    const handleSelectSpk = (spkId: string) => {
        router.get('/produksi/monitor-qc', { spk_id: spkId, date: date }, { preserveState: true });
    };

    const handleDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        router.get('/produksi/monitor-qc', { spk_id: selectedSpk?.id, date: e.target.value }, { preserveState: true });
    };

    const handleRefresh = () => {
        setIsRefreshing(true);
        router.get('/produksi/monitor-qc',
            { spk_id: selectedSpk?.id, date: date },
            {
                preserveState: true,
                preserveScroll: true,
                onFinish: () => setIsRefreshing(false)
            }
        );
    };

    const toggleFullscreen = () => {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen();
            setIsFullscreen(true);
        } else {
            if (document.exitFullscreen) {
                document.exitFullscreen();
                setIsFullscreen(false);
            }
        }
    };

    const topDefect = monitorData.length > 0 ? monitorData.reduce((prev: any, current: any) => (prev.total > current.total) ? prev : current) : null;

    let worstSlot = '-';
    let maxSlotDefect = -1;
    Object.entries(totalPerSlot).forEach(([slot, qty]: any) => {
        if (qty > maxSlotDefect) {
            maxSlotDefect = qty;
            worstSlot = slot;
        }
    });

    const safeStats = stats || { passPercentage: 0, defectPercentage: 0, totalPass: 0, totalDefect: 0, totalPo: 0 };

    return (
        <>
            <Head title="Monitoring QC A" />
            {/* 
              Container Utama. 
              Saat fullscreen, kita pakai fixed inset-0 agar menutupi seluruh layar.
              z-50 agar berada di atas segalanya.
            */}
            <div className={`bg-gray-100 p-4 ${isFullscreen ? 'fixed inset-0 z-50 overflow-y-auto' : 'min-h-screen'}`}>

                {/* Top Header */}
                <div className="bg-white rounded-t-lg shadow-sm border-b p-4 flex justify-between items-center mb-4">
                    <div className="flex items-center gap-4">
                        <Link href="/produksi/report-qc" className={`border px-3 py-1 rounded text-sm text-gray-600 hover:bg-gray-50 flex items-center gap-1 ${isFullscreen ? 'hidden' : ''}`}>
                            &larr; Back
                        </Link>
                        <h1 className="text-xl font-bold text-gray-800 flex items-center gap-2">
                            <span className="text-blue-600 border border-blue-600 rounded p-1 text-xs">QC</span>
                            Monitoring QC A — Line 1
                        </h1>
                    </div>
                    <div className="flex items-center gap-3">
                        <span className="bg-red-500 text-white px-3 py-1 rounded-full text-xs font-bold flex items-center gap-1">
                            <span className="w-2 h-2 bg-white rounded-full animate-pulse"></span> LIVE
                        </span>
                        {isClient && (
                            <span className="text-sm text-gray-500 hidden md:block">Update: {new Date().toLocaleTimeString()}</span>
                        )}

                        <input
                            type="date"
                            value={date}
                            onChange={handleDateChange}
                            className="border p-1.5 rounded text-sm"
                        />

                        {/* TOMBOL REFRESH */}
                        <button
                            onClick={handleRefresh}
                            disabled={isRefreshing}
                            className={`bg-gray-100 border text-gray-700 p-2 rounded hover:bg-gray-200 transition ${isRefreshing ? 'opacity-50 cursor-not-allowed' : ''}`}
                            title="Refresh Data"
                        >
                            <svg
                                className={`w-5 h-5 ${isRefreshing ? 'animate-spin' : ''}`}
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
                            </svg>
                        </button>

                        {/* TOMBOL FULLSCREEN */}
                        <button
                            onClick={toggleFullscreen}
                            className="bg-blue-600 text-white p-2 rounded hover:bg-blue-700 transition"
                            title="Toggle Fullscreen"
                        >
                            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                {/* 
                  Layout PO Selector & Detail 
                  KONDISI 'isFullscreen ? hidden : ...' SUDAH DIHAPUS
                  Agar tetap muncul saat fullscreen.
                */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-4">
                    {/* PO Selector Sidebar */}
                    <div className="col-span-1 bg-white rounded-lg shadow-sm border p-4">
                        <h3 className="font-bold text-blue-600 text-sm mb-3 uppercase">PO Selector</h3>
                        <div className="space-y-2 max-h-60 overflow-y-auto pr-2">
                            {activeSpks.map((spk: any) => (
                                <button
                                    key={spk.id}
                                    onClick={() => handleSelectSpk(spk.id)}
                                    className={`w-full text-left p-2 rounded border transition ${selectedSpk?.id === spk.id ? 'border-blue-500 bg-blue-50' : 'hover:bg-gray-50'}`}
                                >
                                    <div className="font-bold text-sm">{spk.po_number}</div>
                                    <div className="text-xs text-gray-500">{spk.brand.name}</div>
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Detail PO */}
                    <div className="col-span-3 bg-white rounded-lg shadow-sm border p-4 flex flex-col md:flex-row gap-6 items-center">
                        {selectedSpk ? (
                            <>
                                <div className="w-24 h-24 bg-gray-100 rounded border flex items-center justify-center text-xs text-gray-400 overflow-hidden shrink-0">
                                    {selectedSpk.image_path ? (
                                        <img src={`/storage/${selectedSpk.image_path}`} alt="Img" className="w-full h-full object-cover" />
                                    ) : "No Image"}
                                </div>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-2 flex-1 w-full">
                                    <div><span className="text-xs text-gray-400 block uppercase">PO Number</span> <span className="font-bold text-lg">{selectedSpk.po_number}</span></div>
                                    <div><span className="text-xs text-gray-400 block uppercase">Art / Color</span> <span className="font-bold">{selectedSpk.art_color}</span></div>
                                    <div><span className="text-xs text-gray-400 block uppercase">Brand</span> <span className="font-bold">{selectedSpk.brand.name}</span></div>
                                    <div><span className="text-xs text-gray-400 block uppercase">Status</span> <span className="font-bold uppercase text-green-600">{selectedSpk.status}</span></div>
                                </div>
                            </>
                        ) : (
                            <p className="text-gray-400 w-full text-center">Pilih PO terlebih dahulu.</p>
                        )}
                    </div>
                </div>

                {/* Tabel Matrix Defect x Time Slot */}
                <div className="bg-white rounded-lg shadow-sm border overflow-x-auto">
                    <table className="w-full text-left border-collapse text-sm">
                        <thead>
                            <tr className="bg-gray-100 border-b">
                                <th className="p-3 border-r font-bold text-gray-700 min-w-[200px]">DEFECT</th>
                                {timeSlots.map((slot: string) => (
                                    <th key={slot} className="p-3 border-r text-center font-bold text-gray-700">
                                        {slot} <br /><span className="text-xs font-normal text-gray-500">WIB</span>
                                    </th>
                                ))}
                                <th className="p-3 text-center font-bold text-yellow-700 bg-yellow-50">TOTAL</th>
                            </tr>
                        </thead>
                        <tbody>
                            {monitorData.map((row: any, index: number) => (
                                <tr key={index} className="border-b hover:bg-gray-50">
                                    <td className="p-3 border-r font-medium uppercase">{row.name}</td>
                                    {timeSlots.map((slot: string) => (
                                        <td key={slot} className="p-3 border-r text-center">
                                            {row.slots[slot] > 0 ? row.slots[slot] : <span className="text-gray-300">-</span>}
                                        </td>
                                    ))}
                                    <td className="p-3 text-center font-bold text-yellow-700 bg-yellow-50">
                                        {row.total > 0 ? row.total : <span className="text-gray-300">-</span>}
                                    </td>
                                </tr>
                            ))}
                            {monitorData.length === 0 && (
                                <tr><td colSpan={timeSlots.length + 2} className="p-6 text-center text-gray-500">Belum ada data defect untuk PO dan tanggal ini.</td></tr>
                            )}

                            {/* Baris Total Bawah */}
                            <tr className="bg-gray-100 font-bold">
                                <td className="p-3 border-r text-left">TOTAL</td>
                                {timeSlots.map((slot: string) => (
                                    <td key={slot} className="p-3 border-r text-center">{totalPerSlot[slot]}</td>
                                ))}
                                <td className="p-3 text-center text-lg text-yellow-800 bg-yellow-100">{grandTotal}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                {/* Statistik Bawah */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4">
                    <div className="bg-white rounded-lg shadow-sm border-t-4 border-yellow-400 p-4">
                        <span className="text-xs text-gray-500 font-bold uppercase flex items-center gap-1">🏆 Defect Terbanyak</span>
                        <div className="font-bold text-lg mt-2 truncate">{topDefect && topDefect.total > 0 ? topDefect.name : '-'}</div>
                        <div className="text-sm text-gray-500">{topDefect ? `${topDefect.total} Pcs` : '0 Pcs'}</div>
                    </div>
                    <div className="bg-white rounded-lg shadow-sm border-t-4 border-teal-400 p-4">
                        <span className="text-xs text-gray-500 font-bold uppercase flex items-center gap-1">⏱ Jam Paling Rawan</span>
                        <div className="font-bold text-lg mt-2">{maxSlotDefect > 0 ? worstSlot : '-'}</div>
                        <div className="text-sm text-gray-500">{maxSlotDefect > 0 ? `${maxSlotDefect} Defect` : '0 Defect'}</div>
                    </div>
                    <div className="bg-white rounded-lg shadow-sm border-t-4 border-green-500 p-4">
                        <span className="text-xs text-gray-500 font-bold uppercase flex items-center gap-1">📈 Persentase Pass</span>
                        <div className="font-bold text-2xl text-green-600 mt-2">{safeStats.passPercentage}%</div>
                        <div className="text-sm text-gray-500">{safeStats.totalPass} / {safeStats.totalPo}</div>
                    </div>
                    <div className="bg-white rounded-lg shadow-sm border-t-4 border-red-500 p-4">
                        <span className="text-xs text-gray-500 font-bold uppercase flex items-center gap-1">📉 Persentase Defect</span>
                        <div className="font-bold text-2xl text-red-600 mt-2">{safeStats.defectPercentage}%</div>
                        <div className="text-sm text-gray-500">{safeStats.totalDefect} / {safeStats.totalPass}</div>
                    </div>
                </div>

            </div>
        </>
    );
}