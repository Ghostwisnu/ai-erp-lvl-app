<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\RoleController;
use App\Http\Controllers\Admin\MenuController;
use App\Http\Controllers\Admin\SubMenuController;
use App\Http\Controllers\Admin\PermissionController;
use App\Http\Controllers\Admin\EmployeeController;
use App\Http\Controllers\Admin\AttendanceController;
use App\Http\Controllers\Admin\ReportController;
use App\Http\Controllers\Admin\OvertimeController;
use App\Http\Controllers\Admin\HolidayController;
use App\Http\Controllers\Admin\LeaveRequestController;
use App\Http\Controllers\Admin\BrandController;
use App\Http\Controllers\Admin\DefectCategoryController;
use App\Http\Controllers\Produksi\SpkController;
use App\Http\Controllers\Produksi\ScanController;
use App\Http\Controllers\Produksi\DefectController;
use App\Http\Controllers\Produksi\ReportQcController;
use App\Http\Controllers\Produksi\MonitorQcController;
use App\Http\Controllers\Produksi\SpkBatchController;
use App\Http\Controllers\Admin\SettingFingerController;
use App\Http\Controllers\Admin\RekapAbsensiController;

// 1. Group Route Admin (Dilindungi Auth & Permission)
Route::middleware(['auth'])->prefix('admin')->name('admin.')->group(function () {

    // --- MASTER DATA (Role & Permission) ---
    Route::resource('users', UserController::class)->middleware('permission:manage-users');
    Route::resource('roles', RoleController::class)->middleware('permission:manage-roles');
    Route::resource('menus', MenuController::class)->middleware('permission:manage-menus');
    Route::resource('submenus', SubMenuController::class)->middleware('permission:manage-submenus');
    Route::resource('permissions', PermissionController::class)->middleware('permission:manage-permissions');

    // --- HRIS ---
    Route::get('/attendances', [AttendanceController::class, 'index'])->name('attendances.index')->middleware('permission:manage-attendances');
    Route::post('/attendances', [AttendanceController::class, 'store'])->name('attendances.store')->middleware('permission:manage-attendances');

    Route::get('/reports', [ReportController::class, 'index'])->name('reports.index')->middleware('permission:manage-attendances');

    // --- ROUTE IMPORT KARYAWAN (Diletakkan SEBELUM resource employees) ---
    Route::get('/employees/import', [EmployeeController::class, 'importForm'])->name('employees.import-form')->middleware('permission:manage-employees');
    Route::post('/employees/import/preview', [EmployeeController::class, 'importPreview'])->name('employees.import-preview')->middleware('permission:manage-employees');
    Route::get('/employees/import/confirm', [EmployeeController::class, 'importPreviewPage'])->name('employees.import-confirm')->middleware('permission:manage-employees');
    Route::post('/employees/import/store', [EmployeeController::class, 'importStore'])->name('employees.import-store')->middleware('permission:manage-employees');
    Route::get('/employees/import/template', [EmployeeController::class, 'downloadTemplate'])->name('employees.download-template')->middleware('permission:manage-employees');

    Route::resource('employees', EmployeeController::class)->middleware('permission:manage-employees');

    Route::get('/overtimes/daily', [OvertimeController::class, 'dailySchedule'])->name('overtimes.daily')->middleware('permission:manage-overtimes');
    Route::resource('overtimes', OvertimeController::class)->middleware('permission:manage-overtimes');
    Route::get('/overtimes/{overtime}/print', [OvertimeController::class, 'print'])->name('overtimes.print')->middleware('permission:manage-overtimes');

    Route::get('/holidays', [HolidayController::class, 'index'])->name('holidays.index')->middleware('permission:manage-holidays');
    Route::post('/holidays', [HolidayController::class, 'store'])->name('holidays.store')->middleware('permission:manage-holidays');
    Route::post('/holidays/import', [HolidayController::class, 'import'])->name('holidays.import')->middleware('permission:manage-holidays');
    Route::delete('/holidays/{holiday}', [HolidayController::class, 'destroy'])->name('holidays.destroy')->middleware('permission:manage-holidays');

    Route::resource('leave-requests', LeaveRequestController::class)->middleware('permission:manage-leave-requests');
    Route::post('leave-requests/{leaveRequest}/approve', [LeaveRequestController::class, 'approve'])->name('leave-requests.approve')->middleware('permission:manage-leave-requests');

    Route::get('/setting-finger', [SettingFingerController::class, 'index'])->name('setting-finger.index')->middleware('permission:manage-attendances');
    Route::post('/setting-finger/test', [SettingFingerController::class, 'testConnection'])->name('setting-finger.test')->middleware('permission:manage-attendances');

    Route::get('/rekap-absensi', [RekapAbsensiController::class, 'index'])->name('rekap-absensi.index')->middleware('permission:manage-attendances');
    Route::post('/rekap-absensi/tarik', [RekapAbsensiController::class, 'tarikData'])->name('rekap-absensi.tarik')->middleware('permission:manage-attendances');

    // --- PRODUKSI (Master) ---
    Route::resource('brands', BrandController::class)->middleware('permission:manage-brands');
    Route::resource('defect-categories', DefectCategoryController::class)->middleware('permission:manage-defects');
});

// 2. Group Route Produksi (Dilindungi Auth & Permission)
Route::middleware(['auth'])->prefix('produksi')->name('produksi.')->group(function () {
    Route::resource('spks', SpkController::class)->middleware('permission:manage-spk');
    Route::get('/spks/{spk}/print-barcode', [SpkController::class, 'printBarcode'])->name('spks.print-barcode')->middleware('permission:manage-spk');
    Route::post('/spks/{spk}/status', [SpkController::class, 'updateStatus'])->name('spks.update-status')->middleware('permission:manage-spk');

    Route::post('/daily-output', [SpkBatchController::class, 'storeDaily'])->name('daily-output.store')->middleware('permission:manage-spk');
    Route::delete('/daily-output/{daily}', [SpkBatchController::class, 'destroyDaily'])->name('daily-output.destroy')->middleware('permission:manage-spk');
    // --- ROUTE BATCH PRODUKSI ---
    Route::get('/spks/{spk}/batches', [SpkBatchController::class, 'index'])->name('spk-batches.index')->middleware('permission:manage-spk');
    Route::post('/spks/{spk}/batches/split', [SpkBatchController::class, 'split'])->name('spk-batches.split')->middleware('permission:manage-spk');
    Route::post('/spks/{spk}/batches/merge', [SpkBatchController::class, 'merge'])->name('spk-batches.merge')->middleware('permission:manage-spk');
    Route::post('/batches/{batch}/track', [SpkBatchController::class, 'updateTrack'])->name('spk-batches.update-track')->middleware('permission:manage-spk');
    Route::get('/spk-schedules', [SpkBatchController::class, 'schedule'])->name('spk-schedules.index')->middleware('permission:manage-spk');

    Route::get('/scan', [ScanController::class, 'index'])->name('scan.index')->middleware('permission:manage-scan');
    Route::get('/scan/{department}', [ScanController::class, 'scan'])->name('scan.board')->middleware('permission:manage-scan');
    Route::post('/scan/submit', [ScanController::class, 'submitScan'])->name('scan.submit')->middleware('permission:manage-scan');

    Route::get('/defects', [DefectController::class, 'index'])->name('defects.index')->middleware('permission:manage-defects');
    Route::post('/defects', [DefectController::class, 'store'])->name('defects.store')->middleware('permission:manage-defects');

    Route::get('/report-qc', [ReportQcController::class, 'index'])->name('report-qc.index')->middleware('permission:manage-qc');
    Route::get('/report-qc/{spk}', [ReportQcController::class, 'show'])->name('report-qc.show')->middleware('permission:manage-qc');

    Route::get('/monitor-qc', [MonitorQcController::class, 'index'])->name('monitor-qc.index')->middleware('permission:manage-qc');
});

// 3. Route Dashboard (Redirect ke Admin)
Route::middleware(['auth'])->group(function () {
    Route::get('/dashboard', function () {
        return redirect('/settings/profile');
    })->name('dashboard');
});

// 4. Route Bawaan Starter Kit
Route::inertia('/', 'welcome')->name('home');

// 5. Route Settings (Profil, dll)
require __DIR__ . '/settings.php';
