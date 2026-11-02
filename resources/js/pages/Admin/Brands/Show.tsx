import { Head, Link } from '@inertiajs/react';

export default function Show({ brand }: any) {
    return (
        <>
            <Head title={`Detail Merek: ${brand.name}`} />
            <div className="mx-auto max-w-3xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <div className="mb-6 flex items-center justify-between">
                        <h2 className="text-xl font-semibold">Detail Merek</h2>
                        <Link href="/admin/brands" className="text-blue-600">
                            &larr; Kembali
                        </Link>
                    </div>

                    <div className="mb-8 grid grid-cols-2 gap-4 rounded bg-gray-50 p-4">
                        <div>
                            <span className="block text-sm text-gray-500">
                                Kode Merek
                            </span>{' '}
                            <span className="font-medium">{brand.code}</span>
                        </div>
                        <div>
                            <span className="block text-sm text-gray-500">
                                Nama Merek
                            </span>{' '}
                            <span className="font-medium">{brand.name}</span>
                        </div>
                        <div className="col-span-2">
                            <span className="block text-sm text-gray-500">
                                Deskripsi
                            </span>{' '}
                            <span className="font-medium">
                                {brand.description || '-'}
                            </span>
                        </div>
                    </div>

                    <h3 className="mb-3 text-lg font-medium">Daftar Ukuran</h3>
                    <div className="flex flex-wrap gap-2">
                        {brand.size_runs.map((size: any) => (
                            <span
                                key={size.id}
                                className="rounded-lg bg-blue-100 px-4 py-2 font-medium text-blue-800"
                            >
                                {size.size_name}
                            </span>
                        ))}
                    </div>
                </div>
            </div>
        </>
    );
}
