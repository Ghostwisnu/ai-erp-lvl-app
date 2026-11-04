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
    stats,
}: any) {
    const statusLabels: Record<string, string> = {
        create: 'Draf',
        active: 'Aktif',
        finished: 'Selesai',
        closed: 'Ditutup',
    };

    const [isFullscreen, setIsFullscreen] = useState(false);
    const [isClient, setIsClient] = useState(false);
    const [isRefreshing, setIsRefreshing] = useState(false);

    useEffect(() => {
        setIsClient(true);
    }, []);

    const handleSelectSpk = (spkId: string) => {
        router.get(
            '/produksi/monitor-qc',
            { spk_id: spkId, date: date },
            { preserveState: true },
        );
    };

    const handleDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        router.get(
            '/produksi/monitor-qc',
            { spk_id: selectedSpk?.id, date: e.target.value },
            { preserveState: true },
        );
    };

    const handleRefresh = () => {
        setIsRefreshing(true);
        router.get(
            '/produksi/monitor-qc',
            { spk_id: selectedSpk?.id, date: date },
            {
                preserveState: true,
                preserveScroll: true,
                onFinish: () => setIsRefreshing(false),
            },
        );
    };

    const toggleFullscreen = () => {
        if (!document.fullscreenElement) {
            void document.documentElement.requestFullscreen();
            setIsFullscreen(true);
        } else {
            if (document.exitFullscreen) {
                void document.exitFullscreen();
                setIsFullscreen(false);
            }
        }
    };

    const topDefect =
        monitorData.length > 0
            ? monitorData.reduce((prev: any, current: any) =>
                  prev.total > current.total ? prev : current,
              )
            : null;

    let worstSlot = '-';
    let maxSlotDefect = -1;
    Object.entries(totalPerSlot).forEach(([slot, qty]: any) => {
        if (qty > maxSlotDefect) {
            maxSlotDefect = qty;
            worstSlot = slot;
        }
    });

    const safeStats = stats || {
        passPercentage: 0,
        defectPercentage: 0,
        totalPass: 0,
        totalDefect: 0,
        totalPo: 0,
    };

    return (
        <>
            <Head title="Pemantauan QC A" />
            {/*
              Container Utama. 
              Saat fullscreen, kita pakai fixed inset-0 agar menutupi seluruh layar.
              z-50 agar berada di atas segalanya.
            */}
            <div
                className={`bg-gray-100 p-4 ${isFullscreen ? 'fixed inset-0 z-50 overflow-y-auto' : 'min-h-screen'}`}
            >
                {/* Top Header */}
                <div className="mb-4 flex items-center justify-between rounded-t-lg border-b bg-white p-4 shadow-sm">
                    <div className="flex items-center gap-4">
                        <Link
                            href="/produksi/report-qc"
                            className={`flex items-center gap-1 rounded border px-3 py-1 text-sm text-gray-600 hover:bg-gray-50 ${isFullscreen ? 'hidden' : ''}`}
                        >
                            &larr; Kembali
                        </Link>
                        <h1 className="flex items-center gap-2 text-xl font-bold text-gray-800">
                            <span className="rounded border border-blue-600 p-1 text-xs text-blue-600">
                                QC
                            </span>
                            Pemantauan QC A — Lini 1
                        </h1>
                    </div>
                    <div className="flex items-center gap-3">
                        <span className="flex items-center gap-1 rounded-full bg-red-500 px-3 py-1 text-xs font-bold text-white">
                            <span className="h-2 w-2 animate-pulse rounded-full bg-white"></span>{' '}
                            LANGSUNG
                        </span>
                        {isClient && (
                            <span className="hidden text-sm text-gray-500 md:block">
                                Diperbarui: {new Date().toLocaleTimeString()}
                            </span>
                        )}

                        <input
                            type="date"
                            value={date}
                            onChange={handleDateChange}
                            className="rounded border p-1.5 text-sm"
                        />

                        {/* TOMBOL REFRESH */}
                        <button
                            onClick={handleRefresh}
                            disabled={isRefreshing}
                            className={`rounded border bg-gray-100 p-2 text-gray-700 transition hover:bg-gray-200 ${isRefreshing ? 'cursor-not-allowed opacity-50' : ''}`}
                            title="Segarkan Data"
                        >
                            <svg
                                className={`h-5 w-5 ${isRefreshing ? 'animate-spin' : ''}`}
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    strokeLinecap="round"
                                    strokeLinejoin="round"
                                    strokeWidth="2"
                                    d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                                ></path>
                            </svg>
                        </button>

                        {/* TOMBOL FULLSCREEN */}
                        <button
                            onClick={toggleFullscreen}
                            className="rounded bg-blue-600 p-2 text-white transition hover:bg-blue-700"
                            title="Alihkan layar penuh"
                        >
                            <svg
                                className="h-5 w-5"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    strokeLinecap="round"
                                    strokeLinejoin="round"
                                    strokeWidth="2"
                                    d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"
                                ></path>
                            </svg>
                        </button>
                    </div>
                </div>

                {/*
                  Layout PO Selector & Detail 
                  KONDISI 'isFullscreen ? hidden : ...' SUDAH DIHAPUS
                  Agar tetap muncul saat fullscreen.
                */}
                <div className="mb-4 grid grid-cols-1 gap-4 md:grid-cols-4">
                    {/* PO Selector Sidebar */}
                    <div className="col-span-1 rounded-lg border bg-white p-4 shadow-sm">
                        <h3 className="mb-3 text-sm font-bold text-blue-600 uppercase">
                            Pemilih PO
                        </h3>
                        <div className="max-h-60 space-y-2 overflow-y-auto pr-2">
                            {activeSpks.map((spk: any) => (
                                <button
                                    key={spk.id}
                                    onClick={() => handleSelectSpk(spk.id)}
                                    className={`w-full rounded border p-2 text-left transition ${selectedSpk?.id === spk.id ? 'border-blue-500 bg-blue-50' : 'hover:bg-gray-50'}`}
                                >
                                    <div className="text-sm font-bold">
                                        {spk.po_number}
                                    </div>
                                    <div className="text-xs text-gray-500">
                                        {spk.brand.name}
                                    </div>
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Detail PO */}
                    <div className="col-span-3 flex flex-col items-center gap-6 rounded-lg border bg-white p-4 shadow-sm md:flex-row">
                        {selectedSpk ? (
                            <>
                                <div className="flex h-24 w-24 shrink-0 items-center justify-center overflow-hidden rounded border bg-gray-100 text-xs text-gray-400">
                                    {selectedSpk.image_path ? (
                                        <img
                                            src={`/storage/${selectedSpk.image_path}`}
                                            alt="Gambar SPK"
                                            className="h-full w-full object-cover"
                                        />
                                    ) : (
                                        'Tidak ada gambar'
                                    )}
                                </div>
                                <div className="grid w-full flex-1 grid-cols-1 gap-x-8 gap-y-2 md:grid-cols-2">
                                    <div>
                                        <span className="block text-xs text-gray-400 uppercase">
                                            Nomor PO
                                        </span>{' '}
                                        <span className="text-lg font-bold">
                                            {selectedSpk.po_number}
                                        </span>
                                    </div>
                                    <div>
                                        <span className="block text-xs text-gray-400 uppercase">
                                            Model / Warna
                                        </span>{' '}
                                        <span className="font-bold">
                                            {selectedSpk.art_color}
                                        </span>
                                    </div>
                                    <div>
                                        <span className="block text-xs text-gray-400 uppercase">
                                            Merek
                                        </span>{' '}
                                        <span className="font-bold">
                                            {selectedSpk.brand.name}
                                        </span>
                                    </div>
                                    <div>
                                        <span className="block text-xs text-gray-400 uppercase">
                                            Status
                                        </span>{' '}
                                        <span className="font-bold text-green-600 uppercase">
                                            {statusLabels[selectedSpk.status] ??
                                                selectedSpk.status}
                                        </span>
                                    </div>
                                </div>
                            </>
                        ) : (
                            <p className="w-full text-center text-gray-400">
                                Pilih PO terlebih dahulu.
                            </p>
                        )}
                    </div>
                </div>

                {/* Tabel Matrix Defect x Time Slot */}
                <div className="overflow-x-auto rounded-lg border bg-white shadow-sm">
                    <table className="w-full border-collapse text-left text-sm">
                        <thead>
                            <tr className="border-b bg-gray-100">
                                <th className="min-w-[200px] border-r p-3 font-bold text-gray-700">
                                    CACAT
                                </th>
                                {timeSlots.map((slot: string) => (
                                    <th
                                        key={slot}
                                        className="border-r p-3 text-center font-bold text-gray-700"
                                    >
                                        {slot} <br />
                                        <span className="text-xs font-normal text-gray-500">
                                            WIB
                                        </span>
                                    </th>
                                ))}
                                <th className="bg-yellow-50 p-3 text-center font-bold text-yellow-700">
                                    JUMLAH
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            {monitorData.map((row: any, index: number) => (
                                <tr
                                    key={index}
                                    className="border-b hover:bg-gray-50"
                                >
                                    <td className="border-r p-3 font-medium uppercase">
                                        {row.name}
                                    </td>
                                    {timeSlots.map((slot: string) => (
                                        <td
                                            key={slot}
                                            className="border-r p-3 text-center"
                                        >
                                            {row.slots[slot] > 0 ? (
                                                row.slots[slot]
                                            ) : (
                                                <span className="text-gray-300">
                                                    -
                                                </span>
                                            )}
                                        </td>
                                    ))}
                                    <td className="bg-yellow-50 p-3 text-center font-bold text-yellow-700">
                                        {row.total > 0 ? (
                                            row.total
                                        ) : (
                                            <span className="text-gray-300">
                                                -
                                            </span>
                                        )}
                                    </td>
                                </tr>
                            ))}
                            {monitorData.length === 0 && (
                                <tr>
                                    <td
                                        colSpan={timeSlots.length + 2}
                                        className="p-6 text-center text-gray-500"
                                    >
                                        Belum ada data cacat untuk PO dan
                                        tanggal ini.
                                    </td>
                                </tr>
                            )}

                            {/* Baris Total Bawah */}
                            <tr className="bg-gray-100 font-bold">
                                <td className="border-r p-3 text-left">
                                    JUMLAH
                                </td>
                                {timeSlots.map((slot: string) => (
                                    <td
                                        key={slot}
                                        className="border-r p-3 text-center"
                                    >
                                        {totalPerSlot[slot]}
                                    </td>
                                ))}
                                <td className="bg-yellow-100 p-3 text-center text-lg text-yellow-800">
                                    {grandTotal}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                {/* Statistik Bawah */}
                <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-4">
                    <div className="rounded-lg border-t-4 border-yellow-400 bg-white p-4 shadow-sm">
                        <span className="flex items-center gap-1 text-xs font-bold text-gray-500 uppercase">
                            🏆 Cacat Terbanyak
                        </span>
                        <div className="mt-2 truncate text-lg font-bold">
                            {topDefect && topDefect.total > 0
                                ? topDefect.name
                                : '-'}
                        </div>
                        <div className="text-sm text-gray-500">
                            {topDefect ? `${topDefect.total} pcs` : '0 pcs'}
                        </div>
                    </div>
                    <div className="rounded-lg border-t-4 border-teal-400 bg-white p-4 shadow-sm">
                        <span className="flex items-center gap-1 text-xs font-bold text-gray-500 uppercase">
                            ⏱ Jam Paling Rawan
                        </span>
                        <div className="mt-2 text-lg font-bold">
                            {maxSlotDefect > 0 ? worstSlot : '-'}
                        </div>
                        <div className="text-sm text-gray-500">
                            {maxSlotDefect > 0
                                ? `${maxSlotDefect} cacat`
                                : '0 cacat'}
                        </div>
                    </div>
                    <div className="rounded-lg border-t-4 border-green-500 bg-white p-4 shadow-sm">
                        <span className="flex items-center gap-1 text-xs font-bold text-gray-500 uppercase">
                            📈 Persentase Lolos
                        </span>
                        <div className="mt-2 text-2xl font-bold text-green-600">
                            {safeStats.passPercentage}%
                        </div>
                        <div className="text-sm text-gray-500">
                            {safeStats.totalPass} / {safeStats.totalPo}
                        </div>
                    </div>
                    <div className="rounded-lg border-t-4 border-red-500 bg-white p-4 shadow-sm">
                        <span className="flex items-center gap-1 text-xs font-bold text-gray-500 uppercase">
                            📉 Persentase Cacat
                        </span>
                        <div className="mt-2 text-2xl font-bold text-red-600">
                            {safeStats.defectPercentage}%
                        </div>
                        <div className="text-sm text-gray-500">
                            {safeStats.totalDefect} / {safeStats.totalPass}
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
