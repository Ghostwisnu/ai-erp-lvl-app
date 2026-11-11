import React, { useState } from 'react';
import { Head, Link, router } from '@inertiajs/react';
import { jsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';

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

        // Total width A4 landscape = 297mm, margin left=5, right=5 -> width available = 287mm
        // Table columns in target image:
        // Group 1 Header: PO NO. | DEPT. CUTTING | DEPT. SEWING | DEPT. ASSEMBLY | FINISH GOOD
        // Sub Header level 1:
        // NO | PO NO. | ART NO | COLOR | QTY | CUTTING (DAILY, TTL OUT.P, BLC) | SETTING DELIVER TO SWG (DAILY, TTL OUT.P, BLC) | SEWING (DAILY, TTL OUT.P, BLC) | STROBLE (DAILY, TTL OUT.P, BLC) | GUDANG SEMI (DAILY, TTL OUT LINE, BLC) | LASTING (DAILY, TTL OUT.P, BLC) | INJECTION (DAILY, TTL OUT.P, BLC) | FINISHING (DAILY, TTL OUT.P, BLC) | DELIVERY TO WAHANA (QTY PRS, BLC)

        // Brands grouping
        const groupedByBrand: { [brandName: string]: any[] } = {};
        visibleRows.forEach((row) => {
            const bName = row.spk.brand?.name || 'LAIN-LAIN';
            if (!groupedByBrand[bName]) groupedByBrand[bName] = [];
            groupedByBrand[bName].push(row);
        });

        const todayFormatted = new Date().toLocaleDateString('id-ID', {
            day: 'numeric',
            month: 'Long',
            year: 'numeric',
        });

        let currentY = 10;

        Object.keys(groupedByBrand).forEach((brandName, bIdx) => {
            const rows = groupedByBrand[brandName];
            if (bIdx > 0) {
                doc.addPage();
                currentY = 10;
            }

            // Header Form (Kiri logo/brand, tengah FORMULIR PRODUCTION PROGRESS SCHEDULE, kanan No Dokumen)
            doc.setLineWidth(0.3);
            doc.rect(5, currentY, 287, 18); // Header Outer Box

            // Vertical dividers header
            doc.line(60, currentY, 60, currentY + 18);
            doc.line(230, currentY, 230, currentY + 18);

            // Left: Brand Name
            doc.setFontSize(14);
            doc.setFont('helvetica', 'bold');
            doc.text(brandName.toUpperCase(), 32.5, currentY + 10, {
                align: 'center',
            });
            doc.setFontSize(7);
            doc.setFont('helvetica', 'normal');
            doc.text(`Update : ${todayFormatted}`, 32.5, currentY + 16, {
                align: 'center',
            });

            // Center: Title
            doc.setFontSize(9);
            doc.setFont('helvetica', 'bold');
            doc.text('FORMULIR', 145, currentY + 6, { align: 'center' });
            doc.setFontSize(10);
            doc.text('PRODUCTION PROGRESS SCHEDULE', 145, currentY + 12, {
                align: 'center',
            });

            // Right: Doc Info
            doc.setFontSize(6);
            doc.setFont('helvetica', 'normal');
            doc.text('No Dokumen', 232, currentY + 4);
            doc.text(': FR-PPC-02-01', 260, currentY + 4);
            doc.line(230, currentY + 5.5, 292, currentY + 5.5);

            doc.text('Tgl Terbit', 232, currentY + 9.5);
            doc.text(': 12 Februari 2025', 260, currentY + 9.5);
            doc.line(230, currentY + 11, 292, currentY + 11);

            doc.text('Revisi', 232, currentY + 15);
            doc.text(': 00', 260, currentY + 15);
            doc.line(230, currentY + 16.5, 292, currentY + 16.5);

            doc.text('Hal', 232, currentY + 17.5);
            doc.text(': 1-1', 260, currentY + 17.5);

            currentY += 21;

            // Prepare Table Headers & Body following image design exactly
            // Columns list (total 31 cols):
            // 0: NO (6mm)
            // 1: PO NO. (22mm)
            // 2: ART NO (20mm)
            // 3: COLOR (18mm)
            // 4: QTY (10mm)
            // 5..7: CUTTING (DAILY 7mm, TTL OUT.P 8mm, BLC 7mm)
            // 8..10: SETTING DELIVER TO SWG (DAILY 7mm, TTL OUT.P 8mm, BLC 7mm)
            // 11..13: SEWING (DAILY 7mm, TTL OUT.P 8mm, BLC 7mm)
            // 14..16: STROBLE (DAILY 7mm, TTL OUT.P 8mm, BLC 7mm)
            // 17..19: GUDANG SEMI (DAILY 7mm, TTL OUT LINE 8mm, BLC 7mm)
            // 20..22: LASTING (DAILY 7mm, TTL OUT.P 8mm, BLC 7mm)
            // 23..25: INJECTION (DAILY 7mm, TTL OUT.P 8mm, BLC 7mm)
            // 26..28: FINISHING (DAILY 7mm, TTL OUT.P 8mm, BLC 7mm)
            // 29..30: DELIVERY TO WAHANA (QTY PRS 8mm, BLC 8mm)

            const headRow1 = [
                {
                    content: 'PO NO.',
                    colSpan: 5,
                    styles: { fillColor: [210, 215, 220], halign: 'center' },
                },
                {
                    content: 'DEPT. CUTTING',
                    colSpan: 6,
                    styles: { fillColor: [190, 200, 210], halign: 'center' },
                },
                {
                    content: 'DEPT. SEWING',
                    colSpan: 6,
                    styles: { fillColor: [175, 205, 235], halign: 'center' },
                },
                {
                    content: 'DEPT. ASSEMBLY',
                    colSpan: 12,
                    styles: { fillColor: [195, 225, 175], halign: 'center' },
                },
                {
                    content: 'FINISH GOOD',
                    colSpan: 2,
                    styles: { fillColor: [245, 230, 80], halign: 'center' },
                },
            ];

            const headRow2 = [
                {
                    content: 'NO',
                    rowSpan: 2,
                    styles: { fillColor: [210, 215, 220], halign: 'center' },
                },
                {
                    content: 'PO NO.',
                    rowSpan: 2,
                    styles: { fillColor: [210, 215, 220], halign: 'center' },
                },
                {
                    content: 'ART NO',
                    rowSpan: 2,
                    styles: { fillColor: [210, 215, 220], halign: 'center' },
                },
                {
                    content: 'COLOR',
                    rowSpan: 2,
                    styles: { fillColor: [210, 215, 220], halign: 'center' },
                },
                {
                    content: 'QTY',
                    rowSpan: 2,
                    styles: { fillColor: [210, 215, 220], halign: 'center' },
                },
                {
                    content: 'CUTTING',
                    colSpan: 3,
                    styles: { fillColor: [210, 215, 220], halign: 'center' },
                },
                {
                    content: 'SETTING DELIVER\nTO SWG',
                    colSpan: 3,
                    styles: { fillColor: [210, 215, 220], halign: 'center' },
                },
                {
                    content: 'SEWING',
                    colSpan: 3,
                    styles: { fillColor: [175, 205, 235], halign: 'center' },
                },
                {
                    content: 'STROBLE',
                    colSpan: 3,
                    styles: { fillColor: [175, 205, 235], halign: 'center' },
                },
                {
                    content: 'GUDANG SEMI',
                    colSpan: 3,
                    styles: { fillColor: [195, 225, 175], halign: 'center' },
                },
                {
                    content: 'LASTING',
                    colSpan: 3,
                    styles: { fillColor: [195, 225, 175], halign: 'center' },
                },
                {
                    content: 'INJECTION',
                    colSpan: 3,
                    styles: { fillColor: [195, 225, 175], halign: 'center' },
                },
                {
                    content: 'FINISHING',
                    colSpan: 3,
                    styles: { fillColor: [195, 225, 175], halign: 'center' },
                },
                {
                    content: 'DELIVERY TO\nWAHANA',
                    colSpan: 2,
                    styles: { fillColor: [245, 230, 80], halign: 'center' },
                },
            ];

            const headRow3 = [
                // CUTTING
                { content: 'DAILY' },
                { content: 'TTL\nOUT.P' },
                { content: 'BLC' },
                // SETTING
                { content: 'DAILY' },
                { content: 'TTL\nOUT.P' },
                { content: 'BLC' },
                // SEWING
                { content: 'DAILY' },
                { content: 'TTL\nOUT.P' },
                { content: 'BLC' },
                // STROBLE
                { content: 'DAILY' },
                { content: 'TTL\nOUT.P' },
                { content: 'BLC' },
                // GUDANG SEMI
                { content: 'DAILY' },
                { content: 'TTL\nOUT LINE' },
                { content: 'BLC' },
                // LASTING
                { content: 'DAILY' },
                { content: 'TTL\nOUT.P' },
                { content: 'BLC' },
                // INJECTION
                { content: 'DAILY' },
                { content: 'TTL\nOUT.P' },
                { content: 'BLC' },
                // FINISHING
                { content: 'DAILY' },
                { content: 'TTL\nOUT.P' },
                { content: 'BLC' },
                // FINISH GOOD
                { content: 'QTY\nPRS' },
                { content: 'BLC' },
            ].map((item) => ({
                ...item,
                styles: { fillColor: [220, 225, 230], halign: 'center' },
            }));

            // Calculate totals per department for bottom summary row
            let totalQtySum = 0;
            const deptTotals: {
                [key: string]: { daily: number; total: number; blc: number };
            } = {
                cutting: { daily: 0, total: 0, blc: 0 },
                setting: { daily: 0, total: 0, blc: 0 },
                sewing: { daily: 0, total: 0, blc: 0 },
                stroble: { daily: 0, total: 0, blc: 0 },
                gudang_semi: { daily: 0, total: 0, blc: 0 },
                lasting: { daily: 0, total: 0, blc: 0 },
                injection: { daily: 0, total: 0, blc: 0 },
                finishing: { daily: 0, total: 0, blc: 0 },
                finish_good: { daily: 0, total: 0, blc: 0 },
            };

            const bodyRows = rows.map((row: any, idx: number) => {
                totalQtySum += row.qty;

                const getDeptData = (deptKey: string) => {
                    let totalOutput = 0;
                    let latestDailyQty = 0;

                    if (deptKey === 'finishing') {
                        totalOutput = calculateFinishingScan(row);
                        latestDailyQty = 0;
                    } else {
                        totalOutput = row.dailies
                            .filter((d: any) => d.department === deptKey)
                            .reduce((sum: number, d: any) => sum + d.qty, 0);
                        const latestDaily = row.dailies
                            .filter((d: any) => d.department === deptKey)
                            .sort(
                                (a: any, b: any) =>
                                    new Date(b.report_date).getTime() -
                                    new Date(a.report_date).getTime(),
                            )[0];
                        latestDailyQty = latestDaily ? latestDaily.qty : 0;
                    }

                    const balance = row.qty - totalOutput;

                    return {
                        daily: latestDailyQty,
                        total: totalOutput,
                        blc: balance,
                    };
                };

                const cutting = getDeptData('cutting');
                const setting = getDeptData('cementing'); // using cementing as setting
                const sewing = getDeptData('sewing');
                // Stroble, Gudang Semi, Finish Good: no data source yet, placeholder
                const _stroble = { daily: 0, total: 0, blc: row.qty };
                const _gudangSemi = { daily: 0, total: 0, blc: row.qty };
                const lasting = getDeptData('lasting');
                const injection = getDeptData('injection');
                const finishing = getDeptData('finishing');

                // Accumulate totals
                deptTotals.cutting.daily += cutting.daily;
                deptTotals.cutting.total += cutting.total;
                deptTotals.cutting.blc += cutting.blc;

                deptTotals.setting.daily += setting.daily;
                deptTotals.setting.total += setting.total;
                deptTotals.setting.blc += setting.blc;

                deptTotals.sewing.daily += sewing.daily;
                deptTotals.sewing.total += sewing.total;
                deptTotals.sewing.blc += sewing.blc;

                deptTotals.lasting.daily += lasting.daily;
                deptTotals.lasting.total += lasting.total;
                deptTotals.lasting.blc += lasting.blc;

                deptTotals.injection.daily += injection.daily;
                deptTotals.injection.total += injection.total;
                deptTotals.injection.blc += injection.blc;

                deptTotals.finishing.daily += finishing.daily;
                deptTotals.finishing.total += finishing.total;
                deptTotals.finishing.blc += finishing.blc;

                return [
                    idx + 1,
                    row.po_display,
                    row.spk.brand?.name || '',
                    row.spk.art_color || '',
                    row.qty,
                    // Cutting
                    cutting.daily > 0 ? cutting.daily : '',
                    cutting.total > 0 ? cutting.total : '0',
                    {
                        content: cutting.blc,
                        styles: {
                            textColor:
                                cutting.blc > 0 ? [180, 0, 0] : [0, 0, 0],
                            fontStyle: cutting.blc > 0 ? 'bold' : 'normal',
                        },
                    },
                    // Setting
                    setting.daily > 0 ? setting.daily : '',
                    setting.total > 0 ? setting.total : '0',
                    {
                        content: setting.blc,
                        styles: {
                            textColor:
                                setting.blc > 0 ? [180, 0, 0] : [0, 0, 0],
                            fontStyle: setting.blc > 0 ? 'bold' : 'normal',
                        },
                    },
                    // Sewing
                    sewing.daily > 0 ? sewing.daily : '',
                    sewing.total > 0 ? sewing.total : '0',
                    {
                        content: sewing.blc,
                        styles: {
                            textColor: sewing.blc > 0 ? [180, 0, 0] : [0, 0, 0],
                            fontStyle: sewing.blc > 0 ? 'bold' : 'normal',
                        },
                    },
                    // Stroble
                    '',
                    '0',
                    row.qty,
                    // Gudang Semi
                    '',
                    '0',
                    row.qty,
                    // Lasting
                    lasting.daily > 0 ? lasting.daily : '',
                    lasting.total > 0 ? lasting.total : '0',
                    {
                        content: lasting.blc,
                        styles: {
                            textColor:
                                lasting.blc > 0 ? [180, 0, 0] : [0, 0, 0],
                            fontStyle: lasting.blc > 0 ? 'bold' : 'normal',
                        },
                    },
                    // Injection
                    injection.daily > 0 ? injection.daily : '',
                    injection.total > 0 ? injection.total : '0',
                    {
                        content: injection.blc,
                        styles: {
                            textColor:
                                injection.blc > 0 ? [180, 0, 0] : [0, 0, 0],
                            fontStyle: injection.blc > 0 ? 'bold' : 'normal',
                        },
                    },
                    // Finishing
                    finishing.daily > 0 ? finishing.daily : '',
                    finishing.total > 0 ? finishing.total : '0',
                    {
                        content: finishing.blc,
                        styles: {
                            textColor:
                                finishing.blc > 0 ? [180, 0, 0] : [0, 0, 0],
                            fontStyle: finishing.blc > 0 ? 'bold' : 'normal',
                        },
                    },
                    // Finish Good
                    '',
                    row.qty,
                ];
            });

            // Summary Row
            const totalRow = [
                {
                    content: '',
                    colSpan: 4,
                    styles: { fillColor: [180, 210, 170] },
                },
                {
                    content: totalQtySum,
                    styles: {
                        fillColor: [180, 210, 170],
                        fontStyle: 'bold',
                        halign: 'center',
                    },
                },
                // Cutting
                { content: deptTotals.cutting.daily || '0' },
                { content: deptTotals.cutting.total || '0' },
                { content: deptTotals.cutting.blc || '0' },
                // Setting
                { content: deptTotals.setting.daily || '0' },
                { content: deptTotals.setting.total || '0' },
                { content: deptTotals.setting.blc || '0' },
                // Sewing
                { content: deptTotals.sewing.daily || '0' },
                { content: deptTotals.sewing.total || '0' },
                { content: deptTotals.sewing.blc || '0' },
                // Stroble
                { content: '0' },
                { content: '0' },
                { content: totalQtySum },
                // Gudang Semi
                { content: '0' },
                { content: '0' },
                { content: totalQtySum },
                // Lasting
                { content: deptTotals.lasting.daily || '0' },
                { content: deptTotals.lasting.total || '0' },
                { content: deptTotals.lasting.blc || '0' },
                // Injection
                { content: deptTotals.injection.daily || '0' },
                { content: deptTotals.injection.total || '0' },
                { content: deptTotals.injection.blc || '0' },
                // Finishing
                { content: deptTotals.finishing.daily || '0' },
                { content: deptTotals.finishing.total || '0' },
                { content: deptTotals.finishing.blc || '0' },
                // Finish good
                { content: '0' },
                { content: totalQtySum },
            ].map((item: any) => ({
                ...item,
                styles: {
                    fillColor: [180, 210, 170],
                    fontStyle: 'bold',
                    halign: 'center',
                    ...item.styles,
                },
            }));

            autoTable(doc, {
                head: [headRow1, headRow2, headRow3] as any,
                body: [...bodyRows, totalRow] as any,
                startY: currentY,
                margin: { left: 5, right: 5 },
                theme: 'grid',
                styles: {
                    fontSize: 5,
                    cellPadding: 0.8,
                    lineWidth: 0.1,
                    lineColor: [0, 0, 0],
                    halign: 'center',
                    valign: 'middle',
                    textColor: [0, 0, 0],
                },
                headStyles: {
                    textColor: [0, 0, 0],
                    fontStyle: 'bold',
                },
                columnStyles: {
                    0: { cellWidth: 6 }, // NO
                    1: { cellWidth: 22 }, // PO NO
                    2: { cellWidth: 20 }, // ART NO
                    3: { cellWidth: 16 }, // COLOR
                    4: { cellWidth: 10, fontStyle: 'bold' }, // QTY
                },
            });

            // Draw WIP Summary Boxes below table if room available
            const finalY = (doc as any).lastAutoTable.finalY + 4;

            // WIP Boxes: WIP CUTTING, WIP SETTING, WIP SEWING, WIP STROBLE, WIP LASTING, WIP INJECTION, WIP FINISHING
            const wipBoxes = [
                {
                    label: 'WIP CUTTING',
                    val: deptTotals.cutting.blc,
                    startX: 80,
                },
                {
                    label: 'WIP SETTING',
                    val: deptTotals.setting.blc,
                    startX: 105,
                },
                {
                    label: 'WIP SEWING',
                    val: deptTotals.sewing.blc,
                    startX: 130,
                },
                {
                    label: 'WIP STROBLE',
                    val: deptTotals.stroble.blc || totalQtySum,
                    startX: 155,
                },
                {
                    label: 'WIP LASTING',
                    val: deptTotals.lasting.blc,
                    startX: 205,
                },
                {
                    label: 'WIP INJECTION',
                    val: deptTotals.injection.blc,
                    startX: 230,
                },
                {
                    label: 'WIP FINISHING',
                    val: deptTotals.finishing.blc,
                    startX: 255,
                },
            ];

            wipBoxes.forEach((box) => {
                doc.setFillColor(245, 230, 80);
                doc.rect(box.startX, finalY, 20, 4, 'F');
                doc.rect(box.startX, finalY, 20, 4, 'S');

                doc.setFontSize(4.5);
                doc.setFont('helvetica', 'bold');
                doc.text(box.label, box.startX + 10, finalY + 2.8, {
                    align: 'center',
                });

                doc.rect(box.startX, finalY + 4, 20, 5, 'S');
                doc.setFontSize(6);
                doc.setFont('helvetica', 'normal');
                doc.text(String(box.val), box.startX + 10, finalY + 7.5, {
                    align: 'center',
                });
            });
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
                                    BRAND
                                </th>
                                <th
                                    rowSpan={2}
                                    className="border border-black p-1"
                                >
                                    ART/COLOR
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
                                        colSpan={departments.length * 4 + 6} // NO + PO + BRAND + ART/COLOR + QTY + depts*4 + XFD = 5 + dept*4 + 1 = 6 + dept*4
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
