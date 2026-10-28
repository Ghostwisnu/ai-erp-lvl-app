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
        label: `${hours} Jam ${minutes > 0 ? minutes + ' Menit' : ''}`.trim()
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
            duration: e.pivot?.duration ? parseFloat(e.pivot.duration).toFixed(1) : "1.0",
            mutation_reason: e.pivot.mutation_reason || ''
        })),
    });

    const [globalDuration, setGlobalDuration] = useState<string>("1.0");
    const [isModalRegulerOpen, setModalRegulerOpen] = useState(false);
    const [isModalMutasiOpen, setModalMutasiOpen] = useState(false);
    const [mutasiSearch, setMutasiSearch] = useState('');
    const [mutasiDeptFilter, setMutasiDeptFilter] = useState('');

    const submit = (e: FormEvent) => {
        e.preventDefault();
        if (data.employees.length === 0) return toast.error('Pilih minimal 1 karyawan!');
        put(`/admin/overtimes/${overtime.id}`);
    };

    const addEmployee = (emp: any, type: 'reguler' | 'mutasi') => {
        if (data.employees.find((e: any) => e.id === emp.id)) return;
        setData('employees', [...data.employees, {
            id: emp.id, name: emp.full_name, code: emp.employee_code,
            type: type, duration: globalDuration, mutation_reason: ''
        }]);
    };

    const addAllEmployees = (empList: any[], type: 'reguler' | 'mutasi') => {
        const newEmployees = [...data.employees];
        empList.forEach((emp: any) => {
            if (!newEmployees.find((e: any) => e.id === emp.id)) {
                newEmployees.push({
                    id: emp.id, name: emp.full_name, code: emp.employee_code,
                    type: type, duration: globalDuration, mutation_reason: ''
                });
            }
        });
        setData('employees', newEmployees);
    };

    const removeEmployee = (id: number) => setData('employees', data.employees.filter((e: any) => e.id !== id));

    const updateEmployeeField = (id: number, field: string, value: any) => {
        setData('employees', data.employees.map((e: any) =>
            e.id === id ? { ...e, [field]: value } : e
        ));
    };

    const applyDurationToAll = () => {
        setData('employees', data.employees.map((e: any) => ({ ...e, duration: globalDuration })));
        toast.success(`Durasi diterapkan ke semua karyawan!`);
    };

    const regulerEmployees = employees.filter((e: any) => e.department === data.department);
    const mutasiEmployees = useMemo(() => {
        return employees.filter((e: any) => {
            const matchDept = mutasiDeptFilter ? e.department === mutasiDeptFilter : true;
            const matchSearch = e.full_name.toLowerCase().includes(mutasiSearch.toLowerCase());
            return matchDept && matchSearch;
        });
    }, [employees, mutasiDeptFilter, mutasiSearch]);

    return (
        <>
            <Head title="Edit Form Lembur" />
            <div className="py-8">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-4">
                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <h2 className="font-semibold text-xl mb-4">Edit Informasi Lembur</h2>
                        <div className="grid grid-cols-2 gap-4">
                            <div><label className="block text-sm font-medium mb-1">Tanggal</label><input type="date" value={data.date} onChange={e => setData('date', e.target.value)} className="w-full border p-2 rounded" required /></div>
                            <div><label className="block text-sm font-medium mb-1">Departemen</label><select value={data.department} onChange={e => setData('department', e.target.value)} className="w-full border p-2 rounded" required><option value="">-- Pilih --</option>{departments.map((dept: string) => <option key={dept} value={dept}>{dept}</option>)}</select></div>
                            <div><label className="block text-sm font-medium mb-1">Tujuan Lembur</label><input type="text" value={data.purpose} onChange={e => setData('purpose', e.target.value)} className="w-full border p-2 rounded" required /></div>
                            <div><label className="block text-sm font-medium mb-1">PIC</label><input type="text" value={data.pic} onChange={e => setData('pic', e.target.value)} className="w-full border p-2 rounded" required /></div>
                        </div>
                    </div>

                    <div className="bg-white shadow-sm sm:rounded-lg p-6">
                        <div className="flex flex-wrap justify-between items-center mb-4 gap-2">
                            <h3 className="font-medium text-lg">Daftar Karyawan Lembur</h3>
                            <div className="flex items-center gap-2 bg-gray-50 p-2 rounded border">
                                <span className="text-sm font-medium">Atur Durasi:</span>
                                <select value={globalDuration} onChange={(e) => setGlobalDuration(e.target.value)} className="border p-1.5 rounded text-sm">
                                    {DURATION_OPTIONS.map(opt => <option key={opt.value} value={opt.value}>{opt.label}</option>)}
                                </select>
                                <button type="button" onClick={applyDurationToAll} className="bg-gray-200 hover:bg-gray-300 px-3 py-1.5 rounded text-sm font-medium">Apply to All</button>
                            </div>
                            <div className="space-x-2">
                                <button type="button" onClick={() => setModalRegulerOpen(true)} className="bg-blue-600 text-white px-3 py-1.5 rounded text-sm hover:bg-blue-700">+ Pilih (Reguler)</button>
                                <button type="button" onClick={() => setModalMutasiOpen(true)} className="bg-purple-600 text-white px-3 py-1.5 rounded text-sm hover:bg-purple-700">+ Pilih (Mutasi)</button>
                            </div>
                        </div>
                        <table className="w-full text-left border-collapse border text-sm">
                            <thead>
                                <tr className="bg-gray-100 border-b">
                                    <th className="p-2 border-r">NIK</th>
                                    <th className="p-2 border-r">Nama</th>
                                    <th className="p-2 border-r">Tipe</th>
                                    <th className="p-2 border-r w-48">Durasi Lembur</th>
                                    <th className="p-2 border-r">Ket. Mutasi</th>
                                    <th className="p-2">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                {data.employees.map((emp: any) => (
                                    <tr key={emp.id} className="border-b">
                                        <td className="p-2 border-r">{emp.code}</td>
                                        <td className="p-2 border-r">{emp.name}</td>
                                        <td className="p-2 border-r capitalize">{emp.type}</td>
                                        <td className="p-2 border-r">
                                            <select
                                                value={emp.duration || "1.0"}
                                                onChange={(e) => updateEmployeeField(emp.id, 'duration', e.target.value)}
                                                className="w-full border p-1 rounded"
                                            >
                                                {DURATION_OPTIONS.map(opt => (
                                                    <option key={opt.value} value={opt.value}>{opt.label}</option>
                                                ))}
                                            </select>
                                        </td>
                                        <td className="p-2 border-r">
                                            {emp.type === 'mutasi' ? <input type="text" value={emp.mutation_reason} onChange={(e) => updateEmployeeField(emp.id, 'mutation_reason', e.target.value)} placeholder="Alasan..." className="w-full border p-1 rounded" required /> : '-'}
                                        </td>
                                        <td className="p-2"><button type="button" onClick={() => removeEmployee(emp.id)} className="text-red-600 font-medium">Hapus</button></td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    <div className="flex justify-end space-x-2">
                        <Link href="/admin/overtimes" className="px-6 py-2 bg-gray-200 text-gray-700 hover:bg-gray-300 rounded font-medium">Batal</Link>
                        <button onClick={submit} disabled={processing} className="px-6 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded font-medium">
                            {processing ? 'Menyimpan...' : 'Update Form Lembur'}
                        </button>
                    </div>
                </div>
            </div>

            {/* --- MODAL REGULER --- */}
            {isModalRegulerOpen && (
                <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 p-4">
                    <div className="bg-white rounded-lg p-6 w-full max-w-4xl max-h-[80vh] flex flex-col">
                        <div className="flex justify-between items-center mb-4">
                            <h3 className="text-lg font-bold">Pilih Karyawan ({data.department || 'Pilih Dept'})</h3>
                            <button type="button" onClick={() => addAllEmployees(regulerEmployees, 'reguler')} className="bg-blue-100 text-blue-700 px-3 py-1 rounded text-sm">Pilih Semua</button>
                        </div>
                        <div className="overflow-y-auto flex-1 border rounded">
                            <table className="w-full text-left text-sm">
                                <thead className="bg-gray-100 sticky top-0"><tr><th className="p-2 border-b">NIK</th><th className="p-2 border-b">Nama</th><th className="p-2 border-b">Aksi</th></tr></thead>
                                <tbody>
                                    {regulerEmployees.map((emp: any) => {
                                        const isSelected = data.employees.some((e: any) => e.id === emp.id);
                                        return (
                                            <tr key={emp.id} className={`border-b ${isSelected ? 'bg-green-50' : ''}`}>
                                                <td className="p-2">{emp.employee_code}</td>
                                                <td className="p-2">{emp.full_name}</td>
                                                <td className="p-2">{isSelected ? <span className="text-green-600 font-medium">✔ Dipilih</span> : <button type="button" onClick={() => addEmployee(emp, 'reguler')} className="text-blue-600 font-medium">Pilih</button>}</td>
                                            </tr>
                                        );
                                    })}
                                </tbody>
                            </table>
                        </div>
                        <div className="mt-4 flex justify-end"><button onClick={() => setModalRegulerOpen(false)} className="px-4 py-2 bg-gray-300 rounded">Tutup</button></div>
                    </div>
                </div>
            )}

            {/* --- MODAL MUTASI --- */}
            {isModalMutasiOpen && (
                <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 p-4">
                    <div className="bg-white rounded-lg p-6 w-full max-w-4xl max-h-[80vh] flex flex-col">
                        <div className="flex justify-between items-center mb-4">
                            <h3 className="text-lg font-bold">Pilih Karyawan Mutasi</h3>
                            <button type="button" onClick={() => addAllEmployees(mutasiEmployees, 'mutasi')} className="bg-purple-100 text-purple-700 px-3 py-1 rounded text-sm">Pilih Semua (Hasil Filter)</button>
                        </div>
                        <div className="flex gap-2 mb-4">
                            <input type="text" placeholder="Cari Nama..." value={mutasiSearch} onChange={(e) => setMutasiSearch(e.target.value)} className="border p-2 rounded text-sm w-1/2" />
                            <select value={mutasiDeptFilter} onChange={(e) => setMutasiDeptFilter(e.target.value)} className="border p-2 rounded text-sm w-1/2">
                                <option value="">Semua Departemen</option>
                                {departments.map((dept: string) => <option key={dept} value={dept}>{dept}</option>)}
                            </select>
                        </div>
                        <div className="overflow-y-auto flex-1 border rounded">
                            <table className="w-full text-left text-sm">
                                <thead className="bg-gray-100 sticky top-0"><tr><th className="p-2 border-b">NIK</th><th className="p-2 border-b">Nama</th><th className="p-2 border-b">Dept</th><th className="p-2 border-b">Aksi</th></tr></thead>
                                <tbody>
                                    {mutasiEmployees.map((emp: any) => {
                                        const isSelected = data.employees.some((e: any) => e.id === emp.id);
                                        return (
                                            <tr key={emp.id} className={`border-b ${isSelected ? 'bg-purple-50' : ''}`}>
                                                <td className="p-2">{emp.employee_code}</td>
                                                <td className="p-2">{emp.full_name}</td>
                                                <td className="p-2">{emp.department}</td>
                                                <td className="p-2">{isSelected ? <span className="text-purple-600 font-medium">✔ Dipilih</span> : <button type="button" onClick={() => addEmployee(emp, 'mutasi')} className="text-purple-600 font-medium">Pilih</button>}</td>
                                            </tr>
                                        );
                                    })}
                                </tbody>
                            </table>
                        </div>
                        <div className="mt-4 flex justify-end"><button onClick={() => setModalMutasiOpen(false)} className="px-4 py-2 bg-gray-300 rounded">Tutup</button></div>
                    </div>
                </div>
            )}
        </>
    );
}