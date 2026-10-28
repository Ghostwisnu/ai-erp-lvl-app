import { Head, Link } from '@inertiajs/react';

interface Role { id: number; name: string; }
interface User { id: number; name: string; email: string; email_verified_at: string | null; created_at: string; roles: Role[]; }
interface Props { user: User; }

export default function Show({ user }: Props) {
    return (
        <>
            <Head title={`Detail User: ${user.name}`} />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">Detail User</h2>
                        <dl className="space-y-3">
                            <div><dt className="text-sm text-gray-500">Nama</dt><dd className="text-lg font-medium">{user.name}</dd></div>
                            <div><dt className="text-sm text-gray-500">Email</dt><dd className="text-lg">{user.email}</dd></div>
                            <div><dt className="text-sm text-gray-500">Status Verifikasi</dt><dd className="text-lg">{user.email_verified_at ? 'Terverifikasi' : 'Belum Terverifikasi'}</dd></div>
                            <div>
                                <dt className="text-sm text-gray-500">Role</dt>
                                <dd className="mt-1">
                                    {user.roles.length === 0 ? <span className="text-gray-400">Tidak ada role</span> : user.roles.map((r) => (
                                        <span key={r.id} className="inline-block bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded mr-1">{r.name}</span>
                                    ))}
                                </dd>
                            </div>
                            <div><dt className="text-sm text-gray-500">Dibuat</dt><dd className="text-lg">{user.created_at}</dd></div>
                        </dl>
                        <div className="flex justify-end space-x-2 pt-6">
                            <Link href="/admin/users" className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-sm">Kembali</Link>
                            <Link href={`/admin/users/${user.id}/edit`} className="px-4 py-2 bg-yellow-500 hover:bg-yellow-600 text-white rounded-md text-sm">Edit</Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}