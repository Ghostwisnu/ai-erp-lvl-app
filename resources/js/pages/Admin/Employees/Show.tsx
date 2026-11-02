import { Head, Link } from '@inertiajs/react';

export default function Show({ employee, canViewSalary }: any) {
    return (
        <>
            <Head title={`Detail Karyawan: ${employee.full_name}`} />
            <div className="py-12">
                <div className="mx-auto max-w-3xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <div className="mb-6 flex items-center">
                            {employee.photo_path ? (
                                <img
                                    src={`/storage/${employee.photo_path}`}
                                    alt="Foto"
                                    className="mr-6 h-24 w-24 rounded-lg object-cover"
                                />
                            ) : (
                                <div className="mr-6 flex h-24 w-24 items-center justify-center rounded-lg bg-gray-200 text-gray-500">
                                    Tidak ada foto
                                </div>
                            )}
                            <div>
                                <h2 className="text-2xl font-bold">
                                    {employee.full_name}
                                </h2>
                                <p className="text-gray-500">
                                    {employee.position || 'Tanpa Posisi'} -{' '}
                                    {employee.department || 'Tanpa Departemen'}
                                </p>
                                <p className="mt-1 text-sm text-gray-400">
                                    Kode: {employee.employee_code}
                                </p>
                            </div>
                        </div>

                        <dl className="grid grid-cols-2 gap-4">
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Akun pengguna
                                </dt>
                                <dd className="font-medium">
                                    {employee.user?.name || '-'}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Tempat, Tanggal Lahir
                                </dt>
                                <dd className="font-medium">
                                    {employee.birth_place},{' '}
                                    {employee.birth_date}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Jenis Kelamin
                                </dt>
                                <dd className="font-medium">
                                    {employee.gender === 'L'
                                        ? 'Laki-laki'
                                        : 'Perempuan'}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    No. Telepon
                                </dt>
                                <dd className="font-medium">
                                    {employee.phone_number || '-'}
                                </dd>
                            </div>
                            <div className="col-span-2">
                                <dt className="text-sm text-gray-500">
                                    Alamat
                                </dt>
                                <dd className="font-medium">
                                    {employee.address || '-'}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Tanggal Bergabung
                                </dt>
                                <dd className="font-medium">
                                    {employee.join_date}
                                </dd>
                            </div>
                            <div>
                                <dt className="text-sm text-gray-500">
                                    Jam Kerja
                                </dt>
                                <dd className="font-medium">
                                    {employee.start_time || '-'} s/d{' '}
                                    {employee.end_time || '-'}
                                </dd>
                            </div>
                            {canViewSalary && (
                                <div>
                                    <dt className="text-sm text-gray-500">
                                        Gaji Pokok
                                    </dt>
                                    <dd className="font-medium">
                                        Rp{' '}
                                        {Number(
                                            employee.basic_salary,
                                        ).toLocaleString('id-ID')}
                                    </dd>
                                </div>
                            )}
                        </dl>

                        <div className="flex justify-end space-x-2 pt-8">
                            <Link
                                href="/admin/employees"
                                className="rounded bg-gray-200 px-4 py-2"
                            >
                                Kembali
                            </Link>
                            <Link
                                href={`/admin/employees/${employee.id}/edit`}
                                className="rounded bg-yellow-500 px-4 py-2 text-white"
                            >
                                Ubah
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
