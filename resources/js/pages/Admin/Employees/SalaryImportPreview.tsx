import { Head, Link, useForm } from '@inertiajs/react';

type SalaryPreviewRow = {
    row_number: number;
    employee_code: string;
    full_name: string | null;
    current_salary: number | string | null;
    new_salary: number | null;
    status: string;
    is_valid: boolean;
};

function formatCurrency(value: number | string | null) {
    if (value === null) return '-';

    return new Intl.NumberFormat('id-ID', {
        maximumFractionDigits: 2,
    }).format(Number(value));
}

export default function SalaryImportPreview({
    previewData,
}: {
    previewData: SalaryPreviewRow[];
}) {
    const { post, processing } = useForm();
    const allRowsValid =
        previewData.length > 0 && previewData.every((row) => row.is_valid);

    return (
        <>
            <Head title="Pratinjau Impor Gaji" />
            <div className="mx-auto max-w-6xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <div>
                            <h2 className="text-xl font-semibold">
                                Pratinjau Perubahan Gaji
                            </h2>
                            <p className="mt-1 text-sm text-gray-600">
                                {
                                    previewData.filter((row) => row.is_valid)
                                        .length
                                }{' '}
                                dari {previewData.length} baris valid. Gaji
                                tidak akan diubah jika ada baris yang gagal
                                validasi.
                            </p>
                        </div>
                        <Link
                            href="/admin/employees/salary-import"
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
                                    <th className="border-r p-2">
                                        Gaji saat ini
                                    </th>
                                    <th className="border-r p-2">Gaji baru</th>
                                    <th className="border-r p-2">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {previewData.map((row) => (
                                    <tr
                                        key={`${row.row_number}-${row.employee_code}`}
                                        className={`border-b ${row.is_valid ? '' : 'bg-red-50'}`}
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
                                            {formatCurrency(row.current_salary)}
                                        </td>
                                        <td className="border-r p-2">
                                            {formatCurrency(row.new_salary)}
                                        </td>
                                        <td
                                            className={`border-r p-2 ${row.is_valid ? 'text-green-700' : 'font-medium text-red-700'}`}
                                        >
                                            {row.status}
                                        </td>
                                    </tr>
                                ))}
                                {previewData.length === 0 && (
                                    <tr>
                                        <td
                                            colSpan={6}
                                            className="p-4 text-center text-gray-600"
                                        >
                                            Tidak ada baris data pada file.
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>

                    <div className="mt-6 flex justify-end">
                        <button
                            onClick={() =>
                                post('/admin/employees/salary-import/store')
                            }
                            disabled={processing || !allRowsValid}
                            className="rounded bg-green-600 px-6 py-2 font-bold text-white hover:bg-green-700 disabled:cursor-not-allowed disabled:opacity-50"
                        >
                            {processing
                                ? 'Menyimpan...'
                                : `Konfirmasi dan Simpan (${previewData.length} baris)`}
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}
