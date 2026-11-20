# QA Testing Strategy - Issue #36

## Overview

Issue #36 is a general QA request to add test coverage for the `ai-erp-lvl-app` application. This document outlines the testing strategy, findings from codebase analysis, and the automated tests created.

## Repository

- **Repository:** `Ghostwisnu/ai-erp-lvl-app`
- **Stack:** Laravel 13 + React/Inertia.js + TypeScript + Pest PHP
- **Issue Labels:** `qaTesting`, `quality assurance`

## Key Findings

### 1. PpsExport.php Department Inconsistency (HIGH - Bug Found)

**File:** `app/Exports/PpsExport.php`

The `DEPARTMENTS` constant still uses the old department names:
- `cementing` → should be `setting` (renamed in commit `6019b22`)
- `packing` → should be `delivery` / `finish_good`
- Missing: `stroble`, `gudang_semi` (introduced in commit `6019b22`)

The web UI and PDF export use the new departments, but the Excel export does not. This is a clear bug.

### 2. Employee Import Duplicate Detection Logic

**File:** `app/Imports/EmployeesImport.php` (lines 45-47)

The `seenCodes` check happens before the code is added to the array, so the first occurrence of a duplicate code won't be flagged. Same pattern exists in `EmployeeUpdateImport.php` and `EmployeeSalaryImport.php`.

### 3. Missing Test Coverage by Controller

| Controller | Has Tests? |
|---|---|
| `SpkController` | No |
| `SpkBatchController` | No |
| `ScanController` | No |
| `DefectController` | No |
| `OvertimeController` | No |
| `AttendanceController` | No |
| `ReportController` | Partial |
| `PayrollController` | Partial (3 tests) |
| `EmployeeController` | Partial (import/bulk update/salary tests) |
| `LeaveRequestController` | Partial (cancellation/deletion tests) |
| `AssetController` | Partial (AssetInventoryTest only) |

## Test Plan

### Phase 1: Critical Bugs
1. **PpsExport department consistency** - Verify export uses same departments as UI
2. **Employee import duplicate detection** - Verify duplicate codes are flagged

### Phase 2: Missing Controller Coverage
3. **SpkBatchController tests** - Schedule, split, merge, updateTrack, exportSchedule
4. **AttendanceController tests** - Index, store with weekend/holiday handling
5. **OvertimeController tests** - CRUD operations
6. **DefectController tests** - Index, store

### Phase 3: Edge Cases
7. **Payroll calculation edge cases** - Zero employees, boundary dates, negative adjustments
8. **Leave request sync** - Approval sync logic, half-day leave handling
9. **Export functionality** - PDF and Excel exports

## Test Files Created

1. `tests/Feature/Admin/Produksi/PpsExportTest.php` - PPS export tests
2. `tests/Feature/Admin/Produksi/SpkBatchControllerTest.php` - Batch controller tests
3. `tests/Feature/Admin/Produksi/DefectControllerTest.php` - Defect controller tests
4. `tests/Feature/Admin/AttendanceControllerTest.php` - Attendance controller tests
5. `tests/Feature/Admin/OvertimeControllerTest.php` - Overtime controller tests
6. `tests/Feature/Admin/EmployeeImportDuplicateTest.php` - Duplicate detection tests
7. `tests/Feature/Admin/PayrollEdgeCasesTest.php` - Payroll edge cases
8. `tests/Feature/Admin/LeaveRequestSyncTest.php` - Leave sync tests

## How to Run Tests

```bash
# Run all tests
composer test

# Run specific test file
composer test --filter=PpsExportTest

# Run with coverage
composer test --coverage
```