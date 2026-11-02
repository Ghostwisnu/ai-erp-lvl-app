import { Head } from '@inertiajs/react';
import AssetForm from '@/components/assets/asset-form';

export default function Create({
    categories,
    locations,
}: {
    categories: { id: number; name: string }[];
    locations: { id: number; name: string }[];
}) {
    return (
        <>
            <Head title="Tambah Aset" />
            <div className="mx-auto max-w-4xl px-4 py-8">
                <div className="rounded-lg border bg-white p-6">
                    <h1 className="mb-6 text-2xl font-semibold">Tambah Aset</h1>
                    {categories.length === 0 && (
                        <p className="mb-4 rounded bg-amber-50 p-3 text-sm text-amber-800">
                            Tambahkan kategori sebelum membuat aset.
                        </p>
                    )}
                    <AssetForm categories={categories} locations={locations} />
                </div>
            </div>
        </>
    );
}
