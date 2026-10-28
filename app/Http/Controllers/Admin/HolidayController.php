<?php

namespace App\Http\Controllers\Admin;

use App\Models\Holiday;
use Illuminate\Http\Request;
use Carbon\Carbon;

class HolidayController extends BaseAdminController
{
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

    public function destroy(Holiday $holiday)
    {
        $holiday->delete();
        return redirect()->back()->with('success', 'Tanggal merah berhasil dihapus.');
    }

    // Fungsi import manual (jika Anda ingin menambahkan dari API di masa depan)
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
