import React, { useState } from 'react';
import { Head, Link, router } from '@inertiajs/react';

export default function Schedule({ spks, finishingScans }: any) {
    const departments = [
        { key: 'cutting', label: 'CUTTING' },
        { key: 'sewing', label: 'SEWING' },
        { key: 'lasting', label: 'LASTING' },
        { key: 'cementing', label: 'CEMENTING' },
        { key: 'injection', label: 'INJECTION' },
        { key: 'finishing', label: 'FINISHING' },
        { key: 'packing', label: 'PACKING' },
    ];

    // --- STATE UNTUK BULK INPUT ---
    const [isBulkModalOpen, setIsBulkModalOpen] = useState(false);
    const [bulkDept, setBulkDept] = useState('cutting');
    const [bulkDate, setBulkDate] = useState(new Date().toISOString().split('T')[0]);
    const [bulkQty, setBulkQty] = useState<{ [key: string]: number }>({});
    const [isSubmitting, setIsSubmitting] = useState(false);

    // --- STATE UNTUK EXPAND ROW (HISTORI) ---
    const [expandedRow, setExpandedRow] = useState<string | null>(null);

    const toggleRow = (rowId: string) => {
        setExpandedRow(prev => prev === rowId ? null : rowId);
    };

    // --- RATAKAN DATA SPK & BATCH ---
    const allRows: any[] = [];
    spks.forEach((spk: any) => {
        if (spk.batches && spk.batches.length > 0) {
            spk.batches.forEach((batch: any) => {
                allRows.push({
                    id: `batch-${batch.id}`,
                    type: 'batch',
                    spk,
                    batch,
                    po_display: `${spk.po_number}-${batch.batch_code}`,
                    qty: batch.qty,
                    sizes: batch.sizes, // <-- Simpan sizes di row
                    tracks: batch.tracks,
                    dailies: batch.dailies
                });
            });
        } else {
            const totalQty = spk.details.reduce((sum: number, d: any) => sum + d.qty, 0);
            allRows.push({
                id: `spk-${spk.id}`,
                type: 'spk',
                spk,
                batch: null,
                po_display: spk.po_number,
                qty: totalQty,
                sizes: spk.details, // <-- Simpan sizes di row
                tracks: [],
                dailies: spk.dailies
            });
        }
    });

    // --- LOGIKA BULK INPUT ---
    const handleOpenBulk = (dept: string) => {
        setBulkDept(dept);
        setBulkQty({});
        setIsBulkModalOpen(true);
    };

    const handleQtyChange = (rowId: string, val: string) => {
        setBulkQty(prev => ({ ...prev, [rowId]: Number(val) }));
    };

    const submitBulk = (e: React.FormEvent) => {
        e.preventDefault();
        setIsSubmitting(true);

        const items = allRows
            .filter(row => bulkQty[row.id] > 0)
            .map(row => ({
                spk_id: row.spk.id,
                spk_batch_id: row.batch ? row.batch.id : null,
                qty: bulkQty[row.id] || 0,
            }));

        if (items.length === 0) {
            alert('Isi minimal 1 Qty output.');
            setIsSubmitting(false);
            return;
        }

        router.post('/produksi/daily-output', {
            report_date: bulkDate,
            department: bulkDept,
            items: items,
        }, {
            onSuccess: () => {
                setIsBulkModalOpen(false);
                setIsSubmitting(false);
            },
            onError: () => setIsSubmitting(false)
        });
    };

    const handleDeleteDaily = (dailyId: number) => {
        if (confirm('Hapus data histori ini?')) {
            router.delete(`/produksi/daily-output/${dailyId}`);
        }
    };

    // --- HELPER UNTUK HITUNG SCAN FINISHING PER BATCH ---
    const calculateFinishingScan = (row: any) => {
        let total = 0;
        if (row.sizes && row.sizes.length > 0) {
            row.sizes.forEach((size: any) => {
                // PERBAIKAN: Hanya hitung jika Qty di batch ini > 0
                if (size.qty > 0) {
                    const spkScans = finishingScans[row.spk.id];
                    if (spkScans && spkScans[size.size_name]) {
                        total += Number(spkScans[size.size_name].total_scan);
                    }
                }
            });
        }
        return total;
    };

    return (
        <>
            <Head title="Production Progress Schedule" />
            <div className="py-8 max-w-full mx-auto px-4">

                {/* Header */}
                <div className="flex justify-between items-center mb-6">
                    <h1 className="text-2xl font-bold uppercase">Production Progress Schedule</h1>
                    <div className="space-x-2">
                        <button onClick={() => handleOpenBulk('cutting')} className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded shadow text-sm font-bold">
                            + Input Daily Massal
                        </button>
                        <Link href="/produksi/spks" className="text-blue-600 hover:underline text-sm font-medium">&larr; Kembali ke SPK</Link>
                    </div>
                </div>

                {/* Tabel PPS */}
                <div className="bg-white shadow-sm border overflow-x-auto">
                    <table className="w-full text-[10px] text-center border-collapse">
                        <thead>
                            <tr className="bg-gray-200 border-b">
                                <th rowSpan={2} className="border border-black p-1 w-12">NO</th>
                                <th rowSpan={2} className="border border-black p-1">PO NO.</th>
                                <th rowSpan={2} className="border border-black p-1">ART</th>
                                <th rowSpan={2} className="border border-black p-1">COLOR</th>
                                <th rowSpan={2} className="border border-black p-1">QTY</th>
                                {departments.map(d => (
                                    <th key={d.key} colSpan={4} className="border border-black p-1">{d.label}</th>
                                ))}
                                <th rowSpan={2} className="border border-black p-1 bg-yellow-100">XFD</th>
                            </tr>
                            <tr className="bg-gray-100 border-b">
                                {departments.map(d => (
                                    <React.Fragment key={d.key}>
                                        <th className="border border-black p-1 bg-gray-50">TGL</th>
                                        <th className="border border-black p-1 bg-gray-50">DAILY</th>
                                        <th className="border border-black p-1 bg-gray-50">TOTAL</th>
                                        <th className="border border-black p-1 bg-red-50 text-red-700">BAL</th>
                                    </React.Fragment>
                                ))}
                            </tr>
                        </thead>
                        <tbody>
                            {allRows.map((row: any, index: number) => {
                                const isExpanded = expandedRow === row.id;
                                return (
                                    <React.Fragment key={row.id}>
                                        <tr className={`border-b hover:bg-gray-50 ${isExpanded ? 'bg-blue-50' : ''}`}>
                                            <td className="border border-black p-1">
                                                <div className="flex flex-col items-center">
                                                    <span>{index + 1}</span>
                                                    <button onClick={() => toggleRow(row.id)} className="text-blue-600 font-bold text-xs mt-1 hover:scale-125 transition">
                                                        {isExpanded ? '[ - ]' : '[ + ]'}
                                                    </button>
                                                </div>
                                            </td>
                                            <td className="border border-black p-1 font-bold">
                                                {row.po_display}
                                                {row.type === 'spk' && <span className="block text-[8px] text-gray-400">(SPK)</span>}
                                            </td>
                                            <td className="border border-black p-1">{row.spk.brand?.name}</td>
                                            <td className="border border-black p-1">{row.spk.art_color}</td>
                                            <td className="border border-black p-1 font-bold">{row.qty}</td>

                                            {departments.map(dept => {
                                                const track = row.tracks.find((t: any) => t.department === dept.key);

                                                let totalOutput = 0;
                                                let latestDaily = null;

                                                // LOGIKA BARU: JIKA FINISHING, HITUNG DARI SCAN BERDASARKAN SIZE DI BATCH
                                                if (dept.key === 'finishing') {
                                                    totalOutput = calculateFinishingScan(row);

                                                    // Untuk kolom "Daily" di finishing, kita kosongkan (-) karena data scan adalah akumulasi total.
                                                    latestDaily = totalOutput > 0 ? { qty: totalOutput, report_date: null } : null;
                                                } else {
                                                    // DEPARTEMEN LAIN: GUNAKAN INPUT MANUAL
                                                    totalOutput = row.dailies
                                                        .filter((d: any) => d.department === dept.key)
                                                        .reduce((sum: number, d: any) => sum + d.qty, 0);

                                                    latestDaily = row.dailies
                                                        .filter((d: any) => d.department === dept.key)
                                                        .sort((a: any, b: any) =>
                                                            new Date(b.report_date).getTime() - new Date(a.report_date).getTime()
                                                        )[0];
                                                }

                                                const balance = row.qty - totalOutput;

                                                let startDate = '-';
                                                if (track) {
                                                    startDate = new Date(track.start_date).toLocaleDateString('id-ID', { day: '2-digit', month: '2-digit' });
                                                } else if (row.type === 'spk' && dept.key === 'cutting' && row.spk.start_date) {
                                                    startDate = new Date(row.spk.start_date).toLocaleDateString('id-ID', { day: '2-digit', month: '2-digit' });
                                                }

                                                return (
                                                    <React.Fragment key={`${index}-${dept.key}`}>
                                                        <td className="border border-black p-1">{startDate}</td>
                                                        <td className="border border-black p-1">
                                                            {/* Untuk Finishing, kolom DAILY kita kosongkan (-) agar tidak duplikat dengan TOTAL */}
                                                            {dept.key === 'finishing' ? '-' : (latestDaily ? latestDaily.qty : '-')}
                                                        </td>
                                                        <td className="border border-black p-1 font-bold">{totalOutput > 0 ? totalOutput : '-'}</td>
                                                        <td className={`border border-black p-1 font-bold ${balance <= 0 ? 'text-green-600' : 'text-red-600'}`}>
                                                            {balance}
                                                        </td>
                                                    </React.Fragment>
                                                );
                                            })}

                                            <td className="border border-black p-1 font-bold text-red-600">
                                                {new Date(row.spk.xfd_date).toLocaleDateString('id-ID', { day: '2-digit', month: 'short' })}
                                            </td>
                                        </tr>

                                        {/* BARIS HISTORI */}
                                        {isExpanded && (
                                            <tr>
                                                <td colSpan={departments.length * 4 + 6} className="p-4 bg-gray-50 border-b">
                                                    <div className="max-w-3xl mx-auto">
                                                        <h4 className="font-bold text-sm mb-2 text-gray-700">Histori Input Harian: {row.po_display}</h4>
                                                        <table className="w-full text-xs text-left bg-white border rounded">
                                                            <thead className="bg-gray-200">
                                                                <tr>
                                                                    <th className="p-2 border-b">Tanggal Laporan</th>
                                                                    <th className="p-2 border-b">Departemen</th>
                                                                    <th className="p-2 border-b text-center">Qty Output</th>
                                                                    <th className="p-2 border-b text-center w-20">Aksi</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                {row.dailies.length === 0 ? (
                                                                    <tr><td colSpan={4} className="p-3 text-center text-gray-400">Belum ada input harian.</td></tr>
                                                                ) : (
                                                                    row.dailies
                                                                        .sort((a: any, b: any) => new Date(b.report_date).getTime() - new Date(a.report_date).getTime())
                                                                        .map((daily: any) => (
                                                                            <tr key={daily.id} className="border-b hover:bg-gray-50">
                                                                                <td className="p-2">{new Date(daily.report_date).toLocaleDateString('id-ID', { day: '2-digit', month: 'long', year: 'numeric' })}</td>
                                                                                <td className="p-2 uppercase font-medium">{daily.department}</td>
                                                                                <td className="p-2 text-center font-bold text-blue-600">{daily.qty}</td>
                                                                                <td className="p-2 text-center">
                                                                                    <button onClick={() => handleDeleteDaily(daily.id)} className="text-red-500 hover:underline">Hapus</button>
                                                                                </td>
                                                                            </tr>
                                                                        ))
                                                                )}
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        )}
                                    </React.Fragment>
                                );
                            })}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* MODAL BULK INPUT */}
            {isBulkModalOpen && (
                <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-lg shadow-xl w-full max-w-4xl max-h-[90vh] flex flex-col">
                        <div className="p-4 border-b flex justify-between items-center bg-gray-50 rounded-t-lg">
                            <h3 className="text-lg font-bold">Input Daily Output Massal</h3>
                            <button onClick={() => setIsBulkModalOpen(false)} className="text-gray-500 hover:text-red-500 font-bold text-xl">&times;</button>
                        </div>

                        <form onSubmit={submitBulk} className="p-4 flex flex-col overflow-hidden">
                            <div className="flex gap-4 mb-4 bg-blue-50 p-3 rounded border border-blue-100">
                                <div className="flex-1">
                                    <label className="block text-sm font-medium mb-1">Tanggal Laporan</label>
                                    <input type="date" value={bulkDate} onChange={e => setBulkDate(e.target.value)} className="w-full border p-2 rounded" required />
                                </div>
                                <div className="flex-1">
                                    <label className="block text-sm font-medium mb-1">Departemen</label>
                                    <select value={bulkDept} onChange={e => setBulkDept(e.target.value)} className="w-full border p-2 rounded">
                                        {/* Hanya tampilkan departemen yang BUKAN finishing, karena finishing pakai scan */}
                                        {departments.filter(d => d.key !== 'finishing').map(d => (
                                            <option key={d.key} value={d.key}>{d.label}</option>
                                        ))}
                                    </select>
                                </div>
                            </div>

                            <div className="overflow-y-auto flex-1 border rounded">
                                <table className="w-full text-sm text-left">
                                    <thead className="bg-gray-100 sticky top-0">
                                        <tr>
                                            <th className="p-2 border-b">PO / Batch</th>
                                            <th className="p-2 border-b text-center">Total Qty</th>
                                            <th className="p-2 border-b text-center">Sisa (Balance)</th>
                                            <th className="p-2 border-b text-center w-32">Qty Output</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {allRows.map((row: any) => {
                                            // Hitung Balance KHUSUS untuk departemen yang dipilih di modal
                                            let currentOutput = 0;

                                            if (bulkDept === 'finishing') {
                                                // Jaga-jaga jika finishing dipilih (meski sudah disembunyikan)
                                                currentOutput = calculateFinishingScan(row);
                                            } else {
                                                currentOutput = row.dailies
                                                    .filter((d: any) => d.department === bulkDept)
                                                    .reduce((sum: number, d: any) => sum + d.qty, 0);
                                            }

                                            const balance = row.qty - currentOutput;

                                            return (
                                                <tr key={row.id} className="border-b hover:bg-gray-50">
                                                    <td className="p-2 font-medium">{row.po_display}</td>
                                                    <td className="p-2 text-center">{row.qty}</td>
                                                    <td className={`p-2 text-center font-bold ${balance <= 0 ? 'text-green-600' : 'text-red-600'}`}>{balance}</td>
                                                    <td className="p-2">
                                                        <input
                                                            type="number"
                                                            min="0"
                                                            max={balance > 0 ? balance : 9999}
                                                            value={bulkQty[row.id] || ''}
                                                            onChange={e => handleQtyChange(row.id, e.target.value)}
                                                            placeholder="0"
                                                            className="w-full border p-1 rounded text-center"
                                                        />
                                                    </td>
                                                </tr>
                                            );
                                        })}
                                    </tbody>
                                </table>
                            </div>

                            <div className="pt-4 mt-4 border-t flex justify-end space-x-2">
                                <button type="button" onClick={() => setIsBulkModalOpen(false)} className="px-4 py-2 bg-gray-200 rounded font-medium">Batal</button>
                                <button type="submit" disabled={isSubmitting} className="px-6 py-2 bg-blue-600 text-white rounded font-medium disabled:opacity-50">
                                    {isSubmitting ? 'Menyimpan...' : 'Simpan Semua Output'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </>
    );
}