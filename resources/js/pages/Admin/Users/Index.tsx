import { Head, Link } from '@inertiajs/react';

interface Role { id: number; name: string; }
interface User { id: number; name: string; email: string; roles: Role[]; }
interface Props { users: { data: User[]; links: { url: string | null; label: string; active: boolean }[] }; }

export default function Index({ users }: Props) {
    return (
        <>
            <Head title="Data User" />
            <div className="py-12">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6">
                        <div className="flex justify-between items-center mb-4">
                            <h2 className="font-semibold text-xl text-gray-800">Data User</h2>
                            <Link href="/admin/users/create" className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm">
                                + Tambah User
                            </Link>
                        </div>
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b">
                                    <th className="py-2 px-3">#</th>
                                    <th className="py-2 px-3">Nama</th>
                                    <th className="py-2 px-3">Email</th>
                                    <th className="py-2 px-3">Role</th>
                                    <th className="py-2 px-3">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {users.data.length === 0 ? (
                                    <tr><td colSpan={5} className="py-4 text-center text-gray-500">Belum ada data user.</td></tr>
                                ) : users.data.map((user, i) => (
                                    <tr key={user.id} className="border-b hover:bg-gray-50">
                                        <td className="py-2 px-3">{i + 1}</td>
                                        <td className="py-2 px-3">{user.name}</td>
                                        <td className="py-2 px-3">{user.email}</td>
                                        <td className="py-2 px-3">
                                            {user.roles.map((r) => (
                                                <span key={r.id} className="inline-block bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded mr-1">{r.name}</span>
                                            ))}
                                        </td>
                                        <td className="py-2 px-3 space-x-2">
                                            <Link href={`/admin/users/${user.id}`} className="text-gray-600 hover:underline">Lihat</Link>
                                            <Link href={`/admin/users/${user.id}/edit`} className="text-blue-600 hover:underline">Edit</Link>
                                            <Link href={`/admin/users/${user.id}`} method="delete" as="button" className="text-red-600 hover:underline" onBefore={() => confirm('Hapus user ini?')}>Hapus</Link>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </>
    );
}

