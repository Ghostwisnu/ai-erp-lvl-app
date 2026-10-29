<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('spk_batches', function (Blueprint $table) {
            // Menyimpan data size dan qty dalam format JSON
            // Contoh: [{"size": "40", "qty": 10}, {"size": "41", "qty": 15}]
            $table->json('sizes')->nullable()->after('qty');
        });
    }

    public function down(): void
    {
        Schema::table('spk_batches', function (Blueprint $table) {
            $table->dropColumn('sizes');
        });
    }
};
