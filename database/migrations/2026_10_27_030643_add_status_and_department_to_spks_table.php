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
        Schema::table('spks', function (Blueprint $table) {
            // Default 'create', nanti diubah manual oleh user menjadi 'active'
            $table->enum('status', ['create', 'active', 'finished', 'closed'])->default('create');
            $table->string('department')->nullable(); // Warehouse / Finishing
        });
    }

    public function down(): void
    {
        Schema::table('spks', function (Blueprint $table) {
            $table->dropColumn(['status', 'department']);
        });
    }
};
