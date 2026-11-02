import { Head, Link } from '@inertiajs/react';

interface Permission {
    id: number;
    name: string;
}
interface Props {
    permissions: Permission[];
}

export default function Index({ permissions }: Props) {
    return (
        <>
            <Head title="Data Hak Akses" />
            <div className="py-12">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <div className="mb-4 flex items-center justify-between">
                            <h2 className="text-xl font-semibold text-gray-800">
                                Data Hak Akses
                            </h2>
                            <Link
                                href="/admin/permissions/create"
                                className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700"
                            >
                                + Tambah Hak Akses
                            </Link>
                        </div>
                        <table className="w-full border-collapse text-left">
                            <thead>
                                <tr className="border-b">
                                    <th className="px-3 py-2">#</th>
                                    <th className="px-3 py-2">
                                        Nama hak akses
                                    </th>
                                    <th className="px-3 py-2">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {permissions.map((perm, i) => (
                                    <tr
                                        key={perm.id}
                                        className="border-b hover:bg-gray-50"
                                    >
                                        <td className="px-3 py-2">{i + 1}</td>
                                        <td className="px-3 py-2 font-medium">
                                            {perm.name}
                                        </td>
                                        <td className="space-x-2 px-3 py-2">
                                            <Link
                                                href={`/admin/permissions/${perm.id}`}
                                                className="text-gray-600 hover:underline"
                                            >
                                                Lihat
                                            </Link>
                                            <Link
                                                href={`/admin/permissions/${perm.id}/edit`}
                                                className="text-blue-600 hover:underline"
                                            >
                                                Ubah
                                            </Link>
                                            <Link
                                                href={`/admin/permissions/${perm.id}`}
                                                method="delete"
                                                as="button"
                                                className="text-red-600 hover:underline"
                                                onBefore={() =>
                                                    confirm(
                                                        'Hapus hak akses ini?',
                                                    )
                                                }
                                            >
                                                Hapus
                                            </Link>
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
