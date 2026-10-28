import { Head, Link } from '@inertiajs/react';

export default function Index({ overtimes }: any) {
    return (
        <>
            <Head title="Data Lembur" />
            <div className="py-8">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">

                        {/* Header & Tombol Tambah */}
                        <div className="flex justify-between items-center mb-6">
                            <h2 className="font-semibold text-xl text-gray-800">Form Lembur Harian</h2>
                            <Link href="/admin/overtimes/create" className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm font-medium">
                                + Buat Form Lembur
                            </Link>
                        </div>

                        {/* Tabel Data Lembur */}
                        <div className="overflow-x-auto">
                            <table className="w-full text-left border-collapse">
                                <thead>
                                    <tr className="border-b bg-gray-50">
                                        <th className="py-3 px-3 text-sm font-semibold text-gray-600">Tanggal</th>
                                        <th className="py-3 px-3 text-sm font-semibold text-gray-600">Departemen</th>
                                        <th className="py-3 px-3 text-sm font-semibold text-gray-600">Tujuan Lembur</th>
                                        <th className="py-3 px-3 text-sm font-semibold text-gray-600">PIC</th>
                                        <th className="py-3 px-3 text-sm font-semibold text-gray-600 text-center">Jml Peserta</th>
                                        <th className="py-3 px-3 text-sm font-semibold text-gray-600">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {overtimes.data.map((ot: any) => (
                                        <tr key={ot.id} className="border-b hover:bg-gray-50">
                                            <td className="py-2 px-3 text-sm">{ot.date}</td>
                                            <td className="py-2 px-3 text-sm">{ot.department}</td>
                                            <td className="py-2 px-3 text-sm">{ot.purpose}</td>
                                            <td className="py-2 px-3 text-sm">{ot.pic}</td>
                                            <td className="py-2 px-3 text-sm text-center">{ot.employees_count} Orang</td>
                                            <td className="py-2 px-3 text-sm space-x-3">
                                                <Link href={`/admin/overtimes/${ot.id}`} className="text-gray-600 hover:underline font-medium">Lihat</Link>
                                                <Link href={`/admin/overtimes/${ot.id}/edit`} className="text-blue-600 hover:underline font-medium">Edit</Link>

                                                {/* TOMBOL PRINT: Membuka Tab Baru */}
                                                <a
                                                    href={`/admin/overtimes/${ot.id}/print`}
                                                    target="_blank"
                                                    rel="noopener noreferrer"
                                                    className="text-green-600 hover:underline font-medium"
                                                >
                                                    Print
                                                </a>

                                                <Link href={`/admin/overtimes/${ot.id}`} method="delete" as="button" className="text-red-600 hover:underline font-medium">Hapus</Link>
                                            </td>
                                        </tr>
                                    ))}
                                    {overtimes.data.length === 0 && (
                                        <tr>
                                            <td colSpan={6} className="py-4 px-3 text-center text-gray-500 text-sm">
                                                Belum ada data form lembur.
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>

                        {/* Pagination */}
                        <div className="mt-4">
                            {overtimes.links && overtimes.links.map((link: any, i: number) => (
                                link.url ? (
                                    <Link
                                        key={i}
                                        href={link.url}
                                        className={`px-3 py-1 border rounded mr-1 text-sm ${link.active ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'}`}
                                        dangerouslySetInnerHTML={{ __html: link.label }}
                                    />
                                ) : (
                                    <span
                                        key={i}
                                        className="px-3 py-1 border rounded mr-1 text-sm bg-gray-100 text-gray-400"
                                        dangerouslySetInnerHTML={{ __html: link.label }}
                                    />
                                )
                            ))}
                        </div>

                    </div>
                </div>
            </div>
        </>
    );
}