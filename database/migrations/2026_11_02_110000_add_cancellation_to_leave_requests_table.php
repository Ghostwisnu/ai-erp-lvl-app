<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Enum diganti string agar status 'cancelled' dapat disimpan.
        Schema::table('leave_requests', function (Blueprint $table) {
            $table->string('status')->default('pending')->change();
        });

        Schema::table('leave_requests', function (Blueprint $table) {
            $table->foreignId('cancelled_by')->nullable()->after('approval_note')->constrained('users')->nullOnDelete();
            $table->timestamp('cancelled_at')->nullable()->after('cancelled_by');
            $table->text('cancel_reason')->nullable()->after('cancelled_at');
        });
    }

    public function down(): void
    {
        Schema::table('leave_requests', function (Blueprint $table) {
            $table->dropConstrainedForeignId('cancelled_by');
            $table->dropColumn(['cancelled_at', 'cancel_reason']);
        });
    }
};
