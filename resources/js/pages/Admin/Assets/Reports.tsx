import { Head, Link } from '@inertiajs/react';

type Asset = {
    id: number;
    code: string;
    name: string;
    category: { name: string };
    location: { name: string } | null;
    assignee: { name: string } | null;
    status: string;
    acquisition_date: string;
    acquisition_cost: string | number;
    current_book_value: number;
};

type Props = {
    assets: Asset[];
    summary: {
        assetCount: number;
        acquisitionTotal: number;
        bookValueTotal: number;
        maintenanceTotal: number;
    };
};

const money = (value: number | string) =>
    `Rp ${Number(value).toLocaleString('id-ID')}`;

export default function Reports({ assets, summary }: Props) {
    return (
        <>
            <Head title="Laporan Inventaris Aset" />
            <div className="mx-auto max-w-7xl space-y-6 px-4 py-8 sm:px-6 lg:px-8">
                <header className="flex flex-wrap items-center justify-between gap-3">
                    <div>
                        <h1 className="text-2xl font-semibold">
                            Laporan inventaris aset
                        </h1>
                        <p className="text-sm text-muted-foreground">
                            Ringkasan nilai perolehan, penyusutan garis lurus,
                            dan perawatan.
                        </p>
                    </div>
                    <div className="flex gap-2">
                        <Link
                            href="/admin/assets"
                            className="rounded border px-4 py-2 text-sm"
                        >
                            Daftar aset
                        </Link>
                        <a
                            href="/admin/assets/reports/export"
                            className="rounded bg-blue-600 px-4 py-2 text-sm text-white"
                        >
                            Ekspor CSV
                        </a>
                    </div>
                </header>
                <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
                    <SummaryCard
                        label="Jumlah aset"
                        value={summary.assetCount.toLocaleString('id-ID')}
                    />
                    <SummaryCard
                        label="Total nilai perolehan"
                        value={money(summary.acquisitionTotal)}
                    />
                    <SummaryCard
                        label="Total nilai buku"
                        value={money(summary.bookValueTotal)}
                    />
                    <SummaryCard
                        label="Total biaya perawatan"
                        value={money(summary.maintenanceTotal)}
                    />
                </div>
                <div className="overflow-x-auto rounded-lg border bg-white">
                    <table className="w-full min-w-[950px] text-left text-sm">
                        <thead className="bg-gray-50">
                            <tr>
                                <th className="p-3">Kode / Aset</th>
                                <th className="p-3">Kategori</th>
                                <th className="p-3">Lokasi</th>
                                <th className="p-3">Penanggung jawab</th>
                                <th className="p-3">Tanggal perolehan</th>
                                <th className="p-3">Status</th>
                                <th className="p-3 text-right">
                                    Nilai perolehan
                                </th>
                                <th className="p-3 text-right">Nilai buku</th>
                            </tr>
                        </thead>
                        <tbody>
                            {assets.map((asset) => (
                                <tr key={asset.id} className="border-t">
                                    <td className="p-3">
                                        <Link
                                            href={`/admin/assets/${asset.id}`}
                                            className="font-medium text-blue-700 hover:underline"
                                        >
                                            {asset.code}
                                        </Link>
                                        <span className="block">
                                            {asset.name}
                                        </span>
                                    </td>
                                    <td className="p-3">
                                        {asset.category.name}
                                    </td>
                                    <td className="p-3">
                                        {asset.location?.name ?? '-'}
                                    </td>
                                    <td className="p-3">
                                        {asset.assignee?.name ?? '-'}
                                    </td>
                                    <td className="p-3">
                                        {asset.acquisition_date}
                                    </td>
                                    <td className="p-3">
                                        {statusLabel(asset.status)}
                                    </td>
                                    <td className="p-3 text-right">
                                        {money(asset.acquisition_cost)}
                                    </td>
                                    <td className="p-3 text-right">
                                        {money(asset.current_book_value)}
                                    </td>
                                </tr>
                            ))}
                            {assets.length === 0 && (
                                <tr>
                                    <td
                                        colSpan={8}
                                        className="p-8 text-center text-muted-foreground"
                                    >
                                        Belum ada data untuk ditampilkan.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </>
    );
}

function SummaryCard({ label, value }: { label: string; value: string }) {
    return (
        <div className="rounded-lg border bg-white p-5">
            <p className="text-sm text-muted-foreground">{label}</p>
            <p className="mt-2 text-xl font-semibold">{value}</p>
        </div>
    );
}

function statusLabel(status: string) {
    return (
        (
            {
                in_service: 'Digunakan',
                maintenance: 'Dalam perawatan',
                retired: 'Pensiun',
            } as Record<string, string>
        )[status] ?? status
    );
}
