import { Head, Link } from '@inertiajs/react';

export default function SelectDepartment({ stats }: any) {
    return (
        <>
            <Head title="Pilih Departemen" />
            <div className="min-h-screen bg-gray-50 px-4 py-12 sm:px-6 lg:px-8">
                <div className="mx-auto max-w-5xl">
                    <div className="mb-10 text-center">
                        <h1 className="text-3xl font-bold text-gray-800">
                            Pemindaian Produksi
                        </h1>
                        <p className="mt-2 text-gray-500">
                            Pilih departemen kerja Anda saat ini.
                        </p>
                    </div>

                    <div className="grid grid-cols-1 gap-8 md:grid-cols-2">
                        {/* Warehouse */}
                        <Link
                            href="/produksi/scan/warehouse"
                            className="rounded-xl border-t-4 border-blue-600 bg-white p-8 shadow-lg transition hover:shadow-2xl"
                        >
                            <h2 className="mb-6 text-center text-2xl font-bold text-gray-800">
                                GUDANG
                            </h2>
                            <div className="mb-8 space-y-4">
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">
                                        Hasil hari ini
                                    </span>
                                    <span className="font-bold text-blue-600">
                                        {stats?.warehouse?.daily || 0}
                                    </span>
                                </div>
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Lolos</span>
                                    <span className="font-bold text-green-600">
                                        {stats?.warehouse?.pass || 0}
                                    </span>
                                </div>
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Cacat</span>
                                    <span className="font-bold text-red-600">
                                        {stats?.warehouse?.defect || 0}
                                    </span>
                                </div>
                            </div>
                            <div className="rounded-lg bg-blue-600 py-3 text-center font-bold text-white">
                                ▶ MULAI
                            </div>
                        </Link>

                        {/* Finishing */}
                        <Link
                            href="/produksi/scan/finishing"
                            className="rounded-xl border-t-4 border-purple-600 bg-white p-8 shadow-lg transition hover:shadow-2xl"
                        >
                            <h2 className="mb-6 text-center text-2xl font-bold text-gray-800">
                                PENYELESAIAN
                            </h2>
                            <div className="mb-8 space-y-4">
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">
                                        Hasil hari ini
                                    </span>
                                    <span className="font-bold text-purple-600">
                                        {stats?.finishing?.daily || 0}
                                    </span>
                                </div>
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Lolos</span>
                                    <span className="font-bold text-green-600">
                                        {stats?.finishing?.pass || 0}
                                    </span>
                                </div>
                                <div className="flex justify-between border-b pb-2">
                                    <span className="text-gray-500">Cacat</span>
                                    <span className="font-bold text-red-600">
                                        {stats?.finishing?.defect || 0}
                                    </span>
                                </div>
                            </div>
                            <div className="rounded-lg bg-purple-600 py-3 text-center font-bold text-white">
                                ▶ MULAI
                            </div>
                        </Link>
                    </div>
                </div>
            </div>
        </>
    );
}
