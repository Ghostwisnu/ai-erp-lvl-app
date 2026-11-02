import { Head, router, Link } from '@inertiajs/react';
import { useState, useEffect, useRef } from 'react';

export default function ScanBoard({
    department,
    activeSpks,
    selectedSpk,
}: any) {
    const departmentLabel =
        department === 'warehouse'
            ? 'Gudang'
            : department === 'finishing'
              ? 'Penyelesaian'
              : department;
    const [barcodeInput, setBarcodeInput] = useState('');
    const [selectedSpkId, setSelectedSpkId] = useState(selectedSpk?.id || '');
    const inputRef = useRef<HTMLInputElement>(null);

    // Fokus otomatis ke input scan
    useEffect(() => {
        if (inputRef.current) inputRef.current.focus();
    }, [selectedSpkId]);

    const handleScan = (e: React.FormEvent) => {
        e.preventDefault();
        if (!barcodeInput || !selectedSpkId) return;

        // Kirim data scan ke backend
        router.post(
            '/produksi/scan/submit',
            {
                spk_id: selectedSpkId,
                department: department,
                barcode: barcodeInput,
                status: 'pass', // Asumsi default pass
            },
            {
                preserveScroll: true,
                onSuccess: () => {
                    setBarcodeInput(''); // Reset input setelah scan
                },
            },
        );
    };

    const handleSelectSpk = (spkId: string) => {
        setSelectedSpkId(spkId);
        router.get(
            `/produksi/scan/${department}`,
            { spk_id: spkId },
            { preserveState: true },
        );
    };

    // --- LOGIKA PERHITUNGAN PROGRESS & OVER SCAN ---
    let totalScanned = 0;
    let totalTarget = 0;
    let hasOverSize = false;

    if (selectedSpk) {
        selectedSpk.details.forEach((detail: any) => {
            const scanned = detail.scans_count || 0;
            totalScanned += scanned;
            totalTarget += detail.qty;

            // Cek apakah ada size yang melebihi Qty
            if (scanned > detail.qty) {
                hasOverSize = true;
            }
        });
    }

    // Progress maksimal 100% secara visual
    const progressPercentage =
        totalTarget > 0
            ? Math.min(Math.round((totalScanned / totalTarget) * 100), 100)
            : 0;
    const isFinished = totalScanned >= totalTarget && totalTarget > 0;

    return (
        <>
            <Head title={`Pemindaian ${departmentLabel}`} />
            <div className="min-h-screen bg-gray-50 p-6">
                <div className="mx-auto max-w-7xl space-y-6">
                    {/* Tombol Kembali */}
                    <Link
                        href="/produksi/scan"
                        className="font-medium text-blue-600 hover:underline"
                    >
                        &larr; Ganti Departemen
                    </Link>

                    {/* NOTIFIKASI PRODUKSI SELESAI */}
                    {isFinished && (
                        <div className="rounded border-l-4 border-green-500 bg-green-100 p-4 text-green-700 shadow-md">
                            <p className="font-bold">Produksi Selesai!</p>
                            <p className="mt-1 text-sm">
                                Semua jumlah untuk PO ini telah dipindai.
                                Silakan buka halaman Ubah SPK untuk mengubah
                                status menjadi <b>Selesai</b> atau{' '}
                                <b>Ditutup</b>.
                            </p>
                        </div>
                    )}

                    {/* NOTIFIKASI OVER SIZE */}
                    {hasOverSize && (
                        <div className="rounded border-l-4 border-red-500 bg-red-100 p-4 text-red-700 shadow-md">
                            <p className="font-bold">
                                ⚠️ Perhatian: Ada ukuran yang melebihi target!
                            </p>
                            <p className="mt-1 text-sm">
                                Jumlah hasil pemindaian pada ukuran tertentu
                                melebihi jumlah SPK. Silakan periksa tabel{' '}
                                <b>Jumlah per Ukuran</b> di bawah.
                            </p>
                        </div>
                    )}

                    {/* Baris 1: PO Selector */}
                    <div className="rounded-lg border bg-white p-4 shadow-sm">
                        <p className="mb-2 text-xs font-bold tracking-wider text-gray-500 uppercase">
                            Pilih PO (Klik untuk mengganti PO)
                        </p>
                        <div className="flex gap-2 overflow-x-auto pb-2">
                            {activeSpks.map((spk: any) => (
                                <button
                                    key={spk.id}
                                    onClick={() => handleSelectSpk(spk.id)}
                                    className={`rounded px-4 py-2 font-medium whitespace-nowrap text-white transition ${
                                        selectedSpkId === spk.id
                                            ? 'bg-blue-600 shadow-md'
                                            : 'bg-gray-400 hover:bg-gray-500'
                                    }`}
                                >
                                    <span className="block text-sm">
                                        {spk.po_number}
                                    </span>
                                    <span className="text-xs font-normal opacity-90">
                                        {spk.brand.name}
                                    </span>
                                </button>
                            ))}
                            {activeSpks.length === 0 && (
                                <p className="py-2 text-sm text-gray-500">
                                    Tidak ada SPK berstatus Aktif saat ini.
                                </p>
                            )}
                        </div>
                    </div>

                    <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
                        {/* Kolom Kiri: Detail PO */}
                        <div className="rounded-lg border bg-white p-6 shadow-sm">
                            <h2 className="mb-4 border-b pb-2 text-sm font-bold tracking-wider text-gray-500 uppercase">
                                Detail PO
                            </h2>
                            {selectedSpk ? (
                                <div className="flex gap-4">
                                    <div className="flex h-32 w-24 items-center justify-center rounded border bg-gray-100 text-xs text-gray-400">
                                        Tidak ada gambar
                                    </div>
                                    <div className="space-y-3">
                                        <div>
                                            <span className="block text-xs text-gray-400 uppercase">
                                                PO
                                            </span>
                                            <span className="text-lg font-bold">
                                                {selectedSpk.po_number}
                                            </span>
                                        </div>
                                        <div>
                                            <span className="block text-xs text-gray-400 uppercase">
                                                MODEL
                                            </span>
                                            <span className="font-bold">
                                                {selectedSpk.art_color}
                                            </span>
                                        </div>
                                        <div>
                                            <span className="block text-xs text-gray-400 uppercase">
                                                MEREK
                                            </span>
                                            <span className="font-bold">
                                                {selectedSpk.brand.name}
                                            </span>
                                        </div>
                                        <div>
                                            <span className="block text-xs text-gray-400 uppercase">
                                                JUMLAH TOTAL
                                            </span>
                                            <span className="text-lg font-bold">
                                                {totalTarget} Pcs
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            ) : (
                                <p className="py-10 text-center text-gray-400">
                                    Pilih PO terlebih dahulu.
                                </p>
                            )}
                        </div>

                        {/* Kolom Kanan: Scan Barcode */}
                        <div className="flex flex-col justify-between rounded-lg border bg-white p-6 shadow-sm">
                            <h2 className="mb-4 border-b pb-2 text-sm font-bold tracking-wider text-gray-500 uppercase">
                                Pindai Kode Batang
                            </h2>

                            <form
                                onSubmit={handleScan}
                                className="flex flex-1 flex-col justify-center"
                            >
                                <label
                                    htmlFor="barcode"
                                    className="mb-2 text-sm font-medium text-gray-700"
                                >
                                    Kode batang
                                </label>
                                <input
                                    id="barcode"
                                    ref={inputRef}
                                    type="text"
                                    value={barcodeInput}
                                    onChange={(e) =>
                                        setBarcodeInput(e.target.value)
                                    }
                                    placeholder="Pindai di sini..."
                                    className="w-full rounded-lg border-2 border-blue-400 p-4 text-center font-mono text-2xl tracking-widest transition focus:border-blue-600 focus:ring-4 focus:ring-blue-100 focus:outline-none"
                                    autoComplete="off"
                                    required
                                    disabled={!selectedSpkId}
                                />
                                {!selectedSpkId && (
                                    <p className="mt-2 text-center text-sm text-red-500">
                                        Pilih PO terlebih dahulu sebelum
                                        memindai.
                                    </p>
                                )}
                            </form>

                            <div className="mt-4 flex items-center justify-between border-t pt-4">
                                <button
                                    type="button"
                                    className="rounded border bg-white px-4 py-2 text-sm text-gray-600 shadow-sm transition hover:bg-gray-50"
                                >
                                    ↺ Batalkan pemindaian terakhir
                                </button>
                            </div>
                        </div>
                    </div>

                    {/* Baris 3: Counter Per Size & Total */}
                    <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
                        <div className="rounded-lg border bg-white p-6 shadow-sm">
                            <h2 className="mb-4 border-b pb-2 text-sm font-bold tracking-wider text-gray-500 uppercase">
                                Jumlah per Ukuran ({departmentLabel})
                            </h2>
                            <table className="w-full text-sm">
                                <thead>
                                    <tr className="text-left text-gray-400">
                                        <th className="pb-2">UKURAN</th>
                                        <th className="pb-2 text-center">
                                            PESANAN
                                        </th>
                                        <th className="pb-2 text-right">
                                            DIPINDAI
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {selectedSpk?.details.map((detail: any) => {
                                        const scanned = detail.scans_count || 0;
                                        const isOver = scanned > detail.qty;

                                        return (
                                            <tr
                                                key={detail.id}
                                                className={`border-b transition-colors ${isOver ? 'bg-red-50' : ''}`}
                                            >
                                                <td className="py-2 font-bold">
                                                    <span className="rounded bg-gray-100 px-2 py-1">
                                                        {detail.size_name}
                                                    </span>
                                                </td>
                                                <td className="text-center">
                                                    {detail.qty}
                                                </td>
                                                <td
                                                    className={`text-right font-bold ${isOver ? 'text-red-600' : 'text-blue-600'}`}
                                                >
                                                    {scanned} / {detail.qty}
                                                    {isOver && (
                                                        <span className="ml-2 animate-pulse rounded bg-red-600 px-1.5 py-0.5 text-[10px] font-bold text-white uppercase">
                                                            Melebihi
                                                        </span>
                                                    )}
                                                </td>
                                            </tr>
                                        );
                                    })}
                                    {!selectedSpk && (
                                        <tr>
                                            <td
                                                colSpan={3}
                                                className="py-4 text-center text-gray-400"
                                            >
                                                Pilih PO terlebih dahulu
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>

                        <div className="flex flex-col items-center justify-center rounded-lg border bg-white p-6 shadow-sm">
                            <h2 className="mb-6 w-full border-b pb-2 text-center text-sm font-bold tracking-wider text-gray-500 uppercase">
                                Total Pemindaian Harian
                            </h2>
                            <div className="text-center">
                                <div className="mx-auto mb-3 flex h-24 w-24 items-center justify-center rounded-full border-4 border-blue-100 bg-blue-50 text-4xl font-bold text-blue-600 shadow-inner">
                                    {totalScanned}
                                </div>
                                <p className="font-medium text-gray-500">
                                    PO INI (HARI INI)
                                </p>
                            </div>
                        </div>
                    </div>

                    {/* Baris 4: Progress Bar */}
                    <div className="rounded-lg border bg-white p-4 shadow-sm">
                        <div className="mb-2 flex justify-between text-xs font-bold tracking-wider text-gray-500 uppercase">
                            <span>Progres PO ({departmentLabel})</span>
                            <span
                                className={
                                    totalScanned > totalTarget
                                        ? 'text-red-600'
                                        : 'text-gray-700'
                                }
                            >
                                {totalScanned} / {totalTarget} (
                                {Math.round((totalScanned / totalTarget) * 100)}
                                %)
                            </span>
                        </div>
                        <div className="h-3 w-full rounded-full bg-gray-200">
                            <div
                                className={`h-3 rounded-full transition-all duration-500 ${totalScanned > totalTarget ? 'bg-red-500' : 'bg-green-500'}`}
                                style={{ width: `${progressPercentage}%` }}
                            ></div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
