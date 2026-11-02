import { Head, Link } from '@inertiajs/react';

interface Menu {
    id: number;
    name: string;
    route: string | null;
    permission_name: string | null;
    order: number;
    sub_menus_count?: number;
}
interface Props {
    menus: Menu[];
}

export default function Index({ menus }: Props) {
    return (
        <>
            <Head title="Data Menu" />
            <div className="py-12">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <div className="mb-4 flex items-center justify-between">
                            <h2 className="text-xl font-semibold text-gray-800">
                                Data Menu
                            </h2>
                            <Link
                                href="/admin/menus/create"
                                className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700"
                            >
                                + Tambah Menu
                            </Link>
                        </div>
                        <table className="w-full border-collapse text-left">
                            <thead>
                                <tr className="border-b">
                                    <th className="px-3 py-2">#</th>
                                    <th className="px-3 py-2">Nama</th>
                                    <th className="px-3 py-2">Rute</th>
                                    <th className="px-3 py-2">Hak akses</th>
                                    <th className="px-3 py-2">Urutan</th>
                                    <th className="px-3 py-2">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {menus.length === 0 ? (
                                    <tr>
                                        <td
                                            colSpan={6}
                                            className="py-4 text-center text-gray-500"
                                        >
                                            Belum ada menu.
                                        </td>
                                    </tr>
                                ) : (
                                    menus.map((menu, i) => (
                                        <tr
                                            key={menu.id}
                                            className="border-b hover:bg-gray-50"
                                        >
                                            <td className="px-3 py-2">
                                                {i + 1}
                                            </td>
                                            <td className="px-3 py-2 font-medium">
                                                {menu.name}
                                            </td>
                                            <td className="px-3 py-2">
                                                <code>{menu.route ?? '-'}</code>
                                            </td>
                                            <td className="px-3 py-2">
                                                {menu.permission_name ? (
                                                    <span className="rounded bg-gray-100 px-2 py-1 text-xs">
                                                        {menu.permission_name}
                                                    </span>
                                                ) : (
                                                    <span className="text-gray-400">
                                                        -
                                                    </span>
                                                )}
                                            </td>
                                            <td className="px-3 py-2">
                                                {menu.order}
                                            </td>
                                            <td className="space-x-2 px-3 py-2">
                                                <Link
                                                    href={`/admin/menus/${menu.id}`}
                                                    className="text-gray-600 hover:underline"
                                                >
                                                    Lihat
                                                </Link>
                                                <Link
                                                    href={`/admin/menus/${menu.id}/edit`}
                                                    className="text-blue-600 hover:underline"
                                                >
                                                    Ubah
                                                </Link>
                                                <Link
                                                    href={`/admin/menus/${menu.id}`}
                                                    method="delete"
                                                    as="button"
                                                    className="text-red-600 hover:underline"
                                                    onBefore={() =>
                                                        confirm(
                                                            'Hapus menu ini?',
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
                    </div>
                </div>
            </div>
        </>
    );
}
