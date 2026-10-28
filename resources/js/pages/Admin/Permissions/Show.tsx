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
            <Head title={`Detail Permission: ${permission.name}`} />

            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl text-gray-800 mb-6">
                            Detail Permission
                        </h2>

                        <dl className="space-y-4">
                            <div>
                                <dt className="text-sm text-gray-500">Nama Permission</dt>
                                <dd className="text-lg font-medium text-gray-900">
                                    {permission.name}
                                </dd>
                            </div>

                            <div>
                                <dt className="text-sm text-gray-500">Digunakan oleh Role</dt>
                                <dd className="mt-1">
                                    {permission.roles && permission.roles.length > 0 ? (
                                        <div className="flex flex-wrap gap-2">
                                            {permission.roles.map((role) => (
                                                <span
                                                    key={role.id}
                                                    className="inline-block bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded"
                                                >
                                                    {role.name}
                                                </span>
                                            ))}
                                        </div>
                                    ) : (
                                        <span className="text-gray-400 text-sm">Belum dipakai oleh role manapun</span>
                                    )}
                                </dd>
                            </div>
                        </dl>

                        <div className="flex justify-end space-x-2 pt-8">
                            <Link
                                href="/admin/permissions"
                                className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-sm text-gray-800"
                            >
                                Kembali
                            </Link>
                            <Link
                                href={`/admin/permissions/${permission.id}/edit`}
                                className="px-4 py-2 bg-yellow-500 hover:bg-yellow-600 text-white rounded-md text-sm"
                            >
                                Edit
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}