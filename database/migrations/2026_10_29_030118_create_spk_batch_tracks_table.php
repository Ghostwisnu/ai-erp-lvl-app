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
        Schema::create('spk_batch_tracks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('spk_batch_id')->constrained()->cascadeOnDelete();
            $table->string('department'); // cutting, sewing, lasting, cementing, injection, finishing, packing
            $table->date('start_date'); // Kapan batch masuk ke departemen ini
            $table->date('end_date')->nullable(); // Kapan selesai di departemen ini (opsional)
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('spk_batch_tracks');
    }
};
