<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('overtime_employees', function (Blueprint $table) {
            // Tambahkan kolom durasi (dalam hitungan jam, desimal. Contoh 1.5 = 1 jam 30 menit)
            $table->decimal('duration', 5, 2)->default(1)->after('type');
        });
    }

    public function down(): void
    {
        Schema::table('overtime_employees', function (Blueprint $table) {
            $table->dropColumn('duration');
        });
    }
};
