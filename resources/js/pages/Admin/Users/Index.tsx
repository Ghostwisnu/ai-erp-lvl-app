import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useRef, useState } from 'react';

interface Role {
    id: number;
    name: string;
}
interface User {
    id: number;
    name: string;
    roles: Role[];
}
interface Props {
    users: {
        data: User[];
        from: number | null;
        to: number | null;
        total: number;
        links: { url: string | null; label: string; active: boolean }[];
    };
    roles: string[];
    filters: { search: string; role: string };
}

export default function Index({ users, roles = [], filters }: Props) {
    const [search, setSearch] = useState(filters?.search ?? '');
    const [selectedRole, setSelectedRole] = useState(filters?.role ?? '');
    const isFirstRender = useRef(true);

    useEffect(() => {
        if (isFirstRender.current) {
            isFirstRender.current = false;

            return;
        }

        const timer = setTimeout(() => {
            router.get(
                '/admin/users',
                {
                    search: search || undefined,
                    role: selectedRole || undefined,
                },
                { preserveState: true, preserveScroll: true, replace: true },
            );
        }, 300);

        return () => clearTimeout(timer);
    }, [search, selectedRole]);

    return (
        <>
            <Head title="Data Pengguna" />
            <div className="py-12">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="overflow-hidden bg-white p-6 shadow-sm sm:rounded-lg">
                        <div className="mb-4 flex items-center justify-between">
                            <h2 className="text-xl font-semibold text-gray-800">
                                Data Pengguna
                            </h2>
                            <Link
                                href="/admin/users/create"
                                className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700"
                            >
                                + Tambah Pengguna
                            </Link>
                        </div>
                        <div className="mb-4 flex flex-col gap-4 md:flex-row">
                            <input
                                type="text"
                                placeholder="Cari Nama..."
                                value={search}
                                onChange={(e) => setSearch(e.target.value)}
                                className="w-full rounded border p-2 text-sm focus:border-indigo-500 focus:ring-indigo-500 md:w-1/3"
                            />
                            <select
                                value={selectedRole}
                                onChange={(e) =>
                                    setSelectedRole(e.target.value)
                                }
                                className="w-full rounded border p-2 text-sm focus:border-indigo-500 focus:ring-indigo-500 md:w-1/4"
                            >
                                <option value="">Semua Peran</option>
                                {roles.map((role) => (
                                    <option key={role} value={role}>
                                        {role}
                                    </option>
                                ))}
                            </select>
                        </div>
                        <table className="w-full border-collapse text-left">
                            <thead>
                                <tr className="border-b">
                                    <th className="px-3 py-2">#</th>
                                    <th className="px-3 py-2">Nama</th>
                                    <th className="px-3 py-2">Peran</th>
                                    <th className="px-3 py-2">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {users.data.length === 0 ? (
                                    <tr>
                                        <td
                                            colSpan={4}
                                            className="py-4 text-center text-gray-500"
                                        >
                                            Tidak ada pengguna yang sesuai
                                            dengan filter.
                                        </td>
                                    </tr>
                                ) : (
                                    users.data.map((user, i) => (
                                        <tr
                                            key={user.id}
                                            className="border-b hover:bg-gray-50"
                                        >
                                            <td className="px-3 py-2">
                                                {(users.from ?? 1) + i}
                                            </td>
                                            <td className="px-3 py-2">
                                                {user.name}
                                            </td>
                                            <td className="px-3 py-2">
                                                {user.roles.map((r) => (
                                                    <span
                                                        key={r.id}
                                                        className="mr-1 inline-block rounded bg-blue-100 px-2 py-1 text-xs text-blue-800"
                                                    >
                                                        {r.name}
                                                    </span>
                                                ))}
                                            </td>
                                            <td className="space-x-2 px-3 py-2">
                                                <Link
                                                    href={`/admin/users/${user.id}`}
                                                    className="text-gray-600 hover:underline"
                                                >
                                                    Lihat
                                                </Link>
                                                <Link
                                                    href={`/admin/users/${user.id}/edit`}
                                                    className="text-blue-600 hover:underline"
                                                >
                                                    Ubah
                                                </Link>
                                                <Link
                                                    href={`/admin/users/${user.id}`}
                                                    method="delete"
                                                    as="button"
                                                    className="text-red-600 hover:underline"
                                                    onBefore={() =>
                                                        confirm(
                                                            'Hapus pengguna ini?',
                                                        )
                                                    }
                                                >
                                                    Hapus
                                                </Link>
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                        <div className="mt-4 flex flex-wrap items-center justify-between gap-2">
                            <p className="text-sm text-gray-600">
                                Menampilkan {users.from ?? 0}-{users.to ?? 0}{' '}
                                dari {users.total} pengguna
                            </p>
                            <div className="flex flex-wrap gap-1">
                                {users.links.map((link, i) =>
                                    link.url ? (
                                        <Link
                                            key={i}
                                            href={link.url}
                                            preserveScroll
                                            className={`rounded border px-3 py-1 text-sm ${link.active ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'}`}
                                            dangerouslySetInnerHTML={{
                                                __html: link.label,
                                            }}
                                        />
                                    ) : (
                                        <span
                                            key={i}
                                            className="rounded border bg-gray-100 px-3 py-1 text-sm text-gray-400"
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
            </div>
        </>
    );
}
