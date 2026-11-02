import { Head, Link, router } from '@inertiajs/react';

export default function Index({ spks }: any) {
    return (
        <>
            <Head title="Data SPK" />
            <div className="mx-auto max-w-7xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <h2 className="text-xl font-semibold text-gray-800">
                            Surat Perintah Kerja (SPK)
                        </h2>
                        <Link
                            href="/produksi/spks/create"
                            className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white"
                        >
                            + Buat SPK
                        </Link>
                    </div>
                    <table className="w-full border-collapse text-left">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2 text-sm">Gambar</th>
                                <th className="p-2 text-sm">Nomor PO</th>
                                <th className="p-2 text-sm">Merek</th>
                                <th className="p-2 text-sm">Model/Warna</th>
                                <th className="p-2 text-sm">Batas waktu</th>
                                <th className="p-2 text-center text-sm">
                                    Jumlah total
                                </th>
                                <th className="p-2 text-sm">Status</th>
                                <th className="p-2 text-sm">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {spks.data.map((spk: any) => (
                                <tr
                                    key={spk.id}
                                    className="border-b hover:bg-gray-50"
                                >
                                    <td className="p-2">
                                        {spk.image_path ? (
                                            <img
                                                src={`/storage/${spk.image_path}`}
                                                alt="Gambar SPK"
                                                className="h-12 w-12 rounded border object-cover"
                                            />
                                        ) : (
                                            <div className="flex h-12 w-12 items-center justify-center rounded border bg-gray-200 text-[10px] text-gray-500">
                                                Tidak ada gambar
                                            </div>
                                        )}
                                    </td>
                                    <td className="p-2 font-medium">
                                        {spk.po_number}
                                    </td>
                                    <td className="p-2">{spk.brand.name}</td>
                                    <td className="p-2">{spk.art_color}</td>
                                    <td className="p-2">{spk.xfd_date}</td>
                                    <td className="p-2 text-center font-bold text-blue-600">
                                        {spk.details_sum_qty || 0}
                                    </td>
                                    <td className="p-2">
                                        <select
                                            value={spk.status}
                                            onChange={(e) => {
                                                if (
                                                    confirm(
                                                        'Ubah status SPK ini?',
                                                    )
                                                ) {
                                                    router.post(
                                                        `/produksi/spks/${spk.id}/status`,
                                                        {
                                                            status: e.target
                                                                .value,
                                                        },
                                                    );
                                                }
                                            }}
                                            className={`rounded border p-1 text-xs font-bold ${
                                                spk.status === 'active'
                                                    ? 'border-green-600 bg-green-50 text-green-600'
                                                    : spk.status === 'finished'
                                                      ? 'border-blue-600 bg-blue-50 text-blue-600'
                                                      : spk.status === 'closed'
                                                        ? 'border-gray-600 bg-gray-100 text-gray-600'
                                                        : 'border-yellow-600 bg-yellow-50 text-yellow-600'
                                            }`}
                                        >
                                            <option value="create">DRAF</option>
                                            <option value="active">
                                                AKTIF
                                            </option>
                                            <option value="finished">
                                                SELESAI
                                            </option>
                                            <option value="closed">
                                                DITUTUP
                                            </option>
                                        </select>
                                    </td>
                                    <td className="space-x-3 p-2 text-sm">
                                        <Link
                                            href={`/produksi/spks/${spk.id}/batches`}
                                            className="font-medium text-purple-600 hover:underline"
                                        >
                                            Kelompok
                                        </Link>
                                        <Link
                                            href={`/produksi/spks/${spk.id}`}
                                            className="text-gray-600 hover:underline"
                                        >
                                            Lihat
                                        </Link>
                                        <Link
                                            href={`/produksi/spks/${spk.id}/edit`}
                                            className="text-blue-600 hover:underline"
                                        >
                                            Ubah
                                        </Link>
                                        <Link
                                            href={`/produksi/spks/${spk.id}/print-barcode`}
                                            className="font-medium text-green-600 hover:underline"
                                        >
                                            Cetak Kode Batang
                                        </Link>
                                        <Link
                                            href={`/produksi/spks/${spk.id}`}
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
