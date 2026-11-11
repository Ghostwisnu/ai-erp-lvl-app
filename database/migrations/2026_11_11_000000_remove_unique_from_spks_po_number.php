<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $driver = DB::getDriverName();

        // Hapus constraint unique lama pada kolom po_number (jika ada)
        if ($driver === 'mysql') {
            $indexExists = DB::select(
                "SELECT COUNT(*) as cnt FROM information_schema.STATISTICS
                 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'spks' AND INDEX_NAME = 'spks_po_number_unique'"
            )[0]->cnt ?? 0;

            if ($indexExists > 0) {
                DB::statement('DROP INDEX spks_po_number_unique ON spks');
            }
        } elseif ($driver === 'sqlite') {
            // SQLite: coba drop index jika ada, ignore error
            try {
                DB::statement('DROP INDEX spks_po_number_unique');
            } catch (\Throwable) {
                // Index tidak ada, abaikan
            }
        }

        // Tambahkan composite unique index pada (po_number, brand_id, art_color)
        // Sehingga kombinasi ketiga data ini tidak boleh ada 2 SPK yang sama
        Schema::table('spks', function (Blueprint $table) {
            $table->unique(['po_number', 'brand_id', 'art_color'], 'spks_po_brand_color_unique');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        $driver = DB::getDriverName();

        // Hapus composite index
        if ($driver === 'mysql') {
            $indexExists = DB::select(
                "SELECT COUNT(*) as cnt FROM information_schema.STATISTICS
                 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'spks' AND INDEX_NAME = 'spks_po_brand_color_unique'"
            )[0]->cnt ?? 0;

            if ($indexExists > 0) {
                DB::statement('DROP INDEX spks_po_brand_color_unique ON spks');
            }
        } elseif ($driver === 'sqlite') {
            try {
                DB::statement('DROP INDEX spks_po_brand_color_unique');
            } catch (\Throwable) {
                // Index tidak ada, abaikan
            }
        }

        // Kembalikan constraint unique pada po_number
        Schema::table('spks', function (Blueprint $table) {
            $table->unique('po_number');
        });
    }
};