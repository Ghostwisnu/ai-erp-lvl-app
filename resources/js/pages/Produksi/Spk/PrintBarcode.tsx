import { Head, Link } from '@inertiajs/react';
import { useState, useRef } from 'react';
import Barcode from 'react-barcode';
import { useReactToPrint } from 'react-to-print';

export default function PrintBarcode({ spk }: any) {
    const [selectedSizes, setSelectedSizes] = useState<{ [key: number]: number }>({});
    const printRef = useRef<HTMLDivElement>(null);

    const toggleSize = (detailId: number, maxQty: number) => {
        setSelectedSizes(prev => {
            const newState = { ...prev };
            if (newState[detailId]) {
                delete newState[detailId];
            } else {
                newState[detailId] = maxQty;
            }
            return newState;
        });
    };

    const handleQtyChange = (detailId: number, qty: number) => {
        setSelectedSizes(prev => ({
            ...prev,
            [detailId]: qty
        }));
    };

    const handlePrint = useReactToPrint({
        contentRef: printRef,
    });

    // Generate data barcode (Menggunakan input manual jika ada)
    const barcodesToPrint: any[] = [];
    spk.details.forEach((detail: any) => {
        if (selectedSizes[detail.id]) {
            for (let i = 0; i < selectedSizes[detail.id]; i++) {
                // Jika detail.barcode ada, pakai. Jika tidak, buat otomatis.
                const barcodeString = detail.barcode
                    ? detail.barcode
                    : `${spk.po_number}-${detail.size_name}-${i + 1}`;

                barcodesToPrint.push({
                    id: `${detail.id}-${i}`,
                    size: detail.size_name,
                    code: barcodeString,
                });
            }
        }
    });

    return (
        <>
            <Head title={`Print Barcode: ${spk.po_number}`} />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8">

                {/* PANEL PENGATURAN */}
                <div className="bg-white shadow-sm sm:rounded-lg p-6 mb-6 print:hidden">
                    <div className="flex justify-between items-center mb-6">
                        <div>
                            <h2 className="font-semibold text-xl text-gray-800">Cetak Barcode Size Run</h2>
                            <p className="text-gray-500 text-sm mt-1">PO: {spk.po_number} | Brand: {spk.brand.name} | Art: {spk.art_color}</p>
                        </div>
                        <Link href="/produksi/spks" className="text-blue-600 hover:underline">
                            &larr; Kembali ke Data SPK
                        </Link>
                    </div>

                    <div className="grid grid-cols-2 gap-8">
                        <div>
                            <h3 className="font-medium text-gray-700 mb-3">1. Pilih Size yang Dicetak</h3>
                            <div className="space-y-2 max-h-96 overflow-y-auto border p-3 rounded">
                                {spk.details.map((detail: any) => (
                                    <div key={detail.id} className={`flex items-center justify-between p-2 rounded ${selectedSizes[detail.id] ? 'bg-blue-50' : 'hover:bg-gray-50'}`}>
                                        <label className="flex items-center space-x-3 cursor-pointer">
                                            <input
                                                type="checkbox"
                                                checked={!!selectedSizes[detail.id]}
                                                onChange={() => toggleSize(detail.id, detail.qty)}
                                                className="w-4 h-4 text-blue-600 rounded"
                                            />
                                            <span className="font-medium">Size {detail.size_name}</span>
                                            <span className="text-gray-500 text-sm">(Total SPK: {detail.qty})</span>
                                        </label>

                                        {selectedSizes[detail.id] && (
                                            <div className="flex items-center space-x-2">
                                                <span className="text-sm text-gray-600">Copy:</span>
                                                <input
                                                    type="number"
                                                    min="1"
                                                    value={selectedSizes[detail.id]}
                                                    onChange={(e) => handleQtyChange(detail.id, parseInt(e.target.value) || 1)}
                                                    className="w-20 border p-1 rounded text-sm text-center"
                                                />
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div className="flex flex-col justify-center items-center bg-gray-50 rounded-lg border p-6">
                            <div className="text-center mb-6">
                                <span className="text-gray-500 block mb-2">Total Barcode yang akan dicetak:</span>
                                <span className="text-5xl font-bold text-blue-600">{barcodesToPrint.length}</span>
                                <span className="text-gray-500 ml-2">Lembar</span>
                            </div>
                            <button
                                onClick={handlePrint}
                                disabled={barcodesToPrint.length === 0}
                                className="w-full py-3 bg-green-600 hover:bg-green-700 text-white font-bold rounded-lg shadow disabled:opacity-50 transition"
                            >
                                🖨️ CETAK BARCODE
                            </button>
                        </div>
                    </div>
                </div>

                {/* AREA PRINT */}
                <div className="hidden print:block" ref={printRef}>
                    <div className="grid grid-cols-4 gap-2 p-4">
                        {barcodesToPrint.map((barcode, index) => (
                            <div key={index} className="border border-black p-2 flex flex-col items-center justify-center text-center" style={{ pageBreakInside: 'avoid' }}>
                                <Barcode
                                    value={barcode.code}
                                    width={1.2}
                                    height={40}
                                    fontSize={10}
                                    margin={0}
                                />
                                <div className="mt-1 w-full flex justify-between text-[10px] font-bold uppercase px-1">
                                    <span>{spk.brand.name}</span>
                                    <span>Size: {barcode.size}</span>
                                </div>
                                <div className="text-[10px] w-full text-left px-1 truncate">
                                    PO: {spk.po_number}
                                </div>
                            </div>
                        ))}
                    </div>
                </div>

            </div>
        </>
    );
}