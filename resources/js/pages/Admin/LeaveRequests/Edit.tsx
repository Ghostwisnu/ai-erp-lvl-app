import { Head, useForm, Link } from '@inertiajs/react';
import { FormEvent } from 'react';

export default function Edit({ leaveRequest, employees }: any) {
    // Inisialisasi form dengan data yang sudah ada di database
    const { data, setData, put, processing, errors } = useForm({
        employee_id: leaveRequest.employee_id,
        type: leaveRequest.type,
        start_date: leaveRequest.start_date,
        end_date: leaveRequest.end_date || '',
        start_time: leaveRequest.start_time || '',
        end_time: leaveRequest.end_time || '',
        reason: leaveRequest.reason,
        attachment: null as File | null, // File baru (jika ada)
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        // Gunakan _method: 'PUT' karena HTML form tidak mendukung PUT secara native
        // Inertia akan menanganinya secara otomatis jika kita memanggil put()
        put(`/admin/leave-requests/${leaveRequest.id}`);
    };

    return (
        <>
            <Head title="Edit Pengajuan Izin" />
            <div className="py-8 max-w-4xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h2 className="font-semibold text-xl mb-6">Edit Pengajuan Izin</h2>

                    <form onSubmit={submit} className="grid grid-cols-2 gap-4">
                        {/* Pilih Karyawan */}
                        <div className="col-span-2">
                            <label className="block text-sm font-medium mb-1">Pilih Karyawan</label>
                            <select
                                value={data.employee_id}
                                onChange={e => setData('employee_id', e.target.value)}
                                className="w-full border p-2 rounded"
                                required
                            >
                                <option value="">-- Pilih Karyawan --</option>
                                {employees.map((emp: any) => (
                                    <option key={emp.id} value={emp.id}>
                                        {emp.full_name} ({emp.employee_code})
                                    </option>
                                ))}
                            </select>
                            {errors.employee_id && <p className="text-red-500 text-sm mt-1">{errors.employee_id}</p>}
                        </div>

                        {/* Jenis Izin */}
                        <div className="col-span-2">
                            <label className="block text-sm font-medium mb-1">Jenis Izin</label>
                            <select
                                value={data.type}
                                onChange={e => setData('type', e.target.value)}
                                className="w-full border p-2 rounded"
                                required
                            >
                                <option value="sakit">Sakit</option>
                                <option value="cuti">Cuti</option>
                                <option value="izin_setengah_hari">Izin Setengah Hari</option>
                            </select>
                            {errors.type && <p className="text-red-500 text-sm mt-1">{errors.type}</p>}
                        </div>

                        {/* Tanggal */}
                        <div>
                            <label className="block text-sm font-medium mb-1">Tanggal Mulai</label>
                            <input
                                type="date"
                                value={data.start_date}
                                onChange={e => setData('start_date', e.target.value)}
                                className="w-full border p-2 rounded"
                                required
                            />
                            {errors.start_date && <p className="text-red-500 text-sm mt-1">{errors.start_date}</p>}
                        </div>
                        <div>
                            <label className="block text-sm font-medium mb-1">Tanggal Selesai (Opsional)</label>
                            <input
                                type="date"
                                value={data.end_date}
                                onChange={e => setData('end_date', e.target.value)}
                                className="w-full border p-2 rounded"
                            />
                            {errors.end_date && <p className="text-red-500 text-sm mt-1">{errors.end_date}</p>}
                        </div>

                        {/* Jam (Hanya muncul jika memilih Izin Setengah Hari) */}
                        {data.type === 'izin_setengah_hari' && (
                            <>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Jam Mulai Izin</label>
                                    <input
                                        type="time"
                                        value={data.start_time}
                                        onChange={e => setData('start_time', e.target.value)}
                                        className="w-full border p-2 rounded"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Jam Selesai Izin</label>
                                    <input
                                        type="time"
                                        value={data.end_time}
                                        onChange={e => setData('end_time', e.target.value)}
                                        className="w-full border p-2 rounded"
                                    />
                                </div>
                            </>
                        )}

                        {/* Alasan */}
                        <div className="col-span-2">
                            <label className="block text-sm font-medium mb-1">Alasan</label>
                            <textarea
                                value={data.reason}
                                onChange={e => setData('reason', e.target.value)}
                                className="w-full border p-2 rounded"
                                rows={3}
                                required
                            ></textarea>
                            {errors.reason && <p className="text-red-500 text-sm mt-1">{errors.reason}</p>}
                        </div>

                        {/* Lampiran */}
                        <div className="col-span-2">
                            <label className="block text-sm font-medium mb-1">Ganti Surat Dokter / Lampiran (Opsional)</label>
                            <input
                                type="file"
                                onChange={e => setData('attachment', e.target.files?.[0] || null)}
                                className="w-full border p-2 rounded"
                            />
                            {leaveRequest.attachment_path && (
                                <p className="text-xs text-gray-500 mt-1">
                                    Sudah ada lampiran sebelumnya. Biarkan kosong jika tidak ingin menggantinya.
                                </p>
                            )}
                        </div>

                        {/* Tombol Aksi */}
                        <div className="col-span-2 flex justify-end space-x-2 pt-4">
                            <Link href="/admin/leave-requests" className="px-4 py-2 bg-gray-200 rounded font-medium text-gray-700">
                                Batal
                            </Link>
                            <button
                                type="submit"
                                disabled={processing}
                                className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded font-medium disabled:opacity-50"
                            >
                                {processing ? 'Menyimpan...' : 'Update Pengajuan'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}