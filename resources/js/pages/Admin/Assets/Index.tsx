import { Head, Link } from '@inertiajs/react';

type Props = {
    assets: {
        data: {
            id: number;
            code: string;
            name: string;
            status: string;
            current_book_value: number;
            category: { name: string } | null;
            location: { name: string } | null;
            assignee: { name: string } | null;
        }[];
        links: { url: string | null; label: string; active: boolean }[];
    };
    categories: { id: number; name: string }[];
    filters: { search?: string; status?: string; category?: string };
};

const money = (value: number | string) =>
    `Rp ${Number(value).toLocaleString('id-ID')}`;

export default function Index({ assets, categories, filters }: Props) {
    return (
        <>
            <Head title="Inventaris Aset" />
            <div className="mx-auto max-w-7xl space-y-5 px-4 py-8 sm:px-6 lg:px-8">
                <header className="flex flex-wrap items-center justify-between gap-3">
                    <div>
                        <h1 className="text-2xl font-semibold">
                            Inventory Aset
                        </h1>
                        <p className="text-sm text-muted-foreground">
                            Daftar aset, penanggung jawab, lokasi, dan nilai
                            buku.
                        </p>
                    </div>
                    <div className="flex gap-2">
                        <Link
                            href="/admin/assets/catalog"
                            className="rounded border px-4 py-2 text-sm"
                        >
                            Kategori & lokasi
                        </Link>
                        <Link
                            href="/admin/assets/reports"
                            className="rounded border px-4 py-2 text-sm"
                        >
                            Laporan
                        </Link>
                        <Link
                            href="/admin/assets/create"
                            className="rounded bg-blue-600 px-4 py-2 text-sm text-white"
                        >
                            + Tambah aset
                        </Link>
                    </div>
                </header>

                <form
                    method="get"
                    action="/admin/assets"
                    className="flex flex-wrap gap-3 rounded-lg border bg-white p-4"
                >
                    <input
                        name="search"
                        defaultValue={filters.search}
                        placeholder="Cari kode, nama, nomor seri"
                        className="min-w-60 flex-1 rounded border p-2"
                    />
                    <select
                        name="category"
                        defaultValue={filters.category ?? ''}
                        className="rounded border p-2"
                    >
                        <option value="">Semua kategori</option>
                        {categories.map((category) => (
                            <option key={category.id} value={category.id}>
                                {category.name}
                            </option>
                        ))}
                    </select>
                    <select
                        name="status"
                        defaultValue={filters.status ?? ''}
                        className="rounded border p-2"
                    >
                        <option value="">Semua status</option>
                        <option value="in_service">Digunakan</option>
                        <option value="maintenance">Dalam perawatan</option>
                        <option value="retired">Pensiun</option>
                    </select>
                    <button className="rounded bg-gray-800 px-4 py-2 text-white">
                        Terapkan
                    </button>
                </form>

                <div className="overflow-x-auto rounded-lg border bg-white">
                    <table className="w-full min-w-[900px] text-left text-sm">
                        <thead className="bg-gray-50">
                            <tr>
                                <th className="p-3">Kode / Aset</th>
                                <th className="p-3">Kategori</th>
                                <th className="p-3">Lokasi</th>
                                <th className="p-3">Penanggung jawab</th>
                                <th className="p-3">Status</th>
                                <th className="p-3 text-right">Nilai buku</th>
                                <th className="p-3">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {assets.data.map((asset) => (
                                <tr key={asset.id} className="border-t">
                                    <td className="p-3">
                                        <span className="font-medium">
                                            {asset.code}
                                        </span>
                                        <span className="block text-muted-foreground">
                                            {asset.name}
                                        </span>
                                    </td>
                                    <td className="p-3">
                                        {asset.category?.name}
                                    </td>
                                    <td className="p-3">
                                        {asset.location?.name ?? '-'}
                                    </td>
                                    <td className="p-3">
                                        {asset.assignee?.name ??
                                            'Belum ditugaskan'}
                                    </td>
                                    <td className="p-3">
                                        {statusLabel(asset.status)}
                                    </td>
                                    <td className="p-3 text-right">
                                        {money(asset.current_book_value)}
                                    </td>
                                    <td className="space-x-2 p-3 whitespace-nowrap">
                                        <Link
                                            href={`/admin/assets/${asset.id}`}
                                            className="text-blue-700 hover:underline"
                                        >
                                            Detail
                                        </Link>
                                        <Link
                                            href={`/admin/assets/${asset.id}/edit`}
                                            className="text-blue-700 hover:underline"
                                        >
                                            Ubah
                                        </Link>
                                        <Link
                                            href={`/admin/assets/${asset.id}`}
                                            method="delete"
                                            as="button"
                                            onClick={(event) => {
                                                if (
                                                    !window.confirm(
                                                        `Hapus aset ${asset.code}?`,
                                                    )
                                                )
                                                    event.preventDefault();
                                            }}
                                            className="text-red-600 hover:underline"
                                        >
                                            Hapus
                                        </Link>
                                    </td>
                                </tr>
                            ))}
                            {assets.data.length === 0 && (
                                <tr>
                                    <td
                                        colSpan={7}
                                        className="p-8 text-center text-muted-foreground"
                                    >
                                        Belum ada data aset.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
                <div className="flex flex-wrap gap-1">
                    {assets.links.map((link, index) =>
                        link.url ? (
                            <Link
                                key={index}
                                href={link.url}
                                className={`rounded border px-3 py-1 text-sm ${link.active ? 'bg-blue-600 text-white' : ''}`}
                                dangerouslySetInnerHTML={{ __html: link.label }}
                            />
                        ) : (
                            <span
                                key={index}
                                className="rounded border px-3 py-1 text-sm text-gray-400"
                                dangerouslySetInnerHTML={{ __html: link.label }}
                            />
                        ),
                    )}
                </div>
            </div>
        </>
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
