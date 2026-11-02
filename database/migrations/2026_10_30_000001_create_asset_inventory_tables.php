<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('asset_categories', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->text('description')->nullable();
            $table->timestamps();
        });

        Schema::create('asset_locations', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->text('description')->nullable();
            $table->timestamps();
        });

        Schema::create('assets', function (Blueprint $table) {
            $table->id();
            $table->string('code')->unique();
            $table->string('name');
            $table->foreignId('asset_category_id')->constrained()->restrictOnDelete();
            $table->foreignId('asset_location_id')->nullable()->constrained()->nullOnDelete();
            $table->string('serial_number')->nullable()->unique();
            $table->string('brand')->nullable();
            $table->string('model')->nullable();
            $table->date('acquisition_date');
            $table->decimal('acquisition_cost', 15, 2);
            $table->decimal('salvage_value', 15, 2)->default(0);
            $table->unsignedSmallInteger('useful_life_months')->default(60);
            $table->string('condition')->default('good');
            $table->string('status')->default('in_service');
            $table->foreignId('assigned_to')->nullable()->constrained('users')->nullOnDelete();
            $table->text('description')->nullable();
            $table->timestamps();
            $table->index(['status', 'asset_category_id']);
        });

        Schema::create('asset_movements', function (Blueprint $table) {
            $table->id();
            $table->foreignId('asset_id')->constrained()->cascadeOnDelete();
            $table->string('action');
            $table->foreignId('from_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignId('to_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignId('from_location_id')->nullable()->constrained('asset_locations')->nullOnDelete();
            $table->foreignId('to_location_id')->nullable()->constrained('asset_locations')->nullOnDelete();
            $table->foreignId('performed_by')->nullable()->constrained('users')->nullOnDelete();
            $table->text('notes')->nullable();
            $table->timestamp('occurred_at');
            $table->timestamps();
            $table->index(['asset_id', 'occurred_at']);
        });

        Schema::create('asset_maintenances', function (Blueprint $table) {
            $table->id();
            $table->foreignId('asset_id')->constrained()->cascadeOnDelete();
            $table->date('service_date');
            $table->string('service_type');
            $table->string('vendor')->nullable();
            $table->text('description');
            $table->decimal('cost', 15, 2)->default(0);
            $table->date('next_service_date')->nullable();
            $table->string('status')->default('completed');
            $table->foreignId('performed_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
            $table->index(['asset_id', 'service_date']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('asset_maintenances');
        Schema::dropIfExists('asset_movements');
        Schema::dropIfExists('assets');
        Schema::dropIfExists('asset_locations');
        Schema::dropIfExists('asset_categories');
    }
};
