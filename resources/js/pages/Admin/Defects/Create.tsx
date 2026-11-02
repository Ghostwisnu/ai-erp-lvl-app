import { Head, Link, useForm } from '@inertiajs/react';

export default function Create({ brands }: any) {
    const { data, setData, post, processing, errors } = useForm({
        brand_id: '',
        name: '',
        description: '',
    });

    const submit = (e: React.FormEvent) => {
        e.preventDefault();
        post('/admin/defect-categories');
    };

    return (
        <>
            <Head title="Tambah Kategori Cacat" />
            <div className="mx-auto max-w-3xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <h2 className="mb-6 text-xl font-semibold">
                        Tambah Kategori Cacat
                    </h2>
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
                                className="rounded bg-gray-200 px-4 py-2"
                            >
                                Batal
                            </Link>
                            <button
                                type="submit"
                                disabled={processing}
                                className="rounded bg-blue-600 px-4 py-2 text-white"
                            >
                                Simpan
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}
