import { Head, Link, useForm, router } from '@inertiajs/react';

export default function Index({ spk }: any) {
    const details = spk?.details || [];
    const hasBatches = spk?.batches && spk.batches.length > 0;

    // Siapkan state untuk form split
    const { data, setData, post, processing, errors } = useForm({
        batches: [
            { batch_code: 'B1', sizes: details.map((d: any) => ({ size_name: d.size_name, qty: 0 })) }
        ]
    });

    const handleAddBatch = () => {
        const newBatch = {
            batch_code: `B${data.batches.length + 1}`,
            sizes: details.map((d: any) => ({ size_name: d.size_name, qty: 0 }))
        };
        setData('batches', [...data.batches, newBatch]);
    };

    const handleRemoveBatch = (index: number) => {
        const newBatches = [...data.batches];
        newBatches.splice(index, 1);
        setData('batches', newBatches);
    };

    const updateSizeQty = (batchIndex: number, sizeIndex: number, val: number) => {
        const newBatches = [...data.batches];
        newBatches[batchIndex].sizes[sizeIndex].qty = val;
        setData('batches', newBatches);
    };

    // Validasi apakah total size di semua batch sudah sama dengan SPK
    const isSizeValid = details.every((size: any) => {
        const totalInBatches = data.batches.reduce((sum, batch) => {
            const sizeInBatch = batch.sizes.find((s: any) => s.size_name === size.size_name);
            return sum + (sizeInBatch ? sizeInBatch.qty : 0);
        }, 0);
        return totalInBatches === size.qty;
    });

    const submitSplit = (e: React.FormEvent) => {
        e.preventDefault();
        post(`/produksi/spks/${spk.id}/batches/split`);
    };

    return (
        <>
            <Head title={`Batch Produksi - ${spk.po_number}`} />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">

                <div className="bg-white p-6 rounded-lg shadow-sm border flex justify-between items-center">
                    <div>
                        <h1 className="text-xl font-bold">Batch Produksi: {spk.po_number}</h1>
                        <p className="text-gray-500 text-sm mt-1">Brand: {spk.brand?.name}</p>
                    </div>
                    <div className="space-x-4">
                        <Link href="/produksi/spk-schedules" className="text-green-600 hover:underline font-medium">Lihat Schedule (PPS)</Link>
                        <Link href="/produksi/spks" className="text-blue-600 hover:underline">&larr; Kembali</Link>
                    </div>
                </div>

                {!hasBatches ? (
                    <div className="bg-white p-6 rounded-lg shadow-sm border">
                        <h2 className="font-semibold text-lg mb-4">Pecah SPK Berdasarkan Size</h2>
                        <form onSubmit={submitSplit} className="space-y-6">

                            <div className="overflow-x-auto">
                                <table className="w-full text-sm text-left border">
                                    <thead className="bg-gray-200">
                                        <tr>
                                            <th className="p-2 border">Size</th>
                                            <th className="p-2 border text-center">Qty SPK</th>
                                            {data.batches.map((b: any, bIdx: number) => (
                                                <th key={bIdx} className="p-2 border text-center bg-blue-50">
                                                    <div className="flex flex-col items-center">
                                                        <input
                                                            type="text"
                                                            value={b.batch_code}
                                                            onChange={e => {
                                                                const newBatches = [...data.batches];
                                                                newBatches[bIdx].batch_code = e.target.value;
                                                                setData('batches', newBatches);
                                                            }}
                                                            className="border p-1 rounded w-20 text-center font-bold mb-1"
                                                        />
                                                        {/* PERBAIKAN TYPE SCRIPT DI SINI */}
                                                        <span className="text-xs text-gray-500">
                                                            Qty: {b.sizes.reduce((s: number, x: any) => s + x.qty, 0)}
                                                        </span>
                                                        {data.batches.length > 1 && (
                                                            <button type="button" onClick={() => handleRemoveBatch(bIdx)} className="text-red-500 text-xs mt-1">Hapus</button>
                                                        )}
                                                    </div>
                                                </th>
                                            ))}
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {details.map((detail: any, sIdx: number) => (
                                            <tr key={detail.id} className="border-b hover:bg-gray-50">
                                                <td className="p-2 border font-bold">{detail.size_name}</td>
                                                <td className="p-2 border text-center">{detail.qty}</td>
                                                {data.batches.map((batch: any, bIdx: number) => {
                                                    const sizeInBatch = batch.sizes.find((s: any) => s.size_name === detail.size_name);
                                                    const qty = sizeInBatch ? sizeInBatch.qty : 0;
                                                    return (
                                                        <td key={bIdx} className="p-2 border text-center">
                                                            <input
                                                                type="number"
                                                                min="0"
                                                                value={qty}
                                                                onChange={e => updateSizeQty(bIdx, sIdx, Number(e.target.value))}
                                                                className="w-20 border p-1 rounded text-center"
                                                            />
                                                        </td>
                                                    );
                                                })}
                                            </tr>
                                        ))}
                                        {/* Baris Total */}
                                        <tr className="bg-gray-100 font-bold">
                                            <td className="p-2 border">TOTAL</td>
                                            <td className="p-2 border text-center">{details.reduce((s: number, d: any) => s + d.qty, 0)}</td>
                                            {data.batches.map((batch: any, bIdx: number) => (
                                                <td key={bIdx} className="p-2 border text-center">
                                                    {/* PERBAIKAN TYPE SCRIPT DI SINI JUGA */}
                                                    {batch.sizes.reduce((s: number, x: any) => s + x.qty, 0)}
                                                </td>
                                            ))}
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <button type="button" onClick={handleAddBatch} className="text-blue-600 text-sm font-medium">+ Tambah Batch</button>

                            {!isSizeValid && (
                                <div className="bg-red-100 text-red-700 p-3 rounded text-sm font-bold">
                                    Total Qty per Size belum sesuai dengan SPK utama. Pastikan setiap size teralokasi dengan benar.
                                </div>
                            )}

                            <div className="flex justify-end pt-4 border-t">
                                <button type="submit" disabled={processing || !isSizeValid} className="bg-blue-600 text-white px-6 py-2 rounded disabled:opacity-50">
                                    Pecah Menjadi Batch
                                </button>
                            </div>
                        </form>
                    </div>
                ) : (
                    <div className="space-y-4">
                        <div className="flex justify-between items-center">
                            <h2 className="font-semibold text-lg">Daftar Batch ({spk.batches.length})</h2>
                            <button onClick={() => { if (confirm('Gabungkan semua batch kembali?')) router.post(`/produksi/spks/${spk.id}/batches/merge`) }} className="bg-red-600 text-white px-4 py-2 rounded text-sm">Gabungkan (Merge)</button>
                        </div>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            {spk.batches.map((batch: any) => (
                                <div key={batch.id} className="bg-white p-4 rounded-lg shadow-sm border-l-4 border-blue-500">
                                    <div className="flex justify-between items-start mb-2">
                                        <div>
                                            <h3 className="font-bold text-lg">{spk.po_number}-{batch.batch_code}</h3>
                                            <p className="text-sm text-gray-500">{batch.qty} Pasang</p>
                                        </div>
                                        <span className={`px-2 py-1 rounded text-xs font-bold uppercase bg-gray-100 text-gray-700`}>{batch.status}</span>
                                    </div>

                                    <div className="flex flex-wrap gap-1 mb-4">
                                        {batch.sizes && batch.sizes.map((s: any, i: number) => (
                                            s.qty > 0 && <span key={i} className="bg-gray-100 text-[10px] px-2 py-1 rounded border">{s.size_name}: {s.qty}</span>
                                        ))}
                                    </div>

                                    <p className="text-sm font-medium mb-2">Posisi: <span className="uppercase text-blue-600">{batch.current_department || 'Belum Mulai'}</span></p>
                                    <form onSubmit={(e) => {
                                        e.preventDefault();
                                        const formData = new FormData(e.currentTarget);
                                        router.post(`/produksi/batches/${batch.id}/track`, {
                                            department: formData.get('department'),
                                            start_date: formData.get('start_date'),
                                        });
                                    }} className="flex gap-2 text-sm">
                                        <select name="department" className="border p-1 rounded" required defaultValue={batch.current_department || ''}>
                                            <option value="">Pilih Dept</option>
                                            <option value="cutting">Cutting</option>
                                            <option value="sewing">Sewing</option>
                                            <option value="lasting">Lasting</option>
                                            <option value="cementing">Cementing</option>
                                            <option value="injection">Injection</option>
                                            <option value="finishing">Finishing</option>
                                            <option value="packing">Packing</option>
                                        </select>
                                        <input type="date" name="start_date" className="border p-1 rounded" required defaultValue={new Date().toISOString().split('T')[0]} />
                                        <button type="submit" className="bg-gray-800 text-white px-3 py-1 rounded">Set</button>
                                    </form>
                                </div>
                            ))}
                        </div>
                    </div>
                )}
            </div>
        </>
    );
}