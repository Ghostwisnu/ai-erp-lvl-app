import { FormEvent, useState } from 'react';
import { Head, useForm } from '@inertiajs/react';

type CatalogItem = {
    id: number;
    name: string;
    description: string | null;
    assets_count: number;
};
type Props = { categories: CatalogItem[]; locations: CatalogItem[] };

export default function Catalog({ categories, locations }: Props) {
    return (
        <>
            <Head title="Kategori & Lokasi Aset" />
            <div className="mx-auto max-w-6xl space-y-6 px-4 py-8 sm:px-6">
                <header className="flex items-center justify-between gap-4">
                    <div>
                        <h1 className="text-2xl font-semibold">
                            Kategori & lokasi aset
                        </h1>
                        <p className="text-sm text-muted-foreground">
                            Kelola referensi untuk pencatatan aset.
                        </p>
                    </div>
                    <a
                        href="/admin/assets"
                        className="rounded border px-4 py-2 text-sm"
                    >
                        Kembali ke aset
                    </a>
                </header>
                <div className="grid gap-6 lg:grid-cols-2">
                    <CatalogSection
                        title="Kategori"
                        items={categories}
                        endpoint="categories"
                    />
                    <CatalogSection
                        title="Lokasi"
                        items={locations}
                        endpoint="locations"
                    />
                </div>
            </div>
        </>
    );
}

function CatalogSection({
    title,
    items,
    endpoint,
}: {
    title: string;
    items: CatalogItem[];
    endpoint: 'categories' | 'locations';
}) {
    const form = useForm({ name: '', description: '' });
    const submit = (event: FormEvent) => {
        event.preventDefault();
        form.post(`/admin/assets/${endpoint}`, {
            onSuccess: () => form.reset(),
        });
    };

    return (
        <section className="space-y-4 rounded-lg border bg-white p-5">
            <h2 className="text-lg font-semibold">{title}</h2>
            <form onSubmit={submit} className="space-y-3 border-b pb-5">
                <div>
                    <label className="mb-1 block text-sm font-medium">
                        Nama {title.toLowerCase()}
                    </label>
                    <input
                        required
                        maxLength={255}
                        value={form.data.name}
                        onChange={(event) =>
                            form.setData('name', event.target.value)
                        }
                        className="w-full rounded border p-2"
                    />
                    {form.errors.name && (
                        <p className="text-sm text-red-600">
                            {form.errors.name}
                        </p>
                    )}
                </div>
                <div>
                    <label className="mb-1 block text-sm font-medium">
                        Keterangan
                    </label>
                    <textarea
                        value={form.data.description}
                        onChange={(event) =>
                            form.setData('description', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        rows={2}
                    />
                    {form.errors.description && (
                        <p className="text-sm text-red-600">
                            {form.errors.description}
                        </p>
                    )}
                </div>
                <button
                    disabled={form.processing}
                    className="rounded bg-blue-600 px-4 py-2 text-sm text-white disabled:opacity-50"
                >
                    Tambah {title.toLowerCase()}
                </button>
            </form>
            <div className="space-y-3">
                {items.map((item) => (
                    <CatalogRow key={item.id} item={item} endpoint={endpoint} />
                ))}
                {items.length === 0 && (
                    <p className="py-4 text-sm text-muted-foreground">
                        Belum ada {title.toLowerCase()}.
                    </p>
                )}
            </div>
        </section>
    );
}

function CatalogRow({
    item,
    endpoint,
}: {
    item: CatalogItem;
    endpoint: 'categories' | 'locations';
}) {
    const [editing, setEditing] = useState(false);
    const form = useForm({
        name: item.name,
        description: item.description ?? '',
    });
    const submit = (event: FormEvent) => {
        event.preventDefault();
        form.put(`/admin/assets/${endpoint}/${item.id}`, {
            onSuccess: () => setEditing(false),
        });
    };

    if (editing) {
        return (
            <form onSubmit={submit} className="space-y-2 rounded border p-3">
                <input
                    required
                    maxLength={255}
                    value={form.data.name}
                    onChange={(event) =>
                        form.setData('name', event.target.value)
                    }
                    className="w-full rounded border p-2"
                />
                {form.errors.name && (
                    <p className="text-sm text-red-600">{form.errors.name}</p>
                )}
                <textarea
                    value={form.data.description}
                    onChange={(event) =>
                        form.setData('description', event.target.value)
                    }
                    className="w-full rounded border p-2"
                    rows={2}
                />
                {form.errors.description && (
                    <p className="text-sm text-red-600">
                        {form.errors.description}
                    </p>
                )}
                <div className="flex gap-2">
                    <button
                        disabled={form.processing}
                        className="rounded bg-blue-600 px-3 py-1 text-sm text-white"
                    >
                        Simpan
                    </button>
                    <button
                        type="button"
                        onClick={() => setEditing(false)}
                        className="rounded border px-3 py-1 text-sm"
                    >
                        Batal
                    </button>
                </div>
            </form>
        );
    }

    return (
        <div className="flex items-start justify-between gap-3 rounded border p-3">
            <div>
                <p className="font-medium">{item.name}</p>
                <p className="text-sm text-muted-foreground">
                    {item.description || 'Tanpa keterangan'} ·{' '}
                    {item.assets_count} aset
                </p>
            </div>
            <div className="flex shrink-0 gap-2">
                <button
                    type="button"
                    onClick={() => setEditing(true)}
                    className="text-sm text-blue-700 hover:underline"
                >
                    Ubah
                </button>
                <button
                    type="button"
                    onClick={() => {
                        if (
                            item.assets_count === 0 &&
                            window.confirm(`Hapus ${item.name}?`)
                        ) {
                            form.delete(`/admin/assets/${endpoint}/${item.id}`);
                        }
                    }}
                    disabled={item.assets_count > 0}
                    title={
                        item.assets_count > 0 ? 'Masih digunakan aset' : 'Hapus'
                    }
                    className="text-sm text-red-600 disabled:cursor-not-allowed disabled:opacity-40"
                >
                    Hapus
                </button>
            </div>
        </div>
    );
}
