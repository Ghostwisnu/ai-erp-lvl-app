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
        Schema::create('spk_details', function (Blueprint $table) {
            $table->id();
            $table->foreignId('spk_id')->constrained()->cascadeOnDelete();
            $table->string('size_name'); // Menyimpan nama ukuran (S, M, L)
            $table->integer('qty')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('spk_details');
    }
};
