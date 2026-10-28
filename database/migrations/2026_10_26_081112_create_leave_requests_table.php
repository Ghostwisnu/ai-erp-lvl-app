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
        Schema::create('leave_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('employee_id')->constrained()->cascadeOnDelete();

            // Jenis izin: 'sakit', 'cuti', 'izin_setengah_hari'
            $table->enum('type', ['sakit', 'cuti', 'izin_setengah_hari']);

            $table->date('start_date');
            $table->date('end_date')->nullable(); // Nullable untuk izin setengah hari (hanya 1 hari)
            $table->time('start_time')->nullable(); // Untuk izin setengah hari (jam mulai)
            $table->time('end_time')->nullable();   // Untuk izin setengah hari (jam selesai)

            $table->text('reason'); // Alasan izin
            $table->string('attachment_path')->nullable(); // Untuk upload surat dokter (jika sakit)

            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->foreignId('approved_by')->nullable()->constrained('users'); // Siapa yang approve
            $table->text('approval_note')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('leave_requests');
    }
};
