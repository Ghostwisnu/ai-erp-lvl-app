import { Head, Link, router, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

interface Adjustment {
    id: number;
    type: 'allowance' | 'deduction';
    description: string;
    amount: number;
}

interface PayrollItem {
    id: number;
    employee_code: string;
    employee_name: string;
    department: string | null;
    basic_salary: number;
    daily_rate: number;
    unpaid_absence_days: number;
    absence_deduction: number;
    overtime_hours: number;
    overtime_hourly_rate: number;
    overtime_amount: number;
    adjustments: Adjustment[];
    allowance_total: number;
    deduction_total: number;
    net_pay: number;
}

interface PayrollRun {
    id: number;
    month: number;
    year: number;
    period_start: string;
    period_end: string;
    status: 'draft' | 'approved' | 'paid';
}

interface Props {
    payrollRun: PayrollRun;
    items: PayrollItem[];
    totals: {
        basic_salary: number;
        absence_deduction: number;
        overtime_amount: number;
        allowance_total: number;
        deduction_total: number;
        net_pay: number;
    };
}

const currency = (amount: number) =>
    new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0,
    }).format(amount);

const statusLabels: Record<PayrollRun['status'], string> = {
    draft: 'Draft',
    approved: 'Disetujui',
    paid: 'Dibayar',
};

function AdjustmentForm({
    payrollRunId,
    item,
}: {
    payrollRunId: number;
    item: PayrollItem;
}) {
    const form = useForm({
        type: 'allowance' as 'allowance' | 'deduction',
        description: '',
        amount: '',
    });

    const submit = (event: FormEvent) => {
        event.preventDefault();
        form.post(
            `/admin/payroll/${payrollRunId}/items/${item.id}/adjustments`,
            {
                preserveScroll: true,
                onSuccess: () => form.reset('description', 'amount'),
            },
        );
    };

    return (
        <form
            onSubmit={submit}
            className="mt-3 grid gap-2 sm:grid-cols-[130px_1fr_150px_auto]"
        >
            <select
                aria-label="Jenis komponen"
                value={form.data.type}
                onChange={(event) =>
                    form.setData(
                        'type',
                        event.target.value as 'allowance' | 'deduction',
                    )
                }
                className="rounded border px-2 py-1.5 text-xs"
            >
                <option value="allowance">Tunjangan</option>
                <option value="deduction">Potongan</option>
            </select>
            <input
                aria-label="Keterangan komponen"
                value={form.data.description}
                onChange={(event) =>
                    form.setData('description', event.target.value)
                }
                placeholder="Keterangan"
                maxLength={120}
                required
                className="rounded border px-2 py-1.5 text-xs"
            />
            <input
                aria-label="Nominal komponen"
                type="number"
                min="0.01"
                step="0.01"
                value={form.data.amount}
                onChange={(event) => form.setData('amount', event.target.value)}
                placeholder="Nominal (Rp)"
                required
                className="rounded border px-2 py-1.5 text-xs"
            />
            <button
                type="submit"
                disabled={form.processing}
                className="rounded bg-gray-800 px-3 py-1.5 text-xs font-semibold text-white hover:bg-gray-700 disabled:opacity-50"
            >
                Tambahkan
            </button>
            {Object.values(form.errors).length > 0 && (
                <p className="text-xs text-red-600 sm:col-span-4">
                    {Object.values(form.errors).join(' ')}
                </p>
            )}
        </form>
    );
}

export default function Show({ payrollRun, items, totals }: Props) {
    const periodLabel = new Intl.DateTimeFormat('id-ID', {
        month: 'long',
        year: 'numeric',
    }).format(new Date(payrollRun.year, payrollRun.month - 1, 1));

    const submitAction = (action: 'approve' | 'paid', question: string) => {
        if (!window.confirm(question)) {
            return;
        }
        router.post(
            `/admin/payroll/${payrollRun.id}/${action}`,
            {},
            { preserveScroll: true },
        );
    };

    return (
        <>
            <Head title={`Penggajian ${periodLabel}`} />
            <div className="mx-auto max-w-[1600px] space-y-6 px-4 py-8 sm:px-6 lg:px-8">
                <header className="flex flex-wrap items-start justify-between gap-4">
                    <div>
                        <Link
                            href="/admin/payroll"
                            className="text-sm font-medium text-blue-700 hover:underline"
                        >
                            ← Kembali ke penggajian
                        </Link>
                        <h1 className="mt-2 text-2xl font-semibold text-gray-900">
                            Penggajian {periodLabel}
                        </h1>
                        <p className="mt-1 text-sm text-gray-600">
                            Periode {payrollRun.period_start} –{' '}
                            {payrollRun.period_end}
                            {' · '}Tarif lembur per karyawan = gaji pokok ÷ 30 ÷
                            8
                        </p>
                    </div>
                    <div className="flex flex-wrap items-center gap-2">
                        <span className="rounded-full bg-gray-100 px-3 py-1.5 text-sm font-semibold">
                            {statusLabels[payrollRun.status]}
                        </span>
                        <a
                            href={`/admin/payroll/${payrollRun.id}/export/csv`}
                            className="rounded border px-3 py-2 text-sm font-medium hover:bg-gray-50"
                        >
                            Ekspor CSV
                        </a>
                        <a
                            href={`/admin/payroll/${payrollRun.id}/export/xlsx`}
                            className="rounded border px-3 py-2 text-sm font-medium hover:bg-gray-50"
                        >
                            Ekspor Excel
                        </a>
                        {payrollRun.status === 'draft' && (
                            <>
                                <button
                                    type="button"
                                    onClick={() =>
                                        submitAction(
                                            'approve',
                                            'Setujui penggajian ini? Data tidak dapat diubah setelah disetujui.',
                                        )
                                    }
                                    className="rounded bg-blue-700 px-3 py-2 text-sm font-semibold text-white hover:bg-blue-800"
                                >
                                    Setujui penggajian
                                </button>
                                <button
                                    type="button"
                                    onClick={() => {
                                        if (
                                            window.confirm(
                                                'Hapus draft penggajian ini beserta seluruh rinciannya?',
                                            )
                                        ) {
                                            router.delete(
                                                `/admin/payroll/${payrollRun.id}`,
                                            );
                                        }
                                    }}
                                    className="rounded border border-red-300 px-3 py-2 text-sm font-semibold text-red-700 hover:bg-red-50"
                                >
                                    Hapus draft
                                </button>
                            </>
                        )}
                        {payrollRun.status === 'approved' && (
                            <button
                                type="button"
                                onClick={() =>
                                    submitAction(
                                        'paid',
                                        'Tandai seluruh penggajian ini sudah dibayar?',
                                    )
                                }
                                className="rounded bg-green-700 px-3 py-2 text-sm font-semibold text-white hover:bg-green-800"
                            >
                                Tandai sudah dibayar
                            </button>
                        )}
                    </div>
                </header>

                <div className="rounded-lg border border-blue-200 bg-blue-50 p-4 text-sm text-blue-900">
                    Gaji pokok dihitung dengan tarif harian gaji pokok ÷ 30.
                    Setiap ketidakhadiran berstatus Absen, Sakit, atau Izin yang
                    tercatat pada hari kerja dipotong, kecuali tercakup izin
                    yang disetujui. Akhir pekan dan hari libur resmi tidak
                    dihitung sebagai hari potongan. Hari tanpa catatan absensi
                    tidak otomatis dipotong.
                </div>

                <section className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6">
                    {[
                        ['Total gaji pokok', totals.basic_salary],
                        ['Potongan absensi', totals.absence_deduction],
                        ['Uang lembur', totals.overtime_amount],
                        ['Total tunjangan', totals.allowance_total],
                        ['Potongan tambahan', totals.deduction_total],
                        ['Total gaji bersih', totals.net_pay],
                    ].map(([label, amount]) => (
                        <div
                            key={label}
                            className="rounded-lg border bg-white p-4 shadow-sm"
                        >
                            <p className="text-xs text-gray-600">{label}</p>
                            <p className="mt-1 font-semibold text-gray-900">
                                {currency(Number(amount))}
                            </p>
                        </div>
                    ))}
                </section>

                <section className="overflow-x-auto rounded-lg border bg-white shadow-sm">
                    <table className="w-full min-w-[1250px] text-left text-sm">
                        <thead className="bg-gray-50 text-xs text-gray-700 uppercase">
                            <tr>
                                <th className="p-3">Karyawan</th>
                                <th className="p-3 text-right">Gaji pokok</th>
                                <th className="p-3 text-right">Tarif harian</th>
                                <th className="p-3 text-center">
                                    Hari potongan
                                </th>
                                <th className="p-3 text-right">
                                    Potongan absensi
                                </th>
                                <th className="p-3 text-right">Lembur</th>
                                <th className="p-3 text-right">Tunjangan</th>
                                <th className="p-3 text-right">
                                    Potongan lain
                                </th>
                                <th className="p-3 text-right">Gaji bersih</th>
                            </tr>
                        </thead>
                        <tbody>
                            {items.map((item) => (
                                <tr
                                    key={item.id}
                                    className="border-t align-top"
                                >
                                    <td className="p-3">
                                        <p className="font-medium">
                                            {item.employee_name}
                                        </p>
                                        <p className="text-xs text-gray-500">
                                            {item.employee_code} ·{' '}
                                            {item.department ||
                                                'Tanpa departemen'}
                                        </p>
                                    </td>
                                    <td className="p-3 text-right">
                                        {currency(item.basic_salary)}
                                    </td>
                                    <td className="p-3 text-right">
                                        {currency(item.daily_rate)}
                                    </td>
                                    <td className="p-3 text-center">
                                        {item.unpaid_absence_days}
                                    </td>
                                    <td className="p-3 text-right">
                                        {currency(item.absence_deduction)}
                                    </td>
                                    <td className="p-3 text-right">
                                        <span>{item.overtime_hours} jam</span>
                                        <p className="text-xs text-gray-500">
                                            {currency(
                                                item.overtime_hourly_rate,
                                            )}
                                            /jam
                                        </p>
                                        <p className="text-xs text-gray-500">
                                            {currency(item.overtime_amount)}
                                        </p>
                                    </td>
                                    <td className="p-3 text-right">
                                        {currency(item.allowance_total)}
                                    </td>
                                    <td className="p-3 text-right">
                                        {currency(item.deduction_total)}
                                    </td>
                                    <td className="p-3 text-right font-semibold">
                                        {currency(item.net_pay)}
                                    </td>
                                </tr>
                            ))}
                            {items.length === 0 && (
                                <tr>
                                    <td
                                        colSpan={9}
                                        className="p-8 text-center text-gray-500"
                                    >
                                        Tidak ada data karyawan pada periode
                                        ini.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </section>

                {items
                    .filter(
                        (item) =>
                            payrollRun.status === 'draft' ||
                            item.adjustments.length > 0,
                    )
                    .map((item) => (
                        <section
                            key={item.id}
                            className="rounded-lg border bg-white p-4 shadow-sm"
                        >
                            <div className="flex flex-wrap items-start justify-between gap-3">
                                <div>
                                    <h2 className="font-semibold">
                                        {item.employee_name}
                                    </h2>
                                    <p className="text-xs text-gray-500">
                                        {item.employee_code} · Komponen
                                        tunjangan dan potongan
                                    </p>
                                </div>
                                <div className="text-right text-sm">
                                    <p>
                                        Tunjangan:{' '}
                                        <strong>
                                            {currency(item.allowance_total)}
                                        </strong>
                                    </p>
                                    <p>
                                        Potongan:{' '}
                                        <strong>
                                            {currency(item.deduction_total)}
                                        </strong>
                                    </p>
                                </div>
                            </div>
                            {item.adjustments.length > 0 && (
                                <ul className="mt-3 divide-y rounded border">
                                    {item.adjustments.map((adjustment) => (
                                        <li
                                            key={adjustment.id}
                                            className="flex items-center justify-between gap-3 px-3 py-2 text-sm"
                                        >
                                            <span>
                                                {adjustment.type === 'allowance'
                                                    ? 'Tunjangan'
                                                    : 'Potongan'}
                                                {' · '}
                                                {adjustment.description}
                                            </span>
                                            <span className="flex items-center gap-3">
                                                {currency(adjustment.amount)}
                                                {payrollRun.status ===
                                                    'draft' && (
                                                    <button
                                                        type="button"
                                                        onClick={() =>
                                                            router.delete(
                                                                `/admin/payroll/${payrollRun.id}/items/${item.id}/adjustments/${adjustment.id}`,
                                                                {
                                                                    preserveScroll: true,
                                                                },
                                                            )
                                                        }
                                                        className="text-xs text-red-700 hover:underline"
                                                    >
                                                        Hapus
                                                    </button>
                                                )}
                                            </span>
                                        </li>
                                    ))}
                                </ul>
                            )}
                            {payrollRun.status === 'draft' && (
                                <AdjustmentForm
                                    payrollRunId={payrollRun.id}
                                    item={item}
                                />
                            )}
                        </section>
                    ))}
            </div>
        </>
    );
}
