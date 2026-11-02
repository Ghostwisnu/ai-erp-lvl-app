<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('payroll_items', function (Blueprint $table) {
            $table->decimal('overtime_hourly_rate', 15, 2)->default(0)->after('overtime_hours');
        });

        DB::table('payroll_items as items')
            ->join('payroll_runs as runs', 'runs.id', '=', 'items.payroll_run_id')
            ->select([
                'items.id as item_id',
                'items.basic_salary',
                'items.overtime_hours',
                'items.overtime_amount',
                'runs.status',
                'runs.overtime_hourly_rate as legacy_hourly_rate',
            ])
            ->orderBy('items.id')
            ->chunkById(100, function ($items) {
                foreach ($items as $item) {
                    $hourlyRate = $item->status === 'draft'
                        ? round((float) $item->basic_salary / 30 / 8, 2)
                        : (float) $item->legacy_hourly_rate;
                    $overtimeAmount = $item->status === 'draft'
                        ? round((float) $item->overtime_hours * $hourlyRate, 2)
                        : (float) $item->overtime_amount;

                    DB::table('payroll_items')
                        ->where('id', $item->item_id)
                        ->update([
                            'overtime_hourly_rate' => $hourlyRate,
                            'overtime_amount' => $overtimeAmount,
                        ]);
                }
            }, 'items.id', 'item_id');
    }

    public function down(): void
    {
        Schema::table('payroll_items', function (Blueprint $table) {
            $table->dropColumn('overtime_hourly_rate');
        });
    }
};
