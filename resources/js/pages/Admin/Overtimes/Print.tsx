import { Head } from '@inertiajs/react';

export default function Print({ overtime }: any) {
    const totalDuration = overtime.employees.reduce(
        (sum: number, e: any) => sum + parseFloat(e.pivot.duration),
        0,
    );

    const handlePrint = () => {
        window.print();
    };

    return (
        <>
            <Head title={`Pratinjau Form Lembur - ${overtime.date}`} />

            {/* CSS Khusus untuk Print */}
            <style
                dangerouslySetInnerHTML={{
                    __html: `
                @media print {
                    /* 1. Atur ukuran kertas dan margin */
                    @page { 
                        size: A4 portrait; 
                        margin: 15mm 15mm; 
                    }

                    /* 2. Sembunyikan SEMUA elemen di halaman */
                    body * {
                        visibility: hidden;
                    }

                    /* 3. Tampilkan HANYA area dokumen (.print-area) */
                    .print-area, .print-area * {
                        visibility: visible;
                    }

                    /* 4. Paksa area dokumen menempel di pojok kiri atas kertas */
                    .print-area {
                        position: absolute;
                        left: 0;
                        top: 0;
                        width: 100%;
                        margin: 0;
                        padding: 0;
                        box-shadow: none !important;
                    }

                    /* 5. Mencegah baris tabel terpotong di tengah */
                    tr {
                        page-break-inside: avoid;
                    }

                    /* 6. Memastikan header tabel muncul lagi di halaman baru */
                    thead {
                        display: table-header-group;
                    }

                    /* 7. Mencegah bagian tanda tangan terpotong */
                    .signature-section {
                        page-break-inside: avoid;
                    }

                    /* 8. Warna Background Tetap Tercetak */
                    * { 
                        -webkit-print-color-adjust: exact !important; 
                        print-color-adjust: exact !important; 
                    }

                    /* 9. Sembunyikan elemen tombol */
                    .no-print { display: none !important; }
                }
            `,
                }}
            />

            {/* Kontainer Utama - HANYA ini yang tercetak */}
            <div className="print-area relative min-h-screen w-full bg-white font-serif text-black">
                {/* Tombol Kontrol (Hanya tampil di layar) */}
                <div className="no-print fixed top-4 right-4 z-[9999] space-x-2">
                    <button
                        onClick={handlePrint}
                        className="inline-block rounded bg-green-600 px-4 py-2 font-bold text-white shadow hover:bg-green-700"
                    >
                        🖨️ Print / Save PDF
                    </button>
                    <button
                        onClick={() => window.close()}
                        className="inline-block rounded bg-gray-500 px-4 py-2 font-bold text-white shadow hover:bg-gray-600"
                    >
                        &larr; Kembali
                    </button>
                </div>

                {/* Area Kertas Putih (Padding hanya untuk layar, hilang saat print) */}
                <div className="mx-auto w-full max-w-[210mm] p-10 print:p-0">
                    {/* Header Kop Surat */}
                    <div className="mb-6 flex items-center border-b-2 border-black pb-4">
                        <div className="w-40 shrink-0">
                            <img
                                src="/images/logo.jpeg"
                                alt="Logo Perusahaan"
                                className="w-32 object-contain"
                                onError={(e) => {
                                    e.currentTarget.style.display = 'none';
                                }}
                            />
                        </div>
                        <div className="flex-1 text-center">
                            <h1 className="text-2xl font-bold tracking-wider uppercase">
                                PT. AERROSTAR INDONESIA
                            </h1>
                            <p className="mt-1 text-xs">
                                Jl. Cikiwul No.4, RT.001/RW.004, Cikiwul, Kec.
                                Bantar Gebang, Kota Bks, Jawa Barat 17152
                            </p>
                        </div>
                    </div>

                    {/* Judul Form */}
                    <div className="mb-8 text-center">
                        <h2 className="text-xl font-bold uppercase underline">
                            Formulir Perintah Kerja Lembur
                        </h2>
                        <p className="mt-1">No. Dokumen: FR-HRD-04-03</p>
                    </div>

                    {/* Info Lembur */}
                    <div className="mb-6 space-y-1 text-xs">
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <div className="flex">
                                    <span className="w-32 font-semibold">
                                        Tanggal Lembur
                                    </span>
                                    <span>
                                        :{' '}
                                        {new Date(
                                            overtime.date,
                                        ).toLocaleDateString('id-ID', {
                                            weekday: 'long',
                                            day: 'numeric',
                                            month: 'long',
                                            year: 'numeric',
                                        })}
                                    </span>
                                </div>
                                <div className="flex">
                                    <span className="w-32 font-semibold">
                                        Departemen
                                    </span>
                                    <span className="uppercase">
                                        : {overtime.department}
                                    </span>
                                </div>
                                <div className="flex">
                                    <span className="w-32 font-semibold">
                                        Tujuan Lembur
                                    </span>
                                    <span>: {overtime.purpose}</span>
                                </div>
                            </div>
                            <div>
                                <div className="flex">
                                    <span className="w-32 font-semibold">
                                        Tanggal Terbit
                                    </span>
                                    <span>
                                        :{' '}
                                        {new Date().toLocaleDateString(
                                            'id-ID',
                                            {
                                                day: 'numeric',
                                                month: 'long',
                                                year: 'numeric',
                                            },
                                        )}
                                    </span>
                                </div>
                                <div className="flex">
                                    <span className="w-32 font-semibold">
                                        Total Karyawan
                                    </span>
                                    <span>
                                        : {overtime.employees.length} orang
                                    </span>
                                </div>
                                <div className="flex">
                                    <span className="w-32 font-semibold">
                                        Total Jam Lembur
                                    </span>
                                    <span className="font-bold">
                                        : {totalDuration} Jam
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div className="mt-2 flex">
                            <span className="w-32 font-semibold">
                                Penanggung Jawab
                            </span>
                            <span>: {overtime.pic}</span>
                        </div>
                    </div>

                    {/* Tabel Karyawan */}
                    <table className="mb-6 w-full border-collapse border border-black text-xs">
                        <thead>
                            <tr className="bg-gray-200">
                                <th className="w-8 border border-black p-1 text-center">
                                    No
                                </th>
                                <th className="border border-black p-1">NIK</th>
                                <th className="border border-black p-1">
                                    Nama Karyawan
                                </th>
                                <th className="border border-black p-1">
                                    Jabatan
                                </th>
                                <th className="border border-black p-1 text-center">
                                    Jam
                                </th>
                                <th className="border border-black p-1">
                                    Keterangan
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            {overtime.employees.map(
                                (emp: any, index: number) => (
                                    <tr key={emp.id}>
                                        <td className="border border-black p-1 text-center">
                                            {index + 1}
                                        </td>
                                        <td className="border border-black p-1">
                                            {emp.employee_code}
                                        </td>
                                        <td className="border border-black p-1 uppercase">
                                            {emp.full_name}
                                        </td>
                                        <td className="border border-black p-1 uppercase">
                                            {emp.position || 'OPERATOR'}
                                        </td>
                                        <td className="border border-black p-1 text-center font-bold">
                                            {parseFloat(emp.pivot.duration)}
                                        </td>
                                        <td className="border border-black p-1">
                                            {emp.pivot.mutation_reason || '-'}
                                        </td>
                                    </tr>
                                ),
                            )}
                            <tr className="bg-gray-50">
                                <td
                                    colSpan={4}
                                    className="border border-black p-1 text-right font-bold"
                                >
                                    TOTAL
                                </td>
                                <td className="border border-black p-1 text-center font-bold">
                                    {totalDuration}
                                </td>
                                <td className="border border-black p-1 font-bold">
                                    {overtime.employees.length} Karyawan
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    {/* Catatan */}
                    <div className="mb-8 text-xs leading-relaxed">
                        <p className="mb-1 font-bold">Catatan Penting:</p>
                        <ol className="ml-5 list-decimal space-y-1 text-justify">
                            <li>
                                Formulir ini merupakan bukti resmi perintah
                                kerja lembur.
                            </li>
                            <li>
                                Karyawan yang tercantum di atas wajib
                                melaksanakan lembur sesuai jadwal.
                            </li>
                            <li>
                                Pembayaran lembur akan diproses sesuai kebijakan
                                perusahaan.
                            </li>
                            <li>
                                Dokumen ini tidak dapat diubah tanpa persetujuan
                                pihak berwenang.
                            </li>
                        </ol>
                    </div>

                    {/* Tanda Tangan */}
                    <div className="signature-section mt-12 text-xs">
                        <div className="grid grid-cols-4 gap-2 text-center">
                            <div>
                                <p className="mb-16">Dibuat oleh,</p>
                                <p className="font-bold uppercase underline">
                                    ({' '}
                                    {overtime.creator?.name ||
                                        '........................'}{' '}
                                    )
                                </p>
                                <p>Staff</p>
                            </div>
                            <div>
                                <p className="mb-16">Diajukan oleh,</p>
                                <p className="font-bold uppercase underline">
                                    ( {overtime.pic} )
                                </p>
                                <p>PIC</p>
                            </div>
                            <div>
                                <p className="mb-16">Diperiksa oleh,</p>
                                <p className="font-bold underline">
                                    ( JOHANNES )
                                </p>
                                <p>Atasan Langsung</p>
                            </div>
                            <div>
                                <p className="mb-16">Disetujui oleh,</p>
                                <p className="font-bold underline">
                                    ( IR. TJIPTO TANNADY )
                                </p>
                                <p>Direktur / Manajer</p>
                            </div>
                        </div>
                    </div>

                    {/* Footer */}
                    <div className="mt-8 border-t border-black pt-2 text-center text-[9px] text-gray-500">
                        <i>
                            Dokumen ini dicetak otomatis dari sistem HRIS pada{' '}
                            {new Date().toLocaleDateString('id-ID', {
                                day: 'numeric',
                                month: 'long',
                                year: 'numeric',
                            })}{' '}
                            {new Date().toLocaleTimeString('id-ID')} —
                            FR-HRD-04-03
                        </i>
                    </div>
                </div>
            </div>
        </>
    );
}
