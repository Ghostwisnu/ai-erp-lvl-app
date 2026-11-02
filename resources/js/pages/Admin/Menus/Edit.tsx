import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Permission {
    id: number;
    name: string;
}
interface Menu {
    id: number;
    name: string;
    route: string | null;
    icon: string | null;
    order: number;
    permission_name: string | null;
}
interface Props {
    menu: Menu;
    permissions: Permission[];
}

export default function Edit({ menu, permissions }: Props) {
    const { data, setData, put, processing, errors } = useForm({
        name: menu.name,
        route: menu.route ?? '',
        icon: menu.icon ?? '',
        order: menu.order,
        permission_name: menu.permission_name ?? '',
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        put(`/admin/menus/${menu.id}`);
    };

    return (
        <>
            <Head title={`Ubah Menu: ${menu.name}`} />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Ubah Menu: {menu.name}
                        </h2>
                        <form onSubmit={submit} className="space-y-4">
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Nama Menu
                                </label>
                                <input
                                    type="text"
                                    value={data.name}
                                    onChange={(e) =>
                                        setData('name', e.target.value)
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm"
                                    required
                                />
                                {errors.name && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.name}
                                    </p>
                                )}
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Rute
                                </label>
                                <input
                                    type="text"
                                    value={data.route}
                                    onChange={(e) =>
                                        setData('route', e.target.value)
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm"
                                    placeholder="contoh: /admin/users"
                                />
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Ikon
                                </label>
                                <input
                                    type="text"
                                    value={data.icon}
                                    onChange={(e) =>
                                        setData('icon', e.target.value)
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm"
                                />
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Hak akses
                                </label>
                                <select
                                    value={data.permission_name}
                                    onChange={(e) =>
                                        setData(
                                            'permission_name',
                                            e.target.value,
                                        )
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm"
                                >
                                    <option value="">
                                        -- Tanpa hak akses --
                                    </option>
                                    {permissions.map((p) => (
                                        <option key={p.id} value={p.name}>
                                            {p.name}
                                        </option>
                                    ))}
                                </select>
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Urutan
                                </label>
                                <input
                                    type="number"
                                    value={data.order}
                                    onChange={(e) =>
                                        setData(
                                            'order',
                                            parseInt(e.target.value),
                                        )
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm"
                                    min={0}
                                />
                            </div>
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link
                                    href="/admin/menus"
                                    className="rounded-md bg-gray-200 px-4 py-2 text-sm hover:bg-gray-300"
                                >
                                    Batal
                                </Link>
                                <button
                                    type="submit"
                                    disabled={processing}
                                    className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700 disabled:opacity-50"
                                >
                                    {processing
                                        ? 'Menyimpan...'
                                        : 'Simpan Perubahan'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}
