import { Head, Link } from '@inertiajs/react';

interface Permission {
    id: number;
    name: string;
}
interface Role {
    id: number;
    name: string;
    permissions: Permission[];
}
interface Props {
    role: Role;
}

export default function Show({ role }: Props) {
    return (
        <>
            <Head title={`Detail Peran: ${role.name}`} />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Detail Peran
                        </h2>
                        <dl className="space-y-3">
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Nama peran
                                </dt>
                                <dd className="text-lg font-medium">
                                    {role.name}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Hak akses
                                </dt>
                                <dd className="mt-1">
                                    {role.permissions.length === 0 ? (
                                        <span className="text-gray-400">
                                            Tidak ada hak akses
                                        </span>
                                    ) : (
                                        role.permissions.map((p) => (
                                            <span
                                                key={p.id}
                                                className="mr-1 inline-block rounded bg-green-100 px-2 py-1 text-xs text-green-800"
                                            >
                                                {p.name}
                                            </span>
                                        ))
                                    )}
                                </dd>
                            </div>
                        </dl>
                        <div className="flex justify-end space-x-2 pt-6">
                            <Link
                                href="/admin/roles"
                                className="rounded-md bg-gray-200 px-4 py-2 text-sm hover:bg-gray-300"
                            >
                                Kembali
                            </Link>
                            <Link
                                href={`/admin/roles/${role.id}/edit`}
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
