import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent, useMemo } from 'react';

export default function Edit({ spk, brands }: any) {
    const initialDetails = spk.details.map((d: any) => ({
        size_name: d.size_name,
        qty: d.qty,
        barcode: d.barcode || '',
    }));

    const { data, setData, put, processing, errors } = useForm({
        po_number: spk.po_number,
        xfd_date: spk.xfd_date,
        start_date: spk.start_date || '', // <-- Tambahan Tanggal Mulai
        brand_id: spk.brand_id,
        art_color: spk.art_color,
        image: null as File | null,
        details: initialDetails,
    });

    const totalQty = useMemo(() => {
        return data.details.reduce(
            (sum: number, item: any) => sum + (Number(item.qty) || 0),
            0,
        );
    }, [data.details]);

    const handleBrandChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const brandId = e.target.value;
        setData('brand_id', brandId);

        const brand = brands.find((b: any) => b.id === parseInt(brandId));
        if (brand && brand.size_runs) {
            const newDetails = brand.size_runs.map((size: any) => {
                const existing = data.details.find(
                    (d: any) => d.size_name === size.size_name,
                );
                return {
                    size_name: size.size_name,
                    qty: existing ? existing.qty : '',
                    barcode: existing ? existing.barcode : '',
                };
            });
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
        const cleanedDetails = data.details.map((detail: { qty: string }) => ({
            ...detail,
            qty: detail.qty === '' ? 0 : Number(detail.qty),
        }));
        setData('details', cleanedDetails);

        put(`/produksi/spks/${spk.id}`, {
            forceFormData: true,
        });
    };

    return (
        <>
            <Head title={`Ubah SPK: ${spk.po_number}`} />
            <div className="mx-auto max-w-4xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <h2 className="mb-6 text-xl font-semibold">
                        Ubah Surat Perintah Kerja
                    </h2>

                    {Object.keys(errors).length > 0 && (
                        <div className="mb-4 rounded border border-red-400 bg-red-100 px-4 py-3 text-red-700">
                            <strong className="font-bold">
                                Gagal Menyimpan:
                            </strong>
                            <ul className="mt-1 ml-5 list-disc">
                                {Object.values(errors).map((err: any, i) => (
                                    <li key={i}>{err}</li>
                                ))}
                            </ul>
                        </div>
                    )}

                    <form onSubmit={submit} className="space-y-6">
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Nomor PO{' '}
                                    <span className="text-red-500">*</span>
                                </label>
                                <input
                                    type="text"
                                    value={data.po_number}
                                    onChange={(e) =>
                                        setData('po_number', e.target.value)
                                    }
                                    className={`w-full rounded border p-2 ${errors.po_number ? 'border-red-500' : ''}`}
                                />
                                {errors.po_number && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.po_number}
                                    </p>
                                )}
                                <p className="mt-1 text-xs text-gray-500">
                                    Bisa sama dengan PO lain asal Merek atau Model/Warna berbeda
                                </p>
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    XFD (Batas waktu){' '}
                                    <span className="text-red-500">*</span>
                                </label>
                                <input
                                    type="date"
                                    value={data.xfd_date}
                                    onChange={(e) =>
                                        setData('xfd_date', e.target.value)
                                    }
                                    className={`w-full rounded border p-2 ${errors.xfd_date ? 'border-red-500' : ''}`}
                                />
                                {errors.xfd_date && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.xfd_date}
                                    </p>
                                )}
                            </div>

                            {/* INPUT TANGGAL MULAI */}
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Tanggal Mulai Produksi
                                </label>
                                <input
                                    type="date"
                                    value={data.start_date}
                                    onChange={(e) =>
                                        setData('start_date', e.target.value)
                                    }
                                    className="w-full rounded border p-2"
                                />
                                <p className="mt-1 text-xs text-gray-500">
                                    Kosongkan jika akan dibagi menjadi beberapa
                                    kelompok.
                                </p>
                            </div>

                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Merek{' '}
                                    <span className="text-red-500">*</span>
                                </label>
                                <select
                                    value={data.brand_id}
                                    onChange={handleBrandChange}
                                    className={`w-full rounded border p-2 ${errors.brand_id ? 'border-red-500' : ''}`}
                                >
                                    <option value="">-- Pilih Merek --</option>
                                    {brands.map((brand: any) => (
                                        <option key={brand.id} value={brand.id}>
                                            {brand.name}
                                        </option>
                                    ))}
                                </select>
                                {errors.brand_id && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.brand_id}
                                    </p>
                                )}
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Model / Warna{' '}
                                    <span className="text-red-500">*</span>
                                </label>
                                <input
                                    type="text"
                                    value={data.art_color}
                                    onChange={(e) =>
                                        setData('art_color', e.target.value)
                                    }
                                    className={`w-full rounded border p-2 ${errors.art_color ? 'border-red-500' : ''}`}
                                />
                                {errors.art_color && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.art_color}
                                    </p>
                                )}
                            </div>

                            {/* INPUT GAMBAR DI EDIT */}
                            <div className="col-span-2 rounded border bg-gray-50 p-4">
                                <label className="mb-2 block text-sm font-medium">
                                    Gambar Referensi Saat Ini
                                </label>
                                {spk.image_path ? (
                                    <div className="mb-3">
                                        <img
                                            src={`/storage/${spk.image_path}`}
                                            alt="Gambar saat ini"
                                            className="h-32 w-auto rounded border shadow-sm"
                                        />
                                    </div>
                                ) : (
                                    <p className="mb-3 text-sm text-gray-500 italic">
                                        Belum ada gambar.
                                    </p>
                                )}

                                <label className="mb-1 block text-sm font-medium">
                                    Ganti Gambar (Opsional)
                                </label>
                                <input
                                    type="file"
                                    onChange={(e) =>
                                        setData(
                                            'image',
                                            e.target.files?.[0] || null,
                                        )
                                    }
                                    className="w-full rounded border bg-white p-2"
                                    accept="image/*"
                                />
                                {errors.image && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.image}
                                    </p>
                                )}
                            </div>
                        </div>

                        {data.details.length > 0 && (
                            <div className="border-t pt-6">
                                <h3 className="mb-2 text-lg font-medium">
                                    Rincian Ukuran
                                </h3>
                                <p className="mb-4 text-sm text-gray-500">
                                    *Kosongkan jumlah jika ukuran tersebut tidak
                                    diproduksi. Kode batang bersifat opsional.
                                </p>

                                <div className="mb-4 grid grid-cols-2 gap-4 md:grid-cols-4">
                                    {data.details.map(
                                        (detail: any, index: number) => (
                                            <div
                                                key={index}
                                                className="rounded-lg border bg-gray-50 p-3 shadow-sm"
                                            >
                                                <label className="mb-2 block text-center text-sm font-bold">
                                                    {detail.size_name}
                                                </label>

                                                <div className="mb-2">
                                                    <label className="text-xs text-gray-500">
                                                        Jumlah:
                                                    </label>
                                                    <input
                                                        type="number"
                                                        min="0"
                                                        value={detail.qty}
                                                        onChange={(e) =>
                                                            updateQty(
                                                                index,
                                                                e.target.value,
                                                            )
                                                        }
                                                        placeholder="0"
                                                        className="w-full rounded border p-1 text-center"
                                                    />
                                                </div>

                                                <div>
                                                    <label className="text-xs text-gray-500">
                                                        Kode batang:
                                                    </label>
                                                    <input
                                                        type="text"
                                                        value={detail.barcode}
                                                        onChange={(e) =>
                                                            updateBarcode(
                                                                index,
                                                                e.target.value,
                                                            )
                                                        }
                                                        placeholder="Otomatis"
                                                        className="w-full rounded border p-1 text-sm"
                                                    />
                                                </div>
                                            </div>
                                        ),
                                    )}
                                </div>

                                <div className="rounded bg-blue-50 p-4 text-right">
                                    <span className="mr-2 text-gray-600">
                                        Jumlah total:
                                    </span>
                                    <span className="text-2xl font-bold text-blue-700">
                                        {totalQty}
                                    </span>
                                </div>
                            </div>
                        )}

                        <div className="flex justify-end space-x-2 border-t pt-4">
                            <Link
                                href="/produksi/spks"
                                className="rounded bg-gray-200 px-4 py-2 font-medium hover:bg-gray-300"
                            >
                                Batal
                            </Link>
                            <button
                                type="submit"
                                disabled={processing}
                                className="rounded bg-blue-600 px-4 py-2 font-medium text-white hover:bg-blue-700 disabled:opacity-50"
                            >
                                {processing
                                    ? 'Menyimpan...'
                                    : 'Simpan Perubahan SPK'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}
