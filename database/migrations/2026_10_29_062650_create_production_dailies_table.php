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
        Schema::create('production_dailies', function (Blueprint $table) {
            $table->id();
            // Bisa untuk Batch (nullable jika SPK tidak punya batch)
            $table->foreignId('spk_batch_id')->nullable()->constrained('spk_batches')->cascadeOnDelete();
            // Bisa untuk SPK langsung (nullable jika pakai batch)
            $table->foreignId('spk_id')->nullable()->constrained('spks')->cascadeOnDelete();

            $table->string('department'); // cutting, sewing, dll
            $table->date('report_date'); // Tanggal laporan
            $table->integer('qty'); // Jumlah output hari itu
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('production_dailies');
    }
};
