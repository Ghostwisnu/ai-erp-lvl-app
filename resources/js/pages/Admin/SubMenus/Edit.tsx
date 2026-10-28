import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Menu { id: number; name: string; }
interface Permission { id: number; name: string; }
interface SubMenu { id: number; menu_id: number; name: string; route: string | null; order: number; permission_name: string | null; }
interface Props { submenu: SubMenu; menus: Menu[]; permissions: Permission[]; }

export default function Edit({ submenu, menus, permissions }: Props) {
    const { data, setData, put, processing, errors } = useForm({
        menu_id: submenu.menu_id, name: submenu.name, route: submenu.route ?? '', order: submenu.order, permission_name: submenu.permission_name ?? '',
    });

    const submit = (e: FormEvent) => { e.preventDefault(); put(`/admin/submenus/${submenu.id}`); };

    return (
        <>
            <Head title={`Edit Sub Menu: ${submenu.name}`} />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">Edit Sub Menu: {submenu.name}</h2>
                        <form onSubmit={submit} className="space-y-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Menu Induk</label>
                                <select value={data.menu_id} onChange={(e) => setData('menu_id', parseInt(e.target.value))} className="w-full border-gray-300 rounded-md shadow-sm" required>
                                    {menus.map((m) => <option key={m.id} value={m.id}>{m.name}</option>)}
                                </select>
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Nama Sub Menu</label>
                                <input type="text" value={data.name} onChange={(e) => setData('name', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm" required />
                                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name}</p>}
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Route</label>
                                <input type="text" value={data.route} onChange={(e) => setData('route', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm" />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Permission</label>
                                <select value={data.permission_name} onChange={(e) => setData('permission_name', e.target.value)} className="w-full border-gray-300 rounded-md shadow-sm">
                                    <option value="">-- Tanpa permission --</option>
                                    {permissions.map((p) => <option key={p.id} value={p.name}>{p.name}</option>)}
                                </select>
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Urutan</label>
                                <input type="number" value={data.order} onChange={(e) => setData('order', parseInt(e.target.value))} className="w-full border-gray-300 rounded-md shadow-sm" min={0} />
                            </div>
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link href="/admin/submenus" className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-sm">Batal</Link>
                                <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md text-sm disabled:opacity-50">
                                    {processing ? 'Menyimpan...' : 'Update'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}