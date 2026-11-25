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
            Schema::table('brands', function (Blueprint $table) {
                $table->string('code')->nullable()->change();
            });
        } catch (Exception $e) {
            // SQLite fallback - drop and recreate column to make nullable
            Schema::disableForeignKeyConstraints();
            Schema::table('brands', function (Blueprint $table) {
                $table->dropColumn('code');
            });
            Schema::table('brands', function (Blueprint $table) {
                $table->string('code')->nullable()->after('id');
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
            Schema::table('brands', function (Blueprint $table) {
                $table->string('code')->nullable(false)->change();
            });
        } catch (Exception $e) {
            Schema::disableForeignKeyConstraints();
            Schema::table('brands', function (Blueprint $table) {
                $table->dropColumn('code');
            });
            Schema::table('brands', function (Blueprint $table) {
                $table->string('code')->after('id');
            });
            Schema::enableForeignKeyConstraints();
        }
    }
};
