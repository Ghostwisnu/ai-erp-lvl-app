import { Head, router, Link, useForm } from '@inertiajs/react';
import { useState } from 'react';

export default function Index({
    department,
    activeSpks,
    selectedSpk,
    defectCategories,
    todayDefects,
}: any) {
    const [selectedSpkId, setSelectedSpkId] = useState(selectedSpk?.id || '');

    // Form untuk tambah defect
    const { data, setData, post, reset } = useForm({
        spk_id: selectedSpk?.id || '',
        defect_category_id: '',
        department: department,
        qty: 1,
    });

    const handleSelectSpk = (id: string) => {
        setSelectedSpkId(id);
        router.get(
            '/produksi/defects',
            { spk_id: id, dept: department },
            { preserveState: true },
        );
    };

    const submitDefect = (e: React.FormEvent) => {
        e.preventDefault();
        post('/produksi/defects', {
            onSuccess: () => reset('defect_category_id', 'qty'),
        });
    };

    // Hitung total defect PO ini
    const totalDefectPO = todayDefects
        .filter((d: any) => d.spk_id === selectedSpkId)
        .reduce((sum: number, d: any) => sum + d.qty, 0);
    const totalDefectAll = todayDefects.reduce(
        (sum: number, d: any) => sum + d.qty,
        0,
    );

    return (
        <>
            <Head title="Cacat Harian QC" />
            <div className="min-h-screen bg-gray-100 px-4 py-6">
                <div className="mx-auto max-w-7xl">
                    {/* Header */}
                    <div className="mb-6 flex items-center justify-between rounded-lg border bg-white p-4 shadow-sm">
                        <div className="flex items-center gap-4">
                            <h1 className="text-xl font-bold text-gray-800">
                                Cacat Harian QC — QCB-
                                {new Date()
                                    .toISOString()
                                    .slice(0, 10)
                                    .replace(/-/g, '')}
                            </h1>
                            <span className="flex items-center gap-1 rounded bg-green-100 px-2 py-1 text-xs font-bold text-green-700">
                                <span className="h-2 w-2 animate-pulse rounded-full bg-green-500"></span>{' '}
                                LANGSUNG
                            </span>
                        </div>
                        <div className="flex gap-2">
                            <Link
                                href="/produksi/scan"
                                className="rounded border px-3 py-1 text-sm text-blue-600 hover:bg-blue-50"
                            >
                                Ganti Lini
                            </Link>
                            <Link
                                href="/produksi/defects"
                                className="rounded border px-3 py-1 text-sm text-gray-600 hover:bg-gray-50"
                            >
                                &larr; Kembali
                            </Link>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
                        {/* Kiri: Detail PO & Data Defect */}
                        <div className="space-y-6 lg:col-span-2">
                            {/* Detail PO */}
                            <div className="rounded-lg border bg-white p-6 shadow-sm">
                                <h2 className="mb-4 border-b pb-2 text-xs font-bold text-gray-500 uppercase">
                                    Detail PO
                                </h2>
                                {selectedSpk ? (
                                    <div className="flex gap-6">
                                        <div className="flex h-40 w-32 items-center justify-center rounded border bg-gray-100 text-gray-400">
                                            <svg
                                                className="h-12 w-12"
                                                fill="none"
                                                stroke="currentColor"
                                                viewBox="0 0 24 24"
                                            >
                                                <path
                                                    strokeLinecap="round"
                                                    strokeLinejoin="round"
                                                    strokeWidth="2"
                                                    d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                                                ></path>
                                            </svg>
                                        </div>
                                        <div className="space-y-3">
                                            <div>
                                                <span className="block text-xs text-gray-400 uppercase">
                                                    Nomor PO
                                                </span>{' '}
                                                <span className="text-lg font-bold">
                                                    {selectedSpk.po_number}
                                                </span>
                                            </div>
                                            <div>
                                                <span className="block text-xs text-gray-400 uppercase">
                                                    Model / Warna
                                                </span>{' '}
                                                <span className="font-bold">
                                                    {selectedSpk.art_color}
                                                </span>
                                            </div>
                                            <div>
                                                <span className="block text-xs text-gray-400 uppercase">
                                                    Jumlah
                                                </span>{' '}
                                                <span className="text-lg font-bold">
                                                    {
                                                        selectedSpk.details_sum_qty
                                                    }{' '}
                                                    pcs
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                ) : (
                                    <p className="py-10 text-center text-gray-400">
                                        Pilih PO di kanan.
                                    </p>
                                )}
                            </div>

                            {/* Data Defect */}
                            <div className="rounded-lg border bg-white p-6 shadow-sm">
                                <div className="mb-4 flex items-center justify-between border-b pb-2">
                                    <h2 className="text-xs font-bold text-gray-500 uppercase">
                                        Data Cacat —{' '}
                                        {selectedSpk?.po_number || 'Pilih PO'}
                                    </h2>
                                    <span className="rounded bg-red-100 px-2 py-1 text-xs font-bold text-red-600">
                                        {totalDefectPO} cacat
                                    </span>
                                </div>

                                <table className="w-full text-left text-sm">
                                    <thead>
                                        <tr className="border-b text-gray-400">
                                            <th className="pb-2">
                                                KATEGORI CACAT
                                            </th>
                                            <th className="pb-2 text-center">
                                                JUMLAH
                                            </th>
                                            <th className="pb-2 text-right">
                                                AKSI
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {defectCategories.length > 0 ? (
                                            defectCategories.map((cat: any) => {
                                                // Hitung defect untuk kategori ini di SPK ini
                                                const qtyDefect = todayDefects
                                                    .filter(
                                                        (d: any) =>
                                                            d.spk_id ===
                                                                selectedSpkId &&
                                                            d.defect_category_id ===
                                                                cat.id,
                                                    )
                                                    .reduce(
                                                        (sum: number, d: any) =>
                                                            sum + d.qty,
                                                        0,
                                                    );

                                                return (
                                                    <tr
                                                        key={cat.id}
                                                        className="border-b hover:bg-gray-50"
                                                    >
                                                        <td className="py-3">
                                                            <span className="font-medium">
                                                                {cat.name}
                                                            </span>
                                                            <span className="block text-xs text-gray-400">
                                                                {
                                                                    cat.description
                                                                }
                                                            </span>
                                                        </td>
                                                        <td className="text-center font-bold text-red-600">
                                                            {qtyDefect}
                                                        </td>
                                                        <td className="text-right">
                                                            <button
                                                                onClick={() => {
                                                                    setData({
                                                                        ...data,
                                                                        spk_id: selectedSpkId,
                                                                        defect_category_id:
                                                                            cat.id,
                                                                    });
                                                                    setTimeout(
                                                                        () =>
                                                                            document
                                                                                .getElementById(
                                                                                    'btn-submit-defect',
                                                                                )
                                                                                ?.click(),
                                                                        100,
                                                                    );
                                                                }}
                                                                className="rounded bg-red-50 px-3 py-1 text-xs font-bold text-red-600 hover:bg-red-100 disabled:opacity-50"
                                                                disabled={
                                                                    !selectedSpkId
                                                                }
                                                            >
                                                                + Tambah
                                                            </button>
                                                        </td>
                                                    </tr>
                                                );
                                            })
                                        ) : (
                                            <tr>
                                                <td
                                                    colSpan={3}
                                                    className="py-8 text-center text-gray-400"
                                                >
                                                    Belum ada data induk cacat.
                                                </td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>

                                {/* Hidden Form untuk Submit */}
                                <form
                                    onSubmit={submitDefect}
                                    className="hidden"
                                >
                                    <input
                                        type="number"
                                        value={data.qty}
                                        onChange={(e) =>
                                            setData(
                                                'qty',
                                                Number(e.target.value),
                                            )
                                        }
                                        min="1"
                                    />
                                    <button
                                        type="submit"
                                        id="btn-submit-defect"
                                    >
                                        Kirim
                                    </button>
                                </form>
                            </div>
                        </div>

                        {/* Kanan: PO Selector */}
                        <div className="lg:col-span-1">
                            <div className="rounded-lg border bg-white shadow-sm">
                                <div className="rounded-t-lg bg-blue-600 p-3 text-white">
                                    <h3 className="text-sm font-bold">
                                        PILIH PO
                                    </h3>
                                    <p className="text-xs text-blue-100">
                                        SPK yang berjalan
                                    </p>
                                </div>
                                <div className="max-h-[600px] space-y-3 overflow-y-auto p-3">
                                    {activeSpks.map((spk: any) => (
                                        <button
                                            key={spk.id}
                                            onClick={() =>
                                                handleSelectSpk(spk.id)
                                            }
                                            className={`w-full rounded border p-3 text-left transition ${selectedSpkId === spk.id ? 'border-blue-500 bg-blue-50 ring-1 ring-blue-500' : 'hover:bg-gray-50'}`}
                                        >
                                            <div className="flex items-start justify-between">
                                                <div>
                                                    <h4 className="text-sm font-bold">
                                                        {spk.po_number}
                                                    </h4>
                                                    <p className="text-xs text-gray-500">
                                                        {spk.brand.name} •{' '}
                                                        {spk.art_color}
                                                    </p>
                                                    <p className="mt-1 text-xs font-medium">
                                                        Jumlah:{' '}
                                                        {spk.details_sum_qty}
                                                    </p>
                                                </div>
                                                {selectedSpkId === spk.id && (
                                                    <span className="rounded-full bg-red-100 px-2 py-0.5 text-xs font-bold text-red-600">
                                                        {totalDefectPO}
                                                    </span>
                                                )}
                                            </div>
                                        </button>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Footer Total */}
                    <div className="mt-6 rounded-lg border-t-4 border-red-500 bg-white p-4 text-center shadow-sm">
                        <h3 className="text-lg font-bold text-red-600">
                            TOTAL CACAT (PO INI): {totalDefectPO}
                        </h3>
                        <p className="mt-1 text-sm text-gray-500">
                            Total seluruh PO hari ini:{' '}
                            <span className="font-bold">{totalDefectAll}</span>
                        </p>
                    </div>
                </div>
            </div>
        </>
    );
}
