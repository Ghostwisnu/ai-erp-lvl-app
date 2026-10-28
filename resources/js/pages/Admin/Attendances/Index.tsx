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
        if (flash?.success) toast.success('Berhasil', { description: flash.success });
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

            const matchDept = selectedDepartment ? emp.department === selectedDepartment : true;

            return matchSearch && matchDept;
        });
    }, [employees, search, selectedDepartment]);

    return (
        <>
            <Head title="Input Absensi" />
            <div className="py-8">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">

                        {/* Header & Filter Tanggal */}
                        <div className="flex justify-between items-center mb-6">
                            <h2 className="font-semibold text-xl text-gray-800">Input Absensi Harian</h2>
                            <form method="GET" action="/admin/attendances" className="flex items-center space-x-2">
                                <label className="text-sm font-medium text-gray-700">Tanggal:</label>
                                <input
                                    type="date"
                                    name="date"
                                    defaultValue={date}
                                    className="border p-2 rounded text-sm"
                                    onChange={(e) => e.target.form?.submit()}
                                />
                            </form>
                        </div>

                        {/* Filter Search & Departemen */}
                        <div className="flex flex-col md:flex-row gap-4 mb-6">
                            <input
                                type="text"
                                placeholder="Cari Kode atau Nama Karyawan..."
                                value={search}
                                onChange={(e) => setSearch(e.target.value)}
                                className="border p-2 rounded w-full md:w-1/3 text-sm"
                            />

                            {/* GANTI BAGIAN SELECT INI SEMENTARA */}
                            <select
                                value={selectedDepartment}
                                onChange={(e) => setSelectedDepartment(e.target.value)}
                                className="border p-2 rounded w-full md:w-1/4 text-sm"
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

                        {processing && <div className="mb-4 text-blue-500">Menyimpan data...</div>}

                        <form onSubmit={submit}>
                            <div className="overflow-x-auto">
                                <table className="w-full text-left border-collapse">
                                    <thead>
                                        <tr className="border-b bg-gray-50">
                                            <th className="py-2 px-3 border-r text-sm">Kode</th>
                                            <th className="py-2 px-3 border-r text-sm">Nama Karyawan</th>
                                            <th className="py-2 px-3 border-r text-sm">Departemen</th>
                                            <th className="py-2 px-3 border-r text-sm w-32">Status</th>
                                            <th className="py-2 px-3 border-r text-sm w-28">Jam Masuk</th>
                                            <th className="py-2 px-3 border-r text-sm w-28">Jam Keluar</th>
                                            <th className="py-2 px-3 text-sm">Keterangan</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {filteredEmployees.map((emp) => (
                                            <tr key={emp.id} className="border-b hover:bg-gray-50">
                                                <td className="py-1 px-3 border-r text-sm">{emp.employee_code}</td>
                                                <td className="py-1 px-3 border-r text-sm font-medium">{emp.full_name}</td>
                                                <td className="py-1 px-3 border-r text-sm">{emp.department || '-'}</td>

                                                <td className="py-1 px-3 border-r">
                                                    <select
                                                        value={data.attendances[emp.id]?.status}
                                                        onChange={(e) => updateAttendance(emp.id, 'status', e.target.value)}
                                                        className="w-full border p-1 rounded text-sm"
                                                    >
                                                        <option value="present">Hadir</option>
                                                        <option value="sick">Sakit</option>
                                                        <option value="leave">Cuti</option>
                                                        <option value="absent">Alpa</option>
                                                    </select>
                                                </td>

                                                <td className="py-1 px-3 border-r">
                                                    <input
                                                        type="time"
                                                        value={data.attendances[emp.id]?.check_in}
                                                        onChange={(e) => updateAttendance(emp.id, 'check_in', e.target.value)}
                                                        className="w-full border p-1 rounded text-sm"
                                                    />
                                                </td>

                                                <td className="py-1 px-3 border-r">
                                                    <input
                                                        type="time"
                                                        value={data.attendances[emp.id]?.check_out}
                                                        onChange={(e) => updateAttendance(emp.id, 'check_out', e.target.value)}
                                                        className="w-full border p-1 rounded text-sm"
                                                    />
                                                </td>

                                                <td className="py-1 px-3">
                                                    <input
                                                        type="text"
                                                        value={data.attendances[emp.id]?.notes}
                                                        onChange={(e) => updateAttendance(emp.id, 'notes', e.target.value)}
                                                        className="w-full border p-1 rounded text-sm"
                                                        placeholder="Opsional..."
                                                    />
                                                </td>
                                            </tr>
                                        ))}
                                        {filteredEmployees.length === 0 && (
                                            <tr>
                                                <td colSpan={7} className="text-center py-4 text-gray-500">
                                                    Tidak ada karyawan yang sesuai dengan filter.
                                                </td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>
                            </div>

                            <div className="flex justify-end mt-6">
                                <button
                                    type="submit"
                                    disabled={processing}
                                    className="px-6 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md text-sm disabled:opacity-50"
                                >
                                    {processing ? 'Menyimpan...' : 'Simpan Absensi'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}