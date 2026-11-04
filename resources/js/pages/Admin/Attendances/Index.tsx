import { Head, useForm, usePage } from '@inertiajs/react';
import { FormEvent, useEffect, useState, useMemo } from 'react';
import { toast } from 'sonner';

interface Attendance {
    id?: number;
    status: string;
    check_in: string;
    check_out: string;
    notes: string;
}

interface Employee {
    id: number;
    employee_code: string;
    full_name: string;
    department: string | null; // Tambahkan department ke interface
    attendances: Attendance[];
}

interface Props {
    employees: Employee[];
    date: string;
    departments: string[]; // Terima list departemen dari backend
}

export default function Index({ employees, date, departments }: Props) {
    const { flash } = usePage<any>().props;

    // State untuk Filter
    const [search, setSearch] = useState('');
    const [selectedDepartment, setSelectedDepartment] = useState('');

    // Notifikasi
    useEffect(() => {
        if (flash?.success)
            toast.success('Berhasil', { description: flash.success });
        if (flash?.error) toast.error('Gagal', { description: flash.error });
    }, [flash]);

    // Inisialisasi form
    const initialData = employees.reduce((acc: any, emp) => {
        const existing = emp.attendances[0] || {};
        acc[emp.id] = {
            status: existing.status || 'present',
            check_in: existing.check_in || '',
            check_out: existing.check_out || '',
            notes: existing.notes || '',
        };
        return acc;
    }, {});

    const { data, setData, post, processing } = useForm({
        date: date,
        attendances: initialData,
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/admin/attendances', { preserveScroll: true });
    };

    const updateAttendance = (empId: number, field: string, value: string) => {
        setData('attendances', {
            ...data.attendances,
            [empId]: {
                ...data.attendances[empId],
                [field]: value,
            },
        });
    };

    // --- LOGIKA FILTERING ---
    // Menggunakan useMemo agar performa tetap cepat saat mengetik di search bar
    const filteredEmployees = useMemo(() => {
        return employees.filter((emp) => {
            const matchSearch =
                emp.full_name.toLowerCase().includes(search.toLowerCase()) ||
                emp.employee_code.toLowerCase().includes(search.toLowerCase());

            const matchDept = selectedDepartment
                ? emp.department === selectedDepartment
                : true;

            return matchSearch && matchDept;
        });
    }, [employees, search, selectedDepartment]);

    return (
        <>
            <Head title="Input Absensi" />
            <div className="py-8">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        {/* Header & Filter Tanggal */}
                        <div className="mb-6 flex items-center justify-between">
                            <h2 className="text-xl font-semibold text-gray-800">
                                Input Absensi Harian
                            </h2>
                            <form
                                method="GET"
                                action="/admin/attendances"
                                className="flex items-center space-x-2"
                            >
                                <label className="text-sm font-medium text-gray-700">
                                    Tanggal:
                                </label>
                                <input
                                    type="date"
                                    name="date"
                                    defaultValue={date}
                                    className="rounded border p-2 text-sm"
                                    onChange={(e) => e.target.form?.submit()}
                                />
                            </form>
                        </div>

                        {/* Filter Search & Departemen */}
                        <div className="mb-6 flex flex-col gap-4 md:flex-row">
                            <input
                                type="text"
                                placeholder="Cari Kode atau Nama Karyawan..."
                                value={search}
                                onChange={(e) => setSearch(e.target.value)}
                                className="w-full rounded border p-2 text-sm md:w-1/3"
                            />

                            {/* GANTI BAGIAN SELECT INI SEMENTARA */}
                            <select
                                value={selectedDepartment}
                                onChange={(e) =>
                                    setSelectedDepartment(e.target.value)
                                }
                                className="w-full rounded border p-2 text-sm md:w-1/4"
                            >
                                <option value="">Semua Departemen</option>
                                {/* Gunakan data dinamis dari backend */}
                                {departments.map((dept, index) => (
                                    <option key={index} value={dept}>
                                        {dept}
                                    </option>
                                ))}
                            </select>
                        </div>

                        {processing && (
                            <div className="mb-4 text-blue-500">
                                Menyimpan data...
                            </div>
                        )}

                        <form onSubmit={submit}>
                            <div className="overflow-x-auto">
                                <table className="w-full border-collapse text-left">
                                    <thead>
                                        <tr className="border-b bg-gray-50">
                                            <th className="border-r px-3 py-2 text-sm">
                                                Kode
                                            </th>
                                            <th className="border-r px-3 py-2 text-sm">
                                                Nama Karyawan
                                            </th>
                                            <th className="border-r px-3 py-2 text-sm">
                                                Departemen
                                            </th>
                                            <th className="w-32 border-r px-3 py-2 text-sm">
                                                Status
                                            </th>
                                            <th className="w-28 border-r px-3 py-2 text-sm">
                                                Jam Masuk
                                            </th>
                                            <th className="w-28 border-r px-3 py-2 text-sm">
                                                Jam Keluar
                                            </th>
                                            <th className="px-3 py-2 text-sm">
                                                Keterangan
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {filteredEmployees.map((emp) => (
                                            <tr
                                                key={emp.id}
                                                className="border-b hover:bg-gray-50"
                                            >
                                                <td className="border-r px-3 py-1 text-sm">
                                                    {emp.employee_code}
                                                </td>
                                                <td className="border-r px-3 py-1 text-sm font-medium">
                                                    {emp.full_name}
                                                </td>
                                                <td className="border-r px-3 py-1 text-sm">
                                                    {emp.department || '-'}
                                                </td>

                                                <td className="border-r px-3 py-1">
                                                    <select
                                                        value={
                                                            data.attendances[
                                                                emp.id
                                                            ]?.status
                                                        }
                                                        onChange={(e) =>
                                                            updateAttendance(
                                                                emp.id,
                                                                'status',
                                                                e.target.value,
                                                            )
                                                        }
                                                        className="w-full rounded border p-1 text-sm"
                                                    >
                                                        <option value="present">
                                                            Hadir
                                                        </option>
                                                        <option value="sick">
                                                            Sakit
                                                        </option>
                                                        <option value="leave">
                                                            Cuti
                                                        </option>
                                                        <option value="absent">
                                                            Alpa
                                                        </option>
                                                    </select>
                                                </td>

                                                <td className="border-r px-3 py-1">
                                                    <input
                                                        type="time"
                                                        value={
                                                            data.attendances[
                                                                emp.id
                                                            ]?.check_in
                                                        }
                                                        onChange={(e) =>
                                                            updateAttendance(
                                                                emp.id,
                                                                'check_in',
                                                                e.target.value,
                                                            )
                                                        }
                                                        className="w-full rounded border p-1 text-sm"
                                                    />
                                                </td>

                                                <td className="border-r px-3 py-1">
                                                    <input
                                                        type="time"
                                                        value={
                                                            data.attendances[
                                                                emp.id
                                                            ]?.check_out
                                                        }
                                                        onChange={(e) =>
                                                            updateAttendance(
                                                                emp.id,
                                                                'check_out',
                                                                e.target.value,
                                                            )
                                                        }
                                                        className="w-full rounded border p-1 text-sm"
                                                    />
                                                </td>

                                                <td className="px-3 py-1">
                                                    <input
                                                        type="text"
                                                        value={
                                                            data.attendances[
                                                                emp.id
                                                            ]?.notes
                                                        }
                                                        onChange={(e) =>
                                                            updateAttendance(
                                                                emp.id,
                                                                'notes',
                                                                e.target.value,
                                                            )
                                                        }
                                                        className="w-full rounded border p-1 text-sm"
                                                        placeholder="Opsional..."
                                                    />
                                                </td>
                                            </tr>
                                        ))}
                                        {filteredEmployees.length === 0 && (
                                            <tr>
                                                <td
                                                    colSpan={7}
                                                    className="py-4 text-center text-gray-500"
                                                >
                                                    Tidak ada karyawan yang
                                                    sesuai dengan filter.
                                                </td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>
                            </div>

                            <div className="mt-6 flex justify-end">
                                <button
                                    type="submit"
                                    disabled={processing}
                                    className="rounded-md bg-blue-600 px-6 py-2 text-sm text-white hover:bg-blue-700 disabled:opacity-50"
                                >
                                    {processing
                                        ? 'Menyimpan...'
                                        : 'Simpan Absensi'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}
