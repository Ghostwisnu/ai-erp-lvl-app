import { Head, Link } from '@inertiajs/react';

interface SubMenu {
    id: number;
    name: string;
    route: string | null;
}
interface Menu {
    id: number;
    name: string;
    route: string | null;
    permission_name: string | null;
    order: number;
    sub_menus: SubMenu[];
}
interface Props {
    menu: Menu;
}

export default function Show({ menu }: Props) {
    return (
        <>
            <Head title={`Detail Menu: ${menu.name}`} />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Detail Menu
                        </h2>
                        <dl className="space-y-3">
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Nama Menu
                                </dt>
                                <dd className="text-lg font-medium">
                                    {menu.name}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">Rute</dt>
                                <dd>
                                    <code>{menu.route ?? '-'}</code>
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Hak akses
                                </dt>
                                <dd>{menu.permission_name ?? '-'}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Urutan
                                </dt>
                                <dd>{menu.order}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Submenu
                                </dt>
                                <dd className="mt-1">
                                    {menu.sub_menus.length === 0 ? (
                                        <span className="text-gray-400">
                                            Tidak ada submenu
                                        </span>
                                    ) : (
                                        <ul className="list-inside list-disc">
                                            {menu.sub_menus.map((s) => (
                                                <li key={s.id}>
                                                    {s.name} (
                                                    <code>{s.route}</code>)
                                                </li>
                                            ))}
                                        </ul>
                                    )}
                                </dd>
                            </div>
                        </dl>
                        <div className="flex justify-end space-x-2 pt-6">
                            <Link
                                href="/admin/menus"
                                className="rounded-md bg-gray-200 px-4 py-2 text-sm hover:bg-gray-300"
                            >
                                Kembali
                            </Link>
                            <Link
                                href={`/admin/menus/${menu.id}/edit`}
                                className="rounded-md bg-yellow-500 px-4 py-2 text-sm text-white hover:bg-yellow-600"
                            >
                                Ubah
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
