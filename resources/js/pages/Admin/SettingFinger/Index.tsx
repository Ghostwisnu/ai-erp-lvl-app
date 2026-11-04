import { Head } from '@inertiajs/react';
import { useState } from 'react';
import axios from 'axios';

export default function Index() {
    // State untuk 3 IP mesin
    const [ips, setIps] = useState([
        '192.168.100.201',
        '192.168.100.29',
        '192.168.100.78',
    ]);
    const [port, setPort] = useState('4370');
    const [loading, setLoading] = useState(false);
    const [results, setResults] = useState<any[] | null>(null);

    const handleIpChange = (index: number, value: string) => {
        const newIps = [...ips];
        newIps[index] = value;
        setIps(newIps);
    };

    const handleTest = async () => {
        setLoading(true);
        setResults(null);

        try {
            const response = await axios.post('/admin/setting-finger/test', {
                ips,
                port,
            });
            setResults(response.data.results);
        } catch {
            alert('Terjadi kesalahan sistem saat mengetes.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <>
            <Head title="Tes Koneksi Finger" />
            <div className="mx-auto max-w-3xl py-8 sm:px-6 lg:px-8">
                <div className="bg-white p-6 shadow-sm sm:rounded-lg">
                    <h2 className="mb-6 text-xl font-semibold">
                        Tes Koneksi 3 Mesin Finger
                    </h2>

                    <div className="space-y-4">
                        <div>
                            <label className="mb-2 block text-sm font-medium">
                                Daftar IP Mesin
                            </label>
                            <div className="space-y-2">
                                {ips.map((ip, index) => (
                                    <div
                                        key={index}
                                        className="flex items-center gap-2"
                                    >
                                        <span className="w-16 text-gray-500">
                                            Mesin {index + 1}
                                        </span>
                                        <input
                                            type="text"
                                            value={ip}
                                            onChange={(e) =>
                                                handleIpChange(
                                                    index,
                                                    e.target.value,
                                                )
                                            }
                                            className="w-full rounded border p-2"
                                            placeholder="192.168.x.x"
                                        />
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div>
                            <label className="mb-1 block text-sm font-medium">
                                Port
                            </label>
                            <input
                                type="text"
                                value={port}
                                onChange={(e) => setPort(e.target.value)}
                                className="w-48 rounded border p-2"
                                placeholder="4370"
                            />
                        </div>

                        <div className="flex justify-start pt-4">
                            <button
                                onClick={handleTest}
                                disabled={loading}
                                className="rounded bg-blue-600 px-6 py-2 font-medium text-white hover:bg-blue-700 disabled:opacity-50"
                            >
                                {loading ? 'Mengetes...' : 'Tes Semua Koneksi'}
                            </button>
                        </div>
                    </div>

                    {/* Hasil Tes per Mesin */}
                    {results && (
                        <div className="mt-8 space-y-3">
                            <h3 className="border-b pb-2 text-lg font-bold">
                                Hasil Tes:
                            </h3>
                            {results.map((result, index) => (
                                <div
                                    key={index}
                                    className={`flex items-center justify-between rounded border-l-4 p-4 ${
                                        result.success
                                            ? 'border-green-500 bg-green-50'
                                            : 'border-red-500 bg-red-50'
                                    }`}
                                >
                                    <div>
                                        <span className="block font-bold text-gray-800">
                                            {result.ip}
                                        </span>
                                        <span
                                            className={`text-sm ${result.success ? 'text-green-600' : 'text-red-600'}`}
                                        >
                                            {result.message}
                                        </span>
                                    </div>
                                    <div className="text-2xl">
                                        {result.success ? '✅' : '❌'}
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>
        </>
    );
}
