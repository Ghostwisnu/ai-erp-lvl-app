import { Head, useForm, router } from '@inertiajs/react';
import { FormEvent } from 'react';

export default function Index({ localHolidays }: any) {
    const { data, setData, post, processing, errors, reset } = useForm({
        date: '',
        name: '',
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/admin/holidays', {
            onSuccess: () => reset(),
        });
    };

    const handleImportNational = () => {
        if (
            confirm(
                'Import semua hari libur nasional tahun ini? Data yang sudah ada tidak akan diduplikasi.',
            )
        ) {
            router.post('/admin/holidays/import-national', {
                year: new Date().getFullYear(),
            });
        }
    };

    return (
        <>
            <Head title="Manajemen Tanggal Merah" />
            <div className="mx-auto max-w-7xl space-y-6 py-8 sm:px-6 lg:px-8">
                {/* Form Tambah Manual & Tombol Import */}
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-4 flex items-center justify-between">
                        <h2 className="text-xl font-semibold text-gray-800">
                            Tambah Tanggal Merah Manual
                        </h2>
                        <button
                            onClick={handleImportNational}
                            type="button"
                            className="flex items-center gap-2 rounded-md bg-green-600 px-4 py-2 text-sm font-medium text-white hover:bg-green-700"
                        >
                            📥 Import Libur Nasional {new Date().getFullYear()}
                        </button>
                    </div>

                    <form onSubmit={submit} className="flex items-end gap-4">
                        <div>
                            <label className="mb-1 block text-sm font-medium">
                                Tanggal
                            </label>
                            <input
                                type="date"
                                value={data.date}
                                onChange={(e) =>
                                    setData('date', e.target.value)
                                }
                                className="rounded border p-2"
                                required
                            />
                            {errors.date && (
                                <p className="mt-1 text-sm text-red-500">
                                    {errors.date}
                                </p>
                            )}
                        </div>
                        <div className="flex-1">
                            <label className="mb-1 block text-sm font-medium">
                                Nama Hari Raya / Libur
                            </label>
                            <input
                                type="text"
                                value={data.name}
                                onChange={(e) =>
                                    setData('name', e.target.value)
                                }
                                className="w-full rounded border p-2"
                                placeholder="Contoh: Cuti Bersama Idul Fitri"
                                required
                            />
                            {errors.name && (
                                <p className="mt-1 text-sm text-red-500">
                                    {errors.name}
                                </p>
                            )}
                        </div>
                        <button
                            type="submit"
                            disabled={processing}
                            className="rounded bg-blue-600 px-4 py-2 text-white hover:bg-blue-700 disabled:opacity-50"
                        >
                            {processing ? 'Menyimpan...' : 'Simpan'}
                        </button>
                    </form>
                </div>

                {/* Tabel Daftar Tanggal Merah Tersimpan */}
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <h3 className="mb-4 text-lg font-semibold text-gray-800">
                        Daftar Tanggal Merah Tersimpan
                    </h3>
                    <table className="w-full border-collapse text-left text-sm">
                        <thead>
                            <tr className="border-b bg-gray-50">
                                <th className="p-3">Tanggal</th>
                                <th className="p-3">Nama Hari Raya</th>
                                <th className="p-3">Tipe</th>
                                <th className="p-3">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {localHolidays.map((h: any) => (
                                <tr
                                    key={h.id}
                                    className="border-b hover:bg-gray-50"
                                >
                                    <td className="p-3 font-medium">
                                        {h.date}
                                    </td>
                                    <td className="p-3">{h.name}</td>
                                    <td className="p-3">
                                        {h.is_national ? (
                                            <span className="rounded bg-blue-100 px-2 py-1 text-xs text-blue-700">
                                                Nasional
                                            </span>
                                        ) : (
                                            <span className="rounded bg-gray-100 px-2 py-1 text-xs text-gray-700">
                                                Manual
                                            </span>
                                        )}
                                    </td>
                                    <td className="p-3">
                                        <button
                                            onClick={() => {
                                                if (
                                                    confirm(
                                                        'Hapus tanggal merah ini?',
                                                    )
                                                ) {
                                                    router.delete(
                                                        `/admin/holidays/${h.id}`,
                                                    );
                                                }
                                            }}
                                            className="font-medium text-red-600 hover:underline"
                                        >
                                            Hapus
                                        </button>
                                    </td>
                                </tr>
                            ))}
                            {localHolidays.length === 0 && (
                                <tr>
                                    <td
                                        colSpan={4}
                                        className="p-6 text-center text-gray-500"
                                    >
                                        Belum ada data tanggal merah. Silakan
                                        tambah manual atau import dari kalender
                                        nasional.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </>
    );
}
