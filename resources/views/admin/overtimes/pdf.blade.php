<!DOCTYPE html>
<html>

<head>
    <title>Formulir Perintah Kerja Lembur</title>
    <style>
        body {
            font-family: sans-serif;
            font-size: 11px;
            color: #000;
        }

        /* Header */
        .header {
            width: 100%;
            border-bottom: 3px solid #000;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .header td {
            vertical-align: middle;
        }

        .logo {
            max-width: 140px;
            height: auto;
        }

        .company-name {
            font-size: 20px;
            font-weight: bold;
            margin: 0;
        }

        .company-address {
            font-size: 10px;
            margin: 2px 0 0 0;
        }

        /* Title */
        .title {
            text-align: center;
            margin-bottom: 20px;
        }

        .title h2 {
            margin: 0;
            font-size: 16px;
            text-decoration: underline;
        }

        .title p {
            margin: 3px 0 0 0;
            font-size: 10px;
        }

        /* Info Grid */
        .info-table {
            width: 100%;
            margin-bottom: 15px;
            font-size: 11px;
        }

        .info-table td {
            padding: 3px 0;
            vertical-align: top;
        }

        /* Data Table */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .data-table th,
        .data-table td {
            border: 1px solid #000;
            padding: 6px;
            text-align: left;
        }

        .data-table th {
            background-color: #e5e5e5;
            text-align: center;
            font-weight: bold;
        }

        /* Notes & Signature */
        .notes {
            font-size: 10px;
            margin-bottom: 30px;
        }

        .notes ol {
            padding-left: 15px;
            margin: 5px 0 0 0;
        }

        .signature {
            width: 100%;
            text-align: center;
            margin-top: 20px;
        }

        .signature td {
            width: 25%;
            vertical-align: bottom;
            padding-bottom: 10px;
        }

        .sig-line {
            border-top: 1px solid #000;
            width: 80%;
            margin: 0 auto;
            padding-top: 5px;
            font-weight: bold;
        }

        /* Footer */
        .footer {
            width: 100%;
            border-top: 1px solid #000;
            margin-top: 30px;
            padding-top: 5px;
            font-size: 9px;
            text-align: center;
            color: #555;
        }
    </style>
</head>

<body>

    <!-- Header / Kop Surat dengan Logo -->
    <!-- Header / Kop Surat -->
    <table class="header" style="width: 100%; border-bottom: 3px solid #000; padding-bottom: 10px; margin-bottom: 20px;">
        <tr>
            <!-- Kolom Logo (Rata Kiri) -->
            <td width="120" style="text-align: left; vertical-align: middle;">
                <!-- Pastikan file logo.jpeg ada di folder public/images -->
                <img src="{{ public_path('images/logo.jpeg') }}" class="logo" alt="Logo" style="max-width: 100px; height: auto;">
            </td>
            <!-- Kolom Teks Perusahaan (Rata Kiri) -->
            <td style="text-align: left; vertical-align: middle; padding-left: 15px;">
                <h1 class="company-name" style="font-size: 22px; font-weight: bold; margin: 0; text-transform: uppercase;">PT. AERROSTAR INDONESIA</h1>
                <p class="company-address" style="font-size: 11px; margin: 5px 0 0 0; color: #333;">
                    Jl. Cikiwul No.4, RT.001/RW.004, Cikiwul, Kec. Bantar Gebang, Kota Bks, Jawa Barat 17152
                </p>
            </td>
        </tr>
    </table>

    <!-- Judul Form -->
    <div class="title">
        <h2>FORMULIR PERINTAH KERJA LEMBUR</h2>
        <p>No. Dokumen: FR-HRD-04-03</p>
    </div>

    <!-- Info Lembur (2 Kolom) -->
    <table class="info-table">
        <tr>
            <td width="15%">Tanggal Lembur</td>
            <td width="35%">: <b>{{ \Carbon\Carbon::parse($overtime->date)->translatedFormat('d F Y (l)') }}</b></td>
            <td width="15%">Tanggal Terbit</td>
            <td width="35%">: {{ \Carbon\Carbon::now()->translatedFormat('d F Y') }}</td>
        </tr>
        <tr>
            <td>Departemen</td>
            <td>: {{ strtoupper($overtime->department) }}</td>
            <td>Total Karyawan</td>
            <td>: {{ count($overtime->employees) }} orang</td>
        </tr>
        <tr>
            <td>Tujuan Lembur</td>
            <td>: {{ $overtime->purpose }}</td>
            <td>Total Jam Lembur</td>
            <td>: <b>{{ $overtime->employees->sum(fn($e) => $e->pivot->duration) }} Jam</b></td>
        </tr>
        <tr>
            <td>Penanggung Jawab</td>
            <td colspan="3">: {{ $overtime->pic }}</td>
        </tr>
    </table>

    <!-- Tabel Karyawan -->
    <table class="data-table">
        <thead>
            <tr>
                <th width="30">NO</th>
                <th>NIK</th>
                <th>NAMA KARYAWAN</th>
                <th>JABATAN</th>
                <th>JAM LEMBUR</th>
                <th>KETERANGAN</th>
            </tr>
        </thead>
        <tbody>
            @foreach($overtime->employees as $index => $emp)
            <tr>
                <td style="text-align: center;">{{ $index + 1 }}</td>
                <td>{{ $emp->employee_code }}</td>
                <td style="text-transform: uppercase;">{{ $emp->full_name }}</td>
                <td style="text-transform: uppercase;">{{ $emp->position ?? 'OPERATOR' }}</td>
                <td style="text-align: center; font-weight: bold;">{{ (float)$emp->pivot->duration }} jam</td>
                <td>{{ $emp->pivot->mutation_reason ?? '-' }}</td>
            </tr>
            @endforeach
            <!-- Baris Total -->
            <tr>
                <td colspan="4" style="text-align: right; font-weight: bold;">TOTAL</td>
                <td style="text-align: center; font-weight: bold;">{{ $overtime->employees->sum(fn($e) => $e->pivot->duration) }} jam</td>
                <td style="font-weight: bold;">{{ count($overtime->employees) }} Karyawan</td>
            </tr>
        </tbody>
    </table>

    <!-- Catatan Penting -->
    <div class="notes">
        <b>Catatan Penting:</b>
        <ol>
            <li>Formulir ini merupakan bukti resmi perintah kerja lembur.</li>
            <li>Karyawan yang tercantum di atas wajib melaksanakan lembur sesuai jadwal.</li>
            <li>Pembayaran lembur akan diproses sesuai kebijakan perusahaan.</li>
            <li>Dokumen ini tidak dapat diubah tanpa persetujuan pihak berwenang.</li>
        </ol>
    </div>

    <!-- Tanda Tangan -->
    <table class="signature">
        <tr>
            <td>Dibuat oleh,</td>
            <td>Diajukan oleh,</td>
            <td>Diperiksa oleh,</td>
            <td>Disetujui oleh,</td>
        </tr>
        <tr>
            <td><br><br><br><br></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>
                <div class="sig-line" style="text-transform: uppercase;">
                    {{ $overtime->creator->name ?? '........................' }}
                </div>
                <!-- JABATAN DIKUNCI MENJADI STAFF -->
                <span style="font-size: 10px;">Staff</span>
            </td>
            <td>
                <div class="sig-line" style="text-transform: uppercase;">
                    {{ $overtime->pic }}
                </div>
                <span style="font-size: 10px;">PIC</span>
            </td>
            <td>
                <div class="sig-line">
                    JOHANNES
                </div>
                <span style="font-size: 10px;">Atasan Langsung</span>
            </td>
            <td>
                <div class="sig-line">
                    IR. TJIPTO TANNADY
                </div>
                <span style="font-size: 10px;">Direktur / Manajer</span>
            </td>
        </tr>
    </table>

    <!-- Footer -->
    <div class="footer">
        <i>Dokumen ini dicetak otomatis dari sistem HRIS pada {{ \Carbon\Carbon::now()->translatedFormat('d F Y H:i') }} — FR-HRD-04-03</i>
    </div>

</body>

</html>