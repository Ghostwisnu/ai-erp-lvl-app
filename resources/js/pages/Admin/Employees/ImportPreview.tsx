import { Head, Link, useForm } from '@inertiajs/react';

export default function ImportPreview({ previewData }: any) {
    const { post, processing } = useForm();

    const handleConfirm = () => {
        post('/admin/employees/import/store');
    };

    const validCount = previewData.filter((d: any) => d.is_valid).length;

    return (
        <>
            <Head title="Konfirmasi Impor" />
            <div className="mx-auto max-w-5xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <div>
                            <h2 className="text-xl font-semibold">
                                Konfirmasi Impor Data
                            </h2>
                            <p className="mt-1 text-sm text-gray-500">
                                Ditemukan {validCount} data yang siap diimport.
                            </p>
                        </div>
                        <Link
                            href="/admin/employees/import"
                            className="text-sm text-blue-600"
                        >
                            &larr; Unggah Ulang
                        </Link>
                    </div>

                    <div className="mb-6 overflow-x-auto">
                        <table className="w-full border-collapse border text-left text-sm">
                            <thead>
                                <tr className="border-b bg-gray-100">
                                    <th className="border-r p-2">Nama</th>
                                    <th className="border-r p-2">
                                        Kode Karyawan
                                    </th>
                                    <th className="border-r p-2">
                                        Tanggal Bergabung
                                    </th>
                                    <th className="border-r p-2">Departemen</th>
                                    <th className="border-r p-2">Jabatan</th>
                                    <th className="border-r p-2">Peran</th>
                                    <th className="border-r p-2">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {previewData.map((row: any, i: number) => (
                                    <tr
                                        key={i}
                                        className={`border-b ${!row.is_valid ? 'bg-red-50' : ''}`}
                                    >
                                        <td className="border-r p-2">
                                            {row.name}
                                        </td>
                                        <td className="border-r p-2">
                                            {row.employee_code}
                                        </td>
                                        <td className="border-r p-2">
                                            {row.join_date || '-'}
                                        </td>
                                        <td className="border-r p-2">
                                            {row.department}
                                        </td>
                                        <td className="border-r p-2">
                                            {row.position}
                                        </td>
                                        <td className="border-r p-2 capitalize">
                                            {row.role}
                                        </td>
                                        <td
                                            className={`border-r p-2 font-bold ${row.is_valid ? 'text-green-600' : 'text-red-600'}`}
                                        >
                                            {row.status}
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    <div className="flex justify-end">
                        <button
                            onClick={handleConfirm}
                            disabled={processing || validCount === 0}
                            className="rounded bg-green-600 px-6 py-2 font-bold text-white hover:bg-green-700 disabled:opacity-50"
                        >
                            {processing
                                ? 'Menyimpan...'
                                : `Konfirmasi & Simpan (${validCount} Data)`}
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}
