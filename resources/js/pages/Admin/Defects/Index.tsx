import { Head, Link } from '@inertiajs/react';

export default function Index({ defects }: any) {
    return (
        <>
            <Head title="Master Defect" />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="font-semibold text-xl">Master Kategori Defect</h2>
                        <Link href="/admin/defect-categories/create" className="bg-blue-600 text-white px-4 py-2 rounded-md text-sm">+ Tambah Defect</Link>
                    </div>
                    <table className="w-full text-left border-collapse">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2">Brand</th>
                                <th className="p-2">Nama Defect</th>
                                <th className="p-2">Deskripsi</th>
                                <th className="p-2">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {defects.data.map((d: any) => (
                                <tr key={d.id} className="border-b hover:bg-gray-50">
                                    <td className="p-2">{d.brand.name}</td>
                                    <td className="p-2 font-medium">{d.name}</td>
                                    <td className="p-2 text-sm text-gray-500">{d.description || '-'}</td>
                                    <td className="p-2 space-x-2">
                                        <Link href={`/admin/defect-categories/${d.id}/edit`} className="text-blue-600">Edit</Link>
                                        <Link href={`/admin/defect-categories/${d.id}`} method="delete" as="button" className="text-red-600">Hapus</Link>
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