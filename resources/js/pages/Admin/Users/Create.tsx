import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Role {
    id: number;
    name: string;
}
interface Props {
    roles: Role[];
}

export default function Create({ roles }: Props) {
    const { data, setData, post, processing, errors } = useForm({
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
        roles: [] as string[],
    });

    const toggleRole = (name: string) => {
        setData(
            'roles',
            data.roles.includes(name)
                ? data.roles.filter((r) => r !== name)
                : [...data.roles, name],
        );
    };

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/admin/users');
    };

    return (
        <>
            <Head title="Tambah Pengguna" />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Tambah Pengguna
                        </h2>

                        <form onSubmit={submit} className="space-y-4">
                            {/* Nama */}
                            <div>
                                <label
                                    htmlFor="name"
                                    className="mb-1 block text-sm font-medium text-gray-700"
                                >
                                    Nama
                                </label>
                                <input
                                    id="name"
                                    type="text"
                                    value={data.name}
                                    onChange={(e) =>
                                        setData('name', e.target.value)
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    required
                                />
                                {errors.name && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.name}
                                    </p>
                                )}
                            </div>

                            {/* Email */}
                            <div>
                                <label
                                    htmlFor="email"
                                    className="mb-1 block text-sm font-medium text-gray-700"
                                >
                                    Alamat email
                                </label>
                                <input
                                    id="email"
                                    type="email"
                                    value={data.email}
                                    onChange={(e) =>
                                        setData('email', e.target.value)
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    required
                                />
                                {errors.email && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.email}
                                    </p>
                                )}
                            </div>

                            {/* Password */}
                            <div>
                                <label
                                    htmlFor="password"
                                    className="mb-1 block text-sm font-medium text-gray-700"
                                >
                                    Kata sandi
                                </label>
                                <input
                                    id="password"
                                    type="password"
                                    value={data.password}
                                    onChange={(e) =>
                                        setData('password', e.target.value)
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    required
                                />
                                {errors.password && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.password}
                                    </p>
                                )}
                            </div>

                            {/* Konfirmasi kata sandi */}
                            <div>
                                <label
                                    htmlFor="password_confirmation"
                                    className="mb-1 block text-sm font-medium text-gray-700"
                                >
                                    Konfirmasi kata sandi
                                </label>
                                <input
                                    id="password_confirmation"
                                    type="password"
                                    value={data.password_confirmation}
                                    onChange={(e) =>
                                        setData(
                                            'password_confirmation',
                                            e.target.value,
                                        )
                                    }
                                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    required
                                />
                            </div>

                            {/* Roles */}
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Peran
                                </label>
                                <div className="grid grid-cols-2 gap-2 rounded-md border p-3">
                                    {roles.map((role) => (
                                        <label
                                            key={role.id}
                                            className="inline-flex cursor-pointer items-center space-x-2"
                                        >
                                            <input
                                                type="checkbox"
                                                checked={data.roles.includes(
                                                    role.name,
                                                )}
                                                onChange={() =>
                                                    toggleRole(role.name)
                                                }
                                                className="rounded border-gray-300 text-indigo-600 shadow-sm focus:ring-indigo-500"
                                            />
                                            <span className="text-sm">
                                                {role.name}
                                            </span>
                                        </label>
                                    ))}
                                </div>
                                {errors.roles && (
                                    <p className="mt-1 text-sm text-red-500">
                                        {errors.roles}
                                    </p>
                                )}
                            </div>

                            {/* Tombol */}
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link
                                    href="/admin/users"
                                    className="rounded-md bg-gray-200 px-4 py-2 text-sm text-gray-800 hover:bg-gray-300"
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
