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
    submenu: SubMenu;
}

export default function Show({ submenu }: Props) {
    return (
        <>
            <Head title={`Detail Submenu: ${submenu.name}`} />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Detail Submenu
                        </h2>
                        <dl className="space-y-3">
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Menu Induk
                                </dt>
                                <dd className="text-lg font-medium">
                                    {submenu.menu?.name ?? '-'}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Nama submenu
                                </dt>
                                <dd className="text-lg">{submenu.name}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">Rute</dt>
                                <dd>
                                    <code>{submenu.route ?? '-'}</code>
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Hak akses
                                </dt>
                                <dd>{submenu.permission_name ?? '-'}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Urutan
                                </dt>
                                <dd>{submenu.order}</dd>
                            </div>
                        </dl>
                        <div className="flex justify-end space-x-2 pt-6">
                            <Link
                                href="/admin/submenus"
                                className="rounded-md bg-gray-200 px-4 py-2 text-sm hover:bg-gray-300"
                            >
                                Kembali
                            </Link>
                            <Link
                                href={`/admin/submenus/${submenu.id}/edit`}
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
