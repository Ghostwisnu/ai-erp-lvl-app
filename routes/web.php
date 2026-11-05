<?php

use App\Http\Controllers\Admin\AssetCatalogController;
use App\Http\Controllers\Admin\AssetController;
use App\Http\Controllers\Admin\AttendanceController;
use App\Http\Controllers\Admin\BrandController;
use App\Http\Controllers\Admin\DefectCategoryController;
use App\Http\Controllers\Admin\EmployeeController;
use App\Http\Controllers\Admin\HolidayController;
use App\Http\Controllers\Admin\LeaveRequestController;
use App\Http\Controllers\Admin\MenuController;
use App\Http\Controllers\Admin\OvertimeController;
use App\Http\Controllers\Admin\PayrollController;
use App\Http\Controllers\Admin\PermissionController;
use App\Http\Controllers\Admin\RekapAbsensiController;
use App\Http\Controllers\Admin\ReportController;
use App\Http\Controllers\Admin\RoleController;
use App\Http\Controllers\Admin\SettingFingerController;
use App\Http\Controllers\Admin\SubMenuController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Produksi\DefectController;
use App\Http\Controllers\Produksi\MonitorQcController;
use App\Http\Controllers\Produksi\ReportQcController;
use App\Http\Controllers\Produksi\ScanController;
use App\Http\Controllers\Produksi\SpkBatchController;
use App\Http\Controllers\Produksi\SpkController;
use Illuminate\Support\Facades\Route;

// Endpoint ADMS (push data dari mesin finger)
Route::middleware(\App\Http\Middleware\LogAdmsRequest::class)->group(function () {
    Route::match(['get', 'post'], 'iclock/cdata', [\App\Http\Controllers\AdmsController::class, 'cdata']);
    Route::get('iclock/getrequest', [\App\Http\Controllers\AdmsController::class, 'getrequest']);
    Route::post('iclock/devicecmd', [\App\Http\Controllers\AdmsController::class, 'devicecmd']);
    Route::any('iclock/{any}', [\App\Http\Controllers\AdmsController::class, 'getrequest'])->where('any', '.*');
});

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

    Route::get('/reports/export', [ReportController::class, 'export'])->name('reports.export')->middleware('permission:manage-attendances');
    Route::get('/reports', [ReportController::class, 'index'])->name('reports.index')->middleware('permission:manage-attendances');
    Route::get('/reports/attendance-daily', [ReportController::class, 'dailyAttendance'])->name('reports.attendance-daily')->middleware('permission:manage-attendances');

    Route::get('/payroll', [PayrollController::class, 'index'])->name('payroll.index')->middleware('permission:manage-payroll');
    Route::post('/payroll', [PayrollController::class, 'store'])->name('payroll.store')->middleware('permission:manage-payroll');
    Route::delete('/payroll/{payrollRun}', [PayrollController::class, 'destroy'])->name('payroll.destroy')->middleware('permission:manage-payroll');
    Route::get('/payroll/{payrollRun}/export/{format}', [PayrollController::class, 'export'])->name('payroll.export')->middleware('permission:manage-payroll');
    Route::get('/payroll/{payrollRun}', [PayrollController::class, 'show'])->name('payroll.show')->middleware('permission:manage-payroll');
    Route::post('/payroll/{payrollRun}/approve', [PayrollController::class, 'approve'])->name('payroll.approve')->middleware('permission:manage-payroll');
    Route::post('/payroll/{payrollRun}/paid', [PayrollController::class, 'markPaid'])->name('payroll.paid')->middleware('permission:manage-payroll');
    Route::post('/payroll/{payrollRun}/items/{payrollItem}/adjustments', [PayrollController::class, 'storeAdjustment'])->name('payroll.adjustments.store')->middleware('permission:manage-payroll');
    Route::delete('/payroll/{payrollRun}/items/{payrollItem}/adjustments/{payrollAdjustment}', [PayrollController::class, 'destroyAdjustment'])->name('payroll.adjustments.destroy')->middleware('permission:manage-payroll');

    // --- ROUTE IMPORT KARYAWAN (Diletakkan SEBELUM resource employees) ---
    Route::get('/employees/import', [EmployeeController::class, 'importForm'])->name('employees.import-form')->middleware('permission:manage-employees');
    Route::post('/employees/import/preview', [EmployeeController::class, 'importPreview'])->name('employees.import-preview')->middleware('permission:manage-employees');
    Route::get('/employees/import/confirm', [EmployeeController::class, 'importPreviewPage'])->name('employees.import-confirm')->middleware('permission:manage-employees');
    Route::post('/employees/import/store', [EmployeeController::class, 'importStore'])->name('employees.import-store')->middleware('permission:manage-employees');
    Route::get('/employees/import/template', [EmployeeController::class, 'downloadTemplate'])->name('employees.download-template')->middleware('permission:manage-employees');

    Route::get('/employees/bulk-update', [EmployeeController::class, 'bulkUpdateForm'])->name('employees.bulk-update')->middleware('permission:manage-employees');
    Route::post('/employees/bulk-update/preview', [EmployeeController::class, 'bulkUpdatePreview'])->name('employees.bulk-update.preview')->middleware('permission:manage-employees');
    Route::get('/employees/bulk-update/confirm', [EmployeeController::class, 'bulkUpdatePreviewPage'])->name('employees.bulk-update.confirm')->middleware('permission:manage-employees');
    Route::post('/employees/bulk-update/store', [EmployeeController::class, 'bulkUpdateStore'])->name('employees.bulk-update.store')->middleware('permission:manage-employees');
    Route::get('/employees/bulk-update/template', [EmployeeController::class, 'downloadBulkUpdateTemplate'])->name('employees.bulk-update.template')->middleware('permission:manage-employees');

    Route::get('/employees/salary-import', [EmployeeController::class, 'salaryImportForm'])->name('employees.salary-import')->middleware(['permission:manage-employees', 'permission:view-employee-salary']);
    Route::post('/employees/salary-import/preview', [EmployeeController::class, 'salaryImportPreview'])->name('employees.salary-import.preview')->middleware(['permission:manage-employees', 'permission:view-employee-salary']);
    Route::get('/employees/salary-import/confirm', [EmployeeController::class, 'salaryImportPreviewPage'])->name('employees.salary-import.confirm')->middleware(['permission:manage-employees', 'permission:view-employee-salary']);
    Route::post('/employees/salary-import/store', [EmployeeController::class, 'salaryImportStore'])->name('employees.salary-import.store')->middleware(['permission:manage-employees', 'permission:view-employee-salary']);
    Route::get('/employees/salary-import/template', [EmployeeController::class, 'downloadSalaryTemplate'])->name('employees.salary-import.template')->middleware(['permission:manage-employees', 'permission:view-employee-salary']);

    Route::resource('employees', EmployeeController::class)->middleware('permission:manage-employees');

    Route::get('/overtimes/daily', [OvertimeController::class, 'dailySchedule'])->name('overtimes.daily')->middleware('permission:manage-overtimes');
    Route::resource('overtimes', OvertimeController::class)->middleware('permission:manage-overtimes');
    Route::get('/overtimes/{overtime}/print', [OvertimeController::class, 'print'])->name('overtimes.print')->middleware('permission:manage-overtimes');

    Route::get('/holidays', [HolidayController::class, 'index'])->name('holidays.index')->middleware('permission:manage-holidays');
    Route::post('/holidays', [HolidayController::class, 'store'])->name('holidays.store')->middleware('permission:manage-holidays');
    Route::post('/holidays/import', [HolidayController::class, 'import'])->name('holidays.import')->middleware('permission:manage-holidays');
    Route::delete('/holidays/{holiday}', [HolidayController::class, 'destroy'])->name('holidays.destroy')->middleware('permission:manage-holidays');

    Route::resource('leave-requests', LeaveRequestController::class)->except('destroy')->middleware('permission:manage-leave-requests');
    Route::delete('leave-requests/{leaveRequest}', [LeaveRequestController::class, 'destroy'])->name('leave-requests.destroy')->middleware('permission:manage-leave-requests');
    Route::post('leave-requests/{leaveRequest}/cancel', [LeaveRequestController::class, 'cancel'])->name('leave-requests.cancel')->middleware('permission:manage-leave-requests');
    Route::post('leave-requests/{leaveRequest}/approve', [LeaveRequestController::class, 'approve'])->name('leave-requests.approve')->middleware('permission:manage-leave-requests');

    Route::get('/setting-finger', [SettingFingerController::class, 'index'])->name('setting-finger.index')->middleware('permission:manage-attendances');
    Route::post('/setting-finger/test', [SettingFingerController::class, 'testConnection'])->name('setting-finger.test')->middleware('permission:manage-attendances');

    Route::get('/rekap-absensi', [RekapAbsensiController::class, 'index'])->name('rekap-absensi.index')->middleware('permission:manage-attendances');
    Route::post('/rekap-absensi/tarik', [RekapAbsensiController::class, 'tarikData'])->name('rekap-absensi.tarik')->middleware('permission:manage-attendances');

    // --- PRODUKSI (Master) ---
    Route::resource('brands', BrandController::class)->middleware('permission:manage-brands');
    Route::resource('defect-categories', DefectCategoryController::class)->middleware('permission:manage-defects');

    // --- INVENTORY ASET ---
    Route::get('/assets/reports/export', [AssetController::class, 'export'])->name('assets.export')->middleware('permission:manage-assets');
    Route::get('/assets/reports', [AssetController::class, 'reports'])->name('assets.reports')->middleware('permission:manage-assets');
    Route::get('/assets/catalog', [AssetCatalogController::class, 'index'])->name('assets.catalog')->middleware('permission:manage-assets');
    Route::post('/assets/categories', [AssetCatalogController::class, 'storeCategory'])->name('assets.categories.store')->middleware('permission:manage-assets');
    Route::put('/assets/categories/{assetCategory}', [AssetCatalogController::class, 'updateCategory'])->name('assets.categories.update')->middleware('permission:manage-assets');
    Route::delete('/assets/categories/{assetCategory}', [AssetCatalogController::class, 'destroyCategory'])->name('assets.categories.destroy')->middleware('permission:manage-assets');
    Route::post('/assets/locations', [AssetCatalogController::class, 'storeLocation'])->name('assets.locations.store')->middleware('permission:manage-assets');
    Route::put('/assets/locations/{assetLocation}', [AssetCatalogController::class, 'updateLocation'])->name('assets.locations.update')->middleware('permission:manage-assets');
    Route::delete('/assets/locations/{assetLocation}', [AssetCatalogController::class, 'destroyLocation'])->name('assets.locations.destroy')->middleware('permission:manage-assets');
    Route::post('/assets/{asset}/assign', [AssetController::class, 'assign'])->name('assets.assign')->middleware('permission:manage-assets');
    Route::post('/assets/{asset}/maintenance', [AssetController::class, 'storeMaintenance'])->name('assets.maintenance.store')->middleware('permission:manage-assets');
    Route::resource('assets', AssetController::class)->middleware('permission:manage-assets');
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
    Route::get('/spk-schedules/export', [SpkBatchController::class, 'exportSchedule'])->name('spk-schedules.export')->middleware('permission:manage-spk');
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
require __DIR__.'/settings.php';
