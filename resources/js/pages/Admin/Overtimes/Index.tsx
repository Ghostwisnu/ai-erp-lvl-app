import { Head, Link } from '@inertiajs/react';

export default function Index({ overtimes }: any) {
    return (
        <>
            <Head title="Data Lembur" />
            <div className="py-8">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        {/* Header & Tombol Tambah */}
                        <div className="mb-6 flex items-center justify-between">
                            <h2 className="text-xl font-semibold text-gray-800">
                                Form Lembur Harian
                            </h2>
                            <Link
                                href="/admin/overtimes/create"
                                className="rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700"
                            >
                                + Buat Form Lembur
                            </Link>
                        </div>

                        {/* Tabel Data Lembur */}
                        <div className="overflow-x-auto">
                            <table className="w-full border-collapse text-left">
                                <thead>
                                    <tr className="border-b bg-gray-50">
                                        <th className="px-3 py-3 text-sm font-semibold text-gray-600">
                                            Tanggal
                                        </th>
                                        <th className="px-3 py-3 text-sm font-semibold text-gray-600">
                                            Departemen
                                        </th>
                                        <th className="px-3 py-3 text-sm font-semibold text-gray-600">
                                            Tujuan Lembur
                                        </th>
                                        <th className="px-3 py-3 text-sm font-semibold text-gray-600">
                                            PIC
                                        </th>
                                        <th className="px-3 py-3 text-center text-sm font-semibold text-gray-600">
                                            Jml Peserta
                                        </th>
                                        <th className="px-3 py-3 text-sm font-semibold text-gray-600">
                                            Aksi
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {overtimes.data.map((ot: any) => (
                                        <tr
                                            key={ot.id}
                                            className="border-b hover:bg-gray-50"
                                        >
                                            <td className="px-3 py-2 text-sm">
                                                {ot.date}
                                            </td>
                                            <td className="px-3 py-2 text-sm">
                                                {ot.department}
                                            </td>
                                            <td className="px-3 py-2 text-sm">
                                                {ot.purpose}
                                            </td>
                                            <td className="px-3 py-2 text-sm">
                                                {ot.pic}
                                            </td>
                                            <td className="px-3 py-2 text-center text-sm">
                                                {ot.employees_count} Orang
                                            </td>
                                            <td className="space-x-3 px-3 py-2 text-sm">
                                                <Link
                                                    href={`/admin/overtimes/${ot.id}`}
                                                    className="font-medium text-gray-600 hover:underline"
                                                >
                                                    Lihat
                                                </Link>
                                                <Link
                                                    href={`/admin/overtimes/${ot.id}/edit`}
                                                    className="font-medium text-blue-600 hover:underline"
                                                >
                                                    Ubah
                                                </Link>

                                                {/* TOMBOL PRINT: Membuka Tab Baru */}
                                                <a
                                                    href={`/admin/overtimes/${ot.id}/print`}
                                                    target="_blank"
                                                    rel="noopener noreferrer"
                                                    className="font-medium text-green-600 hover:underline"
                                                >
                                                    Print
                                                </a>

                                                <Link
                                                    href={`/admin/overtimes/${ot.id}`}
                                                    method="delete"
                                                    as="button"
                                                    className="font-medium text-red-600 hover:underline"
                                                >
                                                    Hapus
                                                </Link>
                                            </td>
                                        </tr>
                                    ))}
                                    {overtimes.data.length === 0 && (
                                        <tr>
                                            <td
                                                colSpan={6}
                                                className="px-3 py-4 text-center text-sm text-gray-500"
                                            >
                                                Belum ada data form lembur.
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>

                        {/* Pagination */}
                        <div className="mt-4">
                            {overtimes.links &&
                                overtimes.links.map((link: any, i: number) =>
                                    link.url ? (
                                        <Link
                                            key={i}
                                            href={link.url}
                                            className={`mr-1 rounded border px-3 py-1 text-sm ${link.active ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'}`}
                                            dangerouslySetInnerHTML={{
                                                __html: link.label,
                                            }}
                                        />
                                    ) : (
                                        <span
                                            key={i}
                                            className="mr-1 rounded border bg-gray-100 px-3 py-1 text-sm text-gray-400"
                                            dangerouslySetInnerHTML={{
                                                __html: link.label,
                                            }}
                                        />
                                    ),
                                )}
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
