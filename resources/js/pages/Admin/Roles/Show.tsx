import { Head, Link } from '@inertiajs/react';

interface Permission { id: number; name: string; }
interface Role { id: number; name: string; permissions: Permission[]; }
interface Props { role: Role; }

export default function Show({ role }: Props) {
    return (
        <>
            <Head title={`Detail Role: ${role.name}`} />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">Detail Role</h2>
                        <dl className="space-y-3">
                            <div><dt className="text-sm text-gray-500">Nama Role</dt><dd className="text-lg font-medium">{role.name}</dd></div>
                            <div>
                                <dt className="text-sm text-gray-500">Permission</dt>
                                <dd className="mt-1">
                                    {role.permissions.length === 0 ? <span className="text-gray-400">Tidak ada permission</span> : role.permissions.map((p) => (
                                        <span key={p.id} className="inline-block bg-green-100 text-green-800 text-xs px-2 py-1 rounded mr-1">{p.name}</span>
                                    ))}
                                </dd>
                            </div>
                        </dl>
                        <div className="flex justify-end space-x-2 pt-6">
                            <Link href="/admin/roles" className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-sm">Kembali</Link>
                            <Link href={`/admin/roles/${role.id}/edit`} className="px-4 py-2 bg-yellow-500 hover:bg-yellow-600 text-white rounded-md text-sm">Edit</Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}