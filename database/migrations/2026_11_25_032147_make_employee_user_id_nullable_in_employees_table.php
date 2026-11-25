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
        try {
            Schema::table('employees', function (Blueprint $table) {
                $table->foreignId('user_id')->nullable()->change();
            });
        } catch (Exception $e) {
            // SQLite fallback - recreate table with nullable user_id
            Schema::disableForeignKeyConstraints();
            Schema::table('employees', function (Blueprint $table) {
                // SQLite: drop and recreate column to make nullable
                $table->dropColumn('user_id');
            });
            Schema::table('employees', function (Blueprint $table) {
                $table->foreignId('user_id')->nullable()->after('id');
            });
            Schema::enableForeignKeyConstraints();
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        try {
            Schema::table('employees', function (Blueprint $table) {
                $table->foreignId('user_id')->nullable(false)->change();
            });
        } catch (Exception $e) {
            Schema::disableForeignKeyConstraints();
            Schema::table('employees', function (Blueprint $table) {
                $table->dropColumn('user_id');
            });
            Schema::table('employees', function (Blueprint $table) {
                $table->foreignId('user_id')->after('id');
            });
            Schema::enableForeignKeyConstraints();
        }
    }
};
