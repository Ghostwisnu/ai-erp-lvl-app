import { Head, Link } from '@inertiajs/react';

export default function Show({ spk }: any) {
    const totalQty = spk.details.reduce((sum: number, detail: any) => sum + detail.qty, 0);

    return (
        <>
            <Head title={`Detail SPK: ${spk.po_number}`} />
            <div className="py-8 max-w-4xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">

                    <div className="flex justify-between items-center mb-6 border-b pb-4">
                        <div>
                            <h2 className="font-bold text-2xl text-gray-800">Detail SPK</h2>
                            <p className="text-gray-500 text-sm mt-1">PO: {spk.po_number}</p>
                        </div>
                        <div className="space-x-2">
                            <Link href="/produksi/spks" className="px-4 py-2 bg-gray-200 rounded text-sm font-medium hover:bg-gray-300">
                                &larr; Kembali
                            </Link>
                            <Link href={`/produksi/spks/${spk.id}/edit`} className="px-4 py-2 bg-yellow-500 text-white rounded text-sm font-medium hover:bg-yellow-600">
                                Edit SPK
                            </Link>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8 bg-gray-50 p-4 rounded-lg border">
                        <div className="space-y-4">
                            <div>
                                <span className="text-gray-500 text-sm block mb-1">Brand</span>
                                <span className="font-semibold text-lg">{spk.brand.name}</span>
                            </div>
                            <div>
                                <span className="text-gray-500 text-sm block mb-1">Art / Color</span>
                                <span className="font-semibold text-lg">{spk.art_color}</span>
                            </div>
                            <div>
                                <span className="text-gray-500 text-sm block mb-1">XFD (Deadline)</span>
                                <span className="font-semibold text-lg text-red-600">{spk.xfd_date}</span>
                            </div>
                            <div>
                                <span className="text-gray-500 text-sm block mb-1">Total Keseluruhan Qty</span>
                                <span className="font-bold text-2xl text-blue-600">{totalQty} Pcs</span>
                            </div>
                        </div>

                        <div>
                            <span className="text-gray-500 text-sm block mb-2">Gambar Referensi</span>
                            {spk.image_path ? (
                                <img src={`/storage/${spk.image_path}`} alt="Referensi" className="w-full max-w-xs rounded-lg border shadow-sm object-cover" />
                            ) : (
                                <div className="w-full max-w-xs h-40 bg-gray-200 rounded-lg border flex items-center justify-center text-gray-400">
                                    Tidak ada gambar
                                </div>
                            )}
                        </div>
                    </div>

                    <h3 className="font-semibold text-lg mb-3">Size Breakdown</h3>
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse border text-sm">
                            <thead>
                                <tr className="bg-gray-100 border-b">
                                    <th className="p-3 border-r text-center w-16">No</th>
                                    <th className="p-3 border-r text-center">Size / Ukuran</th>
                                    <th className="p-3 text-right">Quantity (Pcs)</th>
                                </tr>
                            </thead>
                            <tbody>
                                {spk.details.map((detail: any, index: number) => (
                                    <tr key={detail.id} className="border-b hover:bg-gray-50">
                                        <td className="p-3 border-r text-center">{index + 1}</td>
                                        <td className="p-3 border-r text-center font-medium bg-gray-50">{detail.size_name}</td>
                                        <td className="p-3 text-right font-bold">{detail.qty}</td>
                                    </tr>
                                ))}
                                <tr className="bg-blue-50 font-bold text-blue-800">
                                    <td colSpan={2} className="p-3 text-right border-r">TOTAL</td>
                                    <td className="p-3 text-right">{totalQty}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </>
    );
}