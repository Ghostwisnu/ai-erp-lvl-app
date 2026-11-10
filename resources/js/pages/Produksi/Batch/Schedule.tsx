import React, { useState } from 'react';
import { Head, Link, router } from '@inertiajs/react';
import { jsPDF } from 'jspdf';
import 'jspdf-autotable';

export default function Schedule({ spks, finishingScans, brands }: any) {
    const departments = [
        { key: 'cutting', label: 'CUTTING' },
        { key: 'sewing', label: 'SEWING' },
        { key: 'lasting', label: 'LASTING' },
        { key: 'cementing', label: 'CEMENTING' },
        { key: 'injection', label: 'INJECTION' },
        { key: 'finishing', label: 'FINISHING' },
        { key: 'packing', label: 'PACKING' },
    ];

    // --- STATE UNTUK BULK INPUT ---
    const [isBulkModalOpen, setIsBulkModalOpen] = useState(false);
    const [bulkDept, setBulkDept] = useState('cutting');
    const [bulkDate, setBulkDate] = useState(
        new Date().toISOString().split('T')[0],
    );
    const [bulkQty, setBulkQty] = useState<{ [key: string]: number }>({});
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [selectedBrandId, setSelectedBrandId] = useState('');

    // --- STATE UNTUK INPUT BERDASARKAN SIZE RUN (PILIH SPK DULU) ---
    const [isSizeRunModalOpen, setIsSizeRunModalOpen] = useState(false);
    const [sizeRunDept, setSizeRunDept] = useState('cutting');
    const [sizeRunDate, setSizeRunDate] = useState(
        new Date().toISOString().split('T')[0],
    );
    const [selectedSpkId, setSelectedSpkId] = useState('');
    const [selectedBatchId, setSelectedBatchId] = useState('');
    const [sizeRunQty, setSizeRunQty] = useState<{ [key: string]: number }>({});
    const [isSizeRunSubmitting, setIsSizeRunSubmitting] = useState(false);

    // --- STATE UNTUK EXPAND ROW (HISTORI) ---
    const [expandedRow, setExpandedRow] = useState<string | null>(null);

    const toggleRow = (rowId: string) => {
        setExpandedRow((prev) => (prev === rowId ? null : rowId));
    };

    // --- RATAKAN DATA SPK & BATCH ---
    const allRows: any[] = [];
    spks.forEach((spk: any) => {
        if (spk.batches && spk.batches.length > 0) {
            spk.batches.forEach((batch: any) => {
                allRows.push({
                    id: `batch-${batch.id}`,
                    type: 'batch',
                    spk,
                    batch,
                    po_display: `${spk.po_number}-${batch.batch_code}`,
                    qty: batch.qty,
                    sizes: batch.sizes, // <-- Simpan sizes di row
                    tracks: batch.tracks,
                    dailies: batch.dailies,
                });
            });
        } else {
            const totalQty = spk.details.reduce(
                (sum: number, d: any) => sum + d.qty,
                0,
            );
            allRows.push({
                id: `spk-${spk.id}`,
                type: 'spk',
                spk,
                batch: null,
                po_display: spk.po_number,
                qty: totalQty,
                sizes: spk.details, // <-- Simpan sizes di row
                tracks: [],
                dailies: spk.dailies,
            });
        }
    });
    const visibleRows = selectedBrandId
        ? allRows.filter((row) => String(row.spk.brand_id) === selectedBrandId)
        : allRows;

    // --- LOGIKA BULK INPUT ---
    const handleOpenBulk = (dept: string) => {
        setBulkDept(dept);
        setBulkQty({});
        setIsBulkModalOpen(true);
    };

    const handleQtyChange = (rowId: string, val: string) => {
        setBulkQty((prev) => ({ ...prev, [rowId]: Number(val) }));
    };

    const submitBulk = (e: React.FormEvent) => {
        e.preventDefault();
        setIsSubmitting(true);

        const items = visibleRows
            .filter((row) => bulkQty[row.id] > 0)
            .map((row) => ({
                spk_id: row.spk.id,
                spk_batch_id: row.batch ? row.batch.id : null,
                qty: bulkQty[row.id] || 0,
            }));

        if (items.length === 0) {
            alert('Masukkan setidaknya satu jumlah hasil.');
            setIsSubmitting(false);
            return;
        }

        router.post(
            '/produksi/daily-output',
            {
                report_date: bulkDate,
                department: bulkDept,
                items: items,
            },
            {
                onSuccess: () => {
                    setIsBulkModalOpen(false);
                    setIsSubmitting(false);
                },
                onError: () => setIsSubmitting(false),
            },
        );
    };

    const handleDeleteDaily = (dailyId: number) => {
        if (confirm('Hapus riwayat ini?')) {
            router.delete(`/produksi/daily-output/${dailyId}`);
        }
    };

    // --- LOGIKA INPUT BERDASARKAN SIZE RUN (PILIH SPK DULU) ---
    const handleOpenSizeRun = (dept: string) => {
        setSizeRunDept(dept);
        setSizeRunQty({});
        setSelectedSpkId('');
        setSelectedBatchId('');
        setIsSizeRunModalOpen(true);
    };

    const handleSizeRunQtyChange = (sizeName: string, val: string) => {
        setSizeRunQty((prev) => ({ ...prev, [sizeName]: Number(val) }));
    };

    // Ambil sizes dari SPK atau Batch yang dipilih
    const getSelectedSizes = () => {
        if (!selectedSpkId) return [];

        const spk = spks.find((s: any) => s.id == selectedSpkId);
        if (!spk) return [];

        if (selectedBatchId) {
            const batch = spk.batches?.find(
                (b: any) => b.id == selectedBatchId,
            );
            return batch?.sizes || [];
        }

        // Jika SPK tanpa batch, gunakan spk.details
        return spk.details || [];
    };

    const submitSizeRun = (e: React.FormEvent) => {
        e.preventDefault();
        setIsSizeRunSubmitting(true);

        const sizes = getSelectedSizes();
        const items = sizes
            .filter((size: any) => sizeRunQty[size.size_name] > 0)
            .map((size: any) => ({
                spk_id: selectedSpkId,
                spk_batch_id: selectedBatchId || null,
                qty: sizeRunQty[size.size_name] || 0,
            }));

        if (items.length === 0) {
            alert('Masukkan setidaknya satu jumlah hasil per size.');
            setIsSizeRunSubmitting(false);
            return;
        }

        router.post(
            '/produksi/daily-output',
            {
                report_date: sizeRunDate,
                department: sizeRunDept,
                items: items,
            },
            {
                onSuccess: () => {
                    setIsSizeRunModalOpen(false);
                    setIsSizeRunSubmitting(false);
                    setSizeRunQty({});
                    setSelectedSpkId('');
                    setSelectedBatchId('');
                },
                onError: () => setIsSizeRunSubmitting(false),
            },
        );
    };

    // --- HELPER UNTUK HITUNG SCAN FINISHING PER BATCH ---
    const calculateFinishingScan = (row: any) => {
        let total = 0;
        if (row.sizes && row.sizes.length > 0) {
            row.sizes.forEach((size: any) => {
                // PERBAIKAN: Hanya hitung jika Qty di batch ini > 0
                if (size.qty > 0) {
                    const spkScans = finishingScans[row.spk.id];
                    if (spkScans && spkScans[size.size_name]) {
                        total += Number(spkScans[size.size_name].total_scan);
                    }
                }
            });
        }
        return total;
    };

    // PDF Export function
    const exportToPDF = () => {
        const doc = new jsPDF('landscape', 'mm', 'a4');

        // Title
        doc.setFontSize(16);
        doc.setFont('helvetica', 'bold');
        doc.text('PRODUCTION PROGRESS SCHEDULE (PPS)', 14, 12);

        // Date and filter info
        doc.setFontSize(9);
        doc.setFont('helvetica', 'normal');
        const today = new Date().toLocaleDateString('en-GB', {
            day: '2-digit',
            month: 'short',
            year: 'numeric',
        });
        doc.text(`Printed: ${today}`, 14, 18);
        if (selectedBrandId) {
            const brand = brands.find((b: any) => b.id == selectedBrandId);
            doc.text(`Brand: ${brand?.name || ''}`, 14, 23);
        }

        // Prepare table data
        const tableHead = [
            [
                'NO',
                'PO NO.',
                'MODEL',
                'COLOR',
                'QTY',
                ...departments.flatMap((d) => [
                    d.label + ' DATE',
                    d.label + ' DAILY',
                    d.label + ' TOTAL',
                    d.label + ' BALANCE',
                ]),
                'XFD',
            ],
        ];

        const tableBody = visibleRows.map((row: any, index: number) => {
            const rowData = [
                index + 1,
                row.po_display,
                row.spk.brand?.name || '',
                row.spk.art_color || '',
                row.qty,
            ];

            departments.forEach((dept) => {
                const track = row.tracks.find(
                    (t: any) => t.department === dept.key,
                );
                let totalOutput = 0;
                let latestDaily = null;

                if (dept.key === 'finishing') {
                    totalOutput = calculateFinishingScan(row);
                    latestDaily =
                        totalOutput > 0
                            ? { qty: totalOutput, report_date: null }
                            : null;
                } else {
                    totalOutput = row.dailies
                        .filter((d: any) => d.department === dept.key)
                        .reduce((sum: number, d: any) => sum + d.qty, 0);
                    latestDaily = row.dailies
                        .filter((d: any) => d.department === dept.key)
                        .sort(
                            (a: any, b: any) =>
                                new Date(b.report_date).getTime() -
                                new Date(a.report_date).getTime(),
                        )[0];
                }

                const balance = row.qty - totalOutput;

                let startDate = '-';
                if (track) {
                    startDate = new Date(track.start_date).toLocaleDateString(
                        'en-GB',
                        { day: '2-digit', month: '2-digit' },
                    );
                } else if (
                    row.type === 'spk' &&
                    dept.key === 'cutting' &&
                    row.spk.start_date
                ) {
                    startDate = new Date(row.spk.start_date).toLocaleDateString(
                        'en-GB',
                        { day: '2-digit', month: '2-digit' },
                    );
                }

                rowData.push(
                    startDate,
                    dept.key === 'finishing'
                        ? '-'
                        : latestDaily
                          ? latestDaily.qty
                          : '-',
                    totalOutput > 0 ? totalOutput : '-',
                    balance,
                );
            });

            rowData.push(
                new Date(row.spk.xfd_date).toLocaleDateString('en-GB', {
                    day: '2-digit',
                    month: 'short',
                }),
            );

            return rowData;
        });

        // @ts-ignore
        doc.autoTable({
            head: tableHead,
            body: tableBody,
            startY: selectedBrandId ? 28 : 22,
            margin: { left: 10, right: 10 },
            styles: { fontSize: 6, cellPadding: 1 },
            headStyles: {
                fillColor: [200, 200, 200],
                textColor: 0,
                fontStyle: 'bold',
            },
            alternateRowStyles: { fillColor: [245, 245, 245] },
            columnStyles: {
                0: { cellWidth: 8 }, // NO
                1: { cellWidth: 25 }, // PO NO
                2: { cellWidth: 20 }, // MODEL
                3: { cellWidth: 15 }, // COLOR
                4: { cellWidth: 12 }, // QTY
                // Department columns will be auto-sized
                [tableHead[0].length - 1]: { cellWidth: 18 }, // XFD
            },
            didDrawPage: (data: any) => {
                // Footer
                const pageCount = doc.getNumberOfPages();
                doc.setFontSize(7);
                doc.text(
                    `Page ${data.pageNumber} of ${pageCount}`,
                    doc.internal.pageSize.width - 20,
                    doc.internal.pageSize.height - 5,
                    { align: 'right' },
                );
            },
        });

        doc.save(
            `PPS_${selectedBrandId ? 'brand-' + selectedBrandId : 'all'}_${new Date().toISOString().split('T')[0]}.pdf`,
        );
    };

    return (
        <>
            <Head title="Production Progress Schedule" />
            <div className="mx-auto max-w-full px-4 py-8">
                {/* Header */}
                <div className="mb-6 flex items-center justify-between">
                    <h1 className="text-2xl font-bold uppercase">
                        Production Progress Schedule
                    </h1>
                    <div className="flex flex-wrap items-center justify-end gap-2">
                        <label
                            htmlFor="brand-filter"
                            className="text-sm font-medium"
                        >
                            Filter Brand
                        </label>
                        <select
                            id="brand-filter"
                            value={selectedBrandId}
                            onChange={(event) =>
                                setSelectedBrandId(event.target.value)
                            }
                            className="rounded border border-gray-300 bg-white px-3 py-2 text-sm"
                        >
                            <option value="">All Brands</option>
                            {brands.map((brand: any) => (
                                <option key={brand.id} value={brand.id}>
                                    {brand.name}
                                </option>
                            ))}
                        </select>
                        <a
                            href={`/produksi/spk-schedules/export${selectedBrandId ? `?brand_id=${encodeURIComponent(selectedBrandId)}` : ''}`}
                            className="rounded bg-green-700 px-4 py-2 text-sm font-bold text-white shadow hover:bg-green-800"
                        >
                            Export Excel
                        </a>
                        <button
                            onClick={exportToPDF}
                            className="rounded bg-red-600 px-4 py-2 text-sm font-bold text-white shadow hover:bg-red-700"
                        >
                            Export PDF
                        </button>
                        <button
                            onClick={() => handleOpenBulk('cutting')}
                            className="rounded bg-blue-600 px-4 py-2 text-sm font-bold text-white shadow hover:bg-blue-700"
                        >
                            + Bulk Daily Input
                        </button>
                        <Link
                            href="/produksi/spks"
                            className="text-sm font-medium text-blue-600 hover:underline"
                        >
                            &larr; Back to SPK
                        </Link>
                        <button
                            onClick={() => handleOpenSizeRun('cutting')}
                            className="rounded bg-purple-600 px-4 py-2 text-sm font-bold text-white shadow hover:bg-purple-700"
                        >
                            + Input by Size Run
                        </button>
                    </div>
                </div>

                {/* Tabel PPS */}
                <div className="overflow-x-auto border bg-white shadow-sm">
                    <table className="w-full border-collapse text-center text-[10px]">
                        <thead>
                            <tr className="border-b bg-gray-200">
                                <th
                                    rowSpan={2}
                                    className="w-12 border border-black p-1"
                                >
                                    NO
                                </th>
                                <th
                                    rowSpan={2}
                                    className="border border-black p-1"
                                >
                                    PO NO.
                                </th>
                                <th
                                    rowSpan={2}
                                    className="border border-black p-1"
                                >
                                    MODEL
                                </th>
                                <th
                                    rowSpan={2}
                                    className="border border-black p-1"
                                >
                                    COLOR
                                </th>
                                <th
                                    rowSpan={2}
                                    className="border border-black p-1"
                                >
                                    QTY
                                </th>
                                {departments.map((d) => (
                                    <th
                                        key={d.key}
                                        colSpan={4}
                                        className="border border-black p-1"
                                    >
                                        {d.label}
                                    </th>
                                ))}
                                <th
                                    rowSpan={2}
                                    className="border border-black bg-yellow-100 p-1"
                                >
                                    XFD
                                </th>
                            </tr>
                            <tr className="border-b bg-gray-100">
                                {departments.map((d) => (
                                    <React.Fragment key={d.key}>
                                        <th className="border border-black bg-gray-50 p-1">
                                            DATE
                                        </th>
                                        <th className="border border-black bg-gray-50 p-1">
                                            DAILY
                                        </th>
                                        <th className="border border-black bg-gray-50 p-1">
                                            TOTAL
                                        </th>
                                        <th className="border border-black bg-red-50 p-1 text-red-700">
                                            BALANCE
                                        </th>
                                    </React.Fragment>
                                ))}
                            </tr>
                        </thead>
                        <tbody>
                            {visibleRows.length === 0 ? (
                                <tr>
                                    <td
                                        colSpan={departments.length * 4 + 6}
                                        className="border border-black p-6 text-center text-gray-500"
                                    >
                                        No PPS data for this brand.
                                    </td>
                                </tr>
                            ) : (
                                visibleRows.map((row: any, index: number) => {
                                    const isExpanded = expandedRow === row.id;
                                    return (
                                        <React.Fragment key={row.id}>
                                            <tr
                                                className={`border-b hover:bg-gray-50 ${isExpanded ? 'bg-blue-50' : ''}`}
                                            >
                                                <td className="border border-black p-1">
                                                    <div className="flex flex-col items-center">
                                                        <span>{index + 1}</span>
                                                        <button
                                                            onClick={() =>
                                                                toggleRow(
                                                                    row.id,
                                                                )
                                                            }
                                                            className="mt-1 text-xs font-bold text-blue-600 transition hover:scale-125"
                                                        >
                                                            {isExpanded
                                                                ? '[ - ]'
                                                                : '[ + ]'}
                                                        </button>
                                                    </div>
                                                </td>
                                                <td className="border border-black p-1 font-bold">
                                                    {row.po_display}
                                                    {row.type === 'spk' && (
                                                        <span className="block text-[8px] text-gray-400">
                                                            (SPK)
                                                        </span>
                                                    )}
                                                </td>
                                                <td className="border border-black p-1">
                                                    {row.spk.brand?.name}
                                                </td>
                                                <td className="border border-black p-1">
                                                    {row.spk.art_color}
                                                </td>
                                                <td className="border border-black p-1 font-bold">
                                                    {row.qty}
                                                </td>

                                                {departments.map((dept) => {
                                                    const track =
                                                        row.tracks.find(
                                                            (t: any) =>
                                                                t.department ===
                                                                dept.key,
                                                        );

                                                    let totalOutput = 0;
                                                    let latestDaily = null;

                                                    // LOGIKA BARU: JIKA FINISHING, HITUNG DARI SCAN BERDASARKAN SIZE DI BATCH
                                                    if (
                                                        dept.key === 'finishing'
                                                    ) {
                                                        totalOutput =
                                                            calculateFinishingScan(
                                                                row,
                                                            );

                                                        // Untuk kolom "Daily" di finishing, kita kosongkan (-) karena data scan adalah akumulasi total.
                                                        latestDaily =
                                                            totalOutput > 0
                                                                ? {
                                                                      qty: totalOutput,
                                                                      report_date:
                                                                          null,
                                                                  }
                                                                : null;
                                                    } else {
                                                        // DEPARTEMEN LAIN: GUNAKAN INPUT MANUAL
                                                        totalOutput =
                                                            row.dailies
                                                                .filter(
                                                                    (d: any) =>
                                                                        d.department ===
                                                                        dept.key,
                                                                )
                                                                .reduce(
                                                                    (
                                                                        sum: number,
                                                                        d: any,
                                                                    ) =>
                                                                        sum +
                                                                        d.qty,
                                                                    0,
                                                                );

                                                        latestDaily =
                                                            row.dailies
                                                                .filter(
                                                                    (d: any) =>
                                                                        d.department ===
                                                                        dept.key,
                                                                )
                                                                .sort(
                                                                    (
                                                                        a: any,
                                                                        b: any,
                                                                    ) =>
                                                                        new Date(
                                                                            b.report_date,
                                                                        ).getTime() -
                                                                        new Date(
                                                                            a.report_date,
                                                                        ).getTime(),
                                                                )[0];
                                                    }

                                                    const balance =
                                                        row.qty - totalOutput;

                                                    let startDate = '-';
                                                    if (track) {
                                                        startDate = new Date(
                                                            track.start_date,
                                                        ).toLocaleDateString(
                                                            'id-ID',
                                                            {
                                                                day: '2-digit',
                                                                month: '2-digit',
                                                            },
                                                        );
                                                    } else if (
                                                        row.type === 'spk' &&
                                                        dept.key ===
                                                            'cutting' &&
                                                        row.spk.start_date
                                                    ) {
                                                        startDate = new Date(
                                                            row.spk.start_date,
                                                        ).toLocaleDateString(
                                                            'id-ID',
                                                            {
                                                                day: '2-digit',
                                                                month: '2-digit',
                                                            },
                                                        );
                                                    }

                                                    return (
                                                        <React.Fragment
                                                            key={`${index}-${dept.key}`}
                                                        >
                                                            <td className="border border-black p-1">
                                                                {startDate}
                                                            </td>
                                                            <td className="border border-black p-1">
                                                                {/* Untuk Finishing, kolom DAILY kita kosongkan (-) agar tidak duplikat dengan TOTAL */}
                                                                {dept.key ===
                                                                'finishing'
                                                                    ? '-'
                                                                    : latestDaily
                                                                      ? latestDaily.qty
                                                                      : '-'}
                                                            </td>
                                                            <td className="border border-black p-1 font-bold">
                                                                {totalOutput > 0
                                                                    ? totalOutput
                                                                    : '-'}
                                                            </td>
                                                            <td
                                                                className={`border border-black p-1 font-bold ${balance <= 0 ? 'text-green-600' : 'text-red-600'}`}
                                                            >
                                                                {balance}
                                                            </td>
                                                        </React.Fragment>
                                                    );
                                                })}

                                                <td className="border border-black p-1 font-bold text-red-600">
                                                    {new Date(
                                                        row.spk.xfd_date,
                                                    ).toLocaleDateString(
                                                        'en-GB',
                                                        {
                                                            day: '2-digit',
                                                            month: 'short',
                                                        },
                                                    )}
                                                </td>
                                            </tr>

                                            {/* HISTORY ROW */}
                                            {isExpanded && (
                                                <tr>
                                                    <td
                                                        colSpan={
                                                            departments.length *
                                                                4 +
                                                            6
                                                        }
                                                        className="border-b bg-gray-50 p-4"
                                                    >
                                                        <div className="mx-auto max-w-3xl">
                                                            <h4 className="mb-2 text-sm font-bold text-gray-700">
                                                                Daily Input
                                                                History:{' '}
                                                                {row.po_display}
                                                            </h4>
                                                            <table className="w-full rounded border bg-white text-left text-xs">
                                                                <thead className="bg-gray-200">
                                                                    <tr>
                                                                        <th className="border-b p-2">
                                                                            Report
                                                                            Date
                                                                        </th>
                                                                        <th className="border-b p-2">
                                                                            Department
                                                                        </th>
                                                                        <th className="border-b p-2 text-center">
                                                                            Qty
                                                                            Output
                                                                        </th>
                                                                        <th className="w-20 border-b p-2 text-center">
                                                                            Action
                                                                        </th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    {row.dailies
                                                                        .length ===
                                                                    0 ? (
                                                                        <tr>
                                                                            <td
                                                                                colSpan={
                                                                                    4
                                                                                }
                                                                                className="p-3 text-center text-gray-400"
                                                                            >
                                                                                No
                                                                                daily
                                                                                input
                                                                                yet.
                                                                            </td>
                                                                        </tr>
                                                                    ) : (
                                                                        row.dailies
                                                                            .sort(
                                                                                (
                                                                                    a: any,
                                                                                    b: any,
                                                                                ) =>
                                                                                    new Date(
                                                                                        b.report_date,
                                                                                    ).getTime() -
                                                                                    new Date(
                                                                                        a.report_date,
                                                                                    ).getTime(),
                                                                            )
                                                                            .map(
                                                                                (
                                                                                    daily: any,
                                                                                ) => (
                                                                                    <tr
                                                                                        key={
                                                                                            daily.id
                                                                                        }
                                                                                        className="border-b hover:bg-gray-50"
                                                                                    >
                                                                                        <td className="p-2">
                                                                                            {new Date(
                                                                                                daily.report_date,
                                                                                            ).toLocaleDateString(
                                                                                                'en-GB',
                                                                                                {
                                                                                                    day: '2-digit',
                                                                                                    month: 'long',
                                                                                                    year: 'numeric',
                                                                                                },
                                                                                            )}
                                                                                        </td>
                                                                                        <td className="p-2 font-medium uppercase">
                                                                                            {
                                                                                                daily.department
                                                                                            }
                                                                                        </td>
                                                                                        <td className="p-2 text-center font-bold text-blue-600">
                                                                                            {
                                                                                                daily.qty
                                                                                            }
                                                                                        </td>
                                                                                        <td className="p-2 text-center">
                                                                                            <button
                                                                                                onClick={() =>
                                                                                                    handleDeleteDaily(
                                                                                                        daily.id,
                                                                                                    )
                                                                                                }
                                                                                                className="text-red-500 hover:underline"
                                                                                            >
                                                                                                Delete
                                                                                            </button>
                                                                                        </td>
                                                                                    </tr>
                                                                                ),
                                                                            )
                                                                    )}
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                            )}
                                        </React.Fragment>
                                    );
                                })
                            )}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* MODAL BULK INPUT */}
            {isBulkModalOpen && (
                <div className="bg-opacity-50 fixed inset-0 z-50 flex items-center justify-center bg-black p-4">
                    <div className="flex max-h-[90vh] w-full max-w-4xl flex-col rounded-lg bg-white shadow-xl">
                        <div className="flex items-center justify-between rounded-t-lg border-b bg-gray-50 p-4">
                            <h3 className="text-lg font-bold">
                                Bulk Daily Input
                            </h3>
                            <button
                                onClick={() => setIsBulkModalOpen(false)}
                                className="text-xl font-bold text-gray-500 hover:text-red-500"
                            >
                                &times;
                            </button>
                        </div>

                        <form
                            onSubmit={submitBulk}
                            className="flex flex-col overflow-hidden p-4"
                        >
                            <div className="mb-4 flex gap-4 rounded border border-blue-100 bg-blue-50 p-3">
                                <div className="flex-1">
                                    <label className="mb-1 block text-sm font-medium">
                                        Report Date
                                    </label>
                                    <input
                                        type="date"
                                        value={bulkDate}
                                        onChange={(e) =>
                                            setBulkDate(e.target.value)
                                        }
                                        className="w-full rounded border p-2"
                                        required
                                    />
                                </div>
                                <div className="flex-1">
                                    <label className="mb-1 block text-sm font-medium">
                                        Department
                                    </label>
                                    <select
                                        value={bulkDept}
                                        onChange={(e) =>
                                            setBulkDept(e.target.value)
                                        }
                                        className="w-full rounded border p-2"
                                    >
                                        {/* Only show departments except finishing, as finishing uses scan */}
                                        {departments
                                            .filter(
                                                (d) => d.key !== 'finishing',
                                            )
                                            .map((d) => (
                                                <option
                                                    key={d.key}
                                                    value={d.key}
                                                >
                                                    {d.label}
                                                </option>
                                            ))}
                                    </select>
                                </div>
                            </div>

                            <div className="flex-1 overflow-y-auto rounded border">
                                <table className="w-full text-left text-sm">
                                    <thead className="sticky top-0 bg-gray-100">
                                        <tr>
                                            <th className="border-b p-2">
                                                PO / Group
                                            </th>
                                            <th className="border-b p-2 text-center">
                                                Total Qty
                                            </th>
                                            <th className="border-b p-2 text-center">
                                                Balance
                                            </th>
                                            <th className="w-32 border-b p-2 text-center">
                                                Daily Output
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {visibleRows.map((row: any) => {
                                            // Calculate Balance SPECIFIC for department selected in modal
                                            let currentOutput = 0;

                                            if (bulkDept === 'finishing') {
                                                // Safety check if finishing selected (though hidden)
                                                currentOutput =
                                                    calculateFinishingScan(row);
                                            } else {
                                                currentOutput = row.dailies
                                                    .filter(
                                                        (d: any) =>
                                                            d.department ===
                                                            bulkDept,
                                                    )
                                                    .reduce(
                                                        (sum: number, d: any) =>
                                                            sum + d.qty,
                                                        0,
                                                    );
                                            }

                                            const balance =
                                                row.qty - currentOutput;

                                            return (
                                                <tr
                                                    key={row.id}
                                                    className="border-b hover:bg-gray-50"
                                                >
                                                    <td className="p-2 font-medium">
                                                        {row.po_display}
                                                    </td>
                                                    <td className="p-2 text-center">
                                                        {row.qty}
                                                    </td>
                                                    <td
                                                        className={`p-2 text-center font-bold ${balance <= 0 ? 'text-green-600' : 'text-red-600'}`}
                                                    >
                                                        {balance}
                                                    </td>
                                                    <td className="p-2">
                                                        <input
                                                            type="number"
                                                            min="0"
                                                            max={
                                                                balance > 0
                                                                    ? balance
                                                                    : 9999
                                                            }
                                                            value={
                                                                bulkQty[
                                                                    row.id
                                                                ] || ''
                                                            }
                                                            onChange={(e) =>
                                                                handleQtyChange(
                                                                    row.id,
                                                                    e.target
                                                                        .value,
                                                                )
                                                            }
                                                            placeholder="0"
                                                            className="w-full rounded border p-1 text-center"
                                                        />
                                                    </td>
                                                </tr>
                                            );
                                        })}
                                    </tbody>
                                </table>
                            </div>

                            <div className="mt-4 flex justify-end space-x-2 border-t pt-4">
                                <button
                                    type="button"
                                    onClick={() => setIsBulkModalOpen(false)}
                                    className="rounded bg-gray-200 px-4 py-2 font-medium"
                                >
                                    Cancel
                                </button>
                                <button
                                    type="submit"
                                    disabled={isSubmitting}
                                    className="rounded bg-blue-600 px-6 py-2 font-medium text-white disabled:opacity-50"
                                >
                                    {isSubmitting
                                        ? 'Saving...'
                                        : 'Save All Output'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* MODAL INPUT BY SIZE RUN (SELECT SPK FIRST) */}
            {isSizeRunModalOpen && (
                <div className="bg-opacity-50 fixed inset-0 z-50 flex items-center justify-center bg-black p-4">
                    <div className="flex max-h-[90vh] w-full max-w-4xl flex-col rounded-lg bg-white shadow-xl">
                        <div className="flex items-center justify-between rounded-t-lg border-b bg-gray-50 p-4">
                            <h3 className="text-lg font-bold">
                                Daily Input by Size Run
                            </h3>
                            <button
                                onClick={() => setIsSizeRunModalOpen(false)}
                                className="text-xl font-bold text-gray-500 hover:text-red-500"
                            >
                                &times;
                            </button>
                        </div>

                        <form
                            onSubmit={submitSizeRun}
                            className="flex flex-col overflow-hidden p-4"
                        >
                            <div className="mb-4 flex gap-4 rounded border border-purple-100 bg-purple-50 p-3">
                                <div className="flex-1">
                                    <label className="mb-1 block text-sm font-medium">
                                        Report Date
                                    </label>
                                    <input
                                        type="date"
                                        value={sizeRunDate}
                                        onChange={(e) =>
                                            setSizeRunDate(e.target.value)
                                        }
                                        className="w-full rounded border p-2"
                                        required
                                    />
                                </div>
                                <div className="flex-1">
                                    <label className="mb-1 block text-sm font-medium">
                                        Department
                                    </label>
                                    <select
                                        value={sizeRunDept}
                                        onChange={(e) =>
                                            setSizeRunDept(e.target.value)
                                        }
                                        className="w-full rounded border p-2"
                                    >
                                        {departments
                                            .filter(
                                                (d) => d.key !== 'finishing',
                                            )
                                            .map((d) => (
                                                <option
                                                    key={d.key}
                                                    value={d.key}
                                                >
                                                    {d.label}
                                                </option>
                                            ))}
                                    </select>
                                </div>
                            </div>

                            {/* Select SPK */}
                            <div className="mb-4 flex gap-4 rounded border border-gray-200 bg-gray-50 p-3">
                                <div className="flex-1">
                                    <label className="mb-1 block text-sm font-medium">
                                        Select SPK
                                    </label>
                                    <select
                                        value={selectedSpkId}
                                        onChange={(e) => {
                                            setSelectedSpkId(e.target.value);
                                            setSelectedBatchId('');
                                            setSizeRunQty({});
                                        }}
                                        className="w-full rounded border p-2"
                                    >
                                        <option value="">
                                            -- Select SPK --
                                        </option>
                                        {/* Show unique SPKs only (not per batch) */}
                                        {spks
                                            .filter(
                                                (spk: any) =>
                                                    !selectedBrandId ||
                                                    String(spk.brand_id) ===
                                                        selectedBrandId,
                                            )
                                            .map((spk: any) => (
                                                <option
                                                    key={spk.id}
                                                    value={spk.id}
                                                >
                                                    {spk.po_number} -{' '}
                                                    {spk.brand?.name} (
                                                    {spk.art_color})
                                                </option>
                                            ))}
                                    </select>
                                </div>
                                <div className="flex-1">
                                    <label className="mb-1 block text-sm font-medium">
                                        Select Batch / Main SPK
                                    </label>
                                    <select
                                        value={selectedBatchId}
                                        onChange={(e) => {
                                            setSelectedBatchId(e.target.value);
                                            setSizeRunQty({});
                                        }}
                                        className="w-full rounded border p-2"
                                    >
                                        <option value="">
                                            -- Main SPK (No Batch) --
                                        </option>
                                        {(() => {
                                            if (!selectedSpkId) return null;
                                            const spk = spks.find(
                                                (s: any) =>
                                                    s.id == selectedSpkId,
                                            );
                                            if (
                                                !spk ||
                                                !spk.batches ||
                                                spk.batches.length === 0
                                            )
                                                return null;
                                            return spk.batches.map(
                                                (batch: any) => (
                                                    <option
                                                        key={batch.id}
                                                        value={batch.id}
                                                    >
                                                        {batch.batch_code} (Qty:{' '}
                                                        {batch.qty})
                                                    </option>
                                                ),
                                            );
                                        })()}
                                    </select>
                                </div>
                            </div>

                            <div className="flex-1 overflow-y-auto rounded border">
                                {selectedSpkId ? (
                                    <table className="w-full text-left text-sm">
                                        <thead className="sticky top-0 bg-gray-100">
                                            <tr>
                                                <th className="border-b p-2">
                                                    Size
                                                </th>
                                                <th className="border-b p-2 text-center">
                                                    Qty SPK/Batch
                                                </th>
                                                <th className="border-b p-2 text-center">
                                                    Already Input
                                                </th>
                                                <th className="border-b p-2 text-center">
                                                    Balance
                                                </th>
                                                <th className="w-32 border-b p-2 text-center">
                                                    Daily Output
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {getSelectedSizes().map(
                                                (size: any) => {
                                                    // Hitung yang sudah diinput untuk size ini di departemen & tanggal yang dipilih
                                                    const spk = spks.find(
                                                        (s: any) =>
                                                            s.id ==
                                                            selectedSpkId,
                                                    );
                                                    const existingDailies =
                                                        spk?.dailies || [];
                                                    const batchDailies =
                                                        selectedBatchId
                                                            ? spk?.batches?.find(
                                                                  (b: any) =>
                                                                      b.id ==
                                                                      selectedBatchId,
                                                              )?.dailies || []
                                                            : [];
                                                    const allDailies = [
                                                        ...existingDailies,
                                                        ...batchDailies,
                                                    ];
                                                    const alreadyInput =
                                                        allDailies
                                                            .filter(
                                                                (d: any) =>
                                                                    d.department ===
                                                                    sizeRunDept,
                                                            )
                                                            .reduce(
                                                                (
                                                                    sum: number,
                                                                    d: any,
                                                                ) =>
                                                                    sum + d.qty,
                                                                0,
                                                            );

                                                    // Hitung qty target untuk size ini
                                                    const targetQty =
                                                        size.qty || 0;
                                                    const balance =
                                                        targetQty -
                                                        alreadyInput;

                                                    return (
                                                        <tr
                                                            key={size.size_name}
                                                            className="border-b hover:bg-gray-50"
                                                        >
                                                            <td className="p-2 font-medium">
                                                                {size.size_name}
                                                            </td>
                                                            <td className="p-2 text-center">
                                                                {targetQty}
                                                            </td>
                                                            <td className="p-2 text-center font-medium text-blue-600">
                                                                {alreadyInput}
                                                            </td>
                                                            <td
                                                                className={`p-2 text-center font-bold ${balance <= 0 ? 'text-green-600' : 'text-red-600'}`}
                                                            >
                                                                {balance}
                                                            </td>
                                                            <td className="p-2">
                                                                <input
                                                                    type="number"
                                                                    min="0"
                                                                    max={
                                                                        balance >
                                                                        0
                                                                            ? balance
                                                                            : 9999
                                                                    }
                                                                    value={
                                                                        sizeRunQty[
                                                                            size
                                                                                .size_name
                                                                        ] || ''
                                                                    }
                                                                    onChange={(
                                                                        e,
                                                                    ) =>
                                                                        handleSizeRunQtyChange(
                                                                            size.size_name,
                                                                            e
                                                                                .target
                                                                                .value,
                                                                        )
                                                                    }
                                                                    placeholder="0"
                                                                    className="w-full rounded border p-1 text-center"
                                                                />
                                                            </td>
                                                        </tr>
                                                    );
                                                },
                                            )}
                                        </tbody>
                                    </table>
                                ) : (
                                    <div className="p-8 text-center text-gray-500">
                                        Silakan pilih SPK terlebih dahulu untuk
                                        melihat daftar size run.
                                    </div>
                                )}
                            </div>

                            <div className="mt-4 flex justify-end space-x-2 border-t pt-4">
                                <button
                                    type="button"
                                    onClick={() => setIsSizeRunModalOpen(false)}
                                    className="rounded bg-gray-200 px-4 py-2 font-medium"
                                >
                                    Batal
                                </button>
                                <button
                                    type="submit"
                                    disabled={
                                        isSizeRunSubmitting || !selectedSpkId
                                    }
                                    className="rounded bg-purple-600 px-6 py-2 font-medium text-white disabled:opacity-50"
                                >
                                    {isSizeRunSubmitting
                                        ? 'Menyimpan...'
                                        : 'Simpan Hasil per Size'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </>
    );
}
