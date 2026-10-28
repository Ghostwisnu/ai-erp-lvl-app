import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Role { id: number; name: string; }
interface User { id: number; name: string; email: string; roles: Role[]; }
interface Props { user: User; roles: Role[]; }

export default function Edit({ user, roles }: Props) {
    const { data, setData, put, processing, errors } = useForm({
        name: user.name, email: user.email, password: '', password_confirmation: '', roles: user.roles.map((r) => r.name) as string[],
    });

    const toggle = (name: string) =>
        setData('roles', data.roles.includes(name) ? data.roles.filter((r) => r !== name) : [...data.roles, name]);

    const submit = (e: FormEvent) => { e.preventDefault(); put(`/admin/users/${user.id}`); };

    return (
        <>
            <Head title={`Edit User: ${user.name}`} />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">Edit User: {user.name}</h2>
                        <form onSubmit={submit} className="space-y-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Nama</label>
                                <input type="text" value={data.name} onChange={(e) => setData('name', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm" required />
                                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name}</p>}
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                                <input type="email" value={data.email} onChange={(e) => setData('email', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm" required />
                                {errors.email && <p className="text-red-500 text-sm mt-1">{errors.email}</p>}
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Password Baru (kosongkan jika tidak diubah)</label>
                                <input type="password" value={data.password} onChange={(e) => setData('password', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm" />
                                {errors.password && <p className="text-red-500 text-sm mt-1">{errors.password}</p>}
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Konfirmasi Password Baru</label>
                                <input type="password" value={data.password_confirmation} onChange={(e) => setData('password_confirmation', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm" />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Role</label>
                                <div className="grid grid-cols-2 gap-2 border rounded-md p-3">
                                    {roles.map((r) => (
                                        <label key={r.id} className="inline-flex items-center space-x-2">
                                            <input type="checkbox" checked={data.roles.includes(r.name)} onChange={() => toggle(r.name)} className="rounded border-gray-300" />
                                            <span className="text-sm">{r.name}</span>
                                        </label>
                                    ))}
                                </div>
                            </div>
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link href="/admin/users" className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-sm">Batal</Link>
                                <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md text-sm disabled:opacity-50">
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