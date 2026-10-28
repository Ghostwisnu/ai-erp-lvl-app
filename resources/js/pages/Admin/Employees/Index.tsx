import { Head, Link } from '@inertiajs/react';
import { useState, useMemo } from 'react';

export default function Index({ employees, departments = [] }: any) {
    // State untuk Filter
    const [search, setSearch] = useState('');
    const [selectedDept, setSelectedDept] = useState('');

    // Logika Filter
    const filteredEmployees = useMemo(() => {
        // Karena employees pakai pagination, kita filter 'data'-nya saja
        const data = employees.data || [];

        return data.filter((emp: any) => {
            const matchSearch =
                emp.full_name.toLowerCase().includes(search.toLowerCase()) ||
                emp.employee_code.toLowerCase().includes(search.toLowerCase());

            const matchDept = selectedDept ? emp.department === selectedDept : true;

            return matchSearch && matchDept;
        });
    }, [employees.data, search, selectedDept]);

    return (
        <>
            <Head title="Data Karyawan" />
            <div className="py-12">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">

                        {/* Header & Tombol Tambah */}
                        <div className="flex justify-between items-center mb-6">
                            <h2 className="font-semibold text-xl text-gray-800">Data Karyawan</h2>
                            <Link href="/admin/employees/import" className="bg-green-600 text-white px-4 py-2 rounded-md text-sm">
                                Import Excel
                            </Link>
                            <Link href="/admin/employees/create" className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm">
                                + Tambah Karyawan
                            </Link>
                        </div>

                        {/* Fitur Filter */}
                        <div className="flex flex-col md:flex-row gap-4 mb-4">
                            <input
                                type="text"
                                placeholder="Cari Nama atau Kode..."
                                value={search}
                                onChange={(e) => setSearch(e.target.value)}
                                className="border p-2 rounded w-full md:w-1/3 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                            />

                            <select
                                value={selectedDept}
                                onChange={(e) => setSelectedDept(e.target.value)}
                                className="border p-2 rounded w-full md:w-1/4 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                            >
                                <option value="">Semua Departemen</option>
                                {departments.map((dept: string, index: number) => (
                                    <option key={index} value={dept}>{dept}</option>
                                ))}
                            </select>
                        </div>

                        {/* Tabel Karyawan */}
                        <div className="overflow-x-auto">
                            <table className="w-full text-left border-collapse">
                                <thead>
                                    <tr className="border-b bg-gray-50">
                                        <th className="py-2 px-3 text-sm">Foto</th>
                                        <th className="py-2 px-3 text-sm">Kode</th>
                                        <th className="py-2 px-3 text-sm">Nama Lengkap</th>
                                        <th className="py-2 px-3 text-sm">Departemen</th>
                                        <th className="py-2 px-3 text-sm">Posisi</th>
                                        <th className="py-2 px-3 text-sm">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {filteredEmployees.map((emp: any) => (
                                        <tr key={emp.id} className="border-b hover:bg-gray-50">
                                            <td className="py-2 px-3">
                                                {emp.photo_path ? (
                                                    <img src={`/storage/${emp.photo_path}`} alt="Foto" className="w-10 h-10 rounded-full object-cover" />
                                                ) : (
                                                    <div className="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center text-xs">No Pic</div>
                                                )}
                                            </td>
                                            <td className="py-2 px-3 text-sm">{emp.employee_code}</td>
                                            <td className="py-2 px-3 text-sm font-medium">{emp.full_name}</td>
                                            <td className="py-2 px-3 text-sm">{emp.department || '-'}</td>
                                            <td className="py-2 px-3 text-sm">{emp.position || '-'}</td>
                                            <td className="py-2 px-3 text-sm space-x-2">
                                                <Link href={`/admin/employees/${emp.id}`} className="text-gray-600 hover:underline">Lihat</Link>
                                                <Link href={`/admin/employees/${emp.id}/edit`} className="text-blue-600 hover:underline">Edit</Link>
                                                <Link href={`/admin/employees/${emp.id}`} method="delete" as="button" className="text-red-600 hover:underline">Hapus</Link>
                                            </td>
                                        </tr>
                                    ))}
                                    {filteredEmployees.length === 0 && (
                                        <tr>
                                            <td colSpan={6} className="text-center py-4 text-gray-500">
                                                Tidak ada karyawan yang sesuai dengan filter.
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>

                        {/* Pagination Links (Bawaan Laravel) */}
                        <div className="mt-4">
                            {employees.links && employees.links.map((link: any, i: number) => (
                                link.url ? (
                                    <Link
                                        key={i}
                                        href={link.url}
                                        className={`px-3 py-1 border rounded mr-1 text-sm ${link.active ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'}`}
                                        dangerouslySetInnerHTML={{ __html: link.label }}
                                    />
                                ) : (
                                    <span
                                        key={i}
                                        className="px-3 py-1 border rounded mr-1 text-sm bg-gray-100 text-gray-400"
                                        dangerouslySetInnerHTML={{ __html: link.label }}
                                    />
                                )
                            ))}
                        </div>

                    </div>
                </div>
            </div>
        </>
    );
}