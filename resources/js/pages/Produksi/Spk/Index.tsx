import { Head, Link, router } from '@inertiajs/react';

export default function Index({ spks }: any) {
    return (
        <>
            <Head title="Data SPK" />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="font-semibold text-xl text-gray-800">Surat Perintah Kerja (SPK)</h2>
                        <Link href="/produksi/spks/create" className="bg-blue-600 text-white px-4 py-2 rounded-md text-sm">
                            + Buat SPK
                        </Link>
                    </div>
                    <table className="w-full text-left border-collapse">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-2 text-sm">Gambar</th>
                                <th className="p-2 text-sm">PO Number</th>
                                <th className="p-2 text-sm">Brand</th>
                                <th className="p-2 text-sm">Art/Color</th>
                                <th className="p-2 text-sm">Deadline</th>
                                <th className="p-2 text-sm text-center">Total Qty</th>
                                <th className="p-2 text-sm">Status</th>
                                <th className="p-2 text-sm">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {spks.data.map((spk: any) => (
                                <tr key={spk.id} className="border-b hover:bg-gray-50">
                                    <td className="p-2">
                                        {spk.image_path ? (
                                            <img src={`/storage/${spk.image_path}`} alt="Img" className="w-12 h-12 object-cover rounded border" />
                                        ) : (
                                            <div className="w-12 h-12 bg-gray-200 rounded border flex items-center justify-center text-[10px] text-gray-500">No Img</div>
                                        )}
                                    </td>
                                    <td className="p-2 font-medium">{spk.po_number}</td>
                                    <td className="p-2">{spk.brand.name}</td>
                                    <td className="p-2">{spk.art_color}</td>
                                    <td className="p-2">{spk.xfd_date}</td>
                                    <td className="p-2 font-bold text-blue-600 text-center">{spk.details_sum_qty || 0}</td>
                                    <td className="p-2">
                                        <select
                                            value={spk.status}
                                            onChange={(e) => {
                                                if (confirm('Ubah status SPK ini?')) {
                                                    router.post(`/produksi/spks/${spk.id}/status`, { status: e.target.value });
                                                }
                                            }}
                                            className={`border p-1 rounded text-xs font-bold ${spk.status === 'active' ? 'text-green-600 border-green-600 bg-green-50' :
                                                    spk.status === 'finished' ? 'text-blue-600 border-blue-600 bg-blue-50' :
                                                        spk.status === 'closed' ? 'text-gray-600 border-gray-600 bg-gray-100' :
                                                            'text-yellow-600 border-yellow-600 bg-yellow-50'
                                                }`}
                                        >
                                            <option value="create">CREATE</option>
                                            <option value="active">ACTIVE</option>
                                            <option value="finished">FINISHED</option>
                                            <option value="closed">CLOSED</option>
                                        </select>
                                    </td>
                                    <td className="p-2 space-x-3 text-sm">
                                        <Link href={`/produksi/spks/${spk.id}`} className="text-gray-600 hover:underline">Lihat</Link>
                                        <Link href={`/produksi/spks/${spk.id}/edit`} className="text-blue-600 hover:underline">Edit</Link>
                                        <Link href={`/produksi/spks/${spk.id}/print-barcode`} className="text-green-600 hover:underline font-medium">Print Barcode</Link>
                                        <Link href={`/produksi/spks/${spk.id}`} method="delete" as="button" className="text-red-600 hover:underline">Hapus</Link>
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