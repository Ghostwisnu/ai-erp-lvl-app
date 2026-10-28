import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Permission { id: number; name: string; }
interface Props { permission: Permission; }

export default function Edit({ permission }: Props) {
    const { data, setData, put, processing, errors } = useForm({ name: permission.name });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        put(`/admin/permissions/${permission.id}`);
    };

    return (
        <>
            <Head title={`Edit Permission: ${permission.name}`} />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">Edit Permission</h2>
                        <form onSubmit={submit} className="space-y-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Nama Permission</label>
                                <input type="text" value={data.name} onChange={(e) => setData('name', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm" required />
                                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name}</p>}
                            </div>
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link href="/admin/permissions" className="px-4 py-2 bg-gray-200 rounded-md text-sm">Batal</Link>
                                <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 text-white rounded-md text-sm disabled:opacity-50">
                                    {processing ? 'Menyimpan...' : 'Update'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}