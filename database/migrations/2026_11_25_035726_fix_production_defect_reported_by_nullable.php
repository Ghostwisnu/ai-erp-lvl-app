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
            Schema::table('production_defects', function (Blueprint $table) {
                $table->string('reported_by')->nullable()->change();
            });
        } catch (Exception $e) {
            // SQLite fallback
            Schema::disableForeignKeyConstraints();
            Schema::table('production_defects', function (Blueprint $table) {
                $table->dropColumn('reported_by');
            });
            Schema::table('production_defects', function (Blueprint $table) {
                $table->string('reported_by')->nullable()->after('qty');
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
            Schema::table('production_defects', function (Blueprint $table) {
                $table->string('reported_by')->nullable(false)->change();
            });
        } catch (Exception $e) {
            Schema::disableForeignKeyConstraints();
            Schema::table('production_defects', function (Blueprint $table) {
                $table->dropColumn('reported_by');
            });
            Schema::table('production_defects', function (Blueprint $table) {
                $table->string('reported_by')->after('qty');
            });
            Schema::enableForeignKeyConstraints();
        }
    }
};
