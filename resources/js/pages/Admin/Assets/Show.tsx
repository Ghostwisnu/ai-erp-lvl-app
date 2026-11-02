import { FormEvent } from 'react';
import { Head, Link, useForm } from '@inertiajs/react';
import Barcode from 'react-barcode';

type Asset = {
    id: number;
    code: string;
    name: string;
    serial_number: string | null;
    brand: string | null;
    model: string | null;
    acquisition_date: string;
    acquisition_cost: string | number;
    salvage_value: string | number;
    useful_life_months: number;
    current_book_value: number;
    condition: string;
    status: string;
    description: string | null;
    assigned_to: number | null;
    asset_location_id: number | null;
    category: { name: string };
    location: { name: string } | null;
    assignee: { name: string } | null;
    movements: {
        id: number;
        action: string;
        fromUser: { name: string } | null;
        toUser: { name: string } | null;
        fromLocation: { name: string } | null;
        toLocation: { name: string } | null;
        notes: string | null;
        occurred_at: string;
    }[];
    maintenances: {
        id: number;
        service_date: string;
        service_type: string;
        vendor: string | null;
        description: string;
        cost: string | number;
        next_service_date: string | null;
        status: string;
        performer: { name: string } | null;
    }[];
};

type Props = {
    asset: Asset;
    users: { id: number; name: string }[];
    locations: { id: number; name: string }[];
};

const money = (value: number | string) =>
    `Rp ${Number(value).toLocaleString('id-ID')}`;

export default function Show({ asset, users, locations }: Props) {
    const assignment = useForm({
        assigned_to: asset.assigned_to ?? '',
        asset_location_id: asset.asset_location_id ?? '',
        notes: '',
    });
    const maintenance = useForm({
        service_date: new Date().toISOString().slice(0, 10),
        service_type: 'preventive',
        vendor: '',
        description: '',
        cost: 0,
        next_service_date: '',
        status: 'completed',
    });

    const saveAssignment = (event: FormEvent) => {
        event.preventDefault();
        assignment.post(`/admin/assets/${asset.id}/assign`);
    };
    const saveMaintenance = (event: FormEvent) => {
        event.preventDefault();
        maintenance.post(`/admin/assets/${asset.id}/maintenance`);
    };

    return (
        <>
            <Head title={`Aset ${asset.code}`} />
            <div className="mx-auto max-w-7xl space-y-6 px-4 py-8 sm:px-6 lg:px-8">
                <header className="flex flex-wrap items-start justify-between gap-3 print:hidden">
                    <div>
                        <Link
                            href="/admin/assets"
                            className="text-sm text-blue-700 hover:underline"
                        >
                            &larr; Kembali ke daftar aset
                        </Link>
                        <h1 className="mt-2 text-2xl font-semibold">
                            {asset.name}
                        </h1>
                        <p className="text-sm text-muted-foreground">
                            {asset.code} · {asset.category.name}
                        </p>
                    </div>
                    <Link
                        href={`/admin/assets/${asset.id}/edit`}
                        className="rounded bg-blue-600 px-4 py-2 text-sm text-white"
                    >
                        Edit aset
                    </Link>
                </header>

                <section className="grid gap-4 lg:grid-cols-[1fr_auto] print:block print:border-0">
                    <div className="grid gap-3 rounded-lg border bg-white p-5 sm:grid-cols-2 lg:grid-cols-3 print:hidden">
                        <Info
                            label="Status"
                            value={statusLabel(asset.status)}
                        />
                        <Info
                            label="Kondisi"
                            value={conditionLabel(asset.condition)}
                        />
                        <Info label="Kategori" value={asset.category.name} />
                        <Info
                            label="Lokasi"
                            value={asset.location?.name ?? 'Belum ditentukan'}
                        />
                        <Info
                            label="Penanggung jawab"
                            value={asset.assignee?.name ?? 'Belum ditugaskan'}
                        />
                        <Info
                            label="Nomor seri"
                            value={asset.serial_number ?? '-'}
                        />
                        <Info
                            label="Merek / model"
                            value={
                                [asset.brand, asset.model]
                                    .filter(Boolean)
                                    .join(' / ') || '-'
                            }
                        />
                        <Info
                            label="Tanggal perolehan"
                            value={asset.acquisition_date}
                        />
                        <Info
                            label="Umur manfaat"
                            value={`${asset.useful_life_months} bulan`}
                        />
                        <Info
                            label="Nilai perolehan"
                            value={money(asset.acquisition_cost)}
                        />
                        <Info
                            label="Nilai residu"
                            value={money(asset.salvage_value)}
                        />
                        <Info
                            label="Nilai buku saat ini"
                            value={money(asset.current_book_value)}
                        />
                        {asset.description && (
                            <Info
                                label="Keterangan"
                                value={asset.description}
                            />
                        )}
                    </div>
                    <div className="flex flex-col items-center justify-center rounded-lg border bg-white p-5 print:border-0">
                        <div className="printable-barcode">
                            <Barcode
                                value={asset.code}
                                width={1.5}
                                height={55}
                                fontSize={12}
                            />
                        </div>
                        <button
                            type="button"
                            onClick={() => window.print()}
                            className="mt-3 rounded border px-3 py-2 text-sm print:hidden"
                        >
                            Cetak barcode
                        </button>
                    </div>
                </section>

                <section className="grid gap-6 lg:grid-cols-2 print:hidden">
                    <form
                        onSubmit={saveAssignment}
                        className="space-y-4 rounded-lg border bg-white p-5"
                    >
                        <h2 className="text-lg font-semibold">
                            Mutasi / penanggung jawab
                        </h2>
                        <Field
                            label="Penanggung jawab"
                            error={assignment.errors.assigned_to}
                        >
                            <select
                                value={assignment.data.assigned_to}
                                onChange={(event) =>
                                    assignment.setData(
                                        'assigned_to',
                                        event.target.value
                                            ? Number(event.target.value)
                                            : '',
                                    )
                                }
                                className="w-full rounded border p-2"
                            >
                                <option value="">Tidak ditugaskan</option>
                                {users.map((user) => (
                                    <option key={user.id} value={user.id}>
                                        {user.name}
                                    </option>
                                ))}
                            </select>
                        </Field>
                        <Field
                            label="Lokasi"
                            error={assignment.errors.asset_location_id}
                        >
                            <select
                                value={assignment.data.asset_location_id}
                                onChange={(event) =>
                                    assignment.setData(
                                        'asset_location_id',
                                        event.target.value
                                            ? Number(event.target.value)
                                            : '',
                                    )
                                }
                                className="w-full rounded border p-2"
                            >
                                <option value="">Tidak ditentukan</option>
                                {locations.map((location) => (
                                    <option
                                        key={location.id}
                                        value={location.id}
                                    >
                                        {location.name}
                                    </option>
                                ))}
                            </select>
                        </Field>
                        <Field label="Catatan" error={assignment.errors.notes}>
                            <textarea
                                value={assignment.data.notes}
                                onChange={(event) =>
                                    assignment.setData(
                                        'notes',
                                        event.target.value,
                                    )
                                }
                                className="w-full rounded border p-2"
                                rows={2}
                            />
                        </Field>
                        <button
                            disabled={assignment.processing}
                            className="rounded bg-blue-600 px-4 py-2 text-sm text-white disabled:opacity-50"
                        >
                            Simpan mutasi
                        </button>
                    </form>

                    <form
                        onSubmit={saveMaintenance}
                        className="space-y-4 rounded-lg border bg-white p-5"
                    >
                        <h2 className="text-lg font-semibold">
                            Catat perawatan
                        </h2>
                        <div className="grid gap-3 sm:grid-cols-2">
                            <Field
                                label="Tanggal perawatan"
                                error={maintenance.errors.service_date}
                            >
                                <input
                                    type="date"
                                    required
                                    max={new Date().toISOString().slice(0, 10)}
                                    value={maintenance.data.service_date}
                                    onChange={(event) =>
                                        maintenance.setData(
                                            'service_date',
                                            event.target.value,
                                        )
                                    }
                                    className="w-full rounded border p-2"
                                />
                            </Field>
                            <Field
                                label="Jenis"
                                error={maintenance.errors.service_type}
                            >
                                <select
                                    required
                                    value={maintenance.data.service_type}
                                    onChange={(event) =>
                                        maintenance.setData(
                                            'service_type',
                                            event.target.value,
                                        )
                                    }
                                    className="w-full rounded border p-2"
                                >
                                    <option value="preventive">
                                        Pencegahan
                                    </option>
                                    <option value="corrective">
                                        Perbaikan
                                    </option>
                                    <option value="inspection">Inspeksi</option>
                                    <option value="other">Lainnya</option>
                                </select>
                            </Field>
                            <Field
                                label="Vendor"
                                error={maintenance.errors.vendor}
                            >
                                <input
                                    value={maintenance.data.vendor}
                                    onChange={(event) =>
                                        maintenance.setData(
                                            'vendor',
                                            event.target.value,
                                        )
                                    }
                                    className="w-full rounded border p-2"
                                    maxLength={255}
                                />
                            </Field>
                            <Field
                                label="Biaya (Rp)"
                                error={maintenance.errors.cost}
                            >
                                <input
                                    type="number"
                                    min="0"
                                    step="0.01"
                                    required
                                    value={maintenance.data.cost}
                                    onChange={(event) =>
                                        maintenance.setData(
                                            'cost',
                                            Number(event.target.value),
                                        )
                                    }
                                    className="w-full rounded border p-2"
                                />
                            </Field>
                            <Field
                                label="Jadwal perawatan berikutnya"
                                error={maintenance.errors.next_service_date}
                            >
                                <input
                                    type="date"
                                    value={maintenance.data.next_service_date}
                                    onChange={(event) =>
                                        maintenance.setData(
                                            'next_service_date',
                                            event.target.value,
                                        )
                                    }
                                    className="w-full rounded border p-2"
                                />
                            </Field>
                            <Field
                                label="Status perawatan"
                                error={maintenance.errors.status}
                            >
                                <select
                                    required
                                    value={maintenance.data.status}
                                    onChange={(event) =>
                                        maintenance.setData(
                                            'status',
                                            event.target.value,
                                        )
                                    }
                                    className="w-full rounded border p-2"
                                >
                                    <option value="completed">Selesai</option>
                                    <option value="in_progress">
                                        Sedang berlangsung
                                    </option>
                                </select>
                            </Field>
                        </div>
                        <Field
                            label="Uraian perawatan"
                            error={maintenance.errors.description}
                        >
                            <textarea
                                required
                                value={maintenance.data.description}
                                onChange={(event) =>
                                    maintenance.setData(
                                        'description',
                                        event.target.value,
                                    )
                                }
                                className="w-full rounded border p-2"
                                rows={2}
                            />
                        </Field>
                        <button
                            disabled={maintenance.processing}
                            className="rounded bg-blue-600 px-4 py-2 text-sm text-white disabled:opacity-50"
                        >
                            Simpan perawatan
                        </button>
                    </form>
                </section>

                <HistoryTable
                    title="Riwayat mutasi"
                    empty="Belum ada riwayat mutasi."
                    hasItems={asset.movements.length > 0}
                >
                    <table className="w-full min-w-[700px] text-left text-sm">
                        <thead className="bg-gray-50">
                            <tr>
                                <th className="p-3">Waktu</th>
                                <th className="p-3">Aksi</th>
                                <th className="p-3">Dari</th>
                                <th className="p-3">Ke</th>
                                <th className="p-3">Catatan</th>
                            </tr>
                        </thead>
                        <tbody>
                            {asset.movements.map((item) => (
                                <tr key={item.id} className="border-t">
                                    <td className="p-3">
                                        {new Date(
                                            item.occurred_at,
                                        ).toLocaleString('id-ID')}
                                    </td>
                                    <td className="p-3">
                                        {movementLabel(item.action)}
                                    </td>
                                    <td className="p-3">
                                        {item.fromUser?.name ?? '-'} /{' '}
                                        {item.fromLocation?.name ?? '-'}
                                    </td>
                                    <td className="p-3">
                                        {item.toUser?.name ?? '-'} /{' '}
                                        {item.toLocation?.name ?? '-'}
                                    </td>
                                    <td className="p-3">{item.notes ?? '-'}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </HistoryTable>

                <HistoryTable
                    title="Riwayat perawatan"
                    empty="Belum ada catatan perawatan."
                    hasItems={asset.maintenances.length > 0}
                >
                    <table className="w-full min-w-[700px] text-left text-sm">
                        <thead className="bg-gray-50">
                            <tr>
                                <th className="p-3">Tanggal</th>
                                <th className="p-3">Jenis</th>
                                <th className="p-3">Uraian / vendor</th>
                                <th className="p-3">Status</th>
                                <th className="p-3 text-right">Biaya</th>
                                <th className="p-3">Jadwal berikutnya</th>
                            </tr>
                        </thead>
                        <tbody>
                            {asset.maintenances.map((item) => (
                                <tr key={item.id} className="border-t">
                                    <td className="p-3">{item.service_date}</td>
                                    <td className="p-3">
                                        {serviceLabel(item.service_type)}
                                    </td>
                                    <td className="p-3">
                                        {item.description}
                                        <span className="block text-muted-foreground">
                                            {item.vendor ?? '-'}
                                        </span>
                                    </td>
                                    <td className="p-3">
                                        {item.status === 'completed'
                                            ? 'Selesai'
                                            : 'Berlangsung'}
                                    </td>
                                    <td className="p-3 text-right">
                                        {money(item.cost)}
                                    </td>
                                    <td className="p-3">
                                        {item.next_service_date ?? '-'}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </HistoryTable>
            </div>
        </>
    );
}

function Info({ label, value }: { label: string; value: string }) {
    return (
        <div>
            <p className="text-xs text-muted-foreground">{label}</p>
            <p className="mt-1 font-medium">{value}</p>
        </div>
    );
}

function Field({
    label,
    error,
    children,
}: {
    label: string;
    error?: string;
    children: React.ReactNode;
}) {
    return (
        <div className="grid gap-1">
            <label className="text-sm font-medium">{label}</label>
            {children}
            {error && <p className="text-sm text-red-600">{error}</p>}
        </div>
    );
}

function HistoryTable({
    title,
    empty,
    hasItems,
    children,
}: {
    title: string;
    empty: string;
    hasItems: boolean;
    children: React.ReactNode;
}) {
    return (
        <section className="space-y-3 print:hidden">
            <h2 className="text-lg font-semibold">{title}</h2>
            <div className="overflow-x-auto rounded-lg border bg-white">
                {hasItems ? (
                    children
                ) : (
                    <p className="p-6 text-sm text-muted-foreground">{empty}</p>
                )}
            </div>
        </section>
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

function conditionLabel(condition: string) {
    return (
        (
            { good: 'Baik', fair: 'Cukup', poor: 'Rusak' } as Record<
                string,
                string
            >
        )[condition] ?? condition
    );
}

function movementLabel(action: string) {
    return (
        (
            {
                assigned: 'Penugasan',
                returned: 'Pengembalian',
                transferred: 'Alih penanggung jawab',
                location_changed: 'Perubahan lokasi',
            } as Record<string, string>
        )[action] ?? action
    );
}

function serviceLabel(type: string) {
    return (
        (
            {
                preventive: 'Pencegahan',
                corrective: 'Perbaikan',
                inspection: 'Inspeksi',
                other: 'Lainnya',
            } as Record<string, string>
        )[type] ?? type
    );
}
