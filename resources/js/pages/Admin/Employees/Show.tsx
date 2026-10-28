import { Head, Link } from '@inertiajs/react';

export default function Show({ employee }: any) {
    return (
        <>
            <Head title={`Detail Karyawan: ${employee.full_name}`} />
            <div className="py-12">
                <div className="max-w-3xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <div className="flex items-center mb-6">
                            {employee.photo_path ? (
                                <img src={`/storage/${employee.photo_path}`} alt="Foto" className="w-24 h-24 rounded-lg object-cover mr-6" />
                            ) : (
                                <div className="w-24 h-24 rounded-lg bg-gray-200 flex items-center justify-center text-gray-500 mr-6">No Pic</div>
                            )}
                            <div>
                                <h2 className="text-2xl font-bold">{employee.full_name}</h2>
                                <p className="text-gray-500">{employee.position || 'Tanpa Posisi'} - {employee.department || 'Tanpa Departemen'}</p>
                                <p className="text-sm text-gray-400 mt-1">Kode: {employee.employee_code}</p>
                            </div>
                        </div>

                        <dl className="grid grid-cols-2 gap-4">
                            <div>
                                <dt className="text-sm text-gray-500">Akun User</dt>
                                <dd className="font-medium">{employee.user?.email || '-'}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">Tempat, Tanggal Lahir</dt>
                                <dd className="font-medium">{employee.birth_place}, {employee.birth_date}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">Jenis Kelamin</dt>
                                <dd className="font-medium">{employee.gender === 'L' ? 'Laki-laki' : 'Perempuan'}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">No. Telepon</dt>
                                <dd className="font-medium">{employee.phone_number || '-'}</dd>
                            </div>
                            <div className="col-span-2">
                                <dt className="text-sm text-gray-500">Alamat</dt>
                                <dd className="font-medium">{employee.address || '-'}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">Tanggal Bergabung</dt>
                                <dd className="font-medium">{employee.join_date}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">Jam Kerja</dt>
                                <dd className="font-medium">{employee.start_time || '-'} s/d {employee.end_time || '-'}</dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">Gaji Pokok</dt>
                                <dd className="font-medium">Rp {Number(employee.basic_salary).toLocaleString('id-ID')}</dd>
                            </div>
                        </dl>

                        <div className="flex justify-end space-x-2 pt-8">
                            <Link href="/admin/employees" className="px-4 py-2 bg-gray-200 rounded">Kembali</Link>
                            <Link href={`/admin/employees/${employee.id}/edit`} className="px-4 py-2 bg-yellow-500 text-white rounded">Edit</Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
