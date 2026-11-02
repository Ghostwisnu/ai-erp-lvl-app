import { Head, Link } from '@inertiajs/react';

export default function Index({ defects }: any) {
    return (
        <>
            <Head title="Kategori Cacat" />
            <div className="mx-auto max-w-7xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <h2 className="text-xl font-semibold">
                            Kategori Cacat
                        </h2>
                        <Link
                            href="/admin/defect-categories/create"
                            className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white"
                        >
                            + Tambah Cacat
                        </Link>
                    </div>
                    <table className="w-full border-collapse text-left">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2">Merek</th>
                                <th className="p-2">Nama Cacat</th>
                                <th className="p-2">Deskripsi</th>
                                <th className="p-2">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {defects.data.map((d: any) => (
                                <tr
                                    key={d.id}
                                    className="border-b hover:bg-gray-50"
                                >
                                    <td className="p-2">{d.brand.name}</td>
                                    <td className="p-2 font-medium">
                                        {d.name}
                                    </td>
                                    <td className="p-2 text-sm text-gray-500">
                                        {d.description || '-'}
                                    </td>
                                    <td className="space-x-2 p-2">
                                        <Link
                                            href={`/admin/defect-categories/${d.id}/edit`}
                                            className="text-blue-600"
                                        >
                                            Ubah
                                        </Link>
                                        <Link
                                            href={`/admin/defect-categories/${d.id}`}
                                            method="delete"
                                            as="button"
                                            className="text-red-600"
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
        </>
    );
}
