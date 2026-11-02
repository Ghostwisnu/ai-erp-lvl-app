import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent, useState } from 'react';

export default function Create() {
    const { data, setData, post, processing, errors } = useForm({
        name: '',
        code: '',
        description: '',
        sizes: [''], // Array string untuk size run
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/admin/brands');
    };

    const addSize = () => {
        setData('sizes', [...data.sizes, '']);
    };

    const removeSize = (index: number) => {
        const newSizes = [...data.sizes];
        newSizes.splice(index, 1);
        setData('sizes', newSizes);
    };

    const updateSize = (index: number, value: string) => {
        const newSizes = [...data.sizes];
        newSizes[index] = value;
        setData('sizes', newSizes);
    };

    return (
        <>
            <Head title="Tambah Merek" />
            <div className="mx-auto max-w-3xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <h2 className="mb-6 text-xl font-semibold">
                        Tambah Merek Baru
                    </h2>
                    <form onSubmit={submit} className="space-y-4">
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Kode Merek
                                </label>
                                <input
                                    type="text"
                                    value={data.code}
                                    onChange={(e) =>
                                        setData('code', e.target.value)
                                    }
                                    className="w-full rounded border p-2"
                                    required
                                />
                                {errors.code && (
                                    <p className="text-sm text-red-500">
                                        {errors.code}
                                    </p>
                                )}
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Nama Merek
                                </label>
                                <input
                                    type="text"
                                    value={data.name}
                                    onChange={(e) =>
                                        setData('name', e.target.value)
                                    }
                                    className="w-full rounded border p-2"
                                    required
                                />
                                {errors.name && (
                                    <p className="text-sm text-red-500">
                                        {errors.name}
                                    </p>
                                )}
                            </div>
                        </div>
                        <div>
                            <label className="mb-1 block text-sm font-medium">
                                Deskripsi (Opsional)
                            </label>
                            <textarea
                                value={data.description}
                                onChange={(e) =>
                                    setData('description', e.target.value)
                                }
                                className="w-full rounded border p-2"
                            ></textarea>
                        </div>

                        <div className="mt-4 border-t pt-4">
                            <div className="mb-3 flex items-center justify-between">
                                <h3 className="text-lg font-medium">
                                    Daftar Ukuran
                                </h3>
                                <button
                                    type="button"
                                    onClick={addSize}
                                    className="rounded bg-blue-100 px-3 py-1 text-sm text-blue-700"
                                >
                                    + Tambah Ukuran
                                </button>
                            </div>

                            {data.sizes.map((size, index) => (
                                <div key={index} className="mb-2 flex gap-2">
                                    <input
                                        type="text"
                                        value={size}
                                        onChange={(e) =>
                                            updateSize(index, e.target.value)
                                        }
                                        placeholder={`Contoh: S, M, L, atau 40`}
                                        className="w-full rounded border p-2"
                                        required
                                    />
                                    {data.sizes.length > 1 && (
                                        <button
                                            type="button"
                                            onClick={() => removeSize(index)}
                                            className="rounded bg-red-100 px-3 text-red-700"
                                        >
                                            Hapus
                                        </button>
                                    )}
                                </div>
                            ))}
                        </div>

                        <div className="flex justify-end space-x-2 pt-4">
                            <Link
                                href="/admin/brands"
                                className="rounded bg-gray-200 px-4 py-2"
                            >
                                Batal
                            </Link>
                            <button
                                type="submit"
                                disabled={processing}
                                className="rounded bg-blue-600 px-4 py-2 text-white"
                            >
                                {processing ? 'Menyimpan...' : 'Simpan Merek'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}
