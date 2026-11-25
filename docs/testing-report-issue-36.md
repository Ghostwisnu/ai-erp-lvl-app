# QA Testing Report - Issue #36

**Repository:** Ghostwisnu/ai-erp-lvl-app  
**Issue:** #36 (qaTesting, quality assurance)  
**Date:** November 20, 2026  
**Framework:** Laravel 13 + React/Inertia.js + TypeScript + Pest PHP

---

## Executive Summary

This report documents the QA testing analysis and automated test creation for issue #36. The analysis identified **2 critical bugs** and **missing test coverage** across the codebase. A comprehensive test suite has been created with **88 new test cases** covering previously untested functionality.

---

## Critical Bugs Found

### 1. PpsExport.php Department Inconsistency (HIGH)

**Location:** `app/Exports/PpsExport.php` - lines 12-20

**Issue:** The `DEPARTMENTS` constant uses outdated department names that don't match the production routes:

| Export (Buggy) | Controller (Correct)       |
| -------------- | -------------------------- |
| `cementing`    | `setting`                  |
| `packing`      | `delivery` / `finish_good` |
| Missing        | `stroble`                  |
| Missing        | `gudang_semi`              |

**Impact:** Excel exports will have incorrect department headers and will miss data for new departments.

**Status:** Bug identified with verification test in `tests/Feature/Admin/Produksi/PpsExportTest.php`

---

### 2. Employee Import Duplicate Detection Logic

**Location:** `app/Imports/EmployeesImport.php` (lines 45-47)

**Issue:** The duplicate code detection checks `seenCodes` before adding the code to the array, meaning the FIRST occurrence of a duplicate code is not flagged as invalid.

**Impact:** Duplicate employee codes in import files may be partially processed.

**Status:** Bug identified with verification tests in `tests/Feature/Admin/EmployeeImportDuplicateTest.php`

---

## Test Coverage Analysis

### Before Testing

| Controller             | Has Tests? | Test Files                      |
| ---------------------- | ---------- | ------------------------------- |
| SpkController          | ❌ No      | -                               |
| SpkBatchController     | ❌ No      | -                               |
| ScanController         | ❌ No      | -                               |
| DefectController       | ❌ No      | -                               |
| OvertimeController     | ❌ No      | -                               |
| AttendanceController   | ❌ No      | -                               |
| ReportController       | ⚠️ Partial | DailyAttendanceReportTest.php   |
| PayrollController      | ⚠️ Partial | PayrollTest.php (3 tests)       |
| EmployeeController     | ⚠️ Partial | Import/Bulk Update/Salary tests |
| LeaveRequestController | ⚠️ Partial | Cancellation/Deletion tests     |

### After Testing

| File                            | Tests | Category                                    |
| ------------------------------- | ----- | ------------------------------------------- |
| PpsExportTest.php               | 6     | Bug verification + Export validation        |
| SpkBatchControllerTest.php      | 15    | CRUD + Split/Merge + Daily output           |
| DefectControllerTest.php        | 10    | Index + Store + Validation                  |
| AttendanceControllerTest.php    | 12    | Index + Store + Weekend/Holiday handling    |
| OvertimeControllerTest.php      | 15    | CRUD + Employee attachment + Daily schedule |
| EmployeeImportDuplicateTest.php | 13    | Duplicate detection + Date parsing          |
| PayrollEdgeCasesTest.php        | 13    | Edge cases + Holiday handling               |
| LeaveRequestSyncTest.php        | 15    | Approval sync + Cancellation + Integration  |

**Total New Tests: 88**

---

## Test Files Created

### 1. `tests/Feature/Admin/Produksi/PpsExportTest.php`

Tests for Production Progress Schedule Excel export:

- Department consistency verification (BUG TEST)
- Header structure validation
- Brand filtering
- Empty collection handling
- Integration tests

### 2. `tests/Feature/Admin/Produksi/SpkBatchControllerTest.php`

Tests for Production Batch operations:

- Schedule viewing
- Split/merge operations
- Track updates with previous track ending
- Daily output storage
- Department validation (all 9 departments)

### 3. `tests/Feature/Admin/Produksi/DefectControllerTest.php`

Tests for Production Defect handling:

- Index page rendering with filtering
- Filter by SPK/Brand
- Defect creation with validation
- Department filtering

### 4. `tests/Feature/Admin/AttendanceControllerTest.php`

Tests for Employee Attendance:

- Index page with date filter
- Multi-employee storage
- Weekend auto-present
- Holiday auto-present
- Update behavior
- Authentication

### 5. `tests/Feature/Admin/OvertimeControllerTest.php`

Tests for Overtime management:

- CRUD operations
- Employee attachment with pivot data (type, duration)
- Validation (duration range, type values)
- Daily schedule
- Print view

### 6. `tests/Feature/Admin/EmployeeImportDuplicateTest.php`

Tests for Employee Import:

- Duplicate code detection within file
- Existing employee code in database detection
- Date format parsing (Y-m-d, d/m/Y, Excel serial)
- Empty required fields
- File type/size validation

### 7. `tests/Feature/Admin/PayrollEdgeCasesTest.php`

Tests for Payroll edge cases:

- Zero employees handling
- Boundary date calculations (period starts/ends)
- Absence deduction caps at basic salary
- Payroll lock status (approved/paid)
- Adjustment prevention after approval
- Leave request integration
- Overtime calculation
- Public holiday handling

### 8. `tests/Feature/Admin/LeaveRequestSyncTest.php`

Tests for Leave Request synchronization:

- Approval creates attendance records
- Correct status mapping (cuti→leave, sakit→sick, izin_setengah_hari→present)
- Time tracking
- Rejection handling
- Cancellation with attendance removal
- Payroll period lock
- Multi-day extension

---

## How to Run Tests

```bash
# Run all new tests
composer test --filter="PpsExportTest|SpkBatchControllerTest|DefectControllerTest|AttendanceControllerTest|OvertimeControllerTest|EmployeeImportDuplicateTest|PayrollEdgeCasesTest|LeaveRequestSyncTest"

# Run specific test file
php vendor/bin/pest tests/Feature/Admin/Produksi/PpsExportTest.php

# Run with coverage
php vendor/bin/pest --coverage

# Run in parallel for speed
php vendor/bin/pest --parallel
```

---

## Recommendations

### 1. Fix PpsExport Department Names (P0)

Update `app/Exports/PpsExport.php` to match production department names:

```php
private const DEPARTMENTS = [
    'cutting' => 'PEMOTONGAN',
    'setting' => 'PENGELEMAN',        // Formerly 'cementing'
    'sewing' => 'PENJAHITAN',
    'stroble' => 'STROBLE',          // New department
    'gudang_semi' => 'GUDANG SEMI',  // New department
    'lasting' => 'PEMASANGAN SOL',
    'injection' => 'INJEKSI',
    'finishing' => 'PENYELESAIAN',
    'packing' => 'DELIVERY',         // May need verification
];
```

### 2. Fix Duplicate Detection Logic (P1)

Refactor `app/Imports/EmployeesImport.php` to check duplicates AFTER adding to seenCodes.

---

## Files Modified/Created

### Created:

1. `tests/Feature/Admin/Produksi/PpsExportTest.php`
2. `tests/Feature/Admin/Produksi/SpkBatchControllerTest.php`
3. `tests/Feature/Admin/Produksi/DefectControllerTest.php`
4. `tests/Feature/Admin/AttendanceControllerTest.php`
5. `tests/Feature/Admin/OvertimeControllerTest.php`
6. `tests/Feature/Admin/EmployeeImportDuplicateTest.php`
7. `tests/Feature/Admin/PayrollEdgeCasesTest.php`
8. `tests/Feature/Admin/LeaveRequestSyncTest.php`
9. `docs/qa-testing-strategy-issue-36.md`
10. `docs/testing-report-issue-36.md`

### Status: ✅ Complete

All 88 test cases are ready for CI/CD integration. Two critical bugs have been identified with corresponding verification tests.
