import { Head } from '@inertiajs/react';
import { useState } from 'react';
import axios from 'axios';

export default function Index() {
    // State untuk 3 IP mesin
    const [ips, setIps] = useState([
        '192.168.100.201',
        '192.168.100.29',
        '192.168.100.78'
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
            const response = await axios.post('/admin/setting-finger/test', { ips, port });
            setResults(response.data.results);
        } catch (error: any) {
            alert('Terjadi kesalahan sistem saat mengetes.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <>
            <Head title="Tes Koneksi Finger" />
            <div className="py-8 max-w-3xl mx-auto sm:px-6 lg:px-8">
                <div className="bg-white shadow-sm sm:rounded-lg p-6">
                    <h2 className="font-semibold text-xl mb-6">Tes Koneksi 3 Mesin Finger</h2>

                    <div className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium mb-2">Daftar IP Mesin</label>
                            <div className="space-y-2">
                                {ips.map((ip, index) => (
                                    <div key={index} className="flex gap-2 items-center">
                                        <span className="text-gray-500 w-16">Mesin {index + 1}</span>
                                        <input
                                            type="text"
                                            value={ip}
                                            onChange={e => handleIpChange(index, e.target.value)}
                                            className="w-full border p-2 rounded"
                                            placeholder="192.168.x.x"
                                        />
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div>
                            <label className="block text-sm font-medium mb-1">Port</label>
                            <input
                                type="text"
                                value={port}
                                onChange={e => setPort(e.target.value)}
                                className="w-48 border p-2 rounded"
                                placeholder="4370"
                            />
                        </div>

                        <div className="flex justify-start pt-4">
                            <button
                                onClick={handleTest}
                                disabled={loading}
                                className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded font-medium disabled:opacity-50"
                            >
                                {loading ? 'Mengetes...' : 'Tes Semua Koneksi'}
                            </button>
                        </div>
                    </div>

                    {/* Hasil Tes per Mesin */}
                    {results && (
                        <div className="mt-8 space-y-3">
                            <h3 className="font-bold text-lg border-b pb-2">Hasil Tes:</h3>
                            {results.map((result, index) => (
                                <div
                                    key={index}
                                    className={`p-4 rounded border-l-4 flex justify-between items-center ${result.success ? 'bg-green-50 border-green-500' : 'bg-red-50 border-red-500'
                                        }`}
                                >
                                    <div>
                                        <span className="font-bold block text-gray-800">{result.ip}</span>
                                        <span className={`text-sm ${result.success ? 'text-green-600' : 'text-red-600'}`}>
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