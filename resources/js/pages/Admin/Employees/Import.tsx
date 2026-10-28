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
            <Head title="Import Data Karyawan" />
            <div className="py-8 max-w-3xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">

                    {/* Header */}
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="font-semibold text-xl text-gray-800">Upload Data Karyawan</h2>
                        <Link href="/admin/employees" className="text-blue-600 hover:underline font-medium">
                            &larr; Kembali
                        </Link>
                    </div>

                    {/* Info & Tombol Download Template */}
                    <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                        <div>
                            <h3 className="font-bold text-blue-800 mb-1">Belum punya format file?</h3>
                            <p className="text-sm text-blue-700">
                                Unduh template Excel terlebih dahulu. Kolom dengan tanda <b>(*)</b> wajib diisi.
                            </p>
                        </div>
                        <a
                            href="/admin/employees/import/template"
                            className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded shadow font-medium text-sm whitespace-nowrap inline-block"
                        >
                            📥 Download Template
                        </a>
                    </div>

                    {/* Form Upload */}
                    <form onSubmit={submit} className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">
                                Pilih File Excel (xlsx, xls, csv)
                            </label>
                            <input
                                type="file"
                                accept=".xlsx, .xls, .csv"
                                onChange={e => setData('file', e.target.files?.[0] || null)}
                                className="w-full border-gray-300 rounded-md shadow-sm p-2 border focus:border-indigo-500 focus:ring-indigo-500"
                                required
                            />
                            {errors.file && <p className="text-red-500 text-sm mt-1">{errors.file}</p>}
                        </div>

                        <div className="flex justify-end pt-4 border-t">
                            <button
                                type="submit"
                                disabled={processing}
                                className="px-6 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded font-medium disabled:opacity-50"
                            >
                                {processing ? 'Membaca File...' : 'Upload & Preview Data'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}