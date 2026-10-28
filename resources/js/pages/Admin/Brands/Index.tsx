import { Head, Link } from '@inertiajs/react';

export default function Index({ brands }: any) {
    return (
        <>
            <Head title="Data Brand" />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="font-semibold text-xl text-gray-800">Master Data Brand</h2>
                        <Link href="/admin/brands/create" className="bg-blue-600 text-white px-4 py-2 rounded-md text-sm">
                            + Tambah Brand
                        </Link>
                    </div>
                    <table className="w-full text-left border-collapse">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2 text-sm">Kode</th>
                                <th className="p-2 text-sm">Nama Brand</th>
                                <th className="p-2 text-sm">Jumlah Size Run</th>
                                <th className="p-2 text-sm">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {brands.data.map((brand: any) => (
                                <tr key={brand.id} className="border-b hover:bg-gray-50">
                                    <td className="p-2 font-medium">{brand.code}</td>
                                    <td className="p-2">{brand.name}</td>
                                    <td className="p-2">{brand.size_runs_count} Ukuran</td>
                                    <td className="p-2 space-x-2">
                                        <Link href={`/admin/brands/${brand.id}`} className="text-gray-600 hover:underline">Lihat</Link>
                                        <Link href={`/admin/brands/${brand.id}/edit`} className="text-blue-600 hover:underline">Edit</Link>
                                        <Link href={`/admin/brands/${brand.id}`} method="delete" as="button" className="text-red-600 hover:underline">Hapus</Link>
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