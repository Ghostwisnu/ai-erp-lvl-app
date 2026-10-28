import { Head, useForm, Link } from '@inertiajs/react';
import { FormEvent } from 'react';

export default function Create({ employees }: any) {
    const { data, setData, post, processing, errors } = useForm({
        employee_id: '',
        type: 'sakit',
        start_date: '',
        end_date: '',
        start_time: '',
        end_time: '',
        reason: '',
        attachment: null as File | null,
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/admin/leave-requests');
    };

    return (
        <>
            <Head title="Buat Pengajuan Izin" />
            <div className="py-8 max-w-4xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h2 className="font-semibold text-xl mb-6">Form Pengajuan Izin</h2>
                    <form onSubmit={submit} className="grid grid-cols-2 gap-4">
                        <div className="col-span-2">
                            <label className="block text-sm font-medium mb-1">Pilih Karyawan</label>
                            <select value={data.employee_id} onChange={e => setData('employee_id', e.target.value)} className="w-full border p-2 rounded" required>
                                <option value="">-- Pilih Karyawan --</option>
                                {employees.map((emp: any) => <option key={emp.id} value={emp.id}>{emp.full_name} ({emp.employee_code})</option>)}
                            </select>
                            {errors.employee_id && <p className="text-red-500 text-sm">{errors.employee_id}</p>}
                        </div>

                        <div className="col-span-2">
                            <label className="block text-sm font-medium mb-1">Jenis Izin</label>
                            <select value={data.type} onChange={e => setData('type', e.target.value)} className="w-full border p-2 rounded" required>
                                <option value="sakit">Sakit</option>
                                <option value="cuti">Cuti</option>
                                <option value="izin_setengah_hari">Izin Setengah Hari</option>
                            </select>
                        </div>

                        <div>
                            <label className="block text-sm font-medium mb-1">Tanggal Mulai</label>
                            <input type="date" value={data.start_date} onChange={e => setData('start_date', e.target.value)} className="w-full border p-2 rounded" required />
                        </div>
                        <div>
                            <label className="block text-sm font-medium mb-1">Tanggal Selesai (Opsional)</label>
                            <input type="date" value={data.end_date} onChange={e => setData('end_date', e.target.value)} className="w-full border p-2 rounded" />
                        </div>

                        {data.type === 'izin_setengah_hari' && (
                            <>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Jam Mulai Izin</label>
                                    <input type="time" value={data.start_time} onChange={e => setData('start_time', e.target.value)} className="w-full border p-2 rounded" />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Jam Selesai Izin</label>
                                    <input type="time" value={data.end_time} onChange={e => setData('end_time', e.target.value)} className="w-full border p-2 rounded" />
                                </div>
                            </>
                        )}

                        <div className="col-span-2">
                            <label className="block text-sm font-medium mb-1">Alasan</label>
                            <textarea value={data.reason} onChange={e => setData('reason', e.target.value)} className="w-full border p-2 rounded" rows={3} required></textarea>
                        </div>

                        <div className="col-span-2">
                            <label className="block text-sm font-medium mb-1">Upload Surat Dokter (Jika Sakit)</label>
                            <input type="file" onChange={e => setData('attachment', e.target.files?.[0] || null)} className="w-full border p-2 rounded" />
                        </div>

                        <div className="col-span-2 flex justify-end space-x-2 pt-4">
                            <Link href="/admin/leave-requests" className="px-4 py-2 bg-gray-200 rounded">Batal</Link>
                            <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 text-white rounded">
                                {processing ? 'Menyimpan...' : 'Simpan Pengajuan'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}