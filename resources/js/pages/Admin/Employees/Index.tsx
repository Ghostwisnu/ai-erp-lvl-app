import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';

export default function Index({ employees, departments = [], filters }: any) {
    // State untuk Filter (diproses di server agar mencakup semua halaman)
    const [search, setSearch] = useState(filters?.search ?? '');
    const [selectedDept, setSelectedDept] = useState(filters?.department ?? '');

    useEffect(() => {
        // Jangan request ulang (dan reset ke halaman 1) bila filter tidak berubah,
        // misalnya saat berpindah halaman pagination.
        if (
            search === (filters?.search ?? '') &&
            selectedDept === (filters?.department ?? '')
        ) {
            return;
        }

        const timer = setTimeout(() => {
            router.get(
                '/admin/employees',
                {
                    search: search || undefined,
                    department: selectedDept || undefined,
                },
                { preserveState: true, preserveScroll: true, replace: true },
            );
        }, 300);

        return () => clearTimeout(timer);
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [search, selectedDept]);

    const filteredEmployees = employees.data || [];

    return (
        <>
            <Head title="Data Karyawan" />
            <div className="py-12">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        {/* Header & Tombol Tambah */}
                        <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                            <h2 className="text-xl font-semibold text-gray-800">
                                Data Karyawan
                            </h2>
                            <div className="flex flex-wrap gap-2">
                                <Link
                                    href="/admin/employees/import"
                                    className="rounded-md bg-green-600 px-4 py-2 text-sm text-white"
                                >
                                    Impor Karyawan
                                </Link>
                                <Link
                                    href="/admin/employees/bulk-update"
                                    className="rounded-md bg-teal-600 px-4 py-2 text-sm text-white hover:bg-teal-700"
                                >
                                    Update Massal
                                </Link>
                                <Link
                                    href="/admin/employees/salary-import"
                                    className="rounded-md bg-amber-600 px-4 py-2 text-sm text-white hover:bg-amber-700"
                                >
                                    Impor Data Gaji
                                </Link>
                                <Link
                                    href="/admin/employees/create"
                                    className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700"
                                >
                                    + Tambah Karyawan
                                </Link>
                            </div>
                        </div>

                        {/* Fitur Filter */}
                        <div className="mb-4 flex flex-col gap-4 md:flex-row">
                            <input
                                type="text"
                                placeholder="Cari Nama atau Kode..."
                                value={search}
                                onChange={(e) => setSearch(e.target.value)}
                                className="w-full rounded border p-2 text-sm focus:border-indigo-500 focus:ring-indigo-500 md:w-1/3"
                            />

                            <select
                                value={selectedDept}
                                onChange={(e) =>
                                    setSelectedDept(e.target.value)
                                }
                                className="w-full rounded border p-2 text-sm focus:border-indigo-500 focus:ring-indigo-500 md:w-1/4"
                            >
                                <option value="">Semua Departemen</option>
                                {departments.map(
                                    (dept: string, index: number) => (
                                        <option key={index} value={dept}>
                                            {dept}
                                        </option>
                                    ),
                                )}
                            </select>
                        </div>

                        {/* Tabel Karyawan */}
                        <div className="overflow-x-auto">
                            <table className="w-full border-collapse text-left">
                                <thead>
                                    <tr className="border-b bg-gray-50">
                                        <th className="px-3 py-2 text-sm">
                                            Foto
                                        </th>
                                        <th className="px-3 py-2 text-sm">
                                            Kode
                                        </th>
                                        <th className="px-3 py-2 text-sm">
                                            Nama Lengkap
                                        </th>
                                        <th className="px-3 py-2 text-sm">
                                            Departemen
                                        </th>
                                        <th className="px-3 py-2 text-sm">
                                            Posisi
                                        </th>
                                        <th className="px-3 py-2 text-sm">
                                            Aksi
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {filteredEmployees.map((emp: any) => (
                                        <tr
                                            key={emp.id}
                                            className="border-b hover:bg-gray-50"
                                        >
                                            <td className="px-3 py-2">
                                                {emp.photo_path ? (
                                                    <img
                                                        src={`/storage/${emp.photo_path}`}
                                                        alt="Foto"
                                                        className="h-10 w-10 rounded-full object-cover"
                                                    />
                                                ) : (
                                                    <div className="flex h-10 w-10 items-center justify-center rounded-full bg-gray-200 text-xs">
                                                        Tidak ada foto
                                                    </div>
                                                )}
                                            </td>
                                            <td className="px-3 py-2 text-sm">
                                                {emp.employee_code}
                                            </td>
                                            <td className="px-3 py-2 text-sm font-medium">
                                                {emp.full_name}
                                            </td>
                                            <td className="px-3 py-2 text-sm">
                                                {emp.department || '-'}
                                            </td>
                                            <td className="px-3 py-2 text-sm">
                                                {emp.position || '-'}
                                            </td>
                                            <td className="space-x-2 px-3 py-2 text-sm">
                                                <Link
                                                    href={`/admin/employees/${emp.id}`}
                                                    className="text-gray-600 hover:underline"
                                                >
                                                    Lihat
                                                </Link>
                                                <Link
                                                    href={`/admin/employees/${emp.id}/edit`}
                                                    className="text-blue-600 hover:underline"
                                                >
                                                    Ubah
                                                </Link>
                                                <Link
                                                    href={`/admin/employees/${emp.id}`}
                                                    method="delete"
                                                    as="button"
                                                    className="text-red-600 hover:underline"
                                                >
                                                    Hapus
                                                </Link>
                                            </td>
                                        </tr>
                                    ))}
                                    {filteredEmployees.length === 0 && (
                                        <tr>
                                            <td
                                                colSpan={6}
                                                className="py-4 text-center text-gray-500"
                                            >
                                                Tidak ada karyawan yang sesuai
                                                dengan filter.
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>

                        {/* Pagination Links (Bawaan Laravel) */}
                        <div className="mt-4">
                            {employees.links &&
                                employees.links.map((link: any, i: number) =>
                                    link.url ? (
                                        <Link
                                            key={i}
                                            href={link.url}
                                            className={`mr-1 rounded border px-3 py-1 text-sm ${link.active ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'}`}
                                            dangerouslySetInnerHTML={{
                                                __html: link.label,
                                            }}
                                        />
                                    ) : (
                                        <span
                                            key={i}
                                            className="mr-1 rounded border bg-gray-100 px-3 py-1 text-sm text-gray-400"
                                            dangerouslySetInnerHTML={{
                                                __html: link.label,
                                            }}
                                        />
                                    ),
                                )}
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
