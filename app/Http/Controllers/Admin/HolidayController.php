<?php

namespace App\Http\Controllers\Admin;

use App\Models\Holiday;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class HolidayController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        // Ambil data dari database lokal (tabel holidays buatan Anda)
        $localHolidays = Holiday::orderBy('date', 'asc')->get();

        // Karena kita tidak memakai package, kita tidak punya data "global".
        // Kita bisa mengosongkan array ini atau mengambil dari API lain jika perlu.
        $globalHolidays = [];

        return $this->renderAdminPage('Admin/Holidays/Index', [
            'localHolidays' => $localHolidays,
            'globalHolidays' => $globalHolidays,
        ]);
    }

    /** @return Responsable|Response */
    public function store(Request $request)
    {
        $request->validate([
            'date' => 'required|date|unique:holidays,date',
            'name' => 'required|string|max:255',
        ]);

        Holiday::create([
            'date' => $request->date,
            'name' => $request->name,
            'is_national' => false,
        ]);

        return redirect()->back()->with('success', 'Tanggal merah berhasil ditambahkan.');
    }

    /** @return Responsable|Response */
    public function destroy(Holiday $holiday)
    {
        $holiday->delete();

        return redirect()->back()->with('success', 'Tanggal merah berhasil dihapus.');
    }

    // Fungsi import manual (jika Anda ingin menambahkan dari API di masa depan)
    /** @return Responsable|Response */
    public function import(Request $request)
    {
        $request->validate([
            'date' => 'required|date',
            'name' => 'required|string',
        ]);

        Holiday::firstOrCreate(
            ['date' => $request->date],
            ['name' => $request->name, 'is_national' => true]
        );

        return redirect()->back()->with('success', 'Tanggal merah berhasil diimport.');
    }
}
