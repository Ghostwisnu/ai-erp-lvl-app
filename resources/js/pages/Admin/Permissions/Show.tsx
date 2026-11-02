import { Head, Link } from '@inertiajs/react';

interface Role {
    id: number;
    name: string;
}

interface Permission {
    id: number;
    name: string;
    roles?: Role[]; // Opsional, tergantung data dari controller
}

interface Props {
    permission: Permission;
}

export default function Show({ permission }: Props) {
    return (
        <>
            <Head title={`Detail Hak Akses: ${permission.name}`} />

            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Detail Hak Akses
                        </h2>

                        <dl className="space-y-4">
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Nama hak akses
                                </dt>
                                <dd className="text-lg font-medium text-gray-900">
                                    {permission.name}
                                </dd>
                            </div>

                            <div>
                                <dt className="text-sm text-gray-500">
                                    Digunakan oleh peran
                                </dt>
                                <dd className="mt-1">
                                    {permission.roles &&
                                    permission.roles.length > 0 ? (
                                        <div className="flex flex-wrap gap-2">
                                            {permission.roles.map((role) => (
                                                <span
                                                    key={role.id}
                                                    className="inline-block rounded bg-blue-100 px-2 py-1 text-xs text-blue-800"
                                                >
                                                    {role.name}
                                                </span>
                                            ))}
                                        </div>
                                    ) : (
                                        <span className="text-sm text-gray-400">
                                            Belum digunakan oleh peran mana pun
                                        </span>
                                    )}
                                </dd>
                            </div>
                        </dl>

                        <div className="flex justify-end space-x-2 pt-8">
                            <Link
                                href="/admin/permissions"
                                className="rounded-md bg-gray-200 px-4 py-2 text-sm text-gray-800 hover:bg-gray-300"
                            >
                                Kembali
                            </Link>
                            <Link
                                href={`/admin/permissions/${permission.id}/edit`}
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
