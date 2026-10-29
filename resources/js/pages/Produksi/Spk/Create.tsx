import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent, useMemo } from 'react';

export default function Create({ brands }: any) {
    const { data, setData, post, processing, errors } = useForm({
        po_number: '',
        xfd_date: '',
        start_date: '', // <-- Tambahan Tanggal Mulai
        brand_id: '',
        art_color: '',
        image: null as File | null,
        details: [] as { size_name: string, qty: number | string, barcode: string }[],
    });

    const totalQty = useMemo(() => {
        return data.details.reduce((sum: number, item: any) => sum + (Number(item.qty) || 0), 0);
    }, [data.details]);

    const handleBrandChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const brandId = e.target.value;
        setData('brand_id', brandId);

        const brand = brands.find((b: any) => b.id === parseInt(brandId));
        if (brand && brand.size_runs) {
            const newDetails = brand.size_runs.map((size: any) => ({
                size_name: size.size_name,
                qty: '',
                barcode: ''
            }));
            setData('details', newDetails);
        } else {
            setData('details', []);
        }
    };

    const updateQty = (index: number, val: string) => {
        const newDetails = [...data.details];
        newDetails[index].qty = val;
        setData('details', newDetails);
    };

    const updateBarcode = (index: number, val: string) => {
        const newDetails = [...data.details];
        newDetails[index].barcode = val;
        setData('details', newDetails);
    };

    const submit = (e: FormEvent) => {
        e.preventDefault();
        const cleanedDetails = data.details.map(detail => ({
            ...detail,
            qty: detail.qty === '' ? 0 : Number(detail.qty)
        }));

        setData('details', cleanedDetails);

        post('/produksi/spks', {
            forceFormData: true,
        });
    };

    return (
        <>
            <Head title="Buat SPK" />
            <div className="py-8 max-w-4xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h2 className="font-semibold text-xl mb-6">Buat Surat Perintah Kerja (SPK)</h2>

                    {Object.keys(errors).length > 0 && (
                        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                            <strong className="font-bold">Gagal Menyimpan:</strong>
                            <ul className="list-disc ml-5 mt-1">
                                {Object.values(errors).map((err: any, i) => (
                                    <li key={i}>{err}</li>
                                ))}
                            </ul>
                        </div>
                    )}

                    <form onSubmit={submit} className="space-y-6">
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium mb-1">PO Number <span className="text-red-500">*</span></label>
                                <input type="text" value={data.po_number} onChange={e => setData('po_number', e.target.value)} className={`w-full border p-2 rounded ${errors.po_number ? 'border-red-500' : ''}`} />
                                {errors.po_number && <p className="text-red-500 text-sm mt-1">{errors.po_number}</p>}
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">XFD (Deadline) <span className="text-red-500">*</span></label>
                                <input type="date" value={data.xfd_date} onChange={e => setData('xfd_date', e.target.value)} className={`w-full border p-2 rounded ${errors.xfd_date ? 'border-red-500' : ''}`} />
                                {errors.xfd_date && <p className="text-red-500 text-sm mt-1">{errors.xfd_date}</p>}
                            </div>
                            {/* INPUT TANGGAL MULAI */}
                            <div>
                                <label className="block text-sm font-medium mb-1">Tanggal Mulai Produksi</label>
                                <input type="date" value={data.start_date} onChange={e => setData('start_date', e.target.value)} className="w-full border p-2 rounded" />
                                <p className="text-xs text-gray-500 mt-1">Kosongkan jika akan dipecah menjadi batch.</p>
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">Brand <span className="text-red-500">*</span></label>
                                <select value={data.brand_id} onChange={handleBrandChange} className={`w-full border p-2 rounded ${errors.brand_id ? 'border-red-500' : ''}`}>
                                    <option value="">-- Pilih Brand --</option>
                                    {brands.map((brand: any) => (
                                        <option key={brand.id} value={brand.id}>{brand.name}</option>
                                    ))}
                                </select>
                                {errors.brand_id && <p className="text-red-500 text-sm mt-1">{errors.brand_id}</p>}
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">Art / Color <span className="text-red-500">*</span></label>
                                <input type="text" value={data.art_color} onChange={e => setData('art_color', e.target.value)} className={`w-full border p-2 rounded ${errors.art_color ? 'border-red-500' : ''}`} />
                                {errors.art_color && <p className="text-red-500 text-sm mt-1">{errors.art_color}</p>}
                            </div>

                            <div className="col-span-2">
                                <label className="block text-sm font-medium mb-1">Gambar Referensi (Opsional)</label>
                                <input
                                    type="file"
                                    onChange={e => setData('image', e.target.files?.[0] || null)}
                                    className="w-full border p-2 rounded"
                                    accept="image/*"
                                />
                                {errors.image && <p className="text-red-500 text-sm mt-1">{errors.image}</p>}
                            </div>
                        </div>

                        {data.details.length > 0 && (
                            <div className="border-t pt-6">
                                <h3 className="font-medium text-lg mb-2">Size Breakdown</h3>
                                <p className="text-sm text-gray-500 mb-4">*Kosongkan Qty jika ukuran tersebut tidak diproduksi. Kode Barcode opsional.</p>

                                <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
                                    {data.details.map((detail: any, index: number) => (
                                        <div key={index} className="border p-3 rounded-lg bg-gray-50 shadow-sm">
                                            <label className="block text-sm font-bold text-center mb-2">{detail.size_name}</label>

                                            <div className="mb-2">
                                                <label className="text-xs text-gray-500">Qty:</label>
                                                <input
                                                    type="number"
                                                    min="0"
                                                    value={detail.qty}
                                                    onChange={e => updateQty(index, e.target.value)}
                                                    placeholder="0"
                                                    className="w-full border p-1 rounded text-center"
                                                />
                                            </div>

                                            <div>
                                                <label className="text-xs text-gray-500">Kode Barcode:</label>
                                                <input
                                                    type="text"
                                                    value={detail.barcode}
                                                    onChange={e => updateBarcode(index, e.target.value)}
                                                    placeholder="Auto"
                                                    className="w-full border p-1 rounded text-sm"
                                                />
                                            </div>
                                        </div>
                                    ))}
                                </div>

                                <div className="bg-blue-50 p-4 rounded text-right">
                                    <span className="text-gray-600 mr-2">Total Qty:</span>
                                    <span className="text-2xl font-bold text-blue-700">{totalQty}</span>
                                </div>
                            </div>
                        )}

                        <div className="flex justify-end space-x-2 pt-4 border-t">
                            <Link href="/produksi/spks" className="px-4 py-2 bg-gray-200 rounded font-medium hover:bg-gray-300">Batal</Link>
                            <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 text-white rounded font-medium hover:bg-blue-700 disabled:opacity-50">
                                {processing ? 'Menyimpan...' : 'Simpan SPK'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}