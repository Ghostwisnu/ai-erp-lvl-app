import { Head, useForm, Link } from '@inertiajs/react';
import { FormEvent, useState, useMemo } from 'react';
import { toast } from 'sonner';

// OPSI: Kita buat value-nya menjadi String desimal (contoh: "1.0", "8.0")
const DURATION_OPTIONS = Array.from({ length: 32 }, (_, i) => {
    const val = (i + 1) * 0.5;
    const hours = Math.floor(val);
    const minutes = (val % 1) * 60;
    return {
        value: val.toFixed(1), // Memastikan nilainya berupa string "8.0"
        label: `${hours} Jam ${minutes > 0 ? minutes + ' Menit' : ''}`.trim(),
    };
});

export default function Edit({ overtime, departments, employees }: any) {
    const { data, setData, put, processing } = useForm({
        date: overtime.date,
        department: overtime.department,
        purpose: overtime.purpose,
        pic: overtime.pic,
        employees: overtime.employees.map((e: any) => ({
            id: e.id,
            name: e.full_name,
            code: e.employee_code,
            type: e.pivot.type,
            // AMANKAN DATA: Konversi ke String "8.0", jika kosong default ke "1.0"
            duration: e.pivot?.duration
                ? parseFloat(e.pivot.duration).toFixed(1)
                : '1.0',
            mutation_reason: e.pivot.mutation_reason || '',
        })),
    });

    const [globalDuration, setGlobalDuration] = useState<string>('1.0');
    const [isModalRegulerOpen, setModalRegulerOpen] = useState(false);
    const [isModalMutasiOpen, setModalMutasiOpen] = useState(false);
    const [mutasiSearch, setMutasiSearch] = useState('');
    const [mutasiDeptFilter, setMutasiDeptFilter] = useState('');

    const submit = (e: FormEvent) => {
        e.preventDefault();
        if (data.employees.length === 0)
            return toast.error('Pilih minimal 1 karyawan!');
        put(`/admin/overtimes/${overtime.id}`);
    };

    const addEmployee = (emp: any, type: 'reguler' | 'mutasi') => {
        if (data.employees.find((e: any) => e.id === emp.id)) return;
        setData('employees', [
            ...data.employees,
            {
                id: emp.id,
                name: emp.full_name,
                code: emp.employee_code,
                type: type,
                duration: globalDuration,
                mutation_reason: '',
            },
        ]);
    };

    const addAllEmployees = (empList: any[], type: 'reguler' | 'mutasi') => {
        const newEmployees = [...data.employees];
        empList.forEach((emp: any) => {
            if (!newEmployees.find((e: any) => e.id === emp.id)) {
                newEmployees.push({
                    id: emp.id,
                    name: emp.full_name,
                    code: emp.employee_code,
                    type: type,
                    duration: globalDuration,
                    mutation_reason: '',
                });
            }
        });
        setData('employees', newEmployees);
    };

    const removeEmployee = (id: number) =>
        setData(
            'employees',
            data.employees.filter((e: any) => e.id !== id),
        );

    const updateEmployeeField = (id: number, field: string, value: any) => {
        setData(
            'employees',
            data.employees.map((e: any) =>
                e.id === id ? { ...e, [field]: value } : e,
            ),
        );
    };

    const applyDurationToAll = () => {
        setData(
            'employees',
            data.employees.map((e: any) => ({
                ...e,
                duration: globalDuration,
            })),
        );
        toast.success(`Durasi diterapkan ke semua karyawan!`);
    };

    const regulerEmployees = employees.filter(
        (e: any) => e.department === data.department,
    );
    const mutasiEmployees = useMemo(() => {
        return employees.filter((e: any) => {
            const matchDept = mutasiDeptFilter
                ? e.department === mutasiDeptFilter
                : true;
            const matchSearch = e.full_name
                .toLowerCase()
                .includes(mutasiSearch.toLowerCase());
            return matchDept && matchSearch;
        });
    }, [employees, mutasiDeptFilter, mutasiSearch]);

    return (
        <>
            <Head title="Ubah Form Lembur" />
            <div className="py-8">
                <div className="mx-auto max-w-7xl space-y-4 sm:px-6 lg:px-8">
                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <h2 className="mb-4 text-xl font-semibold">
                            Ubah Informasi Lembur
                        </h2>
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Tanggal
                                </label>
                                <input
                                    type="date"
                                    value={data.date}
                                    onChange={(e) =>
                                        setData('date', e.target.value)
                                    }
                                    className="w-full rounded border p-2"
                                    required
                                />
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Departemen
                                </label>
                                <select
                                    value={data.department}
                                    onChange={(e) =>
                                        setData('department', e.target.value)
                                    }
                                    className="w-full rounded border p-2"
                                    required
                                >
                                    <option value="">-- Pilih --</option>
                                    {departments.map((dept: string) => (
                                        <option key={dept} value={dept}>
                                            {dept}
                                        </option>
                                    ))}
                                </select>
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    Tujuan Lembur
                                </label>
                                <input
                                    type="text"
                                    value={data.purpose}
                                    onChange={(e) =>
                                        setData('purpose', e.target.value)
                                    }
                                    className="w-full rounded border p-2"
                                    required
                                />
                            </div>
                            <div>
                                <label className="mb-1 block text-sm font-medium">
                                    PIC
                                </label>
                                <input
                                    type="text"
                                    value={data.pic}
                                    onChange={(e) =>
                                        setData('pic', e.target.value)
                                    }
                                    className="w-full rounded border p-2"
                                    required
                                />
                            </div>
                        </div>
                    </div>

                    <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                        <div className="mb-4 flex flex-wrap items-center justify-between gap-2">
                            <h3 className="text-lg font-medium">
                                Daftar Karyawan Lembur
                            </h3>
                            <div className="flex items-center gap-2 rounded border bg-gray-50 p-2">
                                <span className="text-sm font-medium">
                                    Atur Durasi:
                                </span>
                                <select
                                    value={globalDuration}
                                    onChange={(e) =>
                                        setGlobalDuration(e.target.value)
                                    }
                                    className="rounded border p-1.5 text-sm"
                                >
                                    {DURATION_OPTIONS.map((opt) => (
                                        <option
                                            key={opt.value}
                                            value={opt.value}
                                        >
                                            {opt.label}
                                        </option>
                                    ))}
                                </select>
                                <button
                                    type="button"
                                    onClick={applyDurationToAll}
                                    className="rounded bg-gray-200 px-3 py-1.5 text-sm font-medium hover:bg-gray-300"
                                >
                                    Terapkan ke Semua
                                </button>
                            </div>
                            <div className="space-x-2">
                                <button
                                    type="button"
                                    onClick={() => setModalRegulerOpen(true)}
                                    className="rounded bg-blue-600 px-3 py-1.5 text-sm text-white hover:bg-blue-700"
                                >
                                    + Pilih (Reguler)
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setModalMutasiOpen(true)}
                                    className="rounded bg-purple-600 px-3 py-1.5 text-sm text-white hover:bg-purple-700"
                                >
                                    + Pilih (Mutasi)
                                </button>
                            </div>
                        </div>
                        <table className="w-full border-collapse border text-left text-sm">
                            <thead>
                                <tr className="border-b bg-gray-100">
                                    <th className="border-r p-2">NIK</th>
                                    <th className="border-r p-2">Nama</th>
                                    <th className="border-r p-2">Tipe</th>
                                    <th className="w-48 border-r p-2">
                                        Durasi Lembur
                                    </th>
                                    <th className="border-r p-2">
                                        Ket. Mutasi
                                    </th>
                                    <th className="p-2">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {data.employees.map((emp: any) => (
                                    <tr key={emp.id} className="border-b">
                                        <td className="border-r p-2">
                                            {emp.code}
                                        </td>
                                        <td className="border-r p-2">
                                            {emp.name}
                                        </td>
                                        <td className="border-r p-2 capitalize">
                                            {emp.type}
                                        </td>
                                        <td className="border-r p-2">
                                            <select
                                                value={emp.duration || '1.0'}
                                                onChange={(e) =>
                                                    updateEmployeeField(
                                                        emp.id,
                                                        'duration',
                                                        e.target.value,
                                                    )
                                                }
                                                className="w-full rounded border p-1"
                                            >
                                                {DURATION_OPTIONS.map((opt) => (
                                                    <option
                                                        key={opt.value}
                                                        value={opt.value}
                                                    >
                                                        {opt.label}
                                                    </option>
                                                ))}
                                            </select>
                                        </td>
                                        <td className="border-r p-2">
                                            {emp.type === 'mutasi' ? (
                                                <input
                                                    type="text"
                                                    value={emp.mutation_reason}
                                                    onChange={(e) =>
                                                        updateEmployeeField(
                                                            emp.id,
                                                            'mutation_reason',
                                                            e.target.value,
                                                        )
                                                    }
                                                    placeholder="Alasan..."
                                                    className="w-full rounded border p-1"
                                                    required
                                                />
                                            ) : (
                                                '-'
                                            )}
                                        </td>
                                        <td className="p-2">
                                            <button
                                                type="button"
                                                onClick={() =>
                                                    removeEmployee(emp.id)
                                                }
                                                className="font-medium text-red-600"
                                            >
                                                Hapus
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    <div className="flex justify-end space-x-2">
                        <Link
                            href="/admin/overtimes"
                            className="rounded bg-gray-200 px-6 py-2 font-medium text-gray-700 hover:bg-gray-300"
                        >
                            Batal
                        </Link>
                        <button
                            onClick={submit}
                            disabled={processing}
                            className="rounded bg-blue-600 px-6 py-2 font-medium text-white hover:bg-blue-700"
                        >
                            {processing ? 'Menyimpan...' : 'Update Form Lembur'}
                        </button>
                    </div>
                </div>
            </div>

            {/* --- MODAL REGULER --- */}
            {isModalRegulerOpen && (
                <div className="bg-opacity-50 fixed inset-0 z-50 flex items-center justify-center bg-black p-4">
                    <div className="flex max-h-[80vh] w-full max-w-4xl flex-col rounded-lg bg-white p-6">
                        <div className="mb-4 flex items-center justify-between">
                            <h3 className="text-lg font-bold">
                                Pilih Karyawan (
                                {data.department || 'Pilih Dept'})
                            </h3>
                            <button
                                type="button"
                                onClick={() =>
                                    addAllEmployees(regulerEmployees, 'reguler')
                                }
                                className="rounded bg-blue-100 px-3 py-1 text-sm text-blue-700"
                            >
                                Pilih Semua
                            </button>
                        </div>
                        <div className="flex-1 overflow-y-auto rounded border">
                            <table className="w-full text-left text-sm">
                                <thead className="sticky top-0 bg-gray-100">
                                    <tr>
                                        <th className="border-b p-2">NIK</th>
                                        <th className="border-b p-2">Nama</th>
                                        <th className="border-b p-2">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {regulerEmployees.map((emp: any) => {
                                        const isSelected = data.employees.some(
                                            (e: any) => e.id === emp.id,
                                        );
                                        return (
                                            <tr
                                                key={emp.id}
                                                className={`border-b ${isSelected ? 'bg-green-50' : ''}`}
                                            >
                                                <td className="p-2">
                                                    {emp.employee_code}
                                                </td>
                                                <td className="p-2">
                                                    {emp.full_name}
                                                </td>
                                                <td className="p-2">
                                                    {isSelected ? (
                                                        <span className="font-medium text-green-600">
                                                            ✔ Dipilih
                                                        </span>
                                                    ) : (
                                                        <button
                                                            type="button"
                                                            onClick={() =>
                                                                addEmployee(
                                                                    emp,
                                                                    'reguler',
                                                                )
                                                            }
                                                            className="font-medium text-blue-600"
                                                        >
                                                            Pilih
                                                        </button>
                                                    )}
                                                </td>
                                            </tr>
                                        );
                                    })}
                                </tbody>
                            </table>
                        </div>
                        <div className="mt-4 flex justify-end">
                            <button
                                onClick={() => setModalRegulerOpen(false)}
                                className="rounded bg-gray-300 px-4 py-2"
                            >
                                Tutup
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* --- MODAL MUTASI --- */}
            {isModalMutasiOpen && (
                <div className="bg-opacity-50 fixed inset-0 z-50 flex items-center justify-center bg-black p-4">
                    <div className="flex max-h-[80vh] w-full max-w-4xl flex-col rounded-lg bg-white p-6">
                        <div className="mb-4 flex items-center justify-between">
                            <h3 className="text-lg font-bold">
                                Pilih Karyawan Mutasi
                            </h3>
                            <button
                                type="button"
                                onClick={() =>
                                    addAllEmployees(mutasiEmployees, 'mutasi')
                                }
                                className="rounded bg-purple-100 px-3 py-1 text-sm text-purple-700"
                            >
                                Pilih Semua (Hasil Penyaringan)
                            </button>
                        </div>
                        <div className="mb-4 flex gap-2">
                            <input
                                type="text"
                                placeholder="Cari Nama..."
                                value={mutasiSearch}
                                onChange={(e) =>
                                    setMutasiSearch(e.target.value)
                                }
                                className="w-1/2 rounded border p-2 text-sm"
                            />
                            <select
                                value={mutasiDeptFilter}
                                onChange={(e) =>
                                    setMutasiDeptFilter(e.target.value)
                                }
                                className="w-1/2 rounded border p-2 text-sm"
                            >
                                <option value="">Semua Departemen</option>
                                {departments.map((dept: string) => (
                                    <option key={dept} value={dept}>
                                        {dept}
                                    </option>
                                ))}
                            </select>
                        </div>
                        <div className="flex-1 overflow-y-auto rounded border">
                            <table className="w-full text-left text-sm">
                                <thead className="sticky top-0 bg-gray-100">
                                    <tr>
                                        <th className="border-b p-2">NIK</th>
                                        <th className="border-b p-2">Nama</th>
                                        <th className="border-b p-2">Dept</th>
                                        <th className="border-b p-2">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {mutasiEmployees.map((emp: any) => {
                                        const isSelected = data.employees.some(
                                            (e: any) => e.id === emp.id,
                                        );
                                        return (
                                            <tr
                                                key={emp.id}
                                                className={`border-b ${isSelected ? 'bg-purple-50' : ''}`}
                                            >
                                                <td className="p-2">
                                                    {emp.employee_code}
                                                </td>
                                                <td className="p-2">
                                                    {emp.full_name}
                                                </td>
                                                <td className="p-2">
                                                    {emp.department}
                                                </td>
                                                <td className="p-2">
                                                    {isSelected ? (
                                                        <span className="font-medium text-purple-600">
                                                            ✔ Dipilih
                                                        </span>
                                                    ) : (
                                                        <button
                                                            type="button"
                                                            onClick={() =>
                                                                addEmployee(
                                                                    emp,
                                                                    'mutasi',
                                                                )
                                                            }
                                                            className="font-medium text-purple-600"
                                                        >
                                                            Pilih
                                                        </button>
                                                    )}
                                                </td>
                                            </tr>
                                        );
                                    })}
                                </tbody>
                            </table>
                        </div>
                        <div className="mt-4 flex justify-end">
                            <button
                                onClick={() => setModalMutasiOpen(false)}
                                className="rounded bg-gray-300 px-4 py-2"
                            >
                                Tutup
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </>
    );
}
