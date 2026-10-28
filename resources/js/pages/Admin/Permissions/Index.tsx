import { Head, Link } from '@inertiajs/react';

interface Permission { id: number; name: string; }
interface Props { permissions: Permission[]; }

export default function Index({ permissions }: Props) {
    return (
        <>
            <Head title="Data Permission" />
            <div className="py-12">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <div className="flex justify-between items-center mb-4">
                            <h2 className="font-semibold text-xl text-gray-800">Data Permission</h2>
                            <Link href="/admin/permissions/create" className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm">
                                + Tambah Permission
                            </Link>
                        </div>
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b">
                                    <th className="py-2 px-3">#</th>
                                    <th className="py-2 px-3">Nama Permission</th>
                                    <th className="py-2 px-3">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {permissions.map((perm, i) => (
                                    <tr key={perm.id} className="border-b hover:bg-gray-50">
                                        <td className="py-2 px-3">{i + 1}</td>
                                        <td className="py-2 px-3 font-medium">{perm.name}</td>
                                        <td className="py-2 px-3 space-x-2">
                                            <Link href={`/admin/permissions/${perm.id}`} className="text-gray-600 hover:underline">Lihat</Link>
                                            <Link href={`/admin/permissions/${perm.id}/edit`} className="text-blue-600 hover:underline">Edit</Link>
                                            <Link href={`/admin/permissions/${perm.id}`} method="delete" as="button" className="text-red-600 hover:underline" onBefore={() => confirm('Hapus permission ini?')}>Hapus</Link>
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