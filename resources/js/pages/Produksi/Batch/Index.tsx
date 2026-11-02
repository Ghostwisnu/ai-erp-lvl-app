import { Head, Link, useForm, router } from '@inertiajs/react';

const departmentLabels: Record<string, string> = {
    cutting: 'Pemotongan',
    sewing: 'Penjahitan',
    lasting: 'Pemasangan sol',
    cementing: 'Pengeleman',
    injection: 'Injeksi',
    finishing: 'Penyelesaian',
    packing: 'Pengemasan',
};

const batchStatusLabels: Record<string, string> = {
    pending: 'Menunggu',
    in_progress: 'Sedang berlangsung',
    completed: 'Selesai',
};

export default function Index({ spk }: any) {
    const details = spk?.details || [];
    const hasBatches = spk?.batches && spk.batches.length > 0;

    // Siapkan state untuk form split
    const { data, setData, post, processing, errors } = useForm({
        batches: [
            {
                batch_code: 'B1',
                sizes: details.map((d: any) => ({
                    size_name: d.size_name,
                    qty: 0,
                })),
            },
        ],
    });

    const handleAddBatch = () => {
        const newBatch = {
            batch_code: `B${data.batches.length + 1}`,
            sizes: details.map((d: any) => ({
                size_name: d.size_name,
                qty: 0,
            })),
        };
        setData('batches', [...data.batches, newBatch]);
    };

    const handleRemoveBatch = (index: number) => {
        const newBatches = [...data.batches];
        newBatches.splice(index, 1);
        setData('batches', newBatches);
    };

    const updateSizeQty = (
        batchIndex: number,
        sizeIndex: number,
        val: number,
    ) => {
        const newBatches = [...data.batches];
        newBatches[batchIndex].sizes[sizeIndex].qty = val;
        setData('batches', newBatches);
    };

    // Validasi apakah total size di semua batch sudah sama dengan SPK
    const isSizeValid = details.every((size: any) => {
        const totalInBatches = data.batches.reduce((sum, batch) => {
            const sizeInBatch = batch.sizes.find(
                (s: any) => s.size_name === size.size_name,
            );
            return sum + (sizeInBatch ? sizeInBatch.qty : 0);
        }, 0);
        return totalInBatches === size.qty;
    });

    const submitSplit = (e: React.FormEvent) => {
        e.preventDefault();
        post(`/produksi/spks/${spk.id}/batches/split`);
    };

    return (
        <>
            <Head title={`Kelompok Produksi - ${spk.po_number}`} />
            <div className="mx-auto max-w-7xl space-y-6 py-8 sm:px-6 lg:px-8">
                <div className="flex items-center justify-between rounded-lg border bg-white p-6 shadow-sm">
                    <div>
                        <h1 className="text-xl font-bold">
                            Kelompok Produksi: {spk.po_number}
                        </h1>
                        <p className="mt-1 text-sm text-gray-500">
                            Merek: {spk.brand?.name}
                        </p>
                    </div>
                    <div className="space-x-4">
                        <Link
                            href="/produksi/spk-schedules"
                            className="font-medium text-green-600 hover:underline"
                        >
                            Lihat Jadwal Produksi (PPS)
                        </Link>
                        <Link
                            href="/produksi/spks"
                            className="text-blue-600 hover:underline"
                        >
                            &larr; Kembali
                        </Link>
                    </div>
                </div>

                {!hasBatches ? (
                    <div className="rounded-lg border bg-white p-6 shadow-sm">
                        <h2 className="mb-4 text-lg font-semibold">
                            Bagi SPK Berdasarkan Ukuran
                        </h2>
                        <form onSubmit={submitSplit} className="space-y-6">
                            <div className="overflow-x-auto">
                                <table className="w-full border text-left text-sm">
                                    <thead className="bg-gray-200">
                                        <tr>
                                            <th className="border p-2">
                                                Ukuran
                                            </th>
                                            <th className="border p-2 text-center">
                                                Jumlah SPK
                                            </th>
                                            {data.batches.map(
                                                (b: any, bIdx: number) => (
                                                    <th
                                                        key={bIdx}
                                                        className="border bg-blue-50 p-2 text-center"
                                                    >
                                                        <div className="flex flex-col items-center">
                                                            <input
                                                                type="text"
                                                                value={
                                                                    b.batch_code
                                                                }
                                                                onChange={(
                                                                    e,
                                                                ) => {
                                                                    const newBatches =
                                                                        [
                                                                            ...data.batches,
                                                                        ];
                                                                    newBatches[
                                                                        bIdx
                                                                    ].batch_code =
                                                                        e.target.value;
                                                                    setData(
                                                                        'batches',
                                                                        newBatches,
                                                                    );
                                                                }}
                                                                className="mb-1 w-20 rounded border p-1 text-center font-bold"
                                                            />
                                                            {/* PERBAIKAN TYPE SCRIPT DI SINI */}
                                                            <span className="text-xs text-gray-500">
                                                                Jumlah:{' '}
                                                                {b.sizes.reduce(
                                                                    (
                                                                        s: number,
                                                                        x: any,
                                                                    ) =>
                                                                        s +
                                                                        x.qty,
                                                                    0,
                                                                )}
                                                            </span>
                                                            {data.batches
                                                                .length > 1 && (
                                                                <button
                                                                    type="button"
                                                                    onClick={() =>
                                                                        handleRemoveBatch(
                                                                            bIdx,
                                                                        )
                                                                    }
                                                                    className="mt-1 text-xs text-red-500"
                                                                >
                                                                    Hapus
                                                                </button>
                                                            )}
                                                        </div>
                                                    </th>
                                                ),
                                            )}
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {details.map(
                                            (detail: any, sIdx: number) => (
                                                <tr
                                                    key={detail.id}
                                                    className="border-b hover:bg-gray-50"
                                                >
                                                    <td className="border p-2 font-bold">
                                                        {detail.size_name}
                                                    </td>
                                                    <td className="border p-2 text-center">
                                                        {detail.qty}
                                                    </td>
                                                    {data.batches.map(
                                                        (
                                                            batch: any,
                                                            bIdx: number,
                                                        ) => {
                                                            const sizeInBatch =
                                                                batch.sizes.find(
                                                                    (s: any) =>
                                                                        s.size_name ===
                                                                        detail.size_name,
                                                                );
                                                            const qty =
                                                                sizeInBatch
                                                                    ? sizeInBatch.qty
                                                                    : 0;
                                                            return (
                                                                <td
                                                                    key={bIdx}
                                                                    className="border p-2 text-center"
                                                                >
                                                                    <input
                                                                        type="number"
                                                                        min="0"
                                                                        value={
                                                                            qty
                                                                        }
                                                                        onChange={(
                                                                            e,
                                                                        ) =>
                                                                            updateSizeQty(
                                                                                bIdx,
                                                                                sIdx,
                                                                                Number(
                                                                                    e
                                                                                        .target
                                                                                        .value,
                                                                                ),
                                                                            )
                                                                        }
                                                                        className="w-20 rounded border p-1 text-center"
                                                                    />
                                                                </td>
                                                            );
                                                        },
                                                    )}
                                                </tr>
                                            ),
                                        )}
                                        {/* Baris Total */}
                                        <tr className="bg-gray-100 font-bold">
                                            <td className="border p-2">
                                                TOTAL
                                            </td>
                                            <td className="border p-2 text-center">
                                                {details.reduce(
                                                    (s: number, d: any) =>
                                                        s + d.qty,
                                                    0,
                                                )}
                                            </td>
                                            {data.batches.map(
                                                (batch: any, bIdx: number) => (
                                                    <td
                                                        key={bIdx}
                                                        className="border p-2 text-center"
                                                    >
                                                        {/* PERBAIKAN TYPE SCRIPT DI SINI JUGA */}
                                                        {batch.sizes.reduce(
                                                            (
                                                                s: number,
                                                                x: any,
                                                            ) => s + x.qty,
                                                            0,
                                                        )}
                                                    </td>
                                                ),
                                            )}
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <button
                                type="button"
                                onClick={handleAddBatch}
                                className="text-sm font-medium text-blue-600"
                            >
                                + Tambah Kelompok
                            </button>

                            {!isSizeValid && (
                                <div className="rounded bg-red-100 p-3 text-sm font-bold text-red-700">
                                    Jumlah per ukuran belum sesuai dengan SPK
                                    utama. Pastikan setiap ukuran telah
                                    dialokasikan dengan benar.
                                </div>
                            )}

                            <div className="flex justify-end border-t pt-4">
                                <button
                                    type="submit"
                                    disabled={processing || !isSizeValid}
                                    className="rounded bg-blue-600 px-6 py-2 text-white disabled:opacity-50"
                                >
                                    Bagi Menjadi Kelompok
                                </button>
                            </div>
                        </form>
                    </div>
                ) : (
                    <div className="space-y-4">
                        <div className="flex items-center justify-between">
                            <h2 className="text-lg font-semibold">
                                Daftar Batch ({spk.batches.length})
                            </h2>
                            <button
                                onClick={() => {
                                    if (
                                        confirm(
                                            'Gabungkan semua batch kembali?',
                                        )
                                    )
                                        router.post(
                                            `/produksi/spks/${spk.id}/batches/merge`,
                                        );
                                }}
                                className="rounded bg-red-600 px-4 py-2 text-sm text-white"
                            >
                                Gabungkan
                            </button>
                        </div>
                        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                            {spk.batches.map((batch: any) => (
                                <div
                                    key={batch.id}
                                    className="rounded-lg border-l-4 border-blue-500 bg-white p-4 shadow-sm"
                                >
                                    <div className="mb-2 flex items-start justify-between">
                                        <div>
                                            <h3 className="text-lg font-bold">
                                                {spk.po_number}-
                                                {batch.batch_code}
                                            </h3>
                                            <p className="text-sm text-gray-500">
                                                {batch.qty} Pasang
                                            </p>
                                        </div>
                                        <span
                                            className={`rounded bg-gray-100 px-2 py-1 text-xs font-bold text-gray-700 uppercase`}
                                        >
                                            {batchStatusLabels[batch.status] ??
                                                batch.status}
                                        </span>
                                    </div>

                                    <div className="mb-4 flex flex-wrap gap-1">
                                        {batch.sizes &&
                                            batch.sizes.map(
                                                (s: any, i: number) =>
                                                    s.qty > 0 && (
                                                        <span
                                                            key={i}
                                                            className="rounded border bg-gray-100 px-2 py-1 text-[10px]"
                                                        >
                                                            {s.size_name}:{' '}
                                                            {s.qty}
                                                        </span>
                                                    ),
                                            )}
                                    </div>

                                    <p className="mb-2 text-sm font-medium">
                                        Posisi:{' '}
                                        <span className="text-blue-600 uppercase">
                                            {batch.current_department
                                                ? (departmentLabels[
                                                      batch.current_department
                                                  ] ?? batch.current_department)
                                                : 'Belum dimulai'}
                                        </span>
                                    </p>
                                    <form
                                        onSubmit={(e) => {
                                            e.preventDefault();
                                            const formData = new FormData(
                                                e.currentTarget,
                                            );
                                            router.post(
                                                `/produksi/batches/${batch.id}/track`,
                                                {
                                                    department:
                                                        formData.get(
                                                            'department',
                                                        ),
                                                    start_date:
                                                        formData.get(
                                                            'start_date',
                                                        ),
                                                },
                                            );
                                        }}
                                        className="flex gap-2 text-sm"
                                    >
                                        <select
                                            name="department"
                                            className="rounded border p-1"
                                            required
                                            defaultValue={
                                                batch.current_department || ''
                                            }
                                        >
                                            <option value="">Pilih Departemen</option>
                                            <option value="cutting">
                                                Pemotongan
                                            </option>
                                            <option value="sewing">
                                                Penjahitan
                                            </option>
                                            <option value="lasting">
                                                Pemasangan sol
                                            </option>
                                            <option value="cementing">
                                                Pengeleman
                                            </option>
                                            <option value="injection">
                                                Injeksi
                                            </option>
                                            <option value="finishing">
                                                Penyelesaian
                                            </option>
                                            <option value="packing">
                                                Pengemasan
                                            </option>
                                        </select>
                                        <input
                                            type="date"
                                            name="start_date"
                                            className="rounded border p-1"
                                            required
                                            defaultValue={
                                                new Date()
                                                    .toISOString()
                                                    .split('T')[0]
                                            }
                                        />
                                        <button
                                            type="submit"
                                            className="rounded bg-gray-800 px-3 py-1 text-white"
                                        >
                                            Atur
                                        </button>
                                    </form>
                                </div>
                            ))}
                        </div>
                    </div>
                )}
            </div>
        </>
    );
}
