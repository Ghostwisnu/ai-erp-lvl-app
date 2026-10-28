import { Head, Link } from '@inertiajs/react';

export default function Show({ brand }: any) {
    return (
        <>
            <Head title={`Detail Brand: ${brand.name}`} />
            <div className="py-8 max-w-3xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="font-semibold text-xl">Detail Brand</h2>
                        <Link href="/admin/brands" className="text-blue-600">&larr; Kembali</Link>
                    </div>

                    <div className="grid grid-cols-2 gap-4 mb-8 bg-gray-50 p-4 rounded">
                        <div><span className="text-gray-500 text-sm block">Kode Brand</span> <span className="font-medium">{brand.code}</span></div>
                        <div><span className="text-gray-500 text-sm block">Nama Brand</span> <span className="font-medium">{brand.name}</span></div>
                        <div className="col-span-2"><span className="text-gray-500 text-sm block">Deskripsi</span> <span className="font-medium">{brand.description || '-'}</span></div>
                    </div>

                    <h3 className="font-medium text-lg mb-3">Size Run</h3>
                    <div className="flex flex-wrap gap-2">
                        {brand.size_runs.map((size: any) => (
                            <span key={size.id} className="bg-blue-100 text-blue-800 px-4 py-2 rounded-lg font-medium">
                                {size.size_name}
                            </span>
                        ))}
                    </div>
                </div>
            </div>
        </>
    );
}