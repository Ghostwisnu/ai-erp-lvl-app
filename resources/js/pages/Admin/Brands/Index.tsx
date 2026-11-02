import { Head, Link } from '@inertiajs/react';

export default function Index({ brands }: any) {
    return (
        <>
            <Head title="Data Merek" />
            <div className="mx-auto max-w-7xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <h2 className="text-xl font-semibold text-gray-800">
                            Data Merek
                        </h2>
                        <Link
                            href="/admin/brands/create"
                            className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white"
                        >
                            + Tambah Merek
                        </Link>
                    </div>
                    <table className="w-full border-collapse text-left">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2 text-sm">Kode</th>
                                <th className="p-2 text-sm">Nama Merek</th>
                                <th className="p-2 text-sm">
                                    Jumlah Daftar Ukuran
                                </th>
                                <th className="p-2 text-sm">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {brands.data.map((brand: any) => (
                                <tr
                                    key={brand.id}
                                    className="border-b hover:bg-gray-50"
                                >
                                    <td className="p-2 font-medium">
                                        {brand.code}
                                    </td>
                                    <td className="p-2">{brand.name}</td>
                                    <td className="p-2">
                                        {brand.size_runs_count} Ukuran
                                    </td>
                                    <td className="space-x-2 p-2">
                                        <Link
                                            href={`/admin/brands/${brand.id}`}
                                            className="text-gray-600 hover:underline"
                                        >
                                            Lihat
                                        </Link>
                                        <Link
                                            href={`/admin/brands/${brand.id}/edit`}
                                            className="text-blue-600 hover:underline"
                                        >
                                            Ubah
                                        </Link>
                                        <Link
                                            href={`/admin/brands/${brand.id}`}
                                            method="delete"
                                            as="button"
                                            className="text-red-600 hover:underline"
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
