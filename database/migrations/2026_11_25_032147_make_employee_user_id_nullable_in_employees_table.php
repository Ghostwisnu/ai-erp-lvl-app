<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // MySQL: Drop foreign key, alter column to nullable, recreate foreign key
        Schema::table('employees', function (Blueprint $table) {
            // Drop the foreign key constraint first
            $table->dropForeign(['user_id']);
        });

        // Alter the column to be nullable using raw SQL for MySQL compatibility
        DB::statement('ALTER TABLE employees ALTER user_id DROP NOT NULL');

        Schema::table('employees', function (Blueprint $table) {
            // Recreate the foreign key with nullable user_id
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('employees', function (Blueprint $table) {
            // Drop the foreign key
            $table->dropForeign(['user_id']);
        });

        // Alter the column back to NOT NULL using raw SQL for MySQL compatibility
        DB::statement('ALTER TABLE employees ALTER user_id SET NOT NULL');

        Schema::table('employees', function (Blueprint $table) {
            // Recreate the foreign key
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }
};
