import { Head, Link } from '@inertiajs/react';

export default function Index({ spks }: any) {
    return (
        <>
            <Head title="Laporan QC" />
            <div className="mx-auto max-w-7xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <h2 className="mb-6 text-xl font-semibold">
                        Daftar PO (Laporan QC)
                    </h2>
                    <table className="w-full border-collapse text-left">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2">Nomor PO</th>
                                <th className="p-2">Merek</th>
                                <th className="p-2">Model/Warna</th>
                                <th className="p-2 text-center">
                                    Jumlah Total
                                </th>
                                <th className="p-2 text-center">
                                    Total Pemindaian
                                </th>
                                <th className="p-2 text-center">Total Cacat</th>
                                <th className="p-2">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {spks.map((spk: any) => (
                                <tr
                                    key={spk.id}
                                    className="border-b hover:bg-gray-50"
                                >
                                    <td className="p-2 font-medium">
                                        {spk.po_number}
                                    </td>
                                    <td className="p-2">{spk.brand.name}</td>
                                    <td className="p-2">{spk.art_color}</td>
                                    <td className="p-2 text-center">
                                        {spk.details_sum_qty || 0}
                                    </td>
                                    <td className="p-2 text-center font-bold text-blue-600">
                                        {spk.total_scan || 0}
                                    </td>
                                    <td className="p-2 text-center font-bold text-red-600">
                                        {spk.total_defect || 0}
                                    </td>
                                    <td className="p-2">
                                        <Link
                                            href={`/produksi/report-qc/${spk.id}`}
                                            className="font-medium text-blue-600 hover:underline"
                                        >
                                            Lihat Laporan
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
