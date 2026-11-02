import { FormEvent } from 'react';
import { useForm } from '@inertiajs/react';
import { Link } from '@inertiajs/react';

type Asset = {
    id: number;
    code: string;
    name: string;
    asset_category_id: number;
    asset_location_id: number | null;
    serial_number: string | null;
    brand: string | null;
    model: string | null;
    acquisition_date: string;
    acquisition_cost: string | number;
    salvage_value: string | number;
    useful_life_months: number;
    condition: string;
    status: string;
    description: string | null;
};

type Props = {
    asset?: Asset;
    categories: { id: number; name: string }[];
    locations: { id: number; name: string }[];
};

export default function AssetForm({ asset, categories, locations }: Props) {
    const { data, setData, post, put, processing, errors } = useForm({
        code: asset?.code ?? '',
        name: asset?.name ?? '',
        asset_category_id: asset?.asset_category_id ?? '',
        asset_location_id: asset?.asset_location_id ?? '',
        serial_number: asset?.serial_number ?? '',
        brand: asset?.brand ?? '',
        model: asset?.model ?? '',
        acquisition_date:
            asset?.acquisition_date ?? new Date().toISOString().slice(0, 10),
        acquisition_cost: asset ? Number(asset.acquisition_cost) : 0,
        salvage_value: asset ? Number(asset.salvage_value) : 0,
        useful_life_months: asset?.useful_life_months ?? 60,
        condition: asset?.condition ?? 'good',
        status: asset?.status ?? 'in_service',
        description: asset?.description ?? '',
    });

    const submit = (event: FormEvent) => {
        event.preventDefault();

        if (asset) {
            put(`/admin/assets/${asset.id}`);
        } else {
            post('/admin/assets');
        }
    };

    return (
        <form onSubmit={submit} className="space-y-5">
            <div className="grid gap-4 md:grid-cols-2">
                <Field label="Kode aset" name="code" error={errors.code}>
                    <input
                        id="code"
                        value={data.code}
                        onChange={(event) =>
                            setData('code', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        required
                        maxLength={50}
                    />
                </Field>
                <Field label="Nama aset" name="name" error={errors.name}>
                    <input
                        id="name"
                        value={data.name}
                        onChange={(event) =>
                            setData('name', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        required
                        maxLength={255}
                    />
                </Field>
                <Field
                    label="Kategori"
                    name="asset_category_id"
                    error={errors.asset_category_id}
                >
                    <select
                        id="asset_category_id"
                        value={data.asset_category_id}
                        onChange={(event) =>
                            setData(
                                'asset_category_id',
                                event.target.value
                                    ? Number(event.target.value)
                                    : '',
                            )
                        }
                        className="w-full rounded border p-2"
                        required
                    >
                        <option value="">Pilih kategori</option>
                        {categories.map((category) => (
                            <option key={category.id} value={category.id}>
                                {category.name}
                            </option>
                        ))}
                    </select>
                </Field>
                <Field
                    label="Lokasi"
                    name="asset_location_id"
                    error={errors.asset_location_id}
                >
                    <select
                        id="asset_location_id"
                        value={data.asset_location_id}
                        onChange={(event) =>
                            setData(
                                'asset_location_id',
                                event.target.value
                                    ? Number(event.target.value)
                                    : '',
                            )
                        }
                        className="w-full rounded border p-2"
                    >
                        <option value="">Belum ditentukan</option>
                        {locations.map((location) => (
                            <option key={location.id} value={location.id}>
                                {location.name}
                            </option>
                        ))}
                    </select>
                </Field>
                <Field
                    label="Nomor seri"
                    name="serial_number"
                    error={errors.serial_number}
                >
                    <input
                        id="serial_number"
                        value={data.serial_number}
                        onChange={(event) =>
                            setData('serial_number', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        maxLength={100}
                    />
                </Field>
                <Field label="Merek" name="brand" error={errors.brand}>
                    <input
                        id="brand"
                        value={data.brand}
                        onChange={(event) =>
                            setData('brand', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        maxLength={100}
                    />
                </Field>
                <Field label="Model" name="model" error={errors.model}>
                    <input
                        id="model"
                        value={data.model}
                        onChange={(event) =>
                            setData('model', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        maxLength={100}
                    />
                </Field>
                <Field
                    label="Tanggal perolehan"
                    name="acquisition_date"
                    error={errors.acquisition_date}
                >
                    <input
                        id="acquisition_date"
                        type="date"
                        value={data.acquisition_date}
                        onChange={(event) =>
                            setData('acquisition_date', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        required
                        max={new Date().toISOString().slice(0, 10)}
                    />
                </Field>
                <Field
                    label="Nilai perolehan (Rp)"
                    name="acquisition_cost"
                    error={errors.acquisition_cost}
                >
                    <input
                        id="acquisition_cost"
                        type="number"
                        min="0"
                        step="0.01"
                        value={data.acquisition_cost}
                        onChange={(event) =>
                            setData(
                                'acquisition_cost',
                                Number(event.target.value),
                            )
                        }
                        className="w-full rounded border p-2"
                        required
                    />
                </Field>
                <Field
                    label="Nilai residu (Rp)"
                    name="salvage_value"
                    error={errors.salvage_value}
                >
                    <input
                        id="salvage_value"
                        type="number"
                        min="0"
                        step="0.01"
                        value={data.salvage_value}
                        onChange={(event) =>
                            setData('salvage_value', Number(event.target.value))
                        }
                        className="w-full rounded border p-2"
                        required
                    />
                </Field>
                <Field
                    label="Umur manfaat (bulan)"
                    name="useful_life_months"
                    error={errors.useful_life_months}
                >
                    <input
                        id="useful_life_months"
                        type="number"
                        min="1"
                        max="1200"
                        value={data.useful_life_months}
                        onChange={(event) =>
                            setData(
                                'useful_life_months',
                                Number(event.target.value),
                            )
                        }
                        className="w-full rounded border p-2"
                        required
                    />
                </Field>
                <Field
                    label="Kondisi"
                    name="condition"
                    error={errors.condition}
                >
                    <select
                        id="condition"
                        value={data.condition}
                        onChange={(event) =>
                            setData('condition', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        required
                    >
                        <option value="good">Baik</option>
                        <option value="fair">Cukup</option>
                        <option value="poor">Rusak</option>
                    </select>
                </Field>
                <Field label="Status" name="status" error={errors.status}>
                    <select
                        id="status"
                        value={data.status}
                        onChange={(event) =>
                            setData('status', event.target.value)
                        }
                        className="w-full rounded border p-2"
                        required
                    >
                        <option value="in_service">Digunakan</option>
                        <option value="maintenance">Dalam perawatan</option>
                        <option value="retired">Pensiun</option>
                    </select>
                </Field>
            </div>
            <Field
                label="Keterangan"
                name="description"
                error={errors.description}
            >
                <textarea
                    id="description"
                    value={data.description}
                    onChange={(event) =>
                        setData('description', event.target.value)
                    }
                    className="w-full rounded border p-2"
                    rows={3}
                />
            </Field>
            <div className="flex justify-end gap-2">
                <Link
                    href="/admin/assets"
                    className="rounded bg-gray-200 px-4 py-2"
                >
                    Batal
                </Link>
                <button
                    type="submit"
                    disabled={processing}
                    className="rounded bg-blue-600 px-4 py-2 text-white disabled:opacity-50"
                >
                    {processing
                        ? 'Menyimpan...'
                        : asset
                          ? 'Simpan perubahan'
                          : 'Simpan aset'}
                </button>
            </div>
        </form>
    );
}

function Field({
    label,
    name,
    error,
    children,
}: {
    label: string;
    name: string;
    error?: string;
    children: React.ReactNode;
}) {
    return (
        <div className="grid gap-1">
            <label htmlFor={name} className="text-sm font-medium">
                {label}
            </label>
            {children}
            {error && <p className="text-sm text-red-600">{error}</p>}
        </div>
    );
}
