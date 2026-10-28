import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Permission { id: number; name: string; }
interface Props { permissions: Permission[]; }

export default function Create({ permissions }: Props) {
    const { data, setData, post, processing, errors } = useForm({
        name: '', permissions: [] as string[],
    });

    const toggle = (name: string) =>
        setData('permissions', data.permissions.includes(name) ? data.permissions.filter((p) => p !== name) : [...data.permissions, name]);

    const submit = (e: FormEvent) => { e.preventDefault(); post('/admin/roles'); };

    return (
        <>
            <Head title="Tambah Role" />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">Tambah Role</h2>
                        <form onSubmit={submit} className="space-y-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Nama Role</label>
                                <input type="text" value={data.name} onChange={(e) => setData('name', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm" required />
                                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name}</p>}
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Permission</label>
                                <div className="grid grid-cols-2 gap-2 border rounded-md p-3">
                                    {permissions.map((p) => (
                                        <label key={p.id} className="inline-flex items-center space-x-2">
                                            <input type="checkbox" checked={data.permissions.includes(p.name)} onChange={() => toggle(p.name)} className="rounded border-gray-300" />
                                            <span className="text-sm">{p.name}</span>
                                        </label>
                                    ))}
                                </div>
                            </div>
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link href="/admin/roles" className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-sm">Batal</Link>
                                <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md text-sm disabled:opacity-50">
                                    {processing ? 'Menyimpan...' : 'Simpan'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}