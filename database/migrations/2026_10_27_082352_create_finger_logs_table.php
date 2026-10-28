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
        Schema::create('finger_logs', function (Blueprint $table) {
            $table->id();
            $table->string('pin'); // PIN dari mesin
            $table->dateTime('scan_time'); // Waktu scan dari mesin
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('finger_logs');
    }
};
