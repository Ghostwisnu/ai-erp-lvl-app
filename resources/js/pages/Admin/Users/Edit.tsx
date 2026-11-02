import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Role {
    id: number;
    name: string;
}
interface User {
    id: number;
    name: string;
    email: string;
    roles: Role[];
}
interface Props {
    user: User;
    roles: Role[];
}

export default function Edit({ user, roles }: Props) {
    const { data, setData, put, processing, errors } = useForm({
        name: user.name,
        email: user.email,
        password: '',
        password_confirmation: '',
        roles: user.roles.map((r) => r.name) as string[],
    });

    const toggle = (name: string) =>
        setData(
            'roles',
            data.roles.includes(name)
                ? data.roles.filter((r) => r !== name)
                : [...data.roles, name],
        );

    const submit = (e: FormEvent) => {
        e.preventDefault();
        put(`/admin/users/${user.id}`);
    };

    return (
        <>
            <Head title={`Ubah Pengguna: ${user.name}`} />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Ubah Pengguna: {user.name}
                        </h2>
                        <form onSubmit={submit} className="space-y-4">
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Nama
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
                                    Alamat email
                                </label>
                                <input
                                    type="email"
                                    value={data.email}
                                    onChange={(e) =>
                                        setData('email', e.target.value)
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm"
                                    required
                                />
                                {errors.email && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.email}
                                    </p>
                                )}
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Kata sandi baru (kosongkan jika tidak
                                    diubah)
                                </label>
                                <input
                                    type="password"
                                    value={data.password}
                                    onChange={(e) =>
                                        setData('password', e.target.value)
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm"
                                />
                                {errors.password && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.password}
                                    </p>
                                )}
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Konfirmasi kata sandi baru
                                </label>
                                <input
                                    type="password"
                                    value={data.password_confirmation}
                                    onChange={(e) =>
                                        setData(
                                            'password_confirmation',
                                            e.target.value,
                                        )
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm"
                                />
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Peran
                                </label>
                                <div className="grid grid-cols-2 gap-2 rounded-md border p-3">
                                    {roles.map((r) => (
                                        <label
                                            key={r.id}
                                            className="inline-flex items-center space-x-2"
                                        >
                                            <input
                                                type="checkbox"
                                                checked={data.roles.includes(
                                                    r.name,
                                                )}
                                                onChange={() => toggle(r.name)}
                                                className="rounded border-gray-300"
                                            />
                                            <span className="text-sm">
                                                {r.name}
                                            </span>
                                        </label>
                                    ))}
                                </div>
                            </div>
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link
                                    href="/admin/users"
                                    className="rounded-md bg-gray-200 px-4 py-2 text-sm hover:bg-gray-300"
                                >
                                    Batal
                                </Link>
                                <button
                                    type="submit"
                                    disabled={processing}
                                    className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white hover:bg-blue-700 disabled:opacity-50"
                                >
                                    {processing ? 'Menyimpan...' : 'Simpan Perubahan'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}
