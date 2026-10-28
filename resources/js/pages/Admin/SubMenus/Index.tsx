import { Head, Link } from '@inertiajs/react';

interface Menu { id: number; name: string; }
interface SubMenu { id: number; name: string; route: string | null; permission_name: string | null; order: number; menu: Menu | null; }
interface Props { subMenus: SubMenu[]; }

export default function Index({ subMenus }: Props) {
    return (
        <>
            <Head title="Data Sub Menu" />
            <div className="py-12">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <div className="flex justify-between items-center mb-4">
                            <h2 className="font-semibold text-xl text-gray-800">Data Sub Menu</h2>
                            <Link href="/admin/submenus/create" className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm">+ Tambah Sub Menu</Link>
                        </div>
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b">
                                    <th className="py-2 px-3">#</th>
                                    <th className="py-2 px-3">Menu Induk</th>
                                    <th className="py-2 px-3">Nama</th>
                                    <th className="py-2 px-3">Route</th>
                                    <th className="py-2 px-3">Permission</th>
                                    <th className="py-2 px-3">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {subMenus.length === 0 ? (
                                    <tr><td colSpan={6} className="py-4 text-center text-gray-500">Belum ada sub menu.</td></tr>
                                ) : subMenus.map((s, i) => (
                                    <tr key={s.id} className="border-b hover:bg-gray-50">
                                        <td className="py-2 px-3">{i + 1}</td>
                                        <td className="py-2 px-3">{s.menu?.name ?? '-'}</td>
                                        <td className="py-2 px-3 font-medium">{s.name}</td>
                                        <td className="py-2 px-3"><code>{s.route ?? '-'}</code></td>
                                        <td className="py-2 px-3">{s.permission_name ?? '-'}</td>
                                        <td className="py-2 px-3 space-x-2">
                                            <Link href={`/admin/submenus/${s.id}`} className="text-gray-600 hover:underline">Lihat</Link>
                                            <Link href={`/admin/submenus/${s.id}/edit`} className="text-blue-600 hover:underline">Edit</Link>
                                            <Link href={`/admin/submenus/${s.id}`} method="delete" as="button" className="text-red-600 hover:underline" onBefore={() => confirm('Hapus sub menu ini?')}>Hapus</Link>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </>
    );
}