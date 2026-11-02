import { Head, Link } from '@inertiajs/react';

interface Menu {
    id: number;
    name: string;
}
interface SubMenu {
    id: number;
    name: string;
    route: string | null;
    permission_name: string | null;
    order: number;
    menu: Menu | null;
}
interface Props {
    subMenus: SubMenu[];
}

export default function Index({ subMenus }: Props) {
    return (
        <>
            <Head title="Data Submenu" />
            <div className="py-12">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <div className="mb-4 flex items-center justify-between">
                            <h2 className="text-xl font-semibold text-gray-800">
                                Data Submenu
                            </h2>
                            <Link
                                href="/admin/submenus/create"
                                className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700"
                            >
                                + Tambah Submenu
                            </Link>
                        </div>
                        <table className="w-full border-collapse text-left">
                            <thead>
                                <tr className="border-b">
                                    <th className="px-3 py-2">#</th>
                                    <th className="px-3 py-2">Menu Induk</th>
                                    <th className="px-3 py-2">Nama</th>
                                    <th className="px-3 py-2">Rute</th>
                                    <th className="px-3 py-2">Hak akses</th>
                                    <th className="px-3 py-2">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {subMenus.length === 0 ? (
                                    <tr>
                                        <td
                                            colSpan={6}
                                            className="py-4 text-center text-gray-500"
                                        >
                                            Belum ada submenu.
                                        </td>
                                    </tr>
                                ) : (
                                    subMenus.map((s, i) => (
                                        <tr
                                            key={s.id}
                                            className="border-b hover:bg-gray-50"
                                        >
                                            <td className="px-3 py-2">
                                                {i + 1}
                                            </td>
                                            <td className="px-3 py-2">
                                                {s.menu?.name ?? '-'}
                                            </td>
                                            <td className="px-3 py-2 font-medium">
                                                {s.name}
                                            </td>
                                            <td className="px-3 py-2">
                                                <code>{s.route ?? '-'}</code>
                                            </td>
                                            <td className="px-3 py-2">
                                                {s.permission_name ?? '-'}
                                            </td>
                                            <td className="space-x-2 px-3 py-2">
                                                <Link
                                                    href={`/admin/submenus/${s.id}`}
                                                    className="text-gray-600 hover:underline"
                                                >
                                                    Lihat
                                                </Link>
                                                <Link
                                                    href={`/admin/submenus/${s.id}/edit`}
                                                    className="text-blue-600 hover:underline"
                                                >
                                                    Ubah
                                                </Link>
                                                <Link
                                                    href={`/admin/submenus/${s.id}`}
                                                    method="delete"
                                                    as="button"
                                                    className="text-red-600 hover:underline"
                                                    onBefore={() =>
                                                        confirm(
                                                            'Hapus sub menu ini?',
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
