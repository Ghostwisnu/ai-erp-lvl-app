import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Permission {
    id: number;
    name: string;
}
interface Props {
    permissions: Permission[];
}

export default function Create({ permissions }: Props) {
    const { data, setData, post, processing, errors } = useForm({
        name: '',
        permissions: [] as string[],
    });

    const toggle = (name: string) =>
        setData(
            'permissions',
            data.permissions.includes(name)
                ? data.permissions.filter((p) => p !== name)
                : [...data.permissions, name],
        );

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/admin/roles');
    };

    return (
        <>
            <Head title="Tambah Peran" />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Tambah Peran
                        </h2>
                        <form onSubmit={submit} className="space-y-4">
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Nama peran
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
                                    Hak akses
                                </label>
                                <div className="grid grid-cols-2 gap-2 rounded-md border p-3">
                                    {permissions.map((p) => (
                                        <label
                                            key={p.id}
                                            className="inline-flex items-center space-x-2"
                                        >
                                            <input
                                                type="checkbox"
                                                checked={data.permissions.includes(
                                                    p.name,
                                                )}
                                                onChange={() => toggle(p.name)}
                                                className="rounded border-gray-300"
                                            />
                                            <span className="text-sm">
                                                {p.name}
                                            </span>
                                        </label>
                                    ))}
                                </div>
                            </div>
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link
                                    href="/admin/roles"
                                    className="rounded-md bg-gray-200 px-4 py-2 text-sm hover:bg-gray-300"
                                >
                                    Batal
                                </Link>
                                <button
                                    type="submit"
                                    disabled={processing}
                                    className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700 disabled:opacity-50"
                                >
                                    {processing ? 'Menyimpan...' : 'Simpan'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}
