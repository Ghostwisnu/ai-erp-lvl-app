import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

export default function Edit({ brand }: any) {
    const { data, setData, put, processing, errors } = useForm({
        name: brand.name,
        code: brand.code,
        description: brand.description || '',
        sizes: brand.size_runs.map((s: any) => s.size_name), // Ambil dari relasi
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        put(`/admin/brands/${brand.id}`);
    };

    const addSize = () => setData('sizes', [...data.sizes, '']);
    const removeSize = (index: number) => {
        const newSizes = [...data.sizes];
        newSizes.splice(index, 1);
        setData('sizes', newSizes);
    };
    const updateSize = (index: number, value: string) => {
        const newSizes = [...data.sizes];
        newSizes[index] = value;
        setData('sizes', newSizes);
    };

    return (
        <>
            <Head title="Edit Brand" />
            <div className="py-8 max-w-3xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h2 className="font-semibold text-xl mb-6">Edit Brand: {brand.name}</h2>
                    <form onSubmit={submit} className="space-y-4">
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium mb-1">Kode Brand</label>
                                <input type="text" value={data.code} onChange={e => setData('code', e.target.value)} className="w-full border p-2 rounded" required />
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">Nama Brand</label>
                                <input type="text" value={data.name} onChange={e => setData('name', e.target.value)} className="w-full border p-2 rounded" required />
                            </div>
                        </div>
                        <div>
                            <label className="block text-sm font-medium mb-1">Deskripsi (Opsional)</label>
                            <textarea value={data.description} onChange={e => setData('description', e.target.value)} className="w-full border p-2 rounded"></textarea>
                        </div>

                        <div className="border-t pt-4 mt-4">
                            <div className="flex justify-between items-center mb-3">
                                <h3 className="font-medium text-lg">Size Run (Daftar Ukuran)</h3>
                                <button type="button" onClick={addSize} className="bg-blue-100 text-blue-700 px-3 py-1 rounded text-sm">+ Tambah Ukuran</button>
                            </div>
                            {data.sizes.map((size: string, index: number) => (
                                <div key={index} className="flex gap-2 mb-2">
                                    <input type="text" value={size} onChange={e => updateSize(index, e.target.value)} className="w-full border p-2 rounded" required />
                                    <button type="button" onClick={() => removeSize(index)} className="bg-red-100 text-red-700 px-3 rounded">Hapus</button>
                                </div>
                            ))}
                        </div>

                        <div className="flex justify-end space-x-2 pt-4">
                            <Link href="/admin/brands" className="px-4 py-2 bg-gray-200 rounded">Batal</Link>
                            <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 text-white rounded">Update Brand</button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}