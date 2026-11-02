<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('payroll_runs', function (Blueprint $table) {
            $table->id();
            $table->unsignedTinyInteger('month');
            $table->unsignedSmallInteger('year');
            $table->date('period_start');
            $table->date('period_end');
            $table->decimal('overtime_hourly_rate', 15, 2)->default(0);
            $table->string('status')->default('draft');
            $table->foreignId('generated_by')->constrained('users');
            $table->foreignId('approved_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('approved_at')->nullable();
            $table->foreignId('paid_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('paid_at')->nullable();
            $table->timestamps();

            $table->unique(['month', 'year']);
        });

        Schema::create('payroll_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('payroll_run_id')->constrained()->cascadeOnDelete();
            $table->foreignId('employee_id')->nullable()->constrained()->nullOnDelete();
            $table->string('employee_code');
            $table->string('employee_name');
            $table->string('department')->nullable();
            $table->decimal('basic_salary', 15, 2)->default(0);
            $table->decimal('daily_rate', 15, 2)->default(0);
            $table->unsignedSmallInteger('unpaid_absence_days')->default(0);
            $table->decimal('absence_deduction', 15, 2)->default(0);
            $table->decimal('overtime_hours', 8, 2)->default(0);
            $table->decimal('overtime_amount', 15, 2)->default(0);
            $table->timestamps();

            $table->unique(['payroll_run_id', 'employee_code']);
        });

        Schema::create('payroll_adjustments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('payroll_item_id')->constrained()->cascadeOnDelete();
            $table->string('type');
            $table->string('description');
            $table->decimal('amount', 15, 2);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('payroll_adjustments');
        Schema::dropIfExists('payroll_items');
        Schema::dropIfExists('payroll_runs');
    }
};
