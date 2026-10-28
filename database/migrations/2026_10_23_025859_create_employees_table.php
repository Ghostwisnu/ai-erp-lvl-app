<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('employees', function (Blueprint $table) {
            $table->id();
            // Relasi ke tabel users. Jika user dihapus, data karyawan ikut terhapus.
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();

            $table->string('employee_code')->unique(); // Kode Karyawan (misal: EMP-001)
            $table->string('full_name');
            $table->string('birth_place');
            $table->date('birth_date');
            $table->enum('gender', ['L', 'P']); // L = Laki-laki, P = Perempuan
            $table->string('phone_number')->nullable();
            $table->text('address')->nullable();

            // Data Kepegawaian
            $table->string('department')->nullable();
            $table->string('position')->nullable();
            $table->date('join_date');
            $table->time('start_time')->nullable();
            $table->time('end_time')->nullable();
            $table->decimal('basic_salary', 15, 2)->default(0);

            // Foto
            $table->string('photo_path')->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('employees');
    }
};
