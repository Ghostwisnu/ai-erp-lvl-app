import { Head, router, Link } from '@inertiajs/react';
import { useState, useEffect, useRef } from 'react';

export default function ScanBoard({ department, activeSpks, selectedSpk }: any) {
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
        router.post('/produksi/scan/submit', {
            spk_id: selectedSpkId,
            department: department,
            barcode: barcodeInput,
            status: 'pass', // Asumsi default pass
        }, {
            preserveScroll: true,
            onSuccess: () => {
                setBarcodeInput(''); // Reset input setelah scan
            }
        });
    };

    const handleSelectSpk = (spkId: string) => {
        setSelectedSpkId(spkId);
        router.get(`/produksi/scan/${department}`, { spk_id: spkId }, { preserveState: true });
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
    const progressPercentage = totalTarget > 0 ? Math.min(Math.round((totalScanned / totalTarget) * 100), 100) : 0;
    const isFinished = totalScanned >= totalTarget && totalTarget > 0;

    return (
        <>
            <Head title={`Scan ${department}`} />
            <div className="min-h-screen bg-gray-50 p-6">
                <div className="max-w-7xl mx-auto space-y-6">

                    {/* Tombol Kembali */}
                    <Link href="/produksi/scan" className="text-blue-600 font-medium hover:underline">
                        &larr; Ganti Departemen
                    </Link>

                    {/* NOTIFIKASI PRODUKSI SELESAI */}
                    {isFinished && (
                        <div className="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 shadow-md rounded">
                            <p className="font-bold">Produksi Selesai!</p>
                            <p className="text-sm mt-1">Semua Qty untuk PO ini telah di-scan. Silakan pergi ke halaman Edit SPK untuk mengubah status menjadi <b>Finished</b> atau <b>Closed</b>.</p>
                        </div>
                    )}

                    {/* NOTIFIKASI OVER SIZE */}
                    {hasOverSize && (
                        <div className="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 shadow-md rounded">
                            <p className="font-bold">⚠️ Perhatian: Ada Size yang Melebihi Target!</p>
                            <p className="text-sm mt-1">Terdapat size dengan jumlah scan lebih banyak daripada Qty SPK. Silakan periksa tabel <b>Counter Per Size</b> di bawah.</p>
                        </div>
                    )}

                    {/* Baris 1: PO Selector */}
                    <div className="bg-white p-4 rounded-lg shadow-sm border">
                        <p className="text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">PO Selector (Klik untuk ganti PO)</p>
                        <div className="flex gap-2 overflow-x-auto pb-2">
                            {activeSpks.map((spk: any) => (
                                <button
                                    key={spk.id}
                                    onClick={() => handleSelectSpk(spk.id)}
                                    className={`px-4 py-2 rounded text-white font-medium whitespace-nowrap transition ${selectedSpkId === spk.id
                                            ? 'bg-blue-600 shadow-md'
                                            : 'bg-gray-400 hover:bg-gray-500'
                                        }`}
                                >
                                    <span className="block text-sm">{spk.po_number}</span>
                                    <span className="text-xs font-normal opacity-90">{spk.brand.name}</span>
                                </button>
                            ))}
                            {activeSpks.length === 0 && (
                                <p className="text-gray-500 text-sm py-2">Tidak ada SPK berstatus Active saat ini.</p>
                            )}
                        </div>
                    </div>

                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        {/* Kolom Kiri: Detail PO */}
                        <div className="bg-white p-6 rounded-lg shadow-sm border">
                            <h2 className="text-sm font-bold text-gray-500 mb-4 border-b pb-2 uppercase tracking-wider">Detail PO</h2>
                            {selectedSpk ? (
                                <div className="flex gap-4">
                                    <div className="w-24 h-32 bg-gray-100 rounded flex items-center justify-center text-xs text-gray-400 border">
                                        No Image
                                    </div>
                                    <div className="space-y-3">
                                        <div>
                                            <span className="text-xs text-gray-400 block uppercase">PO</span>
                                            <span className="font-bold text-lg">{selectedSpk.po_number}</span>
                                        </div>
                                        <div>
                                            <span className="text-xs text-gray-400 block uppercase">ART</span>
                                            <span className="font-bold">{selectedSpk.art_color}</span>
                                        </div>
                                        <div>
                                            <span className="text-xs text-gray-400 block uppercase">BRAND</span>
                                            <span className="font-bold">{selectedSpk.brand.name}</span>
                                        </div>
                                        <div>
                                            <span className="text-xs text-gray-400 block uppercase">TOTAL QTY</span>
                                            <span className="font-bold text-lg">{totalTarget} Pcs</span>
                                        </div>
                                    </div>
                                </div>
                            ) : (
                                <p className="text-gray-400 text-center py-10">Pilih PO terlebih dahulu.</p>
                            )}
                        </div>

                        {/* Kolom Kanan: Scan Barcode */}
                        <div className="bg-white p-6 rounded-lg shadow-sm border flex flex-col justify-between">
                            <h2 className="text-sm font-bold text-gray-500 mb-4 border-b pb-2 uppercase tracking-wider">Scan Barcode</h2>

                            <form onSubmit={handleScan} className="flex-1 flex flex-col justify-center">
                                <input
                                    ref={inputRef}
                                    type="text"
                                    value={barcodeInput}
                                    onChange={(e) => setBarcodeInput(e.target.value)}
                                    placeholder="Scan di sini..."
                                    className="w-full text-center text-2xl font-mono tracking-widest border-2 border-blue-400 p-4 rounded-lg focus:outline-none focus:border-blue-600 focus:ring-4 focus:ring-blue-100 transition"
                                    autoComplete="off"
                                    disabled={!selectedSpkId}
                                />
                                {!selectedSpkId && (
                                    <p className="text-center text-red-500 text-sm mt-2">Pilih PO terlebih dahulu sebelum scan.</p>
                                )}
                            </form>

                            <div className="flex justify-between items-center mt-4 border-t pt-4">
                                <button type="button" className="bg-white border px-4 py-2 rounded text-sm shadow-sm text-gray-600 hover:bg-gray-50 transition">
                                    ↺ Undo Last
                                </button>
                            </div>
                        </div>
                    </div>

                    {/* Baris 3: Counter Per Size & Total */}
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        <div className="bg-white p-6 rounded-lg shadow-sm border">
                            <h2 className="text-sm font-bold text-gray-500 mb-4 border-b pb-2 uppercase tracking-wider">
                                Counter Per Size ({department})
                            </h2>
                            <table className="w-full text-sm">
                                <thead>
                                    <tr className="text-left text-gray-400">
                                        <th className="pb-2">SIZE</th>
                                        <th className="text-center pb-2">ORDER</th>
                                        <th className="text-right pb-2">SCANNED</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {selectedSpk?.details.map((detail: any) => {
                                        const scanned = detail.scans_count || 0;
                                        const isOver = scanned > detail.qty;

                                        return (
                                            <tr key={detail.id} className={`border-b transition-colors ${isOver ? 'bg-red-50' : ''}`}>
                                                <td className="py-2 font-bold">
                                                    <span className="bg-gray-100 px-2 py-1 rounded">{detail.size_name}</span>
                                                </td>
                                                <td className="text-center">{detail.qty}</td>
                                                <td className={`text-right font-bold ${isOver ? 'text-red-600' : 'text-blue-600'}`}>
                                                    {scanned} / {detail.qty}
                                                    {isOver && (
                                                        <span className="ml-2 text-[10px] bg-red-600 text-white px-1.5 py-0.5 rounded uppercase font-bold animate-pulse">
                                                            Over
                                                        </span>
                                                    )}
                                                </td>
                                            </tr>
                                        );
                                    })}
                                    {!selectedSpk && (
                                        <tr><td colSpan={3} className="text-center py-4 text-gray-400">Pilih PO terlebih dahulu</td></tr>
                                    )}
                                </tbody>
                            </table>
                        </div>

                        <div className="bg-white p-6 rounded-lg shadow-sm border flex flex-col justify-center items-center">
                            <h2 className="text-sm font-bold text-gray-500 mb-6 border-b pb-2 uppercase tracking-wider w-full text-center">Total Scan Daily</h2>
                            <div className="text-center">
                                <div className="w-24 h-24 bg-blue-50 text-blue-600 rounded-full flex items-center justify-center text-4xl font-bold mx-auto mb-3 border-4 border-blue-100 shadow-inner">
                                    {totalScanned}
                                </div>
                                <p className="text-gray-500 font-medium">PO INI (HARI INI)</p>
                            </div>
                        </div>
                    </div>

                    {/* Baris 4: Progress Bar */}
                    <div className="bg-white p-4 rounded-lg shadow-sm border">
                        <div className="flex justify-between text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">
                            <span>Progress PO ({department})</span>
                            <span className={totalScanned > totalTarget ? 'text-red-600' : 'text-gray-700'}>
                                {totalScanned} / {totalTarget} ({Math.round((totalScanned / totalTarget) * 100)}%)
                            </span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-3">
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