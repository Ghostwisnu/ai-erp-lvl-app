import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

export default function Import() {
    const { data, setData, post, processing, errors } = useForm({
        file: null as File | null,
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/admin/employees/import/preview');
    };

    return (
        <>
            <Head title="Impor Data Karyawan" />
            <div className="mx-auto max-w-3xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    {/* Header */}
                    <div className="mb-6 flex items-center justify-between">
                        <h2 className="text-xl font-semibold text-gray-800">
                            Unggah Data Karyawan
                        </h2>
                        <Link
                            href="/admin/employees"
                            className="font-medium text-blue-600 hover:underline"
                        >
                            &larr; Kembali
                        </Link>
                    </div>

                    {/* Info dan tombol unduh templat */}
                    <div className="mb-6 flex flex-col items-start justify-between gap-4 rounded-lg border border-blue-200 bg-blue-50 p-4 md:flex-row md:items-center">
                        <div>
                            <h3 className="mb-1 font-bold text-blue-800">
                                Belum punya format file?
                            </h3>
                            <p className="text-sm text-blue-700">
                                Unduh template Excel terlebih dahulu. Kolom
                                dengan tanda <b>(*)</b> wajib diisi. Tanggal
                                bergabung dapat diisi dengan format YYYY-MM-DD
                                atau sebagai tanggal Excel.
                            </p>
                        </div>
                        <a
                            href="/admin/employees/import/template"
                            className="inline-block rounded bg-green-600 px-4 py-2 text-sm font-medium whitespace-nowrap text-white shadow hover:bg-green-700"
                        >
                            📥 Unduh Templat
                        </a>
                    </div>

                    {/* Form Upload */}
                    <form onSubmit={submit} className="space-y-4">
                        <div>
                            <label className="mb-1 block text-sm font-medium text-gray-700">
                                Pilih File Excel (xlsx, xls, csv)
                            </label>
                            <input
                                type="file"
                                accept=".xlsx, .xls, .csv"
                                onChange={(e) =>
                                    setData('file', e.target.files?.[0] || null)
                                }
                                className="w-full rounded-md border border-gray-300 p-2 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                required
                            />
                            {errors.file && (
                                <p className="mt-1 text-sm text-red-500">
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
                                    ? 'Membaca File...'
                                    : 'Unggah dan Pratinjau Data'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}
