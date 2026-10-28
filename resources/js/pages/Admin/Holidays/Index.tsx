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
            onSuccess: () => reset()
        });
    };

    const handleImportNational = () => {
        if (confirm('Import semua hari libur nasional tahun ini? Data yang sudah ada tidak akan diduplikasi.')) {
            router.post('/admin/holidays/import-national', {
                year: new Date().getFullYear()
            });
        }
    };

    return (
        <>
            <Head title="Manajemen Tanggal Merah" />
            <div className="py-8 max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">

                {/* Form Tambah Manual & Tombol Import */}
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <div className="flex justify-between items-center mb-4">
                        <h2 className="font-semibold text-xl text-gray-800">Tambah Tanggal Merah Manual</h2>
                        <button
                            onClick={handleImportNational}
                            type="button"
                            className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm font-medium flex items-center gap-2"
                        >
                            📥 Import Libur Nasional {new Date().getFullYear()}
                        </button>
                    </div>

                    <form onSubmit={submit} className="flex gap-4 items-end">
                        <div>
                            <label className="block text-sm font-medium mb-1">Tanggal</label>
                            <input
                                type="date"
                                value={data.date}
                                onChange={e => setData('date', e.target.value)}
                                className="border p-2 rounded"
                                required
                            />
                            {errors.date && <p className="text-red-500 text-sm mt-1">{errors.date}</p>}
                        </div>
                        <div className="flex-1">
                            <label className="block text-sm font-medium mb-1">Nama Hari Raya / Libur</label>
                            <input
                                type="text"
                                value={data.name}
                                onChange={e => setData('name', e.target.value)}
                                className="w-full border p-2 rounded"
                                placeholder="Contoh: Cuti Bersama Idul Fitri"
                                required
                            />
                            {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name}</p>}
                        </div>
                        <button
                            type="submit"
                            disabled={processing}
                            className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded disabled:opacity-50"
                        >
                            {processing ? 'Menyimpan...' : 'Simpan'}
                        </button>
                    </form>
                </div>

                {/* Tabel Daftar Tanggal Merah Tersimpan */}
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h3 className="font-semibold text-lg mb-4 text-gray-800">Daftar Tanggal Merah Tersimpan</h3>
                    <table className="w-full text-left text-sm border-collapse">
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
                                <tr key={h.id} className="border-b hover:bg-gray-50">
                                    <td className="p-3 font-medium">{h.date}</td>
                                    <td className="p-3">{h.name}</td>
                                    <td className="p-3">
                                        {h.is_national ? (
                                            <span className="bg-blue-100 text-blue-700 px-2 py-1 rounded text-xs">Nasional</span>
                                        ) : (
                                            <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">Manual</span>
                                        )}
                                    </td>
                                    <td className="p-3">
                                        <button
                                            onClick={() => {
                                                if (confirm('Hapus tanggal merah ini?')) {
                                                    router.delete(`/admin/holidays/${h.id}`);
                                                }
                                            }}
                                            className="text-red-600 hover:underline font-medium"
                                        >
                                            Hapus
                                        </button>
                                    </td>
                                </tr>
                            ))}
                            {localHolidays.length === 0 && (
                                <tr>
                                    <td colSpan={4} className="p-6 text-center text-gray-500">
                                        Belum ada data tanggal merah. Silakan tambah manual atau import dari kalender nasional.
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