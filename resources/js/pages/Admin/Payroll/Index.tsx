import { Head, Link, router, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface PayrollRunSummary {
    id: number;
    month: number;
    year: number;
    period_start: string;
    period_end: string;
    status: 'draft' | 'approved' | 'paid';
    items_count: number;
    net_pay_total: number;
}

interface Props {
    payrollRuns: PayrollRunSummary[];
    defaultMonth: number;
    defaultYear: number;
}

const currency = (amount: number) =>
    new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0,
    }).format(amount);

const statusLabels = {
    draft: 'Draft',
    approved: 'Disetujui',
    paid: 'Dibayar',
};

const statusColors = {
    draft: 'bg-yellow-100 text-yellow-800',
    approved: 'bg-blue-100 text-blue-800',
    paid: 'bg-green-100 text-green-800',
};

const deleteDraft = (id: number) => {
    if (
        window.confirm('Hapus draft penggajian ini beserta seluruh rinciannya?')
    ) {
        router.delete(`/admin/payroll/${id}`);
    }
};

export default function Index({
    payrollRuns,
    defaultMonth,
    defaultYear,
}: Props) {
    const form = useForm({
        month: String(defaultMonth),
        year: String(defaultYear),
    });

    const submit = (event: FormEvent) => {
        event.preventDefault();
        form.post('/admin/payroll');
    };

    return (
        <>
            <Head title="Penggajian" />
            <div className="mx-auto max-w-7xl space-y-6 px-4 py-8 sm:px-6 lg:px-8">
                <header>
                    <h1 className="text-2xl font-semibold text-gray-900">
                        Penggajian
                    </h1>
                    <p className="mt-1 text-sm text-gray-600">
                        Kelola perhitungan gaji, persetujuan, dan pembayaran
                        karyawan.
                    </p>
                </header>

                <section className="rounded-lg border bg-white p-5 shadow-sm">
                    <h2 className="text-lg font-semibold">
                        Buat penggajian baru
                    </h2>
                    <p className="mt-1 text-sm text-gray-600">
                        Periode penggajian selalu tanggal 26 sampai 25. Tarif
                        harian adalah gaji pokok ÷ 30 dan tarif lembur per jam
                        adalah gaji pokok ÷ 30 ÷ 8.
                    </p>
                    <form
                        onSubmit={submit}
                        className="mt-4 flex flex-wrap items-end gap-4"
                    >
                        <label className="flex flex-col gap-1 text-sm font-medium">
                            Bulan periode
                            <select
                                value={form.data.month}
                                onChange={(event) =>
                                    form.setData('month', event.target.value)
                                }
                                className="rounded-md border px-3 py-2 font-normal"
                            >
                                {Array.from({ length: 12 }, (_, index) => {
                                    const month = index + 1;
                                    return (
                                        <option key={month} value={month}>
                                            {new Intl.DateTimeFormat('id-ID', {
                                                month: 'long',
                                            }).format(new Date(2026, index, 1))}
                                        </option>
                                    );
                                })}
                            </select>
                            {form.errors.month && (
                                <span className="text-xs text-red-600">
                                    {form.errors.month}
                                </span>
                            )}
                        </label>
                        <label className="flex flex-col gap-1 text-sm font-medium">
                            Tahun
                            <input
                                type="number"
                                min="2000"
                                max="2100"
                                value={form.data.year}
                                onChange={(event) =>
                                    form.setData('year', event.target.value)
                                }
                                className="w-28 rounded-md border px-3 py-2 font-normal"
                            />
                            {form.errors.year && (
                                <span className="text-xs text-red-600">
                                    {form.errors.year}
                                </span>
                            )}
                        </label>
                        <button
                            type="submit"
                            disabled={form.processing}
                            className="rounded-md bg-blue-700 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-800 disabled:opacity-50"
                        >
                            {form.processing
                                ? 'Membuat draft...'
                                : 'Buat draft penggajian'}
                        </button>
                    </form>
                </section>

                <section className="overflow-hidden rounded-lg border bg-white shadow-sm">
                    <div className="border-b px-5 py-4">
                        <h2 className="text-lg font-semibold">
                            Riwayat penggajian
                        </h2>
                    </div>
                    <div className="overflow-x-auto">
                        <table className="w-full min-w-[700px] text-left text-sm">
                            <thead className="bg-gray-50 text-gray-700">
                                <tr>
                                    <th className="p-3">Periode</th>
                                    <th className="p-3">Rentang tanggal</th>
                                    <th className="p-3 text-center">
                                        Karyawan
                                    </th>
                                    <th className="p-3 text-right">
                                        Total gaji bersih
                                    </th>
                                    <th className="p-3 text-center">Status</th>
                                    <th className="p-3 text-right">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {payrollRuns.map((run) => (
                                    <tr key={run.id} className="border-t">
                                        <td className="p-3 font-medium">
                                            {new Intl.DateTimeFormat('id-ID', {
                                                month: 'long',
                                                year: 'numeric',
                                            }).format(
                                                new Date(
                                                    run.year,
                                                    run.month - 1,
                                                    1,
                                                ),
                                            )}
                                        </td>
                                        <td className="p-3">
                                            {run.period_start} –{' '}
                                            {run.period_end}
                                        </td>
                                        <td className="p-3 text-center">
                                            {run.items_count}
                                        </td>
                                        <td className="p-3 text-right">
                                            {currency(run.net_pay_total)}
                                        </td>
                                        <td className="p-3 text-center">
                                            <span
                                                className={`rounded-full px-2.5 py-1 text-xs font-semibold ${statusColors[run.status]}`}
                                            >
                                                {statusLabels[run.status]}
                                            </span>
                                        </td>
                                        <td className="p-3 text-right">
                                            <div className="flex justify-end gap-3">
                                                <Link
                                                    href={`/admin/payroll/${run.id}`}
                                                    className="font-medium text-blue-700 hover:underline"
                                                >
                                                    Lihat detail
                                                </Link>
                                                {run.status === 'draft' && (
                                                    <button
                                                        type="button"
                                                        onClick={() =>
                                                            deleteDraft(run.id)
                                                        }
                                                        className="font-medium text-red-700 hover:underline"
                                                    >
                                                        Hapus draft
                                                    </button>
                                                )}
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                                {payrollRuns.length === 0 && (
                                    <tr>
                                        <td
                                            colSpan={6}
                                            className="p-8 text-center text-gray-500"
                                        >
                                            Belum ada penggajian. Buat draft
                                            untuk memulai.
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>
        </>
    );
}
