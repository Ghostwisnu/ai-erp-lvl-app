import { Head, Link } from '@inertiajs/react';

export default function SelectDepartment({ stats }: any) {
    return (
        <>
            <Head title="Pilih Departemen" />
            <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
                <div className="max-w-5xl mx-auto">
                    <div className="text-center mb-10">
                        <h1 className="text-3xl font-bold text-gray-800">Produksi Scan</h1>
                        <p className="text-gray-500 mt-2">Pilih departemen kerja Anda saat ini.</p>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                        {/* Warehouse */}
                        <Link href="/produksi/scan/warehouse" className="bg-white rounded-xl shadow-lg p-8 border-t-4 border-blue-600 hover:shadow-2xl transition">
                            <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">WAREHOUSE</h2>
                            <div className="space-y-4 mb-8">
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Daily Hari Ini</span>
                                    <span className="font-bold text-blue-600">{stats?.warehouse?.daily || 0}</span>
                                </div>
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Pass</span>
                                    <span className="font-bold text-green-600">{stats?.warehouse?.pass || 0}</span>
                                </div>
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Defect</span>
                                    <span className="font-bold text-red-600">{stats?.warehouse?.defect || 0}</span>
                                </div>
                            </div>
                            <div className="bg-blue-600 text-white text-center py-3 rounded-lg font-bold">▶ MULAI</div>
                        </Link>

                        {/* Finishing */}
                        <Link href="/produksi/scan/finishing" className="bg-white rounded-xl shadow-lg p-8 border-t-4 border-purple-600 hover:shadow-2xl transition">
                            <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">FINISHING</h2>
                            <div className="space-y-4 mb-8">
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Daily Hari Ini</span>
                                    <span className="font-bold text-purple-600">{stats?.finishing?.daily || 0}</span>
                                </div>
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Pass</span>
                                    <span className="font-bold text-green-600">{stats?.finishing?.pass || 0}</span>
                                </div>
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Defect</span>
                                    <span className="font-bold text-red-600">{stats?.finishing?.defect || 0}</span>
                                </div>
                            </div>
                            <div className="bg-purple-600 text-white text-center py-3 rounded-lg font-bold">▶ MULAI</div>
                        </Link>
                    </div>
                </div>
            </div>
        </>
    );
}