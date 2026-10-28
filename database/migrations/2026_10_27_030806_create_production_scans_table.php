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
        Schema::create('production_scans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('spk_detail_id')->constrained('spk_details')->cascadeOnDelete();
            $table->enum('department', ['warehouse', 'finishing']);
            $table->enum('status', ['pass', 'defect'])->default('pass'); // Asumsi default pass
            $table->string('scanned_by')->nullable(); // Nama user yang scan
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('production_scans');
    }
};
