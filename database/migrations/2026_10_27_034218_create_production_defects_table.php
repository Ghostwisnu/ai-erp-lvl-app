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
        Schema::create('production_defects', function (Blueprint $table) {
            $table->id();
            $table->foreignId('spk_id')->constrained()->cascadeOnDelete();
            $table->foreignId('defect_category_id')->constrained()->cascadeOnDelete();
            $table->enum('department', ['warehouse', 'finishing', 'qc']);
            $table->integer('qty')->default(1);
            $table->string('reported_by'); // Nama QC/User
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('production_defects');
    }
};
