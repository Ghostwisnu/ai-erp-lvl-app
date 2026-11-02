import { Head, Link } from '@inertiajs/react';
import { useState, useRef } from 'react';
import Barcode from 'react-barcode';
import { useReactToPrint } from 'react-to-print';

export default function PrintBarcode({ spk }: any) {
    const [selectedSizes, setSelectedSizes] = useState<{
        [key: number]: number;
    }>({});
    const printRef = useRef<HTMLDivElement>(null);

    const toggleSize = (detailId: number, maxQty: number) => {
        setSelectedSizes((prev) => {
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
        setSelectedSizes((prev) => ({
            ...prev,
            [detailId]: qty,
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
            <Head title={`Cetak Kode Batang: ${spk.po_number}`} />
            <div className="mx-auto max-w-7xl py-8 sm:px-6 lg:px-8">
                {/* PANEL PENGATURAN */}
                <div className="mb-6 bg-white p-6 shadow-sm sm:rounded-lg print:hidden">
                    <div className="mb-6 flex items-center justify-between">
                        <div>
                            <h2 className="text-xl font-semibold text-gray-800">
                                Cetak Kode Batang Daftar Ukuran
                            </h2>
                            <p className="mt-1 text-sm text-gray-500">
                                PO: {spk.po_number} | Merek: {spk.brand.name} |
                                Model: {spk.art_color}
                            </p>
                        </div>
                        <Link
                            href="/produksi/spks"
                            className="text-blue-600 hover:underline"
                        >
                            &larr; Kembali ke Data SPK
                        </Link>
                    </div>

                    <div className="grid grid-cols-2 gap-8">
                        <div>
                            <h3 className="mb-3 font-medium text-gray-700">
                                1. Pilih ukuran yang akan dicetak
                            </h3>
                            <div className="max-h-96 space-y-2 overflow-y-auto rounded border p-3">
                                {spk.details.map((detail: any) => (
                                    <div
                                        key={detail.id}
                                        className={`flex items-center justify-between rounded p-2 ${selectedSizes[detail.id] ? 'bg-blue-50' : 'hover:bg-gray-50'}`}
                                    >
                                        <label className="flex cursor-pointer items-center space-x-3">
                                            <input
                                                type="checkbox"
                                                checked={
                                                    !!selectedSizes[detail.id]
                                                }
                                                onChange={() =>
                                                    toggleSize(
                                                        detail.id,
                                                        detail.qty,
                                                    )
                                                }
                                                className="h-4 w-4 rounded text-blue-600"
                                            />
                                            <span className="font-medium">
                                                Ukuran {detail.size_name}
                                            </span>
                                            <span className="text-sm text-gray-500">
                                                (Jumlah SPK: {detail.qty})
                                            </span>
                                        </label>

                                        {selectedSizes[detail.id] && (
                                            <div className="flex items-center space-x-2">
                                                <span className="text-sm text-gray-600">
                                                    Jumlah salinan:
                                                </span>
                                                <input
                                                    type="number"
                                                    min="1"
                                                    value={
                                                        selectedSizes[detail.id]
                                                    }
                                                    onChange={(e) =>
                                                        handleQtyChange(
                                                            detail.id,
                                                            parseInt(
                                                                e.target.value,
                                                            ) || 1,
                                                        )
                                                    }
                                                    className="w-20 rounded border p-1 text-center text-sm"
                                                />
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div className="flex flex-col items-center justify-center rounded-lg border bg-gray-50 p-6">
                            <div className="mb-6 text-center">
                                <span className="mb-2 block text-gray-500">
                                    Jumlah kode batang yang akan dicetak:
                                </span>
                                <span className="text-5xl font-bold text-blue-600">
                                    {barcodesToPrint.length}
                                </span>
                                <span className="ml-2 text-gray-500">
                                    lembar
                                </span>
                            </div>
                            <button
                                onClick={handlePrint}
                                disabled={barcodesToPrint.length === 0}
                                className="w-full rounded-lg bg-green-600 py-3 font-bold text-white shadow transition hover:bg-green-700 disabled:opacity-50"
                            >
                                🖨️ CETAK KODE BATANG
                            </button>
                        </div>
                    </div>
                </div>

                {/* AREA PRINT */}
                <div className="hidden print:block" ref={printRef}>
                    <div className="grid grid-cols-4 gap-2 p-4">
                        {barcodesToPrint.map((barcode, index) => (
                            <div
                                key={index}
                                className="flex flex-col items-center justify-center border border-black p-2 text-center"
                                style={{ pageBreakInside: 'avoid' }}
                            >
                                <Barcode
                                    value={barcode.code}
                                    width={1.2}
                                    height={40}
                                    fontSize={10}
                                    margin={0}
                                />
                                <div className="mt-1 flex w-full justify-between px-1 text-[10px] font-bold uppercase">
                                    <span>{spk.brand.name}</span>
                                    <span>Ukuran: {barcode.size}</span>
                                </div>
                                <div className="w-full truncate px-1 text-left text-[10px]">
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
