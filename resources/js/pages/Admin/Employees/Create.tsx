import { Head, Link, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';

export default function Create({ users }: any) {
    const { data, setData, post, processing, errors } = useForm({
        user_id: '', employee_code: '', full_name: '', birth_place: '', birth_date: '',
        gender: 'L', phone_number: '', address: '', department: '', position: '',
        join_date: '', start_time: '', end_time: '', basic_salary: 0, photo: null as File | null
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/admin/employees');
    };

    return (
        <>
            <Head title="Tambah Karyawan" />
            <div className="py-12">
                <div className="max-w-4xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl mb-6">Tambah Karyawan</h2>
                        <form onSubmit={submit} className="grid grid-cols-2 gap-4">
                            <div className="col-span-2">
                                <label className="block text-sm font-medium mb-1">Pilih Akun User</label>
                                <select value={data.user_id} onChange={e => setData('user_id', e.target.value)} className="w-full border p-2 rounded">
                                    <option value="">-- Pilih User --</option>
                                    {users.map((u: any) => <option key={u.id} value={u.id}>{u.name} ({u.email})</option>)}
                                </select>
                                {errors.user_id && <p className="text-red-500 text-sm mt-1">{errors.user_id}</p>}
                            </div>

                            <div className="flex items-end pb-2">
                                <p className="text-sm text-gray-500 italic">
                                    * Kode Karyawan akan dibuat otomatis berdasarkan tanggal bergabung.
                                </p>
                            </div>
                            {/* <div>
                                <label className="block text-sm mb-1">Kode Karyawan</label>
                                <input type="text" value={data.employee_code} onChange={e => setData('employee_code', e.target.value)} className="w-full border p-2 rounded" />
                                {errors.employee_code && <p className="text-red-500 text-sm mt-1">{errors.employee_code}</p>}
                            </div> */}
                            <div>
                                <label className="block text-sm mb-1">Nama Lengkap</label>
                                <input type="text" value={data.full_name} onChange={e => setData('full_name', e.target.value)} className="w-full border p-2 rounded" />
                            </div>
                            <div>
                                <label className="block text-sm mb-1">Tempat Lahir</label>
                                <input type="text" value={data.birth_place} onChange={e => setData('birth_place', e.target.value)} className="w-full border p-2 rounded" />
                            </div>
                            <div>
                                <label className="block text-sm mb-1">Tanggal Lahir</label>
                                <input type="date" value={data.birth_date} onChange={e => setData('birth_date', e.target.value)} className="w-full border p-2 rounded" />
                            </div>
                            <div>
                                <label className="block text-sm mb-1">Jenis Kelamin</label>
                                <select value={data.gender} onChange={e => setData('gender', e.target.value)} className="w-full border p-2 rounded">
                                    <option value="L">Laki-laki</option>
                                    <option value="P">Perempuan</option>
                                </select>
                            </div>
                            <div>
                                <label className="block text-sm mb-1">No. Telepon</label>
                                <input type="text" value={data.phone_number} onChange={e => setData('phone_number', e.target.value)} className="w-full border p-2 rounded" />
                            </div>
                            <div className="col-span-2">
                                <label className="block text-sm mb-1">Alamat</label>
                                <textarea value={data.address} onChange={e => setData('address', e.target.value)} className="w-full border p-2 rounded"></textarea>
                            </div>

                            <div>
                                <label className="block text-sm mb-1">Departemen</label>
                                <input type="text" value={data.department} onChange={e => setData('department', e.target.value)} className="w-full border p-2 rounded" />
                            </div>
                            <div>
                                <label className="block text-sm mb-1">Posisi</label>
                                <input type="text" value={data.position} onChange={e => setData('position', e.target.value)} className="w-full border p-2 rounded" />
                            </div>
                            <div>
                                <label className="block text-sm mb-1">Tanggal Bergabung</label>
                                <input type="date" value={data.join_date} onChange={e => setData('join_date', e.target.value)} className="w-full border p-2 rounded" />
                            </div>
                            <div className="flex gap-2">
                                <div className="w-1/2">
                                    <label className="block text-sm mb-1">Jam Masuk</label>
                                    <input type="time" value={data.start_time} onChange={e => setData('start_time', e.target.value)} className="w-full border p-2 rounded" />
                                </div>
                                <div className="w-1/2">
                                    <label className="block text-sm mb-1">Jam Selesai</label>
                                    <input type="time" value={data.end_time} onChange={e => setData('end_time', e.target.value)} className="w-full border p-2 rounded" />
                                </div>
                            </div>
                            <div>
                                <label className="block text-sm mb-1">Gaji Pokok (Rp)</label>
                                <input type="number" value={data.basic_salary} onChange={e => setData('basic_salary', Number(e.target.value))} className="w-full border p-2 rounded" />
                            </div>
                            <div>
                                <label className="block text-sm mb-1">Foto Karyawan</label>
                                <input type="file" onChange={e => setData('photo', e.target.files?.[0] || null)} className="w-full border p-2 rounded" />
                            </div>

                            <div className="col-span-2 flex justify-end space-x-2 pt-4">
                                <Link href="/admin/employees" className="px-4 py-2 bg-gray-200 rounded">Batal</Link>
                                <button type="submit" disabled={processing} className="px-4 py-2 bg-blue-600 text-white rounded">
                                    {processing ? 'Menyimpan...' : 'Simpan'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}
