import { Head, Link } from '@inertiajs/react';

interface Role {
    id: number;
    name: string;
}
interface User {
    id: number;
    name: string;
    created_at: string;
    roles: Role[];
}
interface Props {
    user: User;
}

export default function Show({ user }: Props) {
    return (
        <>
            <Head title={`Detail Pengguna: ${user.name}`} />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Detail Pengguna
                        </h2>
                        <dl className="space-y-3">
                            <div>
                                <dt className="text-sm text-gray-500">Nama</dt>
                                <dd className="text-lg font-medium">
                                    {user.name}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">Peran</dt>
                                <dd className="mt-1">
                                    {user.roles.length === 0 ? (
                                        <span className="text-gray-400">
                                            Tidak ada peran
                                        </span>
                                    ) : (
                                        user.roles.map((r) => (
                                            <span
                                                key={r.id}
                                                className="mr-1 inline-block rounded bg-blue-100 px-2 py-1 text-xs text-blue-800"
                                            >
                                                {r.name}
                                            </span>
                                        ))
                                    )}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Dibuat
                                </dt>
                                <dd className="text-lg">{user.created_at}</dd>
                            </div>
                        </dl>
                        <div className="flex justify-end space-x-2 pt-6">
                            <Link
                                href="/admin/users"
                                className="rounded-md bg-gray-200 px-4 py-2 text-sm hover:bg-gray-300"
                            >
                                Kembali
                            </Link>
                            <Link
                                href={`/admin/users/${user.id}/edit`}
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
