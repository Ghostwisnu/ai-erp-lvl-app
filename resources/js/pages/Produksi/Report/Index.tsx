import { Head, Link } from '@inertiajs/react';

export default function Index({ spks }: any) {
    return (
        <>
            <Head title="Report QC" />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h2 className="font-semibold text-xl mb-6">Daftar PO (Report QC)</h2>
                    <table className="w-full text-left border-collapse">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2">PO Number</th>
                                <th className="p-2">Brand</th>
                                <th className="p-2">Art/Color</th>
                                <th className="p-2 text-center">Total Qty</th>
                                <th className="p-2 text-center">Total Scan</th>
                                <th className="p-2 text-center">Total Defect</th>
                                <th className="p-2">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {spks.map((spk: any) => (
                                <tr key={spk.id} className="border-b hover:bg-gray-50">
                                    <td className="p-2 font-medium">{spk.po_number}</td>
                                    <td className="p-2">{spk.brand.name}</td>
                                    <td className="p-2">{spk.art_color}</td>
                                    <td className="p-2 text-center">{spk.details_sum_qty || 0}</td>
                                    <td className="p-2 text-center text-blue-600 font-bold">{spk.total_scan || 0}</td>
                                    <td className="p-2 text-center text-red-600 font-bold">{spk.total_defect || 0}</td>
                                    <td className="p-2">
                                        <Link href={`/produksi/report-qc/${spk.id}`} className="text-blue-600 hover:underline font-medium">Lihat Report</Link>
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