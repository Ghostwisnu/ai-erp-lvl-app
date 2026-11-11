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
        // Hapus constraint unique lama pada kolom po_number (jika ada)
        $indexExists = DB::select(
            "SELECT COUNT(*) as cnt FROM information_schema.STATISTICS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'spks' AND INDEX_NAME = 'spks_po_number_unique'"
        )[0]->cnt ?? 0;

        if ($indexExists > 0) {
            DB::statement('DROP INDEX spks_po_number_unique ON spks');
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
        // Hapus composite index
        $indexExists = DB::select(
            "SELECT COUNT(*) as cnt FROM information_schema.STATISTICS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'spks' AND INDEX_NAME = 'spks_po_brand_color_unique'"
        )[0]->cnt ?? 0;

        if ($indexExists > 0) {
            DB::statement('DROP INDEX spks_po_brand_color_unique ON spks');
        }

        // Kembalikan constraint unique pada po_number
        Schema::table('spks', function (Blueprint $table) {
            $table->unique('po_number');
        });
    }
};