import { Head, Link } from '@inertiajs/react';

interface SubMenu { id: number; name: string; route: string | null; }
interface Menu { id: number; name: string; route: string | null; permission_name: string | null; order: number; sub_menus: SubMenu[]; }
interface Props { menu: Menu; }

export default function Show({ menu }: Props) {
    return (
        <>
            <Head title={`Detail Menu: ${menu.name}`} />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">Detail Menu</h2>
                        <dl className="space-y-3">
                            <div><dt className="text-sm text-gray-500">Nama Menu</dt><dd className="text-lg font-medium">{menu.name}</dd></div>
                            <div><dt className="text-sm text-gray-500">Route</dt><dd><code>{menu.route ?? '-'}</code></dd></div>
                            <div><dt className="text-sm text-gray-500">Permission</dt><dd>{menu.permission_name ?? '-'}</dd></div>
                            <div><dt className="text-sm text-gray-500">Urutan</dt><dd>{menu.order}</dd></div>
                            <div>
                                <dt className="text-sm text-gray-500">Sub Menu</dt>
                                <dd className="mt-1">
                                    {menu.sub_menus.length === 0 ? <span className="text-gray-400">Tidak ada sub menu</span> : (
                                        <ul className="list-disc list-inside">
                                            {menu.sub_menus.map((s) => <li key={s.id}>{s.name} (<code>{s.route}</code>)</li>)}
                                        </ul>
                                    )}
                                </dd>
                            </div>
                        </dl>
                        <div className="flex justify-end space-x-2 pt-6">
                            <Link href="/admin/menus" className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-sm">Kembali</Link>
                            <Link href={`/admin/menus/${menu.id}/edit`} className="px-4 py-2 bg-yellow-500 hover:bg-yellow-600 text-white rounded-md text-sm">Edit</Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}