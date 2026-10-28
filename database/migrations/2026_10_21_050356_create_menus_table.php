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
        Schema::create('menus', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Contoh: "Data User"
            $table->string('route')->nullable(); // Contoh: 'users.index'
            $table->string('icon')->nullable(); // Untuk ikon sidebar
            $table->integer('order')->default(0); // Urutan tampil
            $table->string('permission_name')->nullable(); // Kunci: permission yang dibutuhkan
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('menus');
    }
};
