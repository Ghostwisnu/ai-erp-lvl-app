import { Head } from '@inertiajs/react';
import AssetForm from '@/components/assets/asset-form';

export default function Edit({
    asset,
    categories,
    locations,
}: {
    asset: React.ComponentProps<typeof AssetForm>['asset'];
    categories: { id: number; name: string }[];
    locations: { id: number; name: string }[];
}) {
    return (
        <>
            <Head title={`Ubah Aset ${asset?.code ?? ''}`} />
            <div className="mx-auto max-w-4xl px-4 py-8">
                <div className="rounded-lg border bg-white p-6">
                    <h1 className="mb-6 text-2xl font-semibold">Ubah Aset</h1>
                    <AssetForm
                        asset={asset}
                        categories={categories}
                        locations={locations}
                    />
                </div>
            </div>
        </>
    );
}
