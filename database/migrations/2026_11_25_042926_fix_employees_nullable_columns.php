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
                $table->string('birth_place')->nullable()->change();
                $table->string('birth_date')->nullable()->change();
            });
        } catch (\Exception $e) {
            // SQLite fallback
            Schema::disableForeignKeyConstraints();
            Schema::table('employees', function (Blueprint $table) {
                $table->dropColumn(['birth_place', 'birth_date']);
            });
            Schema::table('employees', function (Blueprint $table) {
                $table->string('birth_place')->nullable()->after('employee_code');
                $table->date('birth_date')->nullable()->after('birth_place');
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
                $table->string('birth_place')->nullable(false)->change();
                $table->string('birth_date')->nullable(false)->change();
            });
        } catch (\Exception $e) {
            Schema::disableForeignKeyConstraints();
            Schema::table('employees', function (Blueprint $table) {
                $table->dropColumn(['birth_place', 'birth_date']);
            });
            Schema::table('employees', function (Blueprint $table) {
                $table->string('birth_place')->after('employee_code');
                $table->date('birth_date')->after('birth_place');
            });
            Schema::enableForeignKeyConstraints();
        }
    }
};
