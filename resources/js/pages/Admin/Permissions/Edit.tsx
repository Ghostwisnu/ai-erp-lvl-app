import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Permission {
    id: number;
    name: string;
}
interface Props {
    permission: Permission;
}

export default function Edit({ permission }: Props) {
    const { data, setData, put, processing, errors } = useForm({
        name: permission.name,
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        put(`/admin/permissions/${permission.id}`);
    };

    return (
        <>
            <Head title={`Ubah Hak Akses: ${permission.name}`} />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-6 text-xl font-semibold text-gray-800">
                            Ubah Hak Akses
                        </h2>
                        <form onSubmit={submit} className="space-y-4">
                            <div>
                                <label className="mb-1 block text-sm font-medium text-gray-700">
                                    Nama hak akses
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
                            <div className="flex justify-end space-x-2 pt-4">
                                <Link
                                    href="/admin/permissions"
                                    className="rounded-md bg-gray-200 px-4 py-2 text-sm"
                                >
                                    Batal
                                </Link>
                                <button
                                    type="submit"
                                    disabled={processing}
                                    className="rounded-md bg-blue-600 px-4 py-2 text-sm text-white disabled:opacity-50"
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
