import { Head, Link, useForm } from '@inertiajs/react';

type Change = { label: string; old: string | null; new: string };

type PreviewRow = {
    row_number: number;
    employee_code: string;
    full_name: string | null;
    changes: Record<string, Change> | Change[];
    status: string;
    is_valid: boolean;
};

export default function BulkUpdatePreview({
    previewData,
}: {
    previewData: PreviewRow[];
}) {
    const { post, processing } = useForm();
    const allRowsValid =
        previewData.length > 0 && previewData.every((row) => row.is_valid);
    const changedCount = previewData.filter(
        (row) => Object.keys(row.changes).length > 0,
    ).length;

    return (
        <>
            <Head title="Pratinjau Update Massal Karyawan" />
            <div className="mx-auto max-w-6xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <div>
                            <h2 className="text-xl font-semibold">
                                Pratinjau Update Data Karyawan
                            </h2>
                            <p className="mt-1 text-sm text-gray-600">
                                {previewData.filter((r) => r.is_valid).length}{' '}
                                dari {previewData.length} baris valid,{' '}
                                {changedCount} karyawan akan diubah. Tidak ada
                                data yang disimpan jika ada baris yang gagal
                                validasi.
                            </p>
                        </div>
                        <Link
                            href="/admin/employees/bulk-update"
                            className="text-sm text-blue-600 hover:underline"
                        >
                            &larr; Unggah ulang
                        </Link>
                    </div>

                    <div className="overflow-x-auto">
                        <table className="w-full border-collapse border text-left text-sm">
                            <thead>
                                <tr className="border-b bg-gray-100">
                                    <th className="border-r p-2">Baris</th>
                                    <th className="border-r p-2">Kode</th>
                                    <th className="border-r p-2">Nama</th>
                                    <th className="border-r p-2">Perubahan</th>
                                    <th className="border-r p-2">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {previewData.map((row) => (
                                    <tr
                                        key={`${row.row_number}-${row.employee_code}`}
                                        className={`border-b align-top ${row.is_valid ? '' : 'bg-red-50'}`}
                                    >
                                        <td className="border-r p-2">
                                            {row.row_number}
                                        </td>
                                        <td className="border-r p-2">
                                            {row.employee_code || '-'}
                                        </td>
                                        <td className="border-r p-2">
                                            {row.full_name ?? '-'}
                                        </td>
                                        <td className="border-r p-2">
                                            {Object.values(row.changes).map(
                                                (change) => (
                                                    <div key={change.label}>
                                                        <b>{change.label}:</b>{' '}
                                                        <span className="text-gray-500 line-through">
                                                            {change.old || '-'}
                                                        </span>{' '}
                                                        &rarr; {change.new}
                                                    </div>
                                                ),
                                            )}
                                        </td>
                                        <td
                                            className={`border-r p-2 ${row.is_valid ? 'text-green-700' : 'font-medium text-red-700'}`}
                                        >
                                            {row.status}
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    <div className="mt-6 flex justify-end">
                        <button
                            onClick={() =>
                                post('/admin/employees/bulk-update/store')
                            }
                            disabled={processing || !allRowsValid}
                            className="rounded bg-green-600 px-6 py-2 font-bold text-white hover:bg-green-700 disabled:cursor-not-allowed disabled:opacity-50"
                        >
                            {processing
                                ? 'Menyimpan...'
                                : `Konfirmasi dan Simpan (${changedCount} karyawan)`}
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}
