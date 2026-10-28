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
            <Head title="Tambah Defect" />
            <div className="py-8 max-w-3xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h2 className="font-semibold text-xl mb-6">Tambah Kategori Defect</h2>
                    <form onSubmit={submit} className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium mb-1">Brand</label>
                            <select value={data.brand_id} onChange={e => setData('brand_id', e.target.value)} className="w-full border p-2 rounded" required>
                                <option value="">-- Pilih Brand --</option>
                                {brands.map((b: any) => <option key={b.id} value={b.id}>{b.name}</option>)}
                            </select>
                        </div>
                        <div>
                            <label className="block text-sm font-medium mb-1">Nama Defect</label>
                            <input type="text" value={data.name} onChange={e => setData('name', e.target.value)} className="w-full border p-2 rounded" placeholder="Contoh: Jahitan Lepas" required />
                        </div>
                        <div>
                            <label className="block text-sm font-medium mb-1">Deskripsi</label>
                            <textarea value={data.description} onChange={e => setData('description', e.target.value)} className="w-full border p-2 rounded" rows={3}></textarea>
                        </div>
                        <div className="flex justify-end space-x-2 pt-4">
                            <Link href="/admin/defect-categories" className="px-4 py-2 bg-gray-200 rounded">Batal</Link>
                            <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 text-white rounded">Simpan</button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}