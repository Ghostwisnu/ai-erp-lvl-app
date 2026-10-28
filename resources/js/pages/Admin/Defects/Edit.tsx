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
            <Head title={`Edit Defect: ${defect.name}`} />
            <div className="py-8 max-w-3xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h2 className="font-semibold text-xl mb-6">Edit Kategori Defect</h2>

                    {/* Kotak Error jika ada yang kosong */}
                    {Object.keys(errors).length > 0 && (
                        <div className="bg-red-100 text-red-700 p-3 rounded mb-4">
                            <ul className="list-disc ml-4">
                                {Object.values(errors).map((err: any, i) => <li key={i}>{err}</li>)}
                            </ul>
                        </div>
                    )}

                    <form onSubmit={submit} className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium mb-1">Brand</label>
                            <select
                                value={data.brand_id}
                                onChange={e => setData('brand_id', e.target.value)}
                                className="w-full border p-2 rounded"
                                required
                            >
                                <option value="">-- Pilih Brand --</option>
                                {brands.map((b: any) => (
                                    <option key={b.id} value={b.id}>{b.name}</option>
                                ))}
                            </select>
                            {errors.brand_id && <p className="text-red-500 text-sm mt-1">{errors.brand_id}</p>}
                        </div>

                        <div>
                            <label className="block text-sm font-medium mb-1">Nama Defect</label>
                            <input
                                type="text"
                                value={data.name}
                                onChange={e => setData('name', e.target.value)}
                                className="w-full border p-2 rounded"
                                placeholder="Contoh: Jahitan Lepas"
                                required
                            />
                            {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name}</p>}
                        </div>

                        <div>
                            <label className="block text-sm font-medium mb-1">Deskripsi</label>
                            <textarea
                                value={data.description}
                                onChange={e => setData('description', e.target.value)}
                                className="w-full border p-2 rounded"
                                rows={3}
                            ></textarea>
                        </div>

                        <div className="flex justify-end space-x-2 pt-4">
                            <Link href="/admin/defect-categories" className="px-4 py-2 bg-gray-200 rounded font-medium hover:bg-gray-300">
                                Batal
                            </Link>
                            <button
                                type="submit"
                                disabled={processing}
                                className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded font-medium disabled:opacity-50"
                            >
                                {processing ? 'Menyimpan...' : 'Update'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}