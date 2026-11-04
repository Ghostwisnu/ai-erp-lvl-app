import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

export default function SalaryImport() {
    const { setData, post, processing, errors } = useForm({
        file: null as File | null,
    });

    const submit = (event: FormEvent) => {
        event.preventDefault();
        post('/admin/employees/salary-import/preview');
    };

    return (
        <>
            <Head title="Impor Gaji Karyawan" />
            <div className="mx-auto max-w-3xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <h2 className="text-xl font-semibold text-gray-800">
                            Unggah Data Gaji
                        </h2>
                        <Link
                            href="/admin/employees"
                            className="font-medium text-blue-600 hover:underline"
                        >
                            &larr; Kembali
                        </Link>
                    </div>

                    <div className="mb-6 rounded-lg border border-blue-200 bg-blue-50 p-4">
                        <p className="font-bold text-blue-800">
                            Gunakan template impor gaji
                        </p>
                        <p className="mt-1 text-sm text-blue-700">
                            Isi kolom <b>kode_karyawan</b> dan{' '}
                            <b>gaji_pokok_baru</b>. Nilai gaji diisi angka,
                            misalnya 4500000, tanpa pemisah ribuan. Semua baris
                            akan divalidasi sebelum perubahan disimpan.
                        </p>
                        <a
                            href="/admin/employees/salary-import/template"
                            className="mt-3 inline-block rounded bg-green-600 px-4 py-2 text-sm font-medium text-white shadow hover:bg-green-700"
                        >
                            Unduh Template Excel
                        </a>
                    </div>

                    <form onSubmit={submit} className="space-y-4">
                        <div>
                            <label className="mb-1 block text-sm font-medium text-gray-700">
                                File Excel atau CSV (maksimal 2 MB)
                            </label>
                            <input
                                type="file"
                                accept=".xlsx,.xls,.csv"
                                onChange={(event) =>
                                    setData(
                                        'file',
                                        event.target.files?.[0] ?? null,
                                    )
                                }
                                className="w-full rounded-md border border-gray-300 p-2 shadow-sm"
                                required
                            />
                            {errors.file && (
                                <p className="mt-1 text-sm text-red-600">
                                    {errors.file}
                                </p>
                            )}
                        </div>

                        <div className="flex justify-end border-t pt-4">
                            <button
                                type="submit"
                                disabled={processing}
                                className="rounded bg-blue-600 px-6 py-2 font-medium text-white hover:bg-blue-700 disabled:opacity-50"
                            >
                                {processing
                                    ? 'Membaca file...'
                                    : 'Unggah dan Pratinjau'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}
