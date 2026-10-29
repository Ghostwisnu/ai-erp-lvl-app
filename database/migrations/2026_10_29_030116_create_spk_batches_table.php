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
        Schema::create('spk_batches', function (Blueprint $table) {
            $table->id();
            $table->foreignId('spk_id')->constrained()->cascadeOnDelete();
            $table->string('batch_code'); // Contoh: PO123-B1
            $table->integer('qty'); // Jumlah pasang di batch ini
            $table->date('start_date')->nullable(); // Tanggal mulai produksi batch
            $table->string('current_department')->nullable(); // Posisi saat ini (cutting, sewing, dll)
            $table->enum('status', ['pending', 'in_progress', 'completed'])->default('pending');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('spk_batches');
    }
};
