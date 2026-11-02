import { Head, Link, useForm } from '@inertiajs/react';

export default function Edit({ defect, brands }: any) {
    // PERBEDAAN 1: Data awal (useForm) diisi dari database (props 'defect')
    const { data, setData, put, processing, errors } = useForm({
        brand_id: defect.brand_id,
        name: defect.name,
        description: defect.description || '',
    });

    const submit = (e: React.FormEvent) => {
        e.preventDefault();
        // PERBEDAAN 2: Menggunakan 'put' dan URL yang menyertakan ID
        put(`/admin/defect-categories/${defect.id}`);
    };

    return (
        <>
            <Head title={`Ubah Cacat: ${defect.name}`} />
            <div className="mx-auto max-w-3xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <h2 className="mb-6 text-xl font-semibold">
                        Ubah Kategori Cacat
                    </h2>

                    {/* Kotak Error jika ada yang kosong */}
                    {Object.keys(errors).length > 0 && (
                        <div className="mb-4 rounded bg-red-100 p-3 text-red-700">
                            <ul className="ml-4 list-disc">
                                {Object.values(errors).map((err: any, i) => (
                                    <li key={i}>{err}</li>
                                ))}
                            </ul>
                        </div>
                    )}

                    <form onSubmit={submit} className="space-y-4">
                        <div>
                            <label className="mb-1 block text-sm font-medium">
                                Merek
                            </label>
                            <select
                                value={data.brand_id}
                                onChange={(e) =>
                                    setData('brand_id', e.target.value)
                                }
                                className="w-full rounded border p-2"
                                required
                            >
                                <option value="">-- Pilih Merek --</option>
                                {brands.map((b: any) => (
                                    <option key={b.id} value={b.id}>
                                        {b.name}
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
                                Nama Cacat
                            </label>
                            <input
                                type="text"
                                value={data.name}
                                onChange={(e) =>
                                    setData('name', e.target.value)
                                }
                                className="w-full rounded border p-2"
                                placeholder="Contoh: Jahitan Lepas"
                                required
                            />
                            {errors.name && (
                                <p className="mt-1 text-sm text-red-500">
                                    {errors.name}
                                </p>
                            )}
                        </div>

                        <div>
                            <label className="mb-1 block text-sm font-medium">
                                Deskripsi
                            </label>
                            <textarea
                                value={data.description}
                                onChange={(e) =>
                                    setData('description', e.target.value)
                                }
                                className="w-full rounded border p-2"
                                rows={3}
                            ></textarea>
                        </div>

                        <div className="flex justify-end space-x-2 pt-4">
                            <Link
                                href="/admin/defect-categories"
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
                                    : 'Simpan Perubahan'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}
