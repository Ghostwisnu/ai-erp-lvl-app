import { Head, router, Link, useForm } from '@inertiajs/react';
import { useState } from 'react';

export default function Index({ department, activeSpks, selectedSpk, defectCategories, todayDefects }: any) {
    const [selectedSpkId, setSelectedSpkId] = useState(selectedSpk?.id || '');

    // Form untuk tambah defect
    const { data, setData, post, processing, reset } = useForm({
        spk_id: selectedSpk?.id || '',
        defect_category_id: '',
        department: department,
        qty: 1,
    });

    const handleSelectSpk = (id: string) => {
        setSelectedSpkId(id);
        router.get('/produksi/defects', { spk_id: id, dept: department }, { preserveState: true });
    };

    const submitDefect = (e: React.FormEvent) => {
        e.preventDefault();
        post('/produksi/defects', {
            onSuccess: () => reset('defect_category_id', 'qty'),
        });
    };

    // Hitung total defect PO ini
    const totalDefectPO = todayDefects.filter((d: any) => d.spk_id === selectedSpkId).reduce((sum: number, d: any) => sum + d.qty, 0);
    const totalDefectAll = todayDefects.reduce((sum: number, d: any) => sum + d.qty, 0);

    return (
        <>
            <Head title="Daily Defect QC" />
            <div className="min-h-screen bg-gray-100 py-6 px-4">
                <div className="max-w-7xl mx-auto">

                    {/* Header */}
                    <div className="bg-white rounded-lg shadow-sm p-4 mb-6 flex justify-between items-center border">
                        <div className="flex items-center gap-4">
                            <h1 className="text-xl font-bold text-gray-800">Daily Defect QC — QCB-{new Date().toISOString().slice(0, 10).replace(/-/g, '')}</h1>
                            <span className="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold flex items-center gap-1">
                                <span className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span> LIVE
                            </span>
                        </div>
                        <div className="flex gap-2">
                            <Link href="/produksi/scan" className="border px-3 py-1 rounded text-sm text-blue-600 hover:bg-blue-50">Ganti Line</Link>
                            <Link href="/produksi/defects" className="border px-3 py-1 rounded text-sm text-gray-600 hover:bg-gray-50">&larr; Kembali</Link>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        {/* Kiri: Detail PO & Data Defect */}
                        <div className="lg:col-span-2 space-y-6">
                            {/* Detail PO */}
                            <div className="bg-white rounded-lg shadow-sm border p-6">
                                <h2 className="text-xs font-bold text-gray-500 uppercase mb-4 border-b pb-2">Detail PO</h2>
                                {selectedSpk ? (
                                    <div className="flex gap-6">
                                        <div className="w-32 h-40 bg-gray-100 rounded border flex items-center justify-center text-gray-400">
                                            <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                                        </div>
                                        <div className="space-y-3">
                                            <div><span className="text-xs text-gray-400 block uppercase">PO Number</span> <span className="font-bold text-lg">{selectedSpk.po_number}</span></div>
                                            <div><span className="text-xs text-gray-400 block uppercase">Art / Color</span> <span className="font-bold">{selectedSpk.art_color}</span></div>
                                            <div><span className="text-xs text-gray-400 block uppercase">Qty</span> <span className="font-bold text-lg">{selectedSpk.details_sum_qty} Pcs</span></div>
                                        </div>
                                    </div>
                                ) : (
                                    <p className="text-gray-400 text-center py-10">Pilih PO di kanan.</p>
                                )}
                            </div>

                            {/* Data Defect */}
                            <div className="bg-white rounded-lg shadow-sm border p-6">
                                <div className="flex justify-between items-center border-b pb-2 mb-4">
                                    <h2 className="text-xs font-bold text-gray-500 uppercase">Data Defect — {selectedSpk?.po_number || 'Pilih PO'}</h2>
                                    <span className="bg-red-100 text-red-600 px-2 py-1 rounded text-xs font-bold">{totalDefectPO} Defect</span>
                                </div>

                                <table className="w-full text-sm text-left">
                                    <thead>
                                        <tr className="text-gray-400 border-b">
                                            <th className="pb-2">KATEGORI DEFECT</th>
                                            <th className="pb-2 text-center">QTY</th>
                                            <th className="pb-2 text-right">AKSI</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {defectCategories.length > 0 ? defectCategories.map((cat: any) => {
                                            // Hitung defect untuk kategori ini di SPK ini
                                            const qtyDefect = todayDefects
                                                .filter((d: any) => d.spk_id === selectedSpkId && d.defect_category_id === cat.id)
                                                .reduce((sum: number, d: any) => sum + d.qty, 0);

                                            return (
                                                <tr key={cat.id} className="border-b hover:bg-gray-50">
                                                    <td className="py-3">
                                                        <span className="font-medium">{cat.name}</span>
                                                        <span className="block text-xs text-gray-400">{cat.description}</span>
                                                    </td>
                                                    <td className="text-center font-bold text-red-600">{qtyDefect}</td>
                                                    <td className="text-right">
                                                        <button
                                                            onClick={() => {
                                                                setData({ ...data, spk_id: selectedSpkId, defect_category_id: cat.id });
                                                                setTimeout(() => document.getElementById('btn-submit-defect')?.click(), 100);
                                                            }}
                                                            className="bg-red-50 text-red-600 px-3 py-1 rounded text-xs font-bold hover:bg-red-100 disabled:opacity-50"
                                                            disabled={!selectedSpkId}
                                                        >
                                                            + Add
                                                        </button>
                                                    </td>
                                                </tr>
                                            );
                                        }) : (
                                            <tr><td colSpan={3} className="text-center py-8 text-gray-400">Belum ada master defect.</td></tr>
                                        )}
                                    </tbody>
                                </table>

                                {/* Hidden Form untuk Submit */}
                                <form onSubmit={submitDefect} className="hidden">
                                    <input type="number" value={data.qty} onChange={e => setData('qty', Number(e.target.value))} min="1" />
                                    <button type="submit" id="btn-submit-defect">Submit</button>
                                </form>
                            </div>
                        </div>

                        {/* Kanan: PO Selector */}
                        <div className="lg:col-span-1">
                            <div className="bg-white rounded-lg shadow-sm border">
                                <div className="bg-blue-600 text-white p-3 rounded-t-lg">
                                    <h3 className="font-bold text-sm">PO SELECTOR</h3>
                                    <p className="text-blue-100 text-xs">SPK yang berjalan</p>
                                </div>
                                <div className="p-3 space-y-3 max-h-[600px] overflow-y-auto">
                                    {activeSpks.map((spk: any) => (
                                        <button
                                            key={spk.id}
                                            onClick={() => handleSelectSpk(spk.id)}
                                            className={`w-full text-left p-3 rounded border transition ${selectedSpkId === spk.id ? 'border-blue-500 bg-blue-50 ring-1 ring-blue-500' : 'hover:bg-gray-50'}`}
                                        >
                                            <div className="flex justify-between items-start">
                                                <div>
                                                    <h4 className="font-bold text-sm">{spk.po_number}</h4>
                                                    <p className="text-xs text-gray-500">{spk.brand.name} • {spk.art_color}</p>
                                                    <p className="text-xs font-medium mt-1">Qty: {spk.details_sum_qty}</p>
                                                </div>
                                                {selectedSpkId === spk.id && (
                                                    <span className="bg-red-100 text-red-600 text-xs font-bold px-2 py-0.5 rounded-full">{totalDefectPO}</span>
                                                )}
                                            </div>
                                        </button>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Footer Total */}
                    <div className="mt-6 bg-white border-t-4 border-red-500 p-4 rounded-lg shadow-sm text-center">
                        <h3 className="text-lg font-bold text-red-600">TOTAL DEFECT (PO INI) : {totalDefectPO}</h3>
                        <p className="text-sm text-gray-500 mt-1">Total semua PO di daily ini: <span className="font-bold">{totalDefectAll}</span></p>
                    </div>
                </div>
            </div>
        </>
    );
}