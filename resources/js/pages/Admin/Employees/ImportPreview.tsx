import { Head, Link, useForm } from '@inertiajs/react';

export default function ImportPreview({ previewData }: any) {
    const { post, processing } = useForm();

    const handleConfirm = () => {
        post('/admin/employees/import/store');
    };

    const validCount = previewData.filter((d: any) => d.is_valid).length;

    return (
        <>
            <Head title="Konfirmasi Import" />
            <div className="py-8 max-w-5xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <div className="flex justify-between items-center mb-6">
                        <div>
                            <h2 className="font-semibold text-xl">Konfirmasi Import Data</h2>
                            <p className="text-sm text-gray-500 mt-1">Ditemukan {validCount} data yang siap diimport.</p>
                        </div>
                        <Link href="/admin/employees/import" className="text-blue-600 text-sm">&larr; Upload Ulang</Link>
                    </div>

                    <div className="overflow-x-auto mb-6">
                        <table className="w-full text-left border-collapse border text-sm">
                            <thead>
                                <tr className="bg-gray-100 border-b">
                                    <th className="p-2 border-r">Nama</th>
                                    <th className="p-2 border-r">Email</th>
                                    <th className="p-2 border-r">NIK</th>
                                    <th className="p-2 border-r">Departemen</th>
                                    <th className="p-2 border-r">Role</th>
                                    <th className="p-2 border-r">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {previewData.map((row: any, i: number) => (
                                    <tr key={i} className={`border-b ${!row.is_valid ? 'bg-red-50' : ''}`}>
                                        <td className="p-2 border-r">{row.name}</td>
                                        <td className="p-2 border-r">{row.email}</td>
                                        <td className="p-2 border-r">{row.employee_code}</td>
                                        <td className="p-2 border-r">{row.department}</td>
                                        <td className="p-2 border-r capitalize">{row.role}</td>
                                        <td className={`p-2 border-r font-bold ${row.is_valid ? 'text-green-600' : 'text-red-600'}`}>
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
                            className="px-6 py-2 bg-green-600 hover:bg-green-700 text-white rounded font-bold disabled:opacity-50"
                        >
                            {processing ? 'Menyimpan...' : `Konfirmasi & Simpan (${validCount} Data)`}
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}