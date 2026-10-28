import { Head, Link } from '@inertiajs/react';

interface Menu { id: number; name: string; }
interface SubMenu { id: number; name: string; route: string | null; permission_name: string | null; order: number; menu: Menu | null; }
interface Props { submenu: SubMenu; }

export default function Show({ submenu }: Props) {
    return (
        <>
            <Head title={`Detail Sub Menu: ${submenu.name}`} />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">Detail Sub Menu</h2>
                        <dl className="space-y-3">
                            <div><dt className="text-sm text-gray-500">Menu Induk</dt><dd className="text-lg font-medium">{submenu.menu?.name ?? '-'}</dd></div>
                            <div><dt className="text-sm text-gray-500">Nama Sub Menu</dt><dd className="text-lg">{submenu.name}</dd></div>
                            <div><dt className="text-sm text-gray-500">Route</dt><dd><code>{submenu.route ?? '-'}</code></dd></div>
                            <div><dt className="text-sm text-gray-500">Permission</dt><dd>{submenu.permission_name ?? '-'}</dd></div>
                            <div><dt className="text-sm text-gray-500">Urutan</dt><dd>{submenu.order}</dd></div>
                        </dl>
                        <div className="flex justify-end space-x-2 pt-6">
                            <Link href="/admin/submenus" className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-sm">Kembali</Link>
                            <Link href={`/admin/submenus/${submenu.id}/edit`} className="px-4 py-2 bg-yellow-500 hover:bg-yellow-600 text-white rounded-md text-sm">Edit</Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}