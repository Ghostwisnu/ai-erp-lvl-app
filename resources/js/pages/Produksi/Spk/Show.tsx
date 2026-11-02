import { Head, Link } from '@inertiajs/react';

export default function Show({ spk }: any) {
    const totalQty = spk.details.reduce(
        (sum: number, detail: any) => sum + detail.qty,
        0,
    );

    return (
        <>
            <Head title={`Detail SPK: ${spk.po_number}`} />
            <div className="mx-auto max-w-4xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between border-b pb-4">
                        <div>
                            <h2 className="text-2xl font-bold text-gray-800">
                                Detail SPK
                            </h2>
                            <p className="mt-1 text-sm text-gray-500">
                                PO: {spk.po_number}
                            </p>
                        </div>
                        <div className="space-x-2">
                            <Link
                                href="/produksi/spks"
                                className="rounded bg-gray-200 px-4 py-2 text-sm font-medium hover:bg-gray-300"
                            >
                                &larr; Kembali
                            </Link>
                            <Link
                                href={`/produksi/spks/${spk.id}/edit`}
                                className="rounded bg-yellow-500 px-4 py-2 text-sm font-medium text-white hover:bg-yellow-600"
                            >
                                Ubah SPK
                            </Link>
                        </div>
                    </div>

                    <div className="mb-8 grid grid-cols-1 gap-6 rounded-lg border bg-gray-50 p-4 md:grid-cols-2">
                        <div className="space-y-4">
                            <div>
                                <span className="mb-1 block text-sm text-gray-500">
                                    Merek
                                </span>
                                <span className="text-lg font-semibold">
                                    {spk.brand.name}
                                </span>
                            </div>
                            <div>
                                <span className="mb-1 block text-sm text-gray-500">
                                    Model / Warna
                                </span>
                                <span className="text-lg font-semibold">
                                    {spk.art_color}
                                </span>
                            </div>
                            <div>
                                <span className="mb-1 block text-sm text-gray-500">
                                    XFD (Batas waktu)
                                </span>
                                <span className="text-lg font-semibold text-red-600">
                                    {spk.xfd_date}
                                </span>
                            </div>
                            <div>
                                <span className="mb-1 block text-sm text-gray-500">
                                    Jumlah keseluruhan
                                </span>
                                <span className="text-2xl font-bold text-blue-600">
                                    {totalQty} pcs
                                </span>
                            </div>
                        </div>

                        <div>
                            <span className="mb-2 block text-sm text-gray-500">
                                Gambar Referensi
                            </span>
                            {spk.image_path ? (
                                <img
                                    src={`/storage/${spk.image_path}`}
                                    alt="Referensi"
                                    className="w-full max-w-xs rounded-lg border object-cover shadow-sm"
                                />
                            ) : (
                                <div className="flex h-40 w-full max-w-xs items-center justify-center rounded-lg border bg-gray-200 text-gray-400">
                                    Tidak ada gambar
                                </div>
                            )}
                        </div>
                    </div>

                    <h3 className="mb-3 text-lg font-semibold">
                        Rincian Ukuran
                    </h3>
                    <div className="overflow-x-auto">
                        <table className="w-full border-collapse border text-left text-sm">
                            <thead>
                                <tr className="border-b bg-gray-100">
                                    <th className="w-16 border-r p-3 text-center">
                                        No
                                    </th>
                                    <th className="border-r p-3 text-center">
                                        Ukuran
                                    </th>
                                    <th className="p-3 text-right">
                                        Jumlah (pcs)
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                {spk.details.map(
                                    (detail: any, index: number) => (
                                        <tr
                                            key={detail.id}
                                            className="border-b hover:bg-gray-50"
                                        >
                                            <td className="border-r p-3 text-center">
                                                {index + 1}
                                            </td>
                                            <td className="border-r bg-gray-50 p-3 text-center font-medium">
                                                {detail.size_name}
                                            </td>
                                            <td className="p-3 text-right font-bold">
                                                {detail.qty}
                                            </td>
                                        </tr>
                                    ),
                                )}
                                <tr className="bg-blue-50 font-bold text-blue-800">
                                    <td
                                        colSpan={2}
                                        className="border-r p-3 text-right"
                                    >
                                        JUMLAH
                                    </td>
                                    <td className="p-3 text-right">
                                        {totalQty}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </>
    );
}
