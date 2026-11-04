<?php

namespace App\Http\Controllers\Admin;

use Exception;
use HafizAsifAli\ZkTeco\ZkDevice;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SettingFingerController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        return $this->renderAdminPage('Admin/SettingFinger/Index');
    }

    /** @return Responsable|Response */
    public function testConnection(Request $request)
    {
        // Validasi input array IP
        $request->validate([
            'ips' => 'required|array',
            'port' => 'required|numeric',
        ]);

        $results = [];
        $port = $request->port;

        // Looping setiap IP yang dikirim dari frontend
        foreach ($request->ips as $ip) {
            try {
                // Coba koneksi
                $device = ZkDevice::make($ip, timezone: 'Asia/Jakarta');

                // Jika berhasil
                $results[] = [
                    'ip' => $ip,
                    'success' => true,
                    'message' => 'Koneksi Berhasil! Mesin merespon.',
                ];
            } catch (Exception $e) {
                // Jika gagal
                $results[] = [
                    'ip' => $ip,
                    'success' => false,
                    'message' => 'Gagal: '.$e->getMessage(),
                ];
            }
        }

        return response()->json(['results' => $results]);
    }
}
