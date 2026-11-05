-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 05 Nov 2026 pada 01.21
-- Versi server: 9.7.2
-- Versi PHP: 8.5.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Basis data: `ai_erp_lvl`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `assets`
--

CREATE TABLE `assets` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `asset_category_id` bigint UNSIGNED NOT NULL,
  `asset_location_id` bigint UNSIGNED DEFAULT NULL,
  `serial_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `acquisition_date` date NOT NULL,
  `acquisition_cost` decimal(15,2) NOT NULL,
  `salvage_value` decimal(15,2) NOT NULL DEFAULT '0.00',
  `useful_life_months` smallint UNSIGNED NOT NULL DEFAULT '60',
  `condition` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'good',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in_service',
  `assigned_to` bigint UNSIGNED DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `asset_categories`
--

CREATE TABLE `asset_categories` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `asset_locations`
--

CREATE TABLE `asset_locations` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `asset_maintenances`
--

CREATE TABLE `asset_maintenances` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_id` bigint UNSIGNED NOT NULL,
  `service_date` date NOT NULL,
  `service_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendor` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `cost` decimal(15,2) NOT NULL DEFAULT '0.00',
  `next_service_date` date DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'completed',
  `performed_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `asset_movements`
--

CREATE TABLE `asset_movements` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_id` bigint UNSIGNED NOT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_user_id` bigint UNSIGNED DEFAULT NULL,
  `to_user_id` bigint UNSIGNED DEFAULT NULL,
  `from_location_id` bigint UNSIGNED DEFAULT NULL,
  `to_location_id` bigint UNSIGNED DEFAULT NULL,
  `performed_by` bigint UNSIGNED DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `occurred_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `attendances`
--

CREATE TABLE `attendances` (
  `id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `check_in` time DEFAULT NULL,
  `check_out` time DEFAULT NULL,
  `status` enum('present','sick','leave','absent') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'present',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `attendances`
--

INSERT INTO `attendances` (`id`, `employee_id`, `date`, `check_in`, `check_out`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(404, 1, '2026-10-27', '08:07:43', '17:19:59', 'present', NULL, '2026-10-27 01:21:39', '2026-10-29 01:43:37'),
(412, 1, '2026-10-28', '07:56:34', '17:23:08', 'present', NULL, '2026-10-27 18:45:37', '2026-10-29 01:43:39'),
(425, 1, '2026-10-29', '08:11:08', '17:25:51', 'present', NULL, '2026-10-29 01:39:12', '2026-10-29 20:01:53'),
(429, 1, '2026-10-30', '07:56:24', NULL, 'present', NULL, '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(436, 286, '2026-10-31', '16:02:57', NULL, 'present', NULL, '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(437, 286, '2026-11-02', '06:34:18', '18:02:40', 'present', NULL, '2026-11-01 22:37:35', '2026-11-03 19:24:59'),
(438, 234, '2026-11-02', '08:13:22', '17:14:29', 'present', NULL, '2026-11-01 22:37:36', '2026-11-03 19:24:58'),
(439, 1, '2026-11-02', '08:21:58', '17:30:21', 'present', NULL, '2026-11-01 22:37:36', '2026-11-03 19:24:58'),
(440, 176, '2026-11-02', '08:28:21', '17:30:06', 'present', NULL, '2026-11-01 22:37:36', '2026-11-03 19:24:58'),
(441, 116, '2026-11-02', '07:08:27', NULL, 'present', NULL, '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(442, 286, '2026-11-03', '06:34:50', '18:03:15', 'present', NULL, '2026-11-03 19:24:59', '2026-11-03 19:25:02'),
(444, 234, '2026-11-03', '07:48:00', '16:57:11', 'present', NULL, '2026-11-03 19:25:01', '2026-11-03 19:25:02'),
(445, 1, '2026-11-03', '08:03:26', '17:48:25', 'present', NULL, '2026-11-03 19:25:01', '2026-11-03 19:25:02'),
(446, 176, '2026-11-03', '08:23:43', '17:48:21', 'present', NULL, '2026-11-03 19:25:01', '2026-11-03 19:25:02'),
(447, 286, '2026-11-04', '06:30:28', NULL, 'present', NULL, '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(448, 234, '2026-11-04', '08:11:27', NULL, 'present', NULL, '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(449, 1, '2026-11-04', '08:24:21', NULL, 'present', NULL, '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(450, 176, '2026-11-04', '08:24:54', NULL, 'present', NULL, '2026-11-03 19:25:05', '2026-11-03 19:25:05');

-- --------------------------------------------------------

--
-- Struktur dari tabel `brands`
--

CREATE TABLE `brands` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `brands`
--

INSERT INTO `brands` (`id`, `name`, `code`, `description`, `created_at`, `updated_at`) VALUES
(1, 'ARIAT', '01', NULL, '2026-10-26 02:25:01', '2026-10-26 02:25:01');

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-76085509bf2ae92220e2ffb786a1ec31', 'i:1;', 1793327946),
('laravel-cache-76085509bf2ae92220e2ffb786a1ec31:timer', 'i:1793327946;', 1793327946),
('laravel-cache-ca4ff8ef639604c07a6bc2c8cd0e7fd1', 'i:1;', 1793782389),
('laravel-cache-ca4ff8ef639604c07a6bc2c8cd0e7fd1:timer', 'i:1793782389;', 1793782389),
('laravel-cache-f7268280766cb9e624b02a9d89b69b58', 'i:1;', 1793594374),
('laravel-cache-f7268280766cb9e624b02a9d89b69b58:timer', 'i:1793594374;', 1793594374),
('laravel-cache-spatie.permission.cache', 'a:3:{s:5:\"alias\";a:4:{s:1:\"a\";s:2:\"id\";s:1:\"b\";s:4:\"name\";s:1:\"c\";s:10:\"guard_name\";s:1:\"r\";s:5:\"roles\";}s:11:\"permissions\";a:28:{i:0;a:4:{s:1:\"a\";i:1;s:1:\"b\";s:12:\"manage-users\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:1;a:4:{s:1:\"a\";i:2;s:1:\"b\";s:12:\"manage-roles\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:2;a:4:{s:1:\"a\";i:3;s:1:\"b\";s:12:\"manage-menus\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:3;a:4:{s:1:\"a\";i:4;s:1:\"b\";s:15:\"manage-submenus\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:4;a:4:{s:1:\"a\";i:5;s:1:\"b\";s:12:\"view-profile\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}i:5;a:4:{s:1:\"a\";i:6;s:1:\"b\";s:12:\"manage-absen\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:6;a:4:{s:1:\"a\";i:7;s:1:\"b\";s:18:\"manage-permissions\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:7;a:4:{s:1:\"a\";i:8;s:1:\"b\";s:16:\"manage-employees\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:8;a:4:{s:1:\"a\";i:9;s:1:\"b\";s:18:\"manage-attendances\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:9;a:4:{s:1:\"a\";i:10;s:1:\"b\";s:16:\"manage-overtimes\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:10;a:4:{s:1:\"a\";i:11;s:1:\"b\";s:15:\"manage-holidays\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:11;a:4:{s:1:\"a\";i:12;s:1:\"b\";s:21:\"manage-leave-requests\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:12;a:4:{s:1:\"a\";i:13;s:1:\"b\";s:22:\"manage-overtimes-daily\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:13;a:4:{s:1:\"a\";i:14;s:1:\"b\";s:13:\"manage-brands\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:14;a:4:{s:1:\"a\";i:15;s:1:\"b\";s:10:\"manage-spk\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:15;a:4:{s:1:\"a\";i:16;s:1:\"b\";s:12:\"manage-scans\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:16;a:4:{s:1:\"a\";i:17;s:1:\"b\";s:24:\"manage-defect-categories\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:17;a:4:{s:1:\"a\";i:18;s:1:\"b\";s:14:\"manage-defects\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:18;a:4:{s:1:\"a\";i:19;s:1:\"b\";s:16:\"manage-report-qc\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:19;a:4:{s:1:\"a\";i:20;s:1:\"b\";s:17:\"manage-monitor-qc\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:20;a:4:{s:1:\"a\";i:21;s:1:\"b\";s:20:\"manage-rekap-absensi\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:21;a:4:{s:1:\"a\";i:22;s:1:\"b\";s:14:\"manage-koneksi\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:22;a:4:{s:1:\"a\";i:23;s:1:\"b\";s:18:\"manage-master-data\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:23;a:4:{s:1:\"a\";i:24;s:1:\"b\";s:15:\"manage-produksi\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:24;a:4:{s:1:\"a\";i:25;s:1:\"b\";s:11:\"manage-hris\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:25;a:4:{s:1:\"a\";i:26;s:1:\"b\";s:13:\"manage-assets\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:26;a:4:{s:1:\"a\";i:27;s:1:\"b\";s:14:\"manage-payroll\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:27;a:4:{s:1:\"a\";i:28;s:1:\"b\";s:20:\"view-employee-salary\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}}s:5:\"roles\";a:3:{i:0;a:3:{s:1:\"a\";i:1;s:1:\"b\";s:11:\"super-admin\";s:1:\"c\";s:3:\"web\";}i:1;a:3:{s:1:\"a\";i:3;s:1:\"b\";s:2:\"HR\";s:1:\"c\";s:3:\"web\";}i:2;a:3:{s:1:\"a\";i:2;s:1:\"b\";s:8:\"Operator\";s:1:\"c\";s:3:\"web\";}}}', 1793868734);

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `defect_categories`
--

CREATE TABLE `defect_categories` (
  `id` bigint UNSIGNED NOT NULL,
  `brand_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `defect_categories`
--

INSERT INTO `defect_categories` (`id`, `brand_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 1, 'OFF CENTER', 'OFF CENTER', '2026-10-26 20:54:32', '2026-10-26 20:54:32'),
(2, 1, 'HI/LOW BACK', 'HI/LOW BACK', '2026-10-26 20:54:45', '2026-10-26 20:54:45'),
(3, 1, 'MIS MATCHED COLOR', 'MIS MATCHED COLOR', '2026-10-26 20:54:55', '2026-10-26 20:54:55'),
(4, 1, 'BROKEN/LOOSE STITCHING', 'BROKEN/LOOSE STITCHING', '2026-10-26 20:55:06', '2026-10-26 20:55:06'),
(5, 1, 'IMPROPER MARGIN STITCHING', 'IMPROPER MARGIN STITCHING', '2026-10-26 20:55:19', '2026-10-26 20:55:19'),
(6, 1, 'IMPROPER COMPONENT POSITION', 'IMPROPER COMPONENT POSITION', '2026-10-26 20:55:28', '2026-10-26 20:55:28'),
(7, 1, 'STAIN', 'STAIN', '2026-10-26 21:58:36', '2026-10-26 21:58:36'),
(8, 1, 'DAMAGED UPPER/OS', 'DAMAGED UPPER/OS', '2026-10-26 21:58:47', '2026-10-26 21:58:47'),
(9, 1, 'POOR LEATHER CHARACTER', 'POOR LEATHER CHARACTER', '2026-10-26 21:58:57', '2026-10-26 21:58:57'),
(10, 1, 'DELAMINATION', 'DELAMINATION', '2026-10-26 21:59:06', '2026-10-26 21:59:06'),
(11, 1, 'OVER CEMENT', 'OVER CEMENT', '2026-10-26 21:59:18', '2026-10-26 21:59:18');

-- --------------------------------------------------------

--
-- Struktur dari tabel `employees`
--

CREATE TABLE `employees` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `employee_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_place` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date NOT NULL,
  `gender` enum('L','P') COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `join_date` date NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `basic_salary` decimal(15,2) NOT NULL DEFAULT '0.00',
  `photo_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `employees`
--

INSERT INTO `employees` (`id`, `user_id`, `employee_code`, `full_name`, `birth_place`, `birth_date`, `gender`, `phone_number`, `address`, `department`, `position`, `join_date`, `start_time`, `end_time`, `basic_salary`, `photo_path`, `created_at`, `updated_at`) VALUES
(1, 1, '202507001', 'Syafiq Wisnu Aarisatyo Putro', 'Jakarta', '2000-06-11', 'L', '087789525587', 'Komp. Mutiara Garuda Blok D3/19 Kampung Melayu Timur', 'IT', 'STAFF', '2025-07-08', '08:00:00', '17:00:00', 4500000.00, 'employees/dDhbuMHPb23rNbYVqFDwJ8dcFN5bLxkB1yJsvb2a.jpg', '2026-10-22 20:21:18', '2026-11-01 21:29:39'),
(10, 13, '201901001', 'YANTO SURYANTO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2019-01-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:30', '2026-11-01 20:37:30'),
(11, 14, '201901002', 'Bai Sobari', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2019-07-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:30', '2026-11-01 20:37:30'),
(12, 15, '201901003', 'KHARIDIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2019-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:30', '2026-11-01 20:37:30'),
(13, 16, '201901004', 'KOKOM KOMARIAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2019-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:31', '2026-11-01 20:37:31'),
(14, 17, '201901005', 'NOVI NURHAYATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2019-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:31', '2026-11-01 20:37:31'),
(15, 18, '201901006', 'SARMIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2019-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:31', '2026-11-01 20:37:31'),
(16, 19, '201901007', 'SITI ALINA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2019-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:31', '2026-11-01 20:37:31'),
(17, 20, '201901008', 'YUYUN BUDI L', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2019-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:32', '2026-11-01 20:37:32'),
(18, 21, '202004001', 'ACHMAD FAUZI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-04-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:32', '2026-11-01 20:37:32'),
(19, 22, '202004002', 'CARDI SUHAYADI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-04-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:32', '2026-11-01 20:37:32'),
(20, 23, '202004003', 'M. RAMDAN SAUD F', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-04-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:33', '2026-11-01 20:37:33'),
(21, 24, '202005001', 'ALGIA RIZKI ANANDA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:33', '2026-11-01 20:37:33'),
(22, 25, '202005002', 'IMAM NUGRAHA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:33', '2026-11-01 20:37:33'),
(23, 26, '202005003', 'IPAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-05-03', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:34', '2026-11-01 20:37:34'),
(24, 27, '202005004', 'MICAH CAHYATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:34', '2026-11-01 20:37:34'),
(25, 28, '202005005', 'NINGSIH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:34', '2026-11-01 20:37:34'),
(26, 29, '202005006', 'SYARIFUDIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:35', '2026-11-01 20:37:35'),
(27, 30, '202005007', 'WAWAN SETIAWAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:35', '2026-11-01 20:37:35'),
(28, 31, '202006001', 'ASEP JIDAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-06-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:35', '2026-11-01 20:37:35'),
(29, 32, '202006002', 'CASWAN AGUSTIAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-06-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:35', '2026-11-01 20:37:35'),
(30, 33, '202008001', 'FEBRI SUGIANTORO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-08-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:36', '2026-11-01 20:37:36'),
(31, 34, '202009001', 'ENIH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:36', '2026-11-01 20:37:36'),
(32, 35, '202009002', 'ENNO AMELIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:36', '2026-11-01 20:37:36'),
(33, 36, '202009003', 'SINTAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-09-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:37', '2026-11-01 20:37:37'),
(34, 37, '202011001', 'CECEP HIDAYAT', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-11-02', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:37', '2026-11-01 20:37:37'),
(35, 38, '202011002', 'RAMAZAL SAPUTRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2020-11-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:37', '2026-11-01 20:37:37'),
(36, 39, '202101001', 'DANI SUPRIATNA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-01-20', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:38', '2026-11-01 20:37:38'),
(37, 40, '202101002', 'SITI MARWAH HARAHAP', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-01-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:38', '2026-11-01 20:37:38'),
(38, 41, '202103001', 'SUPRIYATIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-03-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:38', '2026-11-01 20:37:38'),
(39, 42, '202105001', 'ERSIH SUKAESIH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:39', '2026-11-01 20:37:39'),
(40, 43, '202105002', 'IIS RISWANTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:39', '2026-11-01 20:37:39'),
(41, 44, '202105003', 'KHOTIMAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:39', '2026-11-01 20:37:39'),
(42, 45, '202105004', 'NIRAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:39', '2026-11-01 20:37:39'),
(43, 46, '202105005', 'SUHENDRA (REPAIR)', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:40', '2026-11-01 20:37:40'),
(44, 47, '202105006', 'WINARTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-05-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:40', '2026-11-01 20:37:40'),
(45, 48, '202106001', 'KARNAH HASANAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-06-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:40', '2026-11-01 20:37:40'),
(46, 49, '202106002', 'MUJIROH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-06-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:41', '2026-11-01 20:37:41'),
(47, 50, '202106003', 'SRI HANDAYANI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-06-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:41', '2026-11-01 20:37:41'),
(48, 51, '202106004', 'SRI SUSANTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-06-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:41', '2026-11-01 20:37:41'),
(49, 52, '202107001', 'ANITA PUSPITA SARI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-07-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:42', '2026-11-01 20:37:42'),
(50, 53, '202107002', 'SRI KARNI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-07-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:42', '2026-11-01 20:37:42'),
(51, 54, '202107003', 'SUKESMI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-07-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:42', '2026-11-01 20:37:42'),
(52, 55, '202108001', 'NUR LAELA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-08-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:43', '2026-11-01 20:37:43'),
(53, 56, '202110001', 'DINAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-10-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:43', '2026-11-01 20:37:43'),
(54, 57, '202110002', 'JULIA RAHMAWATI SIREGAR', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-10-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:43', '2026-11-01 20:37:43'),
(55, 58, '202110003', 'RIZKI AGUNG H', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-10-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:43', '2026-11-01 20:37:43'),
(56, 59, '202112001', 'OPIN MAILANI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2021-12-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:44', '2026-11-01 20:37:44'),
(57, 60, '202205001', 'NABILA DILLANI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-03-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:44', '2026-11-01 20:37:44'),
(58, 61, '202205002', 'TINI MARDINI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:44', '2026-11-01 20:37:44'),
(59, 62, '202205003', 'TUTIK WINARSIH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:45', '2026-11-01 20:37:45'),
(60, 63, '202206001', 'ABDUL ROHIM', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-06-06', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:45', '2026-11-01 20:37:45'),
(61, 64, '202206002', 'BENI SAMBODO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-06-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:45', '2026-11-01 20:37:45'),
(62, 65, '202206003', 'EVA MILANTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-06-16', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:46', '2026-11-01 20:37:46'),
(63, 66, '202206004', 'KORIAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-06-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:46', '2026-11-01 20:37:46'),
(64, 67, '202206005', 'SITI NURHAYATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-06-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:46', '2026-11-01 20:37:46'),
(65, 68, '202207001', 'ISAK SAMSUDIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-07-11', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:46', '2026-11-01 20:37:46'),
(66, 69, '202207002', 'MITA NUR AZIZAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-07-11', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:47', '2026-11-01 20:37:47'),
(67, 70, '202207003', 'NUARI GALIH LAKSONO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-07-11', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:47', '2026-11-01 20:37:47'),
(68, 71, '202208001', 'CETA MARDIANYSAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-08-03', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:47', '2026-11-01 20:37:47'),
(69, 72, '202208002', 'LAPENIA OKTAPIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-08-18', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:48', '2026-11-01 20:37:48'),
(70, 73, '202211001', 'AHMAD NURWAHID', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2022-11-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:48', '2026-11-01 20:37:48'),
(71, 74, '202306001', 'NAZWA KHAIRUNNISA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2023-06-30', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:48', '2026-11-01 20:37:48'),
(72, 75, '202306002', 'PERI FAISAL', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2023-06-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:48', '2026-11-01 20:37:48'),
(73, 76, '202404001', 'NAMAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-04-30', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:49', '2026-11-01 20:37:49'),
(74, 77, '202404002', 'NITA PURNAMASARI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-04-29', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:49', '2026-11-01 20:37:49'),
(75, 78, '202404003', 'NOVITASARI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-04-29', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:49', '2026-11-01 20:37:49'),
(76, 79, '202404004', 'SARI FADILAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-04-29', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:50', '2026-11-01 20:37:50'),
(77, 80, '202404005', 'SEPTIAN RAHAYU', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-04-30', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:50', '2026-11-01 20:37:50'),
(78, 81, '202404006', 'WIDIA WULANDARI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-04-30', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:50', '2026-11-01 20:37:50'),
(79, 82, '202405001', 'ADE KOMARUDIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:51', '2026-11-01 20:37:51'),
(80, 83, '202405002', 'ADITYA CATUR SAYOGA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:51', '2026-11-01 20:37:51'),
(81, 84, '202405003', 'ALYA SERA SETIAWATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:51', '2026-11-01 20:37:51'),
(82, 85, '202405004', 'APRIYATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-10', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:51', '2026-11-01 20:37:51'),
(83, 86, '202405005', 'BERKAH MAWAR SILALAHI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:52', '2026-11-01 20:37:52'),
(84, 87, '202405006', 'CARTINI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-02', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:52', '2026-11-01 20:37:52'),
(85, 88, '202405007', 'DEVI KOMALASARI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:52', '2026-11-01 20:37:52'),
(86, 89, '202405008', 'DINA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:53', '2026-11-01 20:37:53'),
(87, 90, '202405009', 'DINI TITA HANDINI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-08', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:53', '2026-11-01 20:37:53'),
(88, 91, '202405010', 'ENAH HASANAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:53', '2026-11-01 20:37:53'),
(89, 92, '202405011', 'EPRONIKA SIHOTANG', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:53', '2026-11-01 20:37:53'),
(90, 93, '202405012', 'FITRI NURWULAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:54', '2026-11-01 20:37:54'),
(91, 94, '202405013', 'HANIFAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:54', '2026-11-01 20:37:54'),
(92, 95, '202405014', 'JAENAL ABIDIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:54', '2026-11-01 20:37:54'),
(93, 96, '202405015', 'LIANA NURUL AFNI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-08', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:55', '2026-11-01 20:37:55'),
(94, 97, '202405016', 'LISDA SIDABUTAR', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:55', '2026-11-01 20:37:55'),
(95, 98, '202405017', 'MUHAMAD LUCKY', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:55', '2026-11-01 20:37:55'),
(96, 99, '202405018', 'MUSIYAM', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:56', '2026-11-01 20:37:56'),
(97, 100, '202405019', 'NENENG SHOLIHAT', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-08', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:56', '2026-11-01 20:37:56'),
(98, 101, '202405020', 'NUR FITRIA SARI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:56', '2026-11-01 20:37:56'),
(99, 102, '202405021', 'NURHALIMAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:56', '2026-11-01 20:37:56'),
(100, 103, '202405022', 'ODAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:57', '2026-11-01 20:37:57'),
(101, 104, '202405023', 'REKHA ANISA LIANTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:57', '2026-11-01 20:37:57'),
(102, 105, '202405024', 'RIKY EKA PERMANA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-08', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:57', '2026-11-01 20:37:57'),
(103, 106, '202405025', 'ROHMAT', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:58', '2026-11-01 20:37:58'),
(104, 107, '202405026', 'RUKINAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:58', '2026-11-01 20:37:58'),
(105, 108, '202405027', 'SALSA ANISA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:58', '2026-11-01 20:37:58'),
(106, 109, '202405028', 'SAPUTRI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-02', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:59', '2026-11-01 20:37:59'),
(107, 110, '202405029', 'SARWI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:59', '2026-11-01 20:37:59'),
(108, 111, '202405030', 'SIMIH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:59', '2026-11-01 20:37:59'),
(109, 112, '202405031', 'SITI NURUL IDAYANTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:37:59', '2026-11-01 20:37:59'),
(110, 113, '202405032', 'SITI SOLIHAT', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:00', '2026-11-01 20:38:00'),
(111, 114, '202405033', 'SRI WAHYUNI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-02', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:00', '2026-11-01 20:38:00'),
(112, 115, '202405034', 'SYIFA AULIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:00', '2026-11-01 20:38:00'),
(113, 116, '202405035', 'TUTI SUGIARTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:01', '2026-11-01 20:38:01'),
(114, 117, '202405036', 'VERONICA FAZRIW AYAZA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-15', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:01', '2026-11-01 20:38:01'),
(115, 118, '202405037', 'YANTI KUSWARA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:01', '2026-11-01 20:38:01'),
(116, 119, '202405038', 'YATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-05-03', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:02', '2026-11-01 20:38:02'),
(117, 120, '202406001', 'FEBRIANI AULIA PUTRI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-06-25', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:02', '2026-11-01 20:38:02'),
(118, 121, '202406002', 'JAMAL', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-06-15', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:02', '2026-11-01 20:38:02'),
(119, 122, '202406003', 'SAHRUL ROJI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-06-25', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:02', '2026-11-01 20:38:02'),
(120, 123, '202406004', 'SISKA AMELIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-06-25', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:03', '2026-11-01 20:38:03'),
(121, 124, '202406005', 'SUCI NURAENI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-06-25', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:03', '2026-11-01 20:38:03'),
(122, 125, '202406006', 'SULASTRI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-06-12', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:03', '2026-11-01 20:38:03'),
(123, 126, '202407001', 'ANNISYA ALIF RIDHOLLAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-07-30', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:04', '2026-11-01 20:38:04'),
(124, 127, '202407002', 'DANANG NUR ALIM', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-07-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:04', '2026-11-01 20:38:04'),
(125, 128, '202407003', 'ILMA HALIMAHTIS SADIAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-07-30', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:04', '2026-11-01 20:38:04'),
(126, 129, '202408001', 'ADE NOVIANTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:05', '2026-11-01 20:38:05'),
(127, 130, '202408002', 'ADLIL DZIL IKRAM', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:05', '2026-11-01 20:38:05'),
(128, 131, '202408003', 'AKMAL MAULANA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-06', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:06', '2026-11-01 20:38:06'),
(129, 132, '202408004', 'ARIO HERMANSA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:06', '2026-11-01 20:38:06'),
(130, 133, '202408005', 'ASEP RUSTIANA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:06', '2026-11-01 20:38:06'),
(131, 134, '202408006', 'AYU ARYANI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:07', '2026-11-01 20:38:07'),
(132, 135, '202408007', 'EBAH HABIBAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:07', '2026-11-01 20:38:07'),
(133, 136, '202408008', 'ENCUM SUMARTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:07', '2026-11-01 20:38:07'),
(134, 137, '202408009', 'EVAN/RAJANAHOT E GIRSANG', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:08', '2026-11-01 20:38:08'),
(135, 138, '202408010', 'FAIZAL AFRIANSYAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:08', '2026-11-01 20:38:08'),
(136, 139, '202408011', 'HIDUP SOLEHUDIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:08', '2026-11-01 20:38:08'),
(137, 140, '202408012', 'IDA HAMIDAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:09', '2026-11-01 20:38:09'),
(138, 141, '202408013', 'IDHAM MUNANDAR', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:09', '2026-11-01 20:38:09'),
(139, 142, '202408014', 'KARYANI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:09', '2026-11-01 20:38:09'),
(140, 143, '202408015', 'KOKOH WAYAN SATRIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:10', '2026-11-01 20:38:10'),
(141, 144, '202408016', 'METRINAWATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:10', '2026-11-01 20:38:10'),
(142, 145, '202408017', 'MISYATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:10', '2026-11-01 20:38:10'),
(143, 146, '202408018', 'MUHAMAD NAJIB', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:11', '2026-11-01 20:38:11'),
(144, 147, '202408019', 'MUHAMMAD AGUNG RAMADAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:11', '2026-11-01 20:38:11'),
(145, 148, '202408020', 'MUHAMMAD BAHIR', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:11', '2026-11-01 20:38:11'),
(146, 149, '202408021', 'NETTI PURBA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:12', '2026-11-01 20:38:12'),
(147, 150, '202408022', 'OKKY SAPUTRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:12', '2026-11-01 20:38:12'),
(148, 151, '202408023', 'RINEM', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:12', '2026-11-01 20:38:12'),
(149, 152, '202408024', 'RINNY FITRI NURAINI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:13', '2026-11-01 20:38:13'),
(150, 153, '202408025', 'ROBY IRAWAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:13', '2026-11-01 20:38:13'),
(151, 154, '202408026', 'SAMAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:13', '2026-11-01 20:38:13'),
(152, 155, '202408027', 'SANTA MARYANI D', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:14', '2026-11-01 20:38:14'),
(153, 156, '202408028', 'SELY RAHMAWATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:14', '2026-11-01 20:38:14'),
(154, 157, '202408029', 'SHAFA KAROMAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:14', '2026-11-01 20:38:14'),
(155, 158, '202408030', 'SRI DOHARNI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:15', '2026-11-01 20:38:15'),
(156, 159, '202408031', 'SRI LENA PANJAITAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:15', '2026-11-01 20:38:15'),
(157, 160, '202408032', 'UNTUNG SISWOYO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:15', '2026-11-01 20:38:15'),
(158, 161, '202408033', 'VERONIKA ARITONANG', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-08-19', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:15', '2026-11-01 20:38:15'),
(159, 162, '202410001', 'AAM AMELIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:16', '2026-11-01 20:38:16'),
(160, 163, '202410002', 'Adib Prasetyo Hadi', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:16', '2026-11-01 20:38:16'),
(161, 164, '202410003', 'Agus Budi Santoso', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:16', '2026-11-01 20:38:16'),
(162, 165, '202410004', 'ANGGA PRIANANDA PUTRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:17', '2026-11-01 20:38:17'),
(163, 166, '202410005', 'Bagus Wahyu Nurcholis', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:17', '2026-11-01 20:38:17'),
(164, 167, '202410006', 'Aulia Valentica', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:17', '2026-11-01 20:38:17'),
(165, 168, '202410007', 'Aziz Fesan Laut', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:18', '2026-11-01 20:38:18'),
(166, 169, '202410008', 'Ummi Kalsum', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:18', '2026-11-01 20:38:18'),
(167, 170, '202410009', 'Arif Rohimat', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-29', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:18', '2026-11-01 20:38:18'),
(168, 171, '202410010', 'Dodi Aji Yusup', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:19', '2026-11-01 20:38:19'),
(169, 172, '202410011', 'Kurniadi', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:19', '2026-11-01 20:38:19'),
(170, 173, '202410012', 'Lita Amelia', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:19', '2026-11-01 20:38:19'),
(171, 174, '202410013', 'Naufal Rafi Dzaki', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:20', '2026-11-01 20:38:20'),
(172, 175, '202410014', 'NAZWA ALIA RAHMAWATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:20', '2026-11-01 20:38:20'),
(173, 176, '202410015', 'MUHAMMAD ARIFIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:20', '2026-11-01 20:38:20'),
(174, 177, '202410016', 'SUTAMAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:21', '2026-11-01 20:38:21'),
(175, 178, '202410017', 'SRI WAHYUNI DEWI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:21', '2026-11-01 20:38:21'),
(176, 179, '202411001', 'Bagas Prastyo Wibowo', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:21', '2026-11-01 20:38:21'),
(177, 180, '202411002', 'Anisa Marcela', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:22', '2026-11-01 20:38:22'),
(178, 181, '202411003', 'Dede Mahjun', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:22', '2026-11-01 20:38:22'),
(179, 182, '202411004', 'Deni Ahmad', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:22', '2026-11-01 20:38:22'),
(180, 183, '202411005', 'Fatimatu Zahra', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:23', '2026-11-01 20:38:23'),
(181, 184, '202411006', 'Ilham Fadilah', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:23', '2026-11-01 20:38:23'),
(182, 185, '202411007', 'JELITA CINTA F', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-24', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:23', '2026-11-01 20:38:23'),
(183, 186, '202411008', 'Ismail', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:23', '2026-11-01 20:38:23'),
(184, 187, '202411009', 'KARINA NATASYA MARDIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:24', '2026-11-01 20:38:24'),
(185, 188, '202411010', 'Mohamad Ikbal', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:24', '2026-11-01 20:38:24'),
(186, 189, '202411011', 'Naesya Aulia Kartini', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:24', '2026-11-01 20:38:24'),
(187, 190, '202411012', 'Mila Kuswara', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:25', '2026-11-01 20:38:25'),
(188, 191, '202411013', 'MUhamad Ridwan', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:25', '2026-11-01 20:38:25'),
(189, 192, '202411014', 'PUTRI HAYATTUNNISA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:25', '2026-11-01 20:38:25'),
(190, 193, '202411015', 'ROSALINDA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:26', '2026-11-01 20:38:26'),
(191, 194, '202411016', 'RYANTI DEWI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:26', '2026-11-01 20:38:26'),
(192, 195, '202411017', 'Siti Jamilah', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:26', '2026-11-01 20:38:26'),
(193, 196, '202411018', 'Rianti', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:27', '2026-11-01 20:38:27'),
(194, 197, '202411019', 'SELVI MARLISA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:27', '2026-11-01 20:38:27'),
(195, 198, '202411020', 'ZAINAL ARIFIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-11-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:27', '2026-11-01 20:38:27'),
(196, 199, '202501001', 'JUJU MULYAWATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-01-13', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:28', '2026-11-01 20:38:28'),
(197, 200, '202501002', 'MARGARETA SHAELA O', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-01-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:28', '2026-11-01 20:38:28'),
(198, 201, '202501003', 'Melly Permata Sari', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-01-13', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:29', '2026-11-01 20:38:29'),
(199, 202, '202501004', 'Supriyadi', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-01-06', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:29', '2026-11-01 20:38:29'),
(200, 203, '202501005', 'Wulandari', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-01-26', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:30', '2026-11-01 20:38:30'),
(201, 204, '202502001', 'ARUFI DIANA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-02-27', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:30', '2026-11-01 20:38:30'),
(202, 205, '202502002', 'Egi Saputra', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-02-05', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:30', '2026-11-01 20:38:30'),
(203, 206, '202502003', 'Evi Triyanti', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-02-13', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:31', '2026-11-01 20:38:31'),
(204, 207, '202502004', 'HALIMAH LIM', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-02-03', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:31', '2026-11-01 20:38:31'),
(205, 208, '202502005', 'M. Iqbal Kurnia', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-02-03', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:31', '2026-11-01 20:38:31'),
(206, 209, '202502006', 'RIFKI SETIAWAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-02-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:32', '2026-11-01 20:38:32'),
(207, 210, '202502007', 'SILPIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-02-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:32', '2026-11-01 20:38:32'),
(208, 211, '202505001', 'AGUS SETIAWAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-05-26', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:32', '2026-11-01 20:38:32'),
(209, 212, '202505002', 'MARIANA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:33', '2026-11-01 20:38:33'),
(210, 213, '202505003', 'NGATMI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-05-26', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:33', '2026-11-01 20:38:33'),
(211, 214, '202505004', 'NUR SAROPAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:33', '2026-11-01 20:38:33'),
(212, 215, '202505005', 'SYAHRUL WAHYU SHOBIRIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-05-26', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:34', '2026-11-01 20:38:34'),
(213, 216, '202505006', 'UYEH YOGIANSYAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-05-14', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:34', '2026-11-01 20:38:34'),
(214, 217, '202506001', 'AL ZAHRA DWI AGRINA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-06-26', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:34', '2026-11-01 20:38:34'),
(215, 218, '202506002', 'Oktaviona Aidelwys', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-06-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:35', '2026-11-01 20:38:35'),
(216, 219, '202506003', 'EKA APRIYANTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-06-26', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:35', '2026-11-01 20:38:35'),
(217, 220, '202506004', 'MERSI PATTIKWARA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-06-26', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:35', '2026-11-01 20:38:35'),
(218, 221, '202507002', 'AHMAD SUHAEMI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-26', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:36', '2026-11-01 20:38:36'),
(219, 222, '202507003', 'Arinda Estriana Arnianto', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-08', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:36', '2026-11-01 20:38:36'),
(220, 223, '202507004', 'DAENG SABAR K', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-28', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:36', '2026-11-01 20:38:36'),
(221, 224, '202507005', 'Helmaliani Fransischa', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-08', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:37', '2026-11-01 20:38:37'),
(222, 225, '202507006', 'M. Rayesa Aditiya', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-15', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:37', '2026-11-01 20:38:37'),
(223, 226, '202507007', 'NANIM NABILA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-15', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:37', '2026-11-01 20:38:37'),
(224, 227, '202507008', 'RULLI YANSYAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-15', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:37', '2026-11-01 20:38:37'),
(225, 228, '202507009', 'Suriyah', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-23', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:38', '2026-11-01 20:38:38'),
(226, 229, '202507010', 'TRI YUSANTI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-18', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:38', '2026-11-01 20:38:38'),
(227, 230, '202410018', 'MUHAMMAD JAJULI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:38', '2026-11-01 20:38:38'),
(228, 231, '202410019', 'MUHAMMAD RIFKI SAPUTRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2024-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:39', '2026-11-01 20:38:39'),
(229, 232, '202506005', 'VERNANDA DIAN A', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-06-11', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:39', '2026-11-01 20:38:39'),
(230, 233, '202507011', 'Yoyoh Farida', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-03', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:39', '2026-11-01 20:38:39'),
(231, 234, '202507012', 'YASINTA AMEIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-07-15', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:40', '2026-11-01 20:38:40'),
(232, 235, '202508001', 'ENAH MARYNAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-08-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:40', '2026-11-01 20:38:40'),
(233, 236, '202508002', 'MUHAMMAD RIZKI SAPUTRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-08-06', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:40', '2026-11-01 20:38:40'),
(234, 237, '202510001', 'NAMIRA ALIFAH ZAHRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2025-10-27', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:41', '2026-11-01 20:38:41'),
(235, 238, '202604001', 'AJENG MAYANG SARI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-02', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:41', '2026-11-01 20:38:41'),
(236, 239, '202604002', 'ANISAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-01', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:42', '2026-11-01 20:38:42'),
(237, 240, '202604003', 'AQQIL WAHID SUFIAN F', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:42', '2026-11-01 20:38:42'),
(238, 241, '202604004', 'CASMIAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-10', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:42', '2026-11-01 20:38:42'),
(239, 242, '202604005', 'DIAN FIRMANSAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:43', '2026-11-01 20:38:43'),
(240, 243, '202604006', 'DIAN RAMADHAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-16', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:43', '2026-11-01 20:38:43'),
(241, 244, '202604007', 'DICKY DWI SYAHPUTRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:43', '2026-11-01 20:38:43'),
(242, 245, '202604008', 'DINDA KIRANA AZZAHRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-16', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:43', '2026-11-01 20:38:43'),
(243, 246, '202604009', 'DIRA AGUSTINA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:44', '2026-11-01 20:38:44'),
(244, 247, '202604010', 'DRIANA AGUSLIANTARI S.', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-13', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:44', '2026-11-01 20:38:44'),
(245, 248, '202604011', 'ELSON KEVIN HAUMAHU', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:44', '2026-11-01 20:38:44'),
(246, 249, '202604012', 'FAHRI HUSAINI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:45', '2026-11-01 20:38:45'),
(247, 250, '202604013', 'FAUZIAH RAMADHANI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:45', '2026-11-01 20:38:45'),
(248, 251, '202604014', 'FAUZIAH RAMADHANI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:45', '2026-11-01 20:38:45'),
(249, 252, '202604015', 'FITRI MULYANI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:46', '2026-11-01 20:38:46'),
(250, 253, '202604016', 'GILANG PRAYITNO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:46', '2026-11-01 20:38:46'),
(251, 254, '202604017', 'IIN INAYAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-28', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:46', '2026-11-01 20:38:46'),
(252, 255, '202604018', 'INTAN ASHARI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:47', '2026-11-01 20:38:47'),
(253, 256, '202604019', 'JAYADI ANWAR', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-10', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:47', '2026-11-01 20:38:47'),
(254, 257, '202604020', 'JEVITHA SETIA LUCHIA WIBOWO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-08', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:47', '2026-11-01 20:38:47'),
(255, 258, '202604021', 'KAFKHA ATMI PRATIWI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:48', '2026-11-01 20:38:48'),
(256, 259, '202604022', 'KAILA TRI AMANDA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-13', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:48', '2026-11-01 20:38:48'),
(257, 260, '202604023', 'KARDI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:48', '2026-11-01 20:38:48'),
(258, 261, '202604024', 'KEYSA PRATAMA PUTRI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-02', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:49', '2026-11-01 20:38:49'),
(259, 262, '202604025', 'M. KHOLILI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:49', '2026-11-01 20:38:49'),
(260, 263, '202604026', 'M. RENO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:50', '2026-11-01 20:38:50'),
(261, 264, '202604027', 'M. RIZKI RAMADHAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:50', '2026-11-01 20:38:50'),
(262, 265, '202604028', 'MARIO', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-02', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:51', '2026-11-01 20:38:51'),
(263, 266, '202604029', 'MUHAMMAD AL FARISI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:51', '2026-11-01 20:38:51'),
(264, 267, '202604030', 'MUTMAINAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-27', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:51', '2026-11-01 20:38:51'),
(265, 268, '202604031', 'NANA HINDRA MULYANA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-15', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:52', '2026-11-01 20:38:52'),
(266, 269, '202604032', 'NAURISTA SAFITRI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-28', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:52', '2026-11-01 20:38:52'),
(267, 270, '202604033', 'NIA NABILA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:53', '2026-11-01 20:38:53'),
(268, 271, '202604034', 'NISPUDIN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-10', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:53', '2026-11-01 20:38:53'),
(269, 272, '202604035', 'RATNA PRASTIWI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:53', '2026-11-01 20:38:53'),
(270, 273, '202604036', 'RIFQI HIDAYAT', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-15', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:54', '2026-11-01 20:38:54'),
(271, 274, '202604037', 'ROHMAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:54', '2026-11-01 20:38:54'),
(272, 275, '202604038', 'SABRI FAHADI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-02', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:54', '2026-11-01 20:38:54'),
(273, 276, '202604039', 'SAEPUL ANWAR', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-09', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:55', '2026-11-01 20:38:55'),
(274, 277, '202604040', 'SALSA ALVIANA ZAHRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:55', '2026-11-01 20:38:55'),
(275, 278, '202604041', 'SEPTIA NUR ISTIQOMAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:55', '2026-11-01 20:38:55'),
(276, 279, '202604042', 'SILVIA QURROTUL AINNI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:56', '2026-11-01 20:38:56'),
(277, 280, '202604043', 'SIR ROLLAN', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:56', '2026-11-01 20:38:56'),
(278, 281, '202604044', 'SITI NUR AULIA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:56', '2026-11-01 20:38:56'),
(279, 282, '202604045', 'TAUFIK HIDAYAT', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:57', '2026-11-01 20:38:57'),
(280, 283, '202604046', 'TITIN NURAINI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-13', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:57', '2026-11-01 20:38:57'),
(281, 284, '202604047', 'VERAWATI', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-27', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:57', '2026-11-01 20:38:57'),
(282, 285, '202604048', 'WANAH', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-27', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:58', '2026-11-01 20:38:58'),
(283, 286, '202604049', 'YAYIN INTYAS', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-17', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:58', '2026-11-01 20:38:58'),
(284, 287, '202604050', 'YOFRI MAHALIGA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-04-10', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:59', '2026-11-01 20:38:59'),
(285, 288, '202605001', 'MIFTAQUL AZIL SAPUTRA', '-', '2026-11-02', 'L', NULL, NULL, '-', '-', '2026-05-04', NULL, NULL, 0.00, NULL, '2026-11-01 20:38:59', '2026-11-01 20:38:59'),
(286, 289, '202610001', 'Adhika Eka Putta', '-', '2026-11-02', 'L', NULL, NULL, 'HR', 'PIC', '2026-10-07', NULL, NULL, 0.00, NULL, '2026-11-01 20:45:45', '2026-11-01 20:45:45'),
(287, 292, '202607001', 'RIAMA RAJA GUK GUK', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-07-03', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:08', '2026-11-04 02:02:08'),
(288, 293, '202608001', 'WANIH', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-08-19', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:09', '2026-11-04 02:02:09'),
(289, 294, '202608002', 'REHAN HAMDI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-08-11', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:09', '2026-11-04 02:02:09'),
(290, 295, '202608003', 'PRIMO DARMOWIBOWO', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-08-11', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:10', '2026-11-04 02:02:10'),
(291, 296, '202608004', 'MUTIARA SHABRYNA IK', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-08-06', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:10', '2026-11-04 02:02:10'),
(292, 297, '202609001', 'ISTINGANAH', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-02', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:10', '2026-11-04 02:02:10'),
(293, 298, '202609002', 'SITI FARIDA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-03', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:11', '2026-11-04 02:02:11'),
(294, 299, '202609003', 'LOLA SOVIAH', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-05', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:11', '2026-11-04 02:02:11'),
(295, 300, '202609004', 'SALMAH', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-10', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:11', '2026-11-04 02:02:11'),
(296, 301, '202609005', 'UNIH', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-09', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:12', '2026-11-04 02:02:12'),
(297, 302, '202609006', 'DESI SUSILOWATI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-10', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:12', '2026-11-04 02:02:12'),
(298, 303, '202609007', 'RISMA INDRIYANI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-11', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:12', '2026-11-04 02:02:12'),
(299, 304, '202609008', 'ROMI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-14', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:13', '2026-11-04 02:02:13'),
(300, 305, '202609009', 'SRI YANAH', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-15', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:13', '2026-11-04 02:02:13');
INSERT INTO `employees` (`id`, `user_id`, `employee_code`, `full_name`, `birth_place`, `birth_date`, `gender`, `phone_number`, `address`, `department`, `position`, `join_date`, `start_time`, `end_time`, `basic_salary`, `photo_path`, `created_at`, `updated_at`) VALUES
(301, 306, '202609010', 'NAZLA MUTIARA A L', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-18', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:14', '2026-11-04 02:02:14'),
(302, 307, '202609011', 'YUSUF MAULANA M', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:15', '2026-11-04 02:02:15'),
(303, 308, '202609012', 'AHMAD RIFAI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:15', '2026-11-04 02:02:15'),
(304, 309, '202609013', 'MARYADI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:16', '2026-11-04 02:02:16'),
(305, 310, '202609014', 'FAISAL AL FADILLAH', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:16', '2026-11-04 02:02:16'),
(306, 311, '202609015', 'NUR FADLI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:16', '2026-11-04 02:02:16'),
(307, 312, '202609016', 'TARASTI AYU WULANDARI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:17', '2026-11-04 02:02:17'),
(308, 313, '202609017', 'NIKMAT SELAMET SOBIRIN', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:17', '2026-11-04 02:02:17'),
(309, 314, '202609018', 'ROSITA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:17', '2026-11-04 02:02:17'),
(310, 315, '202609019', 'JELITA CINTA FAJARWATI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-21', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:18', '2026-11-04 02:02:18'),
(311, 316, '202609020', 'RASWII WULANDARI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-25', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:18', '2026-11-04 02:02:18'),
(312, 317, '202609021', 'KIDZANIA SALSABILA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-09-25', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:19', '2026-11-04 02:02:19'),
(313, 318, '202610002', 'LIYA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-02', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:19', '2026-11-04 02:02:19'),
(314, 319, '202610003', 'NUNUNG', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-04', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:19', '2026-11-04 02:02:19'),
(315, 320, '202610004', 'SINDI TESILA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-12', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:20', '2026-11-04 02:02:20'),
(316, 321, '202610005', 'NOVA ISMAYA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-16', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:20', '2026-11-04 02:02:20'),
(317, 322, '202610006', 'ALI NURDIN', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-20', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:21', '2026-11-04 02:02:21'),
(318, 323, '202610007', 'ANJASMARA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-20', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:21', '2026-11-04 02:02:21'),
(319, 324, '202610008', 'WINI WIDIARTI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-20', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:21', '2026-11-04 02:02:21'),
(320, 325, '202610009', 'M RIZKI SAPUTRA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-22', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:22', '2026-11-04 02:02:22'),
(321, 326, '202610010', 'MARIA ULFA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-22', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:22', '2026-11-04 02:02:22'),
(322, 327, '202610011', 'HALIMAH', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-22', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:22', '2026-11-04 02:02:22'),
(323, 328, '202610012', 'HARUM BUNGA ALVIYANTY', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-22', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:23', '2026-11-04 02:02:23'),
(324, 329, '202610013', 'ADHIKKA EKA PUTTA', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-08', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:23', '2026-11-04 02:02:23'),
(325, 330, '202610014', 'DARMI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-26', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:23', '2026-11-04 02:02:23'),
(326, 331, '202610015', 'HERLINA BUDIARTI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-27', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:24', '2026-11-04 02:02:24'),
(327, 332, '202610016', 'KARNI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-26', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:24', '2026-11-04 02:02:24'),
(328, 333, '202610017', 'WAHYU RESTIANINGRUM', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-10-26', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:25', '2026-11-04 02:02:25'),
(329, 334, '202610018', 'EKA PUTRI OKTAVIANI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-11-03', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:25', '2026-11-04 02:02:25'),
(330, 335, '202610019', 'WINDA HERLINA PUTRI', '-', '2026-11-04', 'L', NULL, NULL, '-', 'Staff', '2026-11-03', NULL, NULL, 0.00, NULL, '2026-11-04 02:02:25', '2026-11-04 02:02:25');

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `finger_logs`
--

CREATE TABLE `finger_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `pin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scan_time` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `finger_logs`
--

INSERT INTO `finger_logs` (`id`, `pin`, `scan_time`, `created_at`, `updated_at`) VALUES
(1, '202610013', '2026-10-27 07:00:09', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(2, '10129', '2026-10-27 07:00:15', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(3, '10016', '2026-10-27 07:00:45', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(4, '10030', '2026-10-27 07:00:56', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(5, '10157', '2026-10-27 07:02:09', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(6, '202609021', '2026-10-27 07:02:15', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(7, '202609027', '2026-10-27 07:02:24', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(8, '10453', '2026-10-27 07:03:14', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(9, '10146', '2026-10-27 07:03:31', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(10, '10035', '2026-10-27 07:03:48', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(11, '10020', '2026-10-27 07:03:55', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(12, '10211', '2026-10-27 07:04:09', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(13, '10315', '2026-10-27 07:04:15', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(14, '10021', '2026-10-27 07:04:40', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(15, '10209', '2026-10-27 07:04:45', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(16, '10452', '2026-10-27 07:05:12', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(17, '10008', '2026-10-27 07:05:19', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(18, '10162', '2026-10-27 07:05:32', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(19, '10056', '2026-10-27 07:05:45', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(20, '10273', '2026-10-27 07:05:52', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(21, '10492', '2026-10-27 07:06:02', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(22, '10027', '2026-10-27 07:06:56', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(23, '10244', '2026-10-27 07:07:01', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(24, '10003', '2026-10-27 07:07:17', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(25, '10252', '2026-10-27 07:07:26', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(26, '10028', '2026-10-27 07:07:33', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(27, '10002', '2026-10-27 07:08:59', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(28, '10493', '2026-10-27 07:09:51', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(29, '10250', '2026-10-27 07:09:57', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(30, '100323', '2026-10-27 07:10:01', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(31, '10225', '2026-10-27 07:10:12', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(32, '10135', '2026-10-27 07:10:22', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(33, '10263', '2026-10-27 07:10:27', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(34, '10213', '2026-10-27 07:10:40', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(35, '10118', '2026-10-27 07:10:50', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(36, '10173', '2026-10-27 07:10:57', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(37, '10026', '2026-10-27 07:11:00', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(38, '202609013', '2026-10-27 07:11:12', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(39, '10010', '2026-10-27 07:11:26', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(40, '202609026', '2026-10-27 07:11:33', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(41, '10023', '2026-10-27 07:11:37', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(42, '202609014', '2026-10-27 07:11:49', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(43, '202609020', '2026-10-27 07:11:51', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(44, '202609012', '2026-10-27 07:11:54', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(45, '202609019', '2026-10-27 07:11:56', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(46, '202609018', '2026-10-27 07:11:58', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(47, '10005', '2026-10-27 07:12:02', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(48, '10459', '2026-10-27 07:12:37', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(49, '100237', '2026-10-27 07:12:52', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(50, '10232', '2026-10-27 07:12:58', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(51, '10215', '2026-10-27 07:13:00', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(52, '10013', '2026-10-27 07:13:19', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(53, '10276', '2026-10-27 07:13:29', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(54, '10259', '2026-10-27 07:13:33', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(55, '10001', '2026-10-27 07:13:43', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(56, '10036', '2026-10-27 07:13:49', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(57, '10138', '2026-10-27 07:14:00', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(58, '10014', '2026-10-27 07:14:12', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(59, '10267', '2026-10-27 07:14:18', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(60, '10011', '2026-10-27 07:14:21', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(61, '10029', '2026-10-27 07:14:23', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(62, '10256', '2026-10-27 07:14:27', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(63, '10254', '2026-10-27 07:14:35', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(64, '10224', '2026-10-27 07:14:49', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(65, '100348', '2026-10-27 07:14:53', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(66, '10012', '2026-10-27 07:15:19', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(67, '10117', '2026-10-27 07:15:51', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(68, '10128', '2026-10-27 07:15:57', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(69, '10255', '2026-10-27 07:16:01', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(70, '10038', '2026-10-27 07:16:24', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(71, '10108', '2026-10-27 07:16:26', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(72, '10486', '2026-10-27 07:16:30', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(73, '10042', '2026-10-27 07:17:32', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(74, '10006', '2026-10-27 07:17:35', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(75, '10019', '2026-10-27 07:17:44', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(76, '10004', '2026-10-27 07:20:38', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(77, '10054', '2026-10-27 07:23:16', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(78, '10052', '2026-10-27 07:23:19', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(79, '10018', '2026-10-27 07:24:15', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(80, '10046', '2026-10-27 07:36:38', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(81, '10101', '2026-10-27 07:41:39', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(82, '202610003', '2026-10-27 07:45:13', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(83, '10024', '2026-10-27 07:56:00', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(84, '10133', '2026-10-27 08:02:51', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(85, '10488', '2026-10-27 08:03:25', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(86, '200608001', '2026-10-27 08:03:29', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(87, '10495', '2026-10-27 08:03:32', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(88, '10494', '2026-10-27 08:07:43', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(89, '202510001', '2026-10-27 08:10:30', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(90, '10485', '2026-10-27 08:18:18', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(91, '10285', '2026-10-27 08:30:42', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(92, '10125', '2026-10-27 08:31:54', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(93, '10126', '2026-10-27 08:32:34', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(94, '10044', '2026-10-27 08:42:51', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(95, '10047', '2026-10-27 09:00:27', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(96, '202610010', '2026-10-27 12:59:28', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(97, '10024', '2026-10-27 13:00:01', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(98, '202610016', '2026-10-27 13:00:50', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(99, '202610009', '2026-10-27 13:01:32', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(100, '202610012', '2026-10-27 13:02:16', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(101, '202610015', '2026-10-27 13:03:06', '2026-10-27 01:37:24', '2026-10-27 01:37:24'),
(102, '10270', '2026-10-27 16:16:25', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(103, '10056', '2026-10-27 16:16:31', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(104, '10035', '2026-10-27 16:16:37', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(105, '10119', '2026-10-27 16:16:43', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(106, '10013', '2026-10-27 16:16:45', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(107, '10002', '2026-10-27 16:16:47', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(108, '202609026', '2026-10-27 16:16:49', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(109, '10027', '2026-10-27 16:16:55', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(110, '10113', '2026-10-27 16:16:57', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(111, '30102', '2026-10-27 16:16:59', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(112, '10213', '2026-10-27 16:17:02', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(113, '10244', '2026-10-27 16:17:04', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(114, '10036', '2026-10-27 16:17:07', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(115, '10486', '2026-10-27 16:17:09', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(116, '10493', '2026-10-27 16:17:11', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(117, '10492', '2026-10-27 16:17:13', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(118, '10256', '2026-10-27 16:17:16', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(119, '10129', '2026-10-27 16:17:21', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(120, '100231', '2026-10-27 16:17:23', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(121, '10005', '2026-10-27 16:17:25', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(122, '202609019', '2026-10-27 16:17:28', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(123, '202609012', '2026-10-27 16:17:30', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(124, '202609020', '2026-10-27 16:17:32', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(125, '10010', '2026-10-27 16:17:34', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(126, '10252', '2026-10-27 16:17:37', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(127, '10271', '2026-10-27 16:17:39', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(128, '202609018', '2026-10-27 16:17:41', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(129, '10250', '2026-10-27 16:17:44', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(130, '10018', '2026-10-27 16:17:47', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(131, '202609021', '2026-10-27 16:17:49', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(132, '10276', '2026-10-27 16:17:51', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(133, '10003', '2026-10-27 16:17:55', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(134, '10225', '2026-10-27 16:17:57', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(135, '10452', '2026-10-27 16:18:02', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(136, '10453', '2026-10-27 16:18:04', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(137, '10118', '2026-10-27 16:18:07', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(138, '10012', '2026-10-27 16:18:13', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(139, '100233', '2026-10-27 16:18:17', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(140, '10052', '2026-10-27 16:18:19', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(141, '202609013', '2026-10-27 16:18:22', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(142, '202609011', '2026-10-27 16:18:25', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(143, '10016', '2026-10-27 16:18:30', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(144, '10021', '2026-10-27 16:18:47', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(145, '10020', '2026-10-27 16:18:54', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(146, '10004', '2026-10-27 16:18:57', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(147, '10042', '2026-10-27 16:19:04', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(148, '10026', '2026-10-27 16:19:08', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(149, '10023', '2026-10-27 16:19:14', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(150, '10259', '2026-10-27 16:19:19', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(151, '10135', '2026-10-27 16:19:25', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(152, '10263', '2026-10-27 16:19:29', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(153, '10273', '2026-10-27 16:19:32', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(154, '10117', '2026-10-27 16:19:35', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(155, '10029', '2026-10-27 16:19:37', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(156, '10224', '2026-10-27 16:19:39', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(157, '202609027', '2026-10-27 16:19:55', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(158, '10254', '2026-10-27 16:19:57', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(159, '10108', '2026-10-27 16:20:00', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(160, '202609030', '2026-10-27 16:20:02', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(161, '10128', '2026-10-27 16:20:09', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(162, '10267', '2026-10-27 16:20:15', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(163, '10038', '2026-10-27 16:20:17', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(164, '100348', '2026-10-27 16:20:20', '2026-10-27 02:21:17', '2026-10-27 02:21:17'),
(165, '10008', '2026-10-27 16:20:24', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(166, '10138', '2026-10-27 16:20:27', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(167, '100323', '2026-10-27 16:20:30', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(168, '202507001', '2026-10-27 16:21:33', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(169, '202609016', '2026-10-27 16:21:40', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(170, '10054', '2026-10-27 16:21:49', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(171, '10014', '2026-10-27 16:21:53', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(172, '10006', '2026-10-27 16:22:01', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(173, '100237', '2026-10-27 16:22:04', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(174, '10242', '2026-10-27 16:22:11', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(175, '10019', '2026-10-27 16:22:14', '2026-10-27 02:21:18', '2026-10-27 02:21:18'),
(176, '20855', '2026-10-27 07:01:10', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(177, '19239', '2026-10-27 07:03:29', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(178, '19354', '2026-10-27 07:04:00', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(179, '19266', '2026-10-27 07:04:37', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(180, '19453', '2026-10-27 07:04:45', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(181, '21233', '2026-10-27 07:05:37', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(182, '19342', '2026-10-27 07:05:44', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(183, '20753', '2026-10-27 07:05:49', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(184, '21538', '2026-10-27 07:05:55', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(185, '202405038', '2026-10-27 07:06:34', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(186, '19433', '2026-10-27 07:06:40', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(187, '19314', '2026-10-27 07:06:46', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(188, '18035', '2026-10-27 07:06:52', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(189, '21310', '2026-10-27 07:07:25', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(190, '19769', '2026-10-27 07:08:08', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(191, '19244', '2026-10-27 07:09:06', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(192, '20957', '2026-10-27 07:09:14', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(193, '20981', '2026-10-27 07:09:18', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(194, '19077', '2026-10-27 07:09:55', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(195, '20412', '2026-10-27 07:10:05', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(196, '21545', '2026-10-27 07:10:09', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(197, '19477', '2026-10-27 07:10:34', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(198, '19079', '2026-10-27 07:10:43', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(199, '21008', '2026-10-27 07:11:16', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(200, '21332', '2026-10-27 07:11:53', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(201, '19232', '2026-10-27 07:11:59', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(202, '20018', '2026-10-27 07:12:02', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(203, '21400', '2026-10-27 07:12:13', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(204, '21153', '2026-10-27 07:12:27', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(205, '19080', '2026-10-27 07:12:44', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(206, '20947', '2026-10-27 07:12:51', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(207, '21216', '2026-10-27 07:13:48', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(208, '19768', '2026-10-27 07:14:12', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(209, '20208', '2026-10-27 07:14:17', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(210, '19662', '2026-10-27 07:14:37', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(211, '19736', '2026-10-27 07:14:39', '2026-10-27 02:21:35', '2026-10-27 02:21:35'),
(212, '20951', '2026-10-27 07:14:48', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(213, '20965', '2026-10-27 07:14:54', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(214, '20601', '2026-10-27 07:14:57', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(215, '21542', '2026-10-27 07:15:01', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(216, '20954', '2026-10-27 07:15:18', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(217, '19298', '2026-10-27 07:15:32', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(218, '19278', '2026-10-27 07:15:39', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(219, '20335', '2026-10-27 07:16:38', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(220, '21330', '2026-10-27 07:17:55', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(221, '19477', '2026-10-27 16:15:56', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(222, '20018', '2026-10-27 16:15:59', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(223, '19769', '2026-10-27 16:16:12', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(224, '20416', '2026-10-27 16:16:19', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(225, '20954', '2026-10-27 16:16:22', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(226, '20274', '2026-10-27 16:16:25', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(227, '20957', '2026-10-27 16:16:32', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(228, '19768', '2026-10-27 16:16:39', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(229, '19767', '2026-10-27 16:16:46', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(230, '21330', '2026-10-27 16:16:51', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(231, '20947', '2026-10-27 16:17:00', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(232, '19244', '2026-10-27 16:17:03', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(233, '21545', '2026-10-27 16:17:06', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(234, '202405038', '2026-10-27 16:17:08', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(235, '21392', '2026-10-27 16:17:11', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(236, '19312', '2026-10-27 16:17:20', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(237, '20981', '2026-10-27 16:17:24', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(238, '21542', '2026-10-27 16:17:29', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(239, '21332', '2026-10-27 16:17:32', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(240, '19242', '2026-10-27 16:17:35', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(241, '20951', '2026-10-27 16:17:41', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(242, '21400', '2026-10-27 16:17:46', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(243, '20965', '2026-10-27 16:17:50', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(244, '20533', '2026-10-27 16:17:53', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(245, '21153', '2026-10-27 16:17:56', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(246, '19239', '2026-10-27 16:18:00', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(247, '19079', '2026-10-27 16:18:23', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(248, '19426', '2026-10-27 16:18:28', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(249, '20855', '2026-10-27 16:18:35', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(250, '19764', '2026-10-27 16:18:42', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(251, '21538', '2026-10-27 16:18:45', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(252, '20412', '2026-10-27 16:18:50', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(253, '18035', '2026-10-27 16:18:52', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(254, '20218', '2026-10-27 16:19:00', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(255, '19286', '2026-10-27 16:19:08', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(256, '19077', '2026-10-27 16:19:13', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(257, '20601', '2026-10-27 16:19:17', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(258, '19433', '2026-10-27 16:19:24', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(259, '19457', '2026-10-27 16:19:28', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(260, '19453', '2026-10-27 16:19:31', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(261, '19314', '2026-10-27 16:20:30', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(262, '19662', '2026-10-27 16:22:04', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(263, '19736', '2026-10-27 16:22:46', '2026-10-27 02:21:36', '2026-10-27 02:21:36'),
(264, '10111', '2026-10-27 16:23:55', '2026-10-27 02:23:32', '2026-10-27 02:23:32'),
(265, '202411001', '2026-10-27 16:24:14', '2026-10-27 02:23:32', '2026-10-27 02:23:32'),
(266, '19266', '2026-10-27 16:25:16', '2026-10-27 02:23:48', '2026-10-27 02:23:48'),
(267, '10497', '2026-10-28 07:00:00', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(268, '202609011', '2026-10-28 07:00:17', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(269, '202610013', '2026-10-28 07:00:30', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(270, '10165', '2026-10-28 07:01:21', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(271, '10162', '2026-10-28 07:01:44', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(272, '10246', '2026-10-28 07:01:51', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(273, '10244', '2026-10-28 07:02:16', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(274, '10008', '2026-10-28 07:02:31', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(275, '10453', '2026-10-28 07:02:58', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(276, '10020', '2026-10-28 07:03:09', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(277, '10021', '2026-10-28 07:03:51', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(278, '10492', '2026-10-28 07:03:53', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(279, '10452', '2026-10-28 07:04:09', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(280, '10211', '2026-10-28 07:04:16', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(281, '10207', '2026-10-28 07:04:24', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(282, '10252', '2026-10-28 07:04:37', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(283, '10146', '2026-10-28 07:04:48', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(284, '202609027', '2026-10-28 07:05:34', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(285, '10056', '2026-10-28 07:06:10', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(286, '10273', '2026-10-28 07:06:41', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(287, '10315', '2026-10-28 07:06:49', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(288, '10003', '2026-10-28 07:07:05', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(289, '202609026', '2026-10-28 07:07:40', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(290, '10010', '2026-10-28 07:07:43', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(291, '10250', '2026-10-28 07:07:48', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(292, '10028', '2026-10-28 07:08:18', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(293, '10002', '2026-10-28 07:08:31', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(294, '10016', '2026-10-28 07:08:39', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(295, '10118', '2026-10-28 07:09:10', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(296, '10225', '2026-10-28 07:09:52', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(297, '10173', '2026-10-28 07:10:10', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(298, '10493', '2026-10-28 07:10:48', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(299, '100323', '2026-10-28 07:10:50', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(300, '10263', '2026-10-28 07:11:28', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(301, '10135', '2026-10-28 07:11:34', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(302, '202609013', '2026-10-28 07:11:46', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(303, '202609020', '2026-10-28 07:11:48', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(304, '10026', '2026-10-28 07:11:51', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(305, '10213', '2026-10-28 07:11:58', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(306, '10005', '2026-10-28 07:12:13', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(307, '10459', '2026-10-28 07:12:30', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(308, '10215', '2026-10-28 07:12:35', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(309, '100348', '2026-10-28 07:12:42', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(310, '202609014', '2026-10-28 07:12:48', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(311, '202609012', '2026-10-28 07:12:51', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(312, '202609019', '2026-10-28 07:12:54', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(313, '202609018', '2026-10-28 07:12:57', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(314, '10276', '2026-10-28 07:12:59', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(315, '100231', '2026-10-28 07:13:05', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(316, '10036', '2026-10-28 07:13:10', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(317, '10487', '2026-10-28 07:13:13', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(318, '10267', '2026-10-28 07:13:17', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(319, '10259', '2026-10-28 07:13:20', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(320, '10014', '2026-10-28 07:13:24', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(321, '10232', '2026-10-28 07:13:30', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(322, '10013', '2026-10-28 07:13:36', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(323, '10029', '2026-10-28 07:13:43', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(324, '10138', '2026-10-28 07:13:47', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(325, '10038', '2026-10-28 07:13:50', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(326, '10012', '2026-10-28 07:14:15', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(327, '10256', '2026-10-28 07:14:39', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(328, '10254', '2026-10-28 07:14:42', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(329, '10128', '2026-10-28 07:15:01', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(330, '10486', '2026-10-28 07:15:15', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(331, '10255', '2026-10-28 07:15:19', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(332, '10117', '2026-10-28 07:15:23', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(333, '10224', '2026-10-28 07:15:28', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(334, '10011', '2026-10-28 07:15:54', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(335, '10023', '2026-10-28 07:16:20', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(336, '10035', '2026-10-28 07:16:31', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(337, '100237', '2026-10-28 07:16:34', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(338, '10004', '2026-10-28 07:16:44', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(339, '10108', '2026-10-28 07:17:14', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(340, '10052', '2026-10-28 07:20:32', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(341, '10054', '2026-10-28 07:24:15', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(342, '10030', '2026-10-28 07:25:05', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(343, '10046', '2026-10-28 07:35:06', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(344, '10101', '2026-10-28 07:38:03', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(345, '10024', '2026-10-28 07:38:08', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(346, '202610003', '2026-10-28 07:56:06', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(347, '202507001', '2026-10-28 07:56:34', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(348, '10495', '2026-10-28 08:01:13', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(349, '10488', '2026-10-28 08:04:58', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(350, '200608001', '2026-10-28 08:06:54', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(351, '202510001', '2026-10-28 08:13:59', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(352, '10133', '2026-10-28 08:16:03', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(353, '10018', '2026-10-28 08:22:58', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(354, '202411001', '2026-10-28 08:23:01', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(355, '10485', '2026-10-28 08:27:34', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(356, '10044', '2026-10-28 08:39:44', '2026-10-27 18:45:37', '2026-10-27 18:45:37'),
(357, '19239', '2026-10-28 07:00:15', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(358, '19354', '2026-10-28 07:03:18', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(359, '20218', '2026-10-28 07:03:52', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(360, '21233', '2026-10-28 07:05:15', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(361, '20981', '2026-10-28 07:05:28', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(362, '20855', '2026-10-28 07:05:42', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(363, '21310', '2026-10-28 07:06:02', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(364, '19314', '2026-10-28 07:06:11', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(365, '202405038', '2026-10-28 07:06:38', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(366, '20957', '2026-10-28 07:07:07', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(367, '20753', '2026-10-28 07:07:36', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(368, '21538', '2026-10-28 07:07:43', '2026-10-27 18:46:00', '2026-10-27 18:46:00'),
(369, '18035', '2026-10-28 07:07:47', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(370, '19079', '2026-10-28 07:09:30', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(371, '19077', '2026-10-28 07:10:19', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(372, '19244', '2026-10-28 07:10:41', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(373, '19342', '2026-10-28 07:11:45', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(374, '21008', '2026-10-28 07:11:51', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(375, '21545', '2026-10-28 07:11:54', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(376, '19298', '2026-10-28 07:11:58', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(377, '19232', '2026-10-28 07:12:03', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(378, '19769', '2026-10-28 07:12:38', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(379, '20951', '2026-10-28 07:12:47', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(380, '20947', '2026-10-28 07:12:51', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(381, '20208', '2026-10-28 07:13:47', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(382, '19278', '2026-10-28 07:14:32', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(383, '21332', '2026-10-28 07:14:38', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(384, '21216', '2026-10-28 07:14:41', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(385, '21153', '2026-10-28 07:14:56', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(386, '20965', '2026-10-28 07:15:01', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(387, '21330', '2026-10-28 07:15:10', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(388, '21400', '2026-10-28 07:15:13', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(389, '19477', '2026-10-28 07:15:17', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(390, '19768', '2026-10-28 07:15:30', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(391, '19453', '2026-10-28 07:15:32', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(392, '19662', '2026-10-28 07:16:19', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(393, '19736', '2026-10-28 07:16:22', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(394, '19080', '2026-10-28 07:16:28', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(395, '21542', '2026-10-28 07:16:31', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(396, '20601', '2026-10-28 07:16:37', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(397, '20412', '2026-10-28 07:16:41', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(398, '20335', '2026-10-28 07:19:29', '2026-10-27 18:46:01', '2026-10-27 18:46:01'),
(399, '20218', '2026-10-29 07:00:45', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(400, '19239', '2026-10-29 07:01:09', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(401, '19266', '2026-10-29 07:03:38', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(402, '20416', '2026-10-29 07:03:56', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(403, '20855', '2026-10-29 07:04:41', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(404, '20981', '2026-10-29 07:04:50', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(405, '21233', '2026-10-29 07:05:04', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(406, '20533', '2026-10-29 07:05:12', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(407, '202405038', '2026-10-29 07:05:24', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(408, '20957', '2026-10-29 07:06:03', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(409, '19314', '2026-10-29 07:06:33', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(410, '19354', '2026-10-29 07:06:54', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(411, '21330', '2026-10-29 07:07:30', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(412, '21545', '2026-10-29 07:07:37', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(413, '20753', '2026-10-29 07:07:45', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(414, '21538', '2026-10-29 07:07:51', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(415, '19433', '2026-10-29 07:08:35', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(416, '21332', '2026-10-29 07:09:27', '2026-10-29 01:36:57', '2026-10-29 01:36:57'),
(417, '19232', '2026-10-29 07:11:07', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(418, '19769', '2026-10-29 07:11:34', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(419, '19342', '2026-10-29 07:12:12', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(420, '20951', '2026-10-29 07:12:21', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(421, '21310', '2026-10-29 07:12:26', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(422, '19079', '2026-10-29 07:12:35', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(423, '18035', '2026-10-29 07:12:40', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(424, '21400', '2026-10-29 07:13:10', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(425, '21008', '2026-10-29 07:13:26', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(426, '19244', '2026-10-29 07:13:35', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(427, '20947', '2026-10-29 07:13:39', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(428, '19298', '2026-10-29 07:13:42', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(429, '19768', '2026-10-29 07:13:51', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(430, '19477', '2026-10-29 07:13:59', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(431, '21153', '2026-10-29 07:14:03', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(432, '19077', '2026-10-29 07:14:11', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(433, '20208', '2026-10-29 07:14:23', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(434, '19662', '2026-10-29 07:14:28', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(435, '19736', '2026-10-29 07:14:31', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(436, '20412', '2026-10-29 07:14:37', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(437, '20954', '2026-10-29 07:14:43', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(438, '20601', '2026-10-29 07:14:47', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(439, '20018', '2026-10-29 07:14:50', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(440, '21216', '2026-10-29 07:15:18', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(441, '19453', '2026-10-29 07:15:25', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(442, '20335', '2026-10-29 07:17:45', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(443, '19080', '2026-10-29 07:19:31', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(444, '21542', '2026-10-29 07:19:57', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(445, '19278', '2026-10-29 08:10:57', '2026-10-29 01:36:58', '2026-10-29 01:36:58'),
(446, '10028', '2026-10-27 16:26:31', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(447, '10101', '2026-10-27 16:36:45', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(448, '10126', '2026-10-27 16:53:40', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(449, '10495', '2026-10-27 16:59:56', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(450, '200608001', '2026-10-27 16:59:58', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(451, '10133', '2026-10-27 17:00:08', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(452, '10485', '2026-10-27 17:00:16', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(453, '10024', '2026-10-27 17:00:26', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(454, '10488', '2026-10-27 17:00:53', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(455, '202510001', '2026-10-27 17:00:58', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(456, '10046', '2026-10-27 17:01:42', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(457, '10125', '2026-10-27 17:06:53', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(458, '202411001', '2026-10-27 17:19:47', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(459, '202507001', '2026-10-27 17:19:59', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(460, '202610003', '2026-10-27 17:20:03', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(461, '10044', '2026-10-27 17:22:09', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(462, '10057', '2026-10-27 17:54:27', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(463, '10075', '2026-10-27 17:59:51', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(464, '10011', '2026-10-27 17:59:56', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(465, '202610006', '2026-10-27 17:59:59', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(466, '10215', '2026-10-27 18:00:02', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(467, '202610007', '2026-10-27 18:00:04', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(468, '202610009', '2026-10-27 18:00:10', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(469, '10162', '2026-10-27 18:00:12', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(470, '10459', '2026-10-27 18:00:15', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(471, '10072', '2026-10-27 18:00:18', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(472, '10177', '2026-10-27 18:00:22', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(473, '10143', '2026-10-27 18:00:27', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(474, '202609003', '2026-10-27 18:00:29', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(475, '202609002', '2026-10-27 18:00:34', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(476, '10190', '2026-10-27 18:00:36', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(477, '202610008', '2026-10-27 18:00:41', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(478, '10001', '2026-10-27 18:00:44', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(479, '10066', '2026-10-27 18:00:46', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(480, '10178', '2026-10-27 18:00:53', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(481, '202608004', '2026-10-27 18:00:55', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(482, '10246', '2026-10-27 18:00:58', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(483, '202610013', '2026-10-27 18:01:00', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(484, '202610004', '2026-10-27 18:01:03', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(485, '202610010', '2026-10-27 18:01:06', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(486, '10030', '2026-10-27 18:01:09', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(487, '202609001', '2026-10-27 18:01:11', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(488, '10315', '2026-10-27 18:01:14', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(489, '202609008', '2026-10-27 18:01:16', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(490, '10144', '2026-10-27 18:01:18', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(491, '202609007', '2026-10-27 18:01:20', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(492, '103333', '2026-10-27 18:01:23', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(493, '10073', '2026-10-27 18:01:27', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(494, '202608003', '2026-10-27 18:01:33', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(495, '10097', '2026-10-27 18:01:35', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(496, '10086', '2026-10-27 18:01:47', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(497, '10211', '2026-10-27 18:01:50', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(498, '2026090010', '2026-10-27 18:01:52', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(499, '10082', '2026-10-27 18:01:54', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(500, '10207', '2026-10-27 18:01:56', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(501, '10165', '2026-10-27 18:02:04', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(502, '10188', '2026-10-27 18:02:07', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(503, '202610011', '2026-10-27 18:02:12', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(504, '10061', '2026-10-27 18:02:18', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(505, '202609009', '2026-10-27 18:02:20', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(506, '202610002', '2026-10-27 18:02:23', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(507, '10091', '2026-10-27 18:02:26', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(508, '10497', '2026-10-27 18:02:28', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(509, '10079', '2026-10-27 18:02:30', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(510, '202610015', '2026-10-27 18:02:33', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(511, '10491', '2026-10-27 18:02:35', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(512, '202610001', '2026-10-27 18:02:38', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(513, '202610012', '2026-10-27 18:02:41', '2026-10-29 01:39:08', '2026-10-29 01:39:08'),
(514, '10105', '2026-10-27 18:02:44', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(515, '10069', '2026-10-27 18:02:47', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(516, '202609005', '2026-10-27 18:02:49', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(517, '202609006', '2026-10-27 18:02:52', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(518, '202610016', '2026-10-27 18:02:57', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(519, '10093', '2026-10-27 18:03:06', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(520, '10090', '2026-10-27 18:03:09', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(521, '10154', '2026-10-27 18:03:11', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(522, '10017', '2026-10-27 18:03:15', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(523, '10255', '2026-10-27 18:03:19', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(524, '10092', '2026-10-27 18:03:23', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(525, '10084', '2026-10-27 18:03:28', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(526, '10146', '2026-10-27 18:03:30', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(527, '202608010', '2026-10-27 18:03:45', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(528, '10068', '2026-10-27 18:03:48', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(529, '10490', '2026-10-27 18:03:52', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(530, '10157', '2026-10-27 18:04:05', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(531, '10209', '2026-10-27 18:04:07', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(532, '10173', '2026-10-27 18:04:17', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(533, '10047', '2026-10-27 18:05:16', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(534, '10057', '2026-10-28 05:51:33', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(535, '202609002', '2026-10-28 06:03:41', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(536, '10069', '2026-10-28 06:04:23', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(537, '10490', '2026-10-28 06:04:43', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(538, '10075', '2026-10-28 06:15:53', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(539, '10084', '2026-10-28 06:19:13', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(540, '10177', '2026-10-28 06:20:37', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(541, '202609008', '2026-10-28 06:24:02', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(542, '202610001', '2026-10-28 06:28:00', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(543, '202610006', '2026-10-28 06:29:55', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(544, '202609005', '2026-10-28 06:31:07', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(545, '10178', '2026-10-28 06:31:33', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(546, '202610007', '2026-10-28 06:31:37', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(547, '202609007', '2026-10-28 06:32:41', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(548, '100233', '2026-10-28 06:35:01', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(549, '10086', '2026-10-28 06:35:34', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(550, '202608004', '2026-10-28 06:35:41', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(551, '202608003', '2026-10-28 06:36:37', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(552, '10113', '2026-10-28 06:38:02', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(553, '202610008', '2026-10-28 06:38:20', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(554, '10154', '2026-10-28 06:39:12', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(555, '10119', '2026-10-28 06:40:39', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(556, '10271', '2026-10-28 06:40:45', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(557, '202610015', '2026-10-28 06:41:20', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(558, '202610010', '2026-10-28 06:43:59', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(559, '10270', '2026-10-28 06:44:30', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(560, '202610012', '2026-10-28 06:44:43', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(561, '10090', '2026-10-28 06:44:59', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(562, '202610016', '2026-10-28 06:47:15', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(563, '202610009', '2026-10-28 06:47:30', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(564, '10143', '2026-10-28 06:47:43', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(565, '10144', '2026-10-28 06:47:50', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(566, '202610002', '2026-10-28 06:49:02', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(567, '10093', '2026-10-28 06:49:19', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(568, '202609016', '2026-10-28 06:49:35', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(569, '10061', '2026-10-28 06:50:04', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(570, '10188', '2026-10-28 06:50:07', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(571, '202609006', '2026-10-28 06:50:09', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(572, '202609003', '2026-10-28 06:51:16', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(573, '202608010', '2026-10-28 06:51:37', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(574, '10157', '2026-10-28 06:51:48', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(575, '10209', '2026-10-28 06:51:51', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(576, '10097', '2026-10-28 06:52:02', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(577, '10068', '2026-10-28 06:52:04', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(578, '10073', '2026-10-28 06:52:20', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(579, '10072', '2026-10-28 06:52:22', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(580, '30102', '2026-10-28 06:52:28', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(581, '202610004', '2026-10-28 06:53:49', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(582, '202610011', '2026-10-28 06:54:20', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(583, '10111', '2026-10-28 06:54:25', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(584, '103333', '2026-10-28 06:54:32', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(585, '10091', '2026-10-28 06:55:50', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(586, '202609009', '2026-10-28 06:56:21', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(587, '10491', '2026-10-28 06:57:48', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(588, '202609021', '2026-10-28 06:57:52', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(589, '10190', '2026-10-28 06:57:54', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(590, '202609001', '2026-10-28 06:57:59', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(591, '10066', '2026-10-28 06:58:03', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(592, '10105', '2026-10-28 06:58:36', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(593, '2026090010', '2026-10-28 06:58:39', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(594, '10129', '2026-10-28 06:58:47', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(595, '202609030', '2026-10-28 06:59:03', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(596, '10082', '2026-10-28 06:59:43', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(597, '10017', '2026-10-28 06:59:46', '2026-10-29 01:39:09', '2026-10-29 01:39:09');
INSERT INTO `finger_logs` (`id`, `pin`, `scan_time`, `created_at`, `updated_at`) VALUES
(598, '10079', '2026-10-28 06:59:50', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(599, '10125', '2026-10-28 08:48:27', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(600, '10047', '2026-10-28 08:54:22', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(601, '10126', '2026-10-28 09:07:19', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(602, '10028', '2026-10-28 15:02:41', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(603, '30102', '2026-10-28 16:11:05', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(604, '10119', '2026-10-28 16:15:38', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(605, '10036', '2026-10-28 16:15:41', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(606, '10270', '2026-10-28 16:15:45', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(607, '10056', '2026-10-28 16:15:50', '2026-10-29 01:39:09', '2026-10-29 01:39:09'),
(608, '10013', '2026-10-28 16:15:56', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(609, '10002', '2026-10-28 16:15:58', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(610, '202609026', '2026-10-28 16:16:00', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(611, '10035', '2026-10-28 16:16:02', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(612, '10113', '2026-10-28 16:16:05', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(613, '100231', '2026-10-28 16:16:07', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(614, '10008', '2026-10-28 16:16:10', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(615, '10250', '2026-10-28 16:16:15', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(616, '10256', '2026-10-28 16:16:17', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(617, '10003', '2026-10-28 16:16:19', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(618, '10213', '2026-10-28 16:16:22', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(619, '10129', '2026-10-28 16:16:24', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(620, '202609019', '2026-10-28 16:16:26', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(621, '10244', '2026-10-28 16:16:29', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(622, '202609020', '2026-10-28 16:16:31', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(623, '10271', '2026-10-28 16:16:33', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(624, '10026', '2026-10-28 16:16:35', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(625, '100233', '2026-10-28 16:16:37', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(626, '10252', '2026-10-28 16:16:40', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(627, '10052', '2026-10-28 16:16:42', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(628, '10012', '2026-10-28 16:16:47', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(629, '10021', '2026-10-28 16:16:49', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(630, '202609018', '2026-10-28 16:16:51', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(631, '202609021', '2026-10-28 16:16:54', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(632, '10020', '2026-10-28 16:16:57', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(633, '10023', '2026-10-28 16:16:59', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(634, '10486', '2026-10-28 16:17:02', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(635, '202609016', '2026-10-28 16:17:04', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(636, '10492', '2026-10-28 16:17:07', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(637, '10010', '2026-10-28 16:17:11', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(638, '10118', '2026-10-28 16:17:15', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(639, '10276', '2026-10-28 16:17:17', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(640, '10452', '2026-10-28 16:17:21', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(641, '10453', '2026-10-28 16:17:24', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(642, '10225', '2026-10-28 16:17:26', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(643, '10224', '2026-10-28 16:17:31', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(644, '10004', '2026-10-28 16:17:33', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(645, '10005', '2026-10-28 16:17:36', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(646, '10030', '2026-10-28 16:17:38', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(647, '10267', '2026-10-28 16:17:48', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(648, '10111', '2026-10-28 16:17:52', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(649, '10246', '2026-10-28 16:17:58', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(650, '10117', '2026-10-28 16:18:01', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(651, '202609027', '2026-10-28 16:18:03', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(652, '10254', '2026-10-28 16:18:06', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(653, '10273', '2026-10-28 16:18:08', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(654, '10315', '2026-10-28 16:18:12', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(655, '202609013', '2026-10-28 16:18:17', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(656, '202609012', '2026-10-28 16:18:20', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(657, '202609014', '2026-10-28 16:18:23', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(658, '10259', '2026-10-28 16:18:26', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(659, '10263', '2026-10-28 16:18:30', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(660, '10135', '2026-10-28 16:18:33', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(661, '100348', '2026-10-28 16:18:36', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(662, '10038', '2026-10-28 16:18:40', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(663, '10215', '2026-10-28 16:18:44', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(664, '202609030', '2026-10-28 16:18:53', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(665, '100237', '2026-10-28 16:19:01', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(666, '10029', '2026-10-28 16:19:05', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(667, '202609011', '2026-10-28 16:19:08', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(668, '10018', '2026-10-28 16:19:11', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(669, '10138', '2026-10-28 16:19:14', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(670, '100323', '2026-10-28 16:19:17', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(671, '10493', '2026-10-28 16:19:19', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(672, '10016', '2026-10-28 16:19:26', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(673, '10128', '2026-10-28 16:19:31', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(674, '10054', '2026-10-28 16:19:52', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(675, '10173', '2026-10-28 16:19:55', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(676, '10014', '2026-10-28 16:20:07', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(677, '10108', '2026-10-28 16:21:21', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(678, '10101', '2026-10-28 16:21:31', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(679, '10126', '2026-10-28 16:51:59', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(680, '10488', '2026-10-28 16:57:33', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(681, '202510001', '2026-10-28 16:57:36', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(682, '200608001', '2026-10-28 16:57:50', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(683, '10485', '2026-10-28 16:57:52', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(684, '10495', '2026-10-28 16:57:54', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(685, '10133', '2026-10-28 16:59:39', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(686, '10125', '2026-10-28 17:00:14', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(687, '10046', '2026-10-28 17:00:18', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(688, '10024', '2026-10-28 17:03:14', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(689, '202411001', '2026-10-28 17:22:58', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(690, '202507001', '2026-10-28 17:23:08', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(691, '202610003', '2026-10-28 17:23:13', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(692, '10255', '2026-10-28 18:00:47', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(693, '10459', '2026-10-28 18:00:50', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(694, '10162', '2026-10-28 18:00:52', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(695, '10066', '2026-10-28 18:00:54', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(696, '10082', '2026-10-28 18:00:58', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(697, '10178', '2026-10-28 18:01:01', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(698, '202610008', '2026-10-28 18:01:05', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(699, '202609007', '2026-10-28 18:01:08', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(700, '10177', '2026-10-28 18:01:12', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(701, '10075', '2026-10-28 18:01:20', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(702, '202609003', '2026-10-28 18:01:22', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(703, '202610006', '2026-10-28 18:01:24', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(704, '10143', '2026-10-28 18:01:27', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(705, '202610007', '2026-10-28 18:01:29', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(706, '202608004', '2026-10-28 18:01:31', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(707, '10086', '2026-10-28 18:01:34', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(708, '202610010', '2026-10-28 18:01:36', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(709, '10190', '2026-10-28 18:01:38', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(710, '103333', '2026-10-28 18:01:41', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(711, '10144', '2026-10-28 18:01:43', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(712, '10207', '2026-10-28 18:01:45', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(713, '202608003', '2026-10-28 18:01:50', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(714, '202609008', '2026-10-28 18:01:52', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(715, '10097', '2026-10-28 18:01:55', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(716, '2026090010', '2026-10-28 18:01:59', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(717, '202609001', '2026-10-28 18:02:03', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(718, '202609009', '2026-10-28 18:02:06', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(719, '10072', '2026-10-28 18:02:14', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(720, '10211', '2026-10-28 18:02:21', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(721, '10165', '2026-10-28 18:02:28', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(722, '202610009', '2026-10-28 18:02:34', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(723, '202609002', '2026-10-28 18:02:37', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(724, '10093', '2026-10-28 18:02:44', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(725, '10105', '2026-10-28 18:02:46', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(726, '10491', '2026-10-28 18:02:49', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(727, '10091', '2026-10-28 18:02:53', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(728, '10188', '2026-10-28 18:02:55', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(729, '10497', '2026-10-28 18:02:58', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(730, '10073', '2026-10-28 18:03:01', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(731, '10090', '2026-10-28 18:03:04', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(732, '202610004', '2026-10-28 18:03:07', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(733, '202610002', '2026-10-28 18:03:10', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(734, '202610011', '2026-10-28 18:03:16', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(735, '10209', '2026-10-28 18:03:18', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(736, '10069', '2026-10-28 18:03:21', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(737, '202609005', '2026-10-28 18:03:23', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(738, '10079', '2026-10-28 18:03:25', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(739, '202610012', '2026-10-28 18:03:28', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(740, '10017', '2026-10-28 18:03:30', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(741, '202610001', '2026-10-28 18:03:33', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(742, '10092', '2026-10-28 18:03:36', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(743, '202610016', '2026-10-28 18:03:40', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(744, '202610015', '2026-10-28 18:03:43', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(745, '202609006', '2026-10-28 18:03:49', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(746, '10061', '2026-10-28 18:03:56', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(747, '10154', '2026-10-28 18:03:58', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(748, '10146', '2026-10-28 18:04:00', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(749, '10068', '2026-10-28 18:04:03', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(750, '10157', '2026-10-28 18:04:05', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(751, '202608010', '2026-10-28 18:04:08', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(752, '10487', '2026-10-28 18:04:11', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(753, '10011', '2026-10-28 18:04:28', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(754, '10490', '2026-10-28 18:05:11', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(755, '10084', '2026-10-28 18:05:14', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(756, '10057', '2026-10-28 18:06:02', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(757, '10047', '2026-10-28 18:51:17', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(758, '10057', '2026-10-29 05:54:20', '2026-10-29 01:39:10', '2026-10-29 01:39:10'),
(759, '202609002', '2026-10-29 06:06:26', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(760, '10069', '2026-10-29 06:06:33', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(761, '10490', '2026-10-29 06:07:53', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(762, '10075', '2026-10-29 06:15:49', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(763, '202609008', '2026-10-29 06:19:41', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(764, '10086', '2026-10-29 06:25:17', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(765, '202610004', '2026-10-29 06:25:59', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(766, '202610006', '2026-10-29 06:27:33', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(767, '202610007', '2026-10-29 06:27:40', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(768, '202609005', '2026-10-29 06:31:15', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(769, '10084', '2026-10-29 06:31:52', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(770, '202610001', '2026-10-29 06:34:05', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(771, '10177', '2026-10-29 06:34:29', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(772, '10178', '2026-10-29 06:36:01', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(773, '202609007', '2026-10-29 06:36:05', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(774, '10090', '2026-10-29 06:38:42', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(775, '202610002', '2026-10-29 06:38:45', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(776, '10113', '2026-10-29 06:39:16', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(777, '202608004', '2026-10-29 06:41:44', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(778, '202608003', '2026-10-29 06:41:47', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(779, '10154', '2026-10-29 06:42:03', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(780, '10119', '2026-10-29 06:42:40', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(781, '10270', '2026-10-29 06:43:58', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(782, '10143', '2026-10-29 06:44:03', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(783, '10144', '2026-10-29 06:44:09', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(784, '202610010', '2026-10-29 06:44:16', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(785, '202610008', '2026-10-29 06:44:33', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(786, '100233', '2026-10-29 06:44:59', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(787, '10017', '2026-10-29 06:45:20', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(788, '10271', '2026-10-29 06:45:33', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(789, '10066', '2026-10-29 06:46:02', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(790, '103333', '2026-10-29 06:48:47', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(791, '202610016', '2026-10-29 06:50:07', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(792, '202610015', '2026-10-29 06:50:15', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(793, '10188', '2026-10-29 06:50:19', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(794, '202609006', '2026-10-29 06:50:32', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(795, '202609003', '2026-10-29 06:50:37', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(796, '202609016', '2026-10-29 06:50:49', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(797, '30102', '2026-10-29 06:50:55', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(798, '202608010', '2026-10-29 06:51:08', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(799, '10068', '2026-10-29 06:51:27', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(800, '10073', '2026-10-29 06:51:37', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(801, '10242', '2026-10-29 06:51:49', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(802, '202610012', '2026-10-29 06:52:18', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(803, '202610009', '2026-10-29 06:52:30', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(804, '10157', '2026-10-29 06:52:35', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(805, '10105', '2026-10-29 06:52:43', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(806, '2026090010', '2026-10-29 06:52:46', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(807, '10061', '2026-10-29 06:52:58', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(808, '202610011', '2026-10-29 06:53:04', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(809, '10209', '2026-10-29 06:53:54', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(810, '10072', '2026-10-29 06:54:10', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(811, '10091', '2026-10-29 06:54:34', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(812, '10097', '2026-10-29 06:55:23', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(813, '202609001', '2026-10-29 06:56:15', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(814, '202609009', '2026-10-29 06:57:11', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(815, '10497', '2026-10-29 06:57:48', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(816, '10491', '2026-10-29 06:58:22', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(817, '10082', '2026-10-29 06:58:29', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(818, '10111', '2026-10-29 06:58:51', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(819, '10190', '2026-10-29 06:59:21', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(820, '202609019', '2026-10-29 06:59:31', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(821, '202610013', '2026-10-29 07:00:17', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(822, '10165', '2026-10-29 07:00:22', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(823, '10092', '2026-10-29 07:00:31', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(824, '10079', '2026-10-29 07:00:35', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(825, '202609021', '2026-10-29 07:00:39', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(826, '202609011', '2026-10-29 07:00:48', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(827, '10093', '2026-10-29 07:00:53', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(828, '202609030', '2026-10-29 07:00:56', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(829, '10129', '2026-10-29 07:01:46', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(830, '10146', '2026-10-29 07:02:24', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(831, '10035', '2026-10-29 07:02:42', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(832, '10246', '2026-10-29 07:03:10', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(833, '10003', '2026-10-29 07:03:14', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(834, '10020', '2026-10-29 07:03:53', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(835, '10030', '2026-10-29 07:04:01', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(836, '10021', '2026-10-29 07:04:19', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(837, '10211', '2026-10-29 07:04:26', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(838, '10492', '2026-10-29 07:04:56', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(839, '10056', '2026-10-29 07:05:01', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(840, '10001', '2026-10-29 07:05:04', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(841, '10252', '2026-10-29 07:05:08', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(842, '10244', '2026-10-29 07:05:23', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(843, '10315', '2026-10-29 07:05:29', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(844, '10453', '2026-10-29 07:05:40', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(845, '10207', '2026-10-29 07:05:48', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(846, '10027', '2026-10-29 07:07:31', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(847, '10225', '2026-10-29 07:07:36', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(848, '10016', '2026-10-29 07:07:45', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(849, '10173', '2026-10-29 07:08:08', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(850, '10452', '2026-10-29 07:08:48', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(851, '10162', '2026-10-29 07:09:31', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(852, '10002', '2026-10-29 07:09:58', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(853, '10118', '2026-10-29 07:10:07', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(854, '10036', '2026-10-29 07:10:11', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(855, '10026', '2026-10-29 07:10:20', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(856, '10273', '2026-10-29 07:10:28', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(857, '10010', '2026-10-29 07:10:32', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(858, '10213', '2026-10-29 07:10:46', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(859, '202609026', '2026-10-29 07:10:56', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(860, '10250', '2026-10-29 07:11:11', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(861, '10008', '2026-10-29 07:11:13', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(862, '10135', '2026-10-29 07:11:21', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(863, '10263', '2026-10-29 07:11:24', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(864, '10276', '2026-10-29 07:11:29', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(865, '100323', '2026-10-29 07:11:36', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(866, '10493', '2026-10-29 07:11:39', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(867, '10459', '2026-10-29 07:11:43', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(868, '10014', '2026-10-29 07:11:47', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(869, '10486', '2026-10-29 07:11:58', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(870, '202609018', '2026-10-29 07:12:09', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(871, '202609012', '2026-10-29 07:12:11', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(872, '202609014', '2026-10-29 07:12:14', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(873, '202609013', '2026-10-29 07:12:17', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(874, '202609020', '2026-10-29 07:12:20', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(875, '10267', '2026-10-29 07:12:26', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(876, '10215', '2026-10-29 07:12:29', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(877, '10029', '2026-10-29 07:12:35', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(878, '100237', '2026-10-29 07:12:42', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(879, '202609027', '2026-10-29 07:13:15', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(880, '10013', '2026-10-29 07:13:31', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(881, '100231', '2026-10-29 07:13:34', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(882, '10028', '2026-10-29 07:13:37', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(883, '10259', '2026-10-29 07:13:41', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(884, '10232', '2026-10-29 07:13:45', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(885, '100348', '2026-10-29 07:13:48', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(886, '10487', '2026-10-29 07:13:51', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(887, '10256', '2026-10-29 07:13:58', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(888, '10254', '2026-10-29 07:14:00', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(889, '10038', '2026-10-29 07:14:42', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(890, '10138', '2026-10-29 07:14:45', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(891, '10117', '2026-10-29 07:14:49', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(892, '10224', '2026-10-29 07:14:52', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(893, '10005', '2026-10-29 07:15:31', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(894, '10019', '2026-10-29 07:15:44', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(895, '10255', '2026-10-29 07:15:46', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(896, '10012', '2026-10-29 07:16:27', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(897, '10108', '2026-10-29 07:16:32', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(898, '10004', '2026-10-29 07:17:07', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(899, '10006', '2026-10-29 07:18:46', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(900, '10011', '2026-10-29 07:18:49', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(901, '10101', '2026-10-29 07:25:01', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(902, '10054', '2026-10-29 07:25:07', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(903, '10018', '2026-10-29 07:27:46', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(904, '202610003', '2026-10-29 07:33:57', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(905, '10046', '2026-10-29 07:39:21', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(906, '202510001', '2026-10-29 07:55:33', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(907, '10024', '2026-10-29 07:57:04', '2026-10-29 01:39:11', '2026-10-29 01:39:11'),
(908, '10133', '2026-10-29 08:01:24', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(909, '10488', '2026-10-29 08:07:57', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(910, '10495', '2026-10-29 08:08:35', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(911, '200608001', '2026-10-29 08:08:39', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(912, '202507001', '2026-10-29 08:11:08', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(913, '202411001', '2026-10-29 08:29:01', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(914, '10125', '2026-10-29 08:31:32', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(915, '10485', '2026-10-29 08:35:28', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(916, '10044', '2026-10-29 08:44:18', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(917, '10047', '2026-10-29 08:54:29', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(918, '10126', '2026-10-29 09:00:07', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(919, '202610017', '2026-10-29 10:09:13', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(920, '202507001', '2026-10-29 15:27:36', '2026-10-29 01:39:12', '2026-10-29 01:39:12'),
(921, '21216', '2026-10-27 17:59:40', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(922, '20208', '2026-10-27 17:59:51', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(923, '19342', '2026-10-27 18:00:23', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(924, '19341', '2026-10-27 18:00:36', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(925, '19236', '2026-10-27 18:01:01', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(926, '19080', '2026-10-27 18:01:03', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(927, '19298', '2026-10-27 18:01:06', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(928, '19232', '2026-10-27 18:01:12', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(929, '21074', '2026-10-27 18:01:19', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(930, '19354', '2026-10-27 18:01:26', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(931, '21233', '2026-10-27 18:01:31', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(932, '21334', '2026-10-27 18:01:33', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(933, '21405', '2026-10-27 18:02:07', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(934, '21008', '2026-10-27 18:02:37', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(935, '20753', '2026-10-27 18:02:45', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(936, '19278', '2026-10-27 18:02:54', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(937, '21310', '2026-10-27 18:03:06', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(938, '20335', '2026-10-27 18:05:34', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(939, '21334', '2026-10-28 06:19:45', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(940, '19767', '2026-10-28 06:25:58', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(941, '19286', '2026-10-28 06:34:54', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(942, '19341', '2026-10-28 06:37:08', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(943, '19764', '2026-10-28 06:37:30', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(944, '21405', '2026-10-28 06:43:46', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(945, '19457', '2026-10-28 06:45:29', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(946, '20274', '2026-10-28 06:50:20', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(947, '19312', '2026-10-28 06:51:16', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(948, '21074', '2026-10-28 06:51:58', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(949, '19426', '2026-10-28 06:53:23', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(950, '19433', '2026-10-28 06:53:28', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(951, '21392', '2026-10-28 06:53:36', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(952, '19236', '2026-10-28 06:54:32', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(953, '20416', '2026-10-28 06:55:15', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(954, '20533', '2026-10-28 06:56:12', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(955, '19242', '2026-10-28 06:57:01', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(956, '19266', '2026-10-28 06:59:54', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(957, '19477', '2026-10-28 16:15:44', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(958, '20965', '2026-10-28 16:16:07', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(959, '19769', '2026-10-28 16:16:24', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(960, '20533', '2026-10-28 16:16:26', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(961, '19767', '2026-10-28 16:16:30', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(962, '20957', '2026-10-28 16:16:35', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(963, '20951', '2026-10-28 16:16:40', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(964, '20274', '2026-10-28 16:16:43', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(965, '19079', '2026-10-28 16:16:47', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(966, '20416', '2026-10-28 16:16:59', '2026-10-29 01:39:34', '2026-10-29 01:39:34'),
(967, '20947', '2026-10-28 16:17:15', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(968, '19768', '2026-10-28 16:17:22', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(969, '21545', '2026-10-28 16:17:25', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(970, '19426', '2026-10-28 16:17:32', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(971, '21400', '2026-10-28 16:17:35', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(972, '21330', '2026-10-28 16:17:42', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(973, '21392', '2026-10-28 16:17:45', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(974, '19077', '2026-10-28 16:17:52', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(975, '20218', '2026-10-28 16:17:55', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(976, '21332', '2026-10-28 16:17:58', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(977, '19354', '2026-10-28 16:18:02', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(978, '21216', '2026-10-28 16:18:04', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(979, '19266', '2026-10-28 16:18:07', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(980, '19239', '2026-10-28 16:18:12', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(981, '19312', '2026-10-28 16:18:25', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(982, '21008', '2026-10-28 16:18:34', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(983, '202405038', '2026-10-28 16:18:38', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(984, '20855', '2026-10-28 16:18:43', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(985, '20412', '2026-10-28 16:18:46', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(986, '21538', '2026-10-28 16:18:52', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(987, '19342', '2026-10-28 16:18:55', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(988, '18035', '2026-10-28 16:18:58', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(989, '19244', '2026-10-28 16:19:04', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(990, '19764', '2026-10-28 16:19:14', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(991, '19433', '2026-10-28 16:19:19', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(992, '19242', '2026-10-28 16:19:21', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(993, '19286', '2026-10-28 16:19:28', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(994, '21153', '2026-10-28 16:19:31', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(995, '19341', '2026-10-28 16:19:34', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(996, '19298', '2026-10-28 16:19:37', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(997, '21542', '2026-10-28 16:19:40', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(998, '20601', '2026-10-28 16:19:43', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(999, '19080', '2026-10-28 16:19:54', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1000, '19314', '2026-10-28 16:19:57', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1001, '19457', '2026-10-28 16:20:58', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1002, '19453', '2026-10-28 16:21:07', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1003, '19662', '2026-10-28 16:21:23', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1004, '19736', '2026-10-28 16:21:29', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1005, '20981', '2026-10-28 17:59:23', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1006, '20208', '2026-10-28 18:00:36', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1007, '19236', '2026-10-28 18:00:45', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1008, '21233', '2026-10-28 18:01:07', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1009, '21334', '2026-10-28 18:01:15', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1010, '21074', '2026-10-28 18:01:20', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1011, '19232', '2026-10-28 18:01:25', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1012, '20753', '2026-10-28 18:01:48', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1013, '19278', '2026-10-28 18:03:08', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1014, '21405', '2026-10-28 18:04:28', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1015, '20335', '2026-10-28 18:05:33', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1016, '21310', '2026-10-28 18:06:09', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1017, '19767', '2026-10-29 06:18:45', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1018, '21334', '2026-10-29 06:20:40', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1019, '19764', '2026-10-29 06:35:15', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1020, '21405', '2026-10-29 06:39:43', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1021, '19341', '2026-10-29 06:42:39', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1022, '21392', '2026-10-29 06:45:30', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1023, '20274', '2026-10-29 06:50:05', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1024, '21074', '2026-10-29 06:51:32', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1025, '19236', '2026-10-29 06:52:00', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1026, '19426', '2026-10-29 06:52:20', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1027, '19286', '2026-10-29 06:52:49', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1028, '19312', '2026-10-29 06:53:17', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1029, '19457', '2026-10-29 06:54:53', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1030, '19242', '2026-10-29 06:55:11', '2026-10-29 01:39:35', '2026-10-29 01:39:35'),
(1031, '10270', '2026-10-29 16:15:39', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1032, '10119', '2026-10-29 16:15:42', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1033, '30102', '2026-10-29 16:15:47', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1034, '10013', '2026-10-29 16:15:51', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1035, '10012', '2026-10-29 16:15:58', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1036, '202609026', '2026-10-29 16:16:02', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1037, '10002', '2026-10-29 16:16:04', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1038, '10056', '2026-10-29 16:16:07', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1039, '10113', '2026-10-29 16:16:09', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1040, '10256', '2026-10-29 16:16:11', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1041, '10250', '2026-10-29 16:16:14', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1042, '100231', '2026-10-29 16:16:17', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1043, '202609019', '2026-10-29 16:16:27', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1044, '202609021', '2026-10-29 16:16:31', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1045, '10003', '2026-10-29 16:16:33', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1046, '202609018', '2026-10-29 16:16:35', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1047, '202609012', '2026-10-29 16:16:37', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1048, '10035', '2026-10-29 16:16:40', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1049, '100233', '2026-10-29 16:16:43', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1050, '202609013', '2026-10-29 16:16:52', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1051, '10010', '2026-10-29 16:16:56', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1052, '202609020', '2026-10-29 16:16:58', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1053, '10252', '2026-10-29 16:17:01', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1054, '10271', '2026-10-29 16:17:03', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1055, '10111', '2026-10-29 16:17:05', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1056, '10129', '2026-10-29 16:17:10', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1057, '10276', '2026-10-29 16:17:12', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1058, '10244', '2026-10-29 16:17:14', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1059, '10453', '2026-10-29 16:17:21', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1060, '10030', '2026-10-29 16:17:23', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1061, '202609016', '2026-10-29 16:17:26', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1062, '10004', '2026-10-29 16:17:28', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1063, '10452', '2026-10-29 16:17:30', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1064, '10135', '2026-10-29 16:17:33', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1065, '10254', '2026-10-29 16:17:35', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1066, '10224', '2026-10-29 16:17:40', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1067, '202609014', '2026-10-29 16:17:43', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1068, '10246', '2026-10-29 16:17:46', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1069, '10005', '2026-10-29 16:17:48', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1070, '10108', '2026-10-29 16:17:51', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1071, '10486', '2026-10-29 16:17:54', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1072, '10263', '2026-10-29 16:17:56', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1073, '10492', '2026-10-29 16:17:59', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1074, '10493', '2026-10-29 16:18:01', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1075, '10315', '2026-10-29 16:18:06', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1076, '10259', '2026-10-29 16:18:10', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1077, '10001', '2026-10-29 16:18:12', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1078, '10225', '2026-10-29 16:18:16', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1079, '10117', '2026-10-29 16:18:23', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1080, '10029', '2026-10-29 16:18:26', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1081, '202609027', '2026-10-29 16:18:29', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1082, '202609030', '2026-10-29 16:18:32', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1083, '202609011', '2026-10-29 16:18:37', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1084, '10215', '2026-10-29 16:18:40', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1085, '10008', '2026-10-29 16:18:45', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1086, '10014', '2026-10-29 16:18:55', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1087, '10027', '2026-10-29 16:19:04', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1088, '10026', '2026-10-29 16:19:11', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1089, '100237', '2026-10-29 16:19:17', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1090, '10021', '2026-10-29 16:19:39', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1091, '10020', '2026-10-29 16:20:04', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1092, '10173', '2026-10-29 16:21:03', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1093, '10054', '2026-10-29 16:21:09', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1094, '10242', '2026-10-29 16:21:23', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1095, '10267', '2026-10-29 16:21:45', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1096, '10016', '2026-10-29 16:21:48', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1097, '10018', '2026-10-29 16:21:57', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1098, '10118', '2026-10-29 16:22:14', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1099, '10101', '2026-10-29 16:26:08', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1100, '10138', '2026-10-29 16:28:49', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1101, '10019', '2026-10-29 16:32:58', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1102, '10126', '2026-10-29 16:55:35', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1103, '200608001', '2026-10-29 16:57:17', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1104, '10495', '2026-10-29 16:57:19', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1105, '202510001', '2026-10-29 16:57:46', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1106, '10485', '2026-10-29 16:57:51', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1107, '10488', '2026-10-29 16:57:55', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1108, '10024', '2026-10-29 16:58:00', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1109, '202610017', '2026-10-29 16:58:12', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1110, '10125', '2026-10-29 16:58:43', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1111, '10046', '2026-10-29 16:58:48', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1112, '10133', '2026-10-29 17:04:31', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1113, '10044', '2026-10-29 17:24:51', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1114, '202507001', '2026-10-29 17:25:51', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1115, '202411001', '2026-10-29 17:25:54', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1116, '202610003', '2026-10-29 17:25:58', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1117, '10006', '2026-10-29 17:55:55', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1118, '10036', '2026-10-29 17:58:19', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1119, '10255', '2026-10-29 17:58:22', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1120, '100348', '2026-10-29 17:58:27', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1121, '10038', '2026-10-29 17:59:10', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1122, '10011', '2026-10-29 17:59:18', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1123, '202609003', '2026-10-29 17:59:23', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1124, '10211', '2026-10-29 17:59:25', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1125, '10177', '2026-10-29 17:59:29', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1126, '10162', '2026-10-29 17:59:34', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1127, '10190', '2026-10-29 17:59:36', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1128, '10178', '2026-10-29 17:59:38', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1129, '202609001', '2026-10-29 17:59:44', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1130, '202610009', '2026-10-29 17:59:48', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1131, '202610006', '2026-10-29 17:59:50', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1132, '10075', '2026-10-29 17:59:53', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1133, '202610007', '2026-10-29 17:59:55', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1134, '202608004', '2026-10-29 17:59:58', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1135, '10072', '2026-10-29 18:00:02', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1136, '10207', '2026-10-29 18:00:13', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1137, '10143', '2026-10-29 18:00:17', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1138, '2026090010', '2026-10-29 18:00:19', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1139, '10066', '2026-10-29 18:00:24', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1140, '10082', '2026-10-29 18:00:26', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1141, '202610013', '2026-10-29 18:00:28', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1142, '202610008', '2026-10-29 18:00:31', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1143, '202609009', '2026-10-29 18:00:34', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1144, '202610002', '2026-10-29 18:00:37', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1145, '10213', '2026-10-29 18:00:39', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1146, '202610004', '2026-10-29 18:00:41', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1147, '10459', '2026-10-29 18:00:43', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1148, '10093', '2026-10-29 18:00:46', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1149, '202609008', '2026-10-29 18:00:48', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1150, '10105', '2026-10-29 18:00:50', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1151, '10086', '2026-10-29 18:00:52', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1152, '10144', '2026-10-29 18:00:55', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1153, '202609007', '2026-10-29 18:00:57', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1154, '202610010', '2026-10-29 18:00:59', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1155, '10091', '2026-10-29 18:01:01', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1156, '202610011', '2026-10-29 18:01:03', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1157, '10097', '2026-10-29 18:01:06', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1158, '10068', '2026-10-29 18:01:08', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1159, '103333', '2026-10-29 18:01:12', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1160, '10487', '2026-10-29 18:01:15', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1161, '10165', '2026-10-29 18:01:25', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1162, '202609002', '2026-10-29 18:01:28', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1163, '10154', '2026-10-29 18:01:30', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1164, '10073', '2026-10-29 18:01:36', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1165, '10209', '2026-10-29 18:01:38', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1166, '202609005', '2026-10-29 18:01:40', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1167, '10092', '2026-10-29 18:01:42', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1168, '202608003', '2026-10-29 18:01:45', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1169, '10017', '2026-10-29 18:01:49', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1170, '202608010', '2026-10-29 18:01:54', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1171, '10157', '2026-10-29 18:01:56', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1172, '202610012', '2026-10-29 18:01:59', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1173, '10069', '2026-10-29 18:02:01', '2026-10-29 20:01:53', '2026-10-29 20:01:53'),
(1174, '10497', '2026-10-29 18:02:04', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1175, '202610001', '2026-10-29 18:02:06', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1176, '10079', '2026-10-29 18:02:08', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1177, '202610015', '2026-10-29 18:02:10', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1178, '202610016', '2026-10-29 18:02:15', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1179, '10491', '2026-10-29 18:02:17', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1180, '10188', '2026-10-29 18:02:19', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1181, '10146', '2026-10-29 18:02:22', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1182, '202609006', '2026-10-29 18:02:25', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1183, '10061', '2026-10-29 18:02:31', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1184, '10090', '2026-10-29 18:02:35', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1185, '100323', '2026-10-29 18:02:39', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1186, '10273', '2026-10-29 18:02:41', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1187, '10490', '2026-10-29 18:02:45', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1188, '10084', '2026-10-29 18:02:49', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1189, '10057', '2026-10-29 18:03:01', '2026-10-29 20:01:54', '2026-10-29 20:01:54');
INSERT INTO `finger_logs` (`id`, `pin`, `scan_time`, `created_at`, `updated_at`) VALUES
(1190, '10047', '2026-10-29 18:47:02', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1191, '10057', '2026-10-30 05:52:26', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1192, '10069', '2026-10-30 06:03:17', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1193, '202609002', '2026-10-30 06:03:24', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1194, '10490', '2026-10-30 06:04:31', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1195, '10075', '2026-10-30 06:17:53', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1196, '10154', '2026-10-30 06:20:55', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1197, '202609008', '2026-10-30 06:21:45', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1198, '202610006', '2026-10-30 06:23:41', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1199, '202610007', '2026-10-30 06:23:45', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1200, '10086', '2026-10-30 06:26:40', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1201, '10084', '2026-10-30 06:27:19', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1202, '202609007', '2026-10-30 06:30:12', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1203, '10178', '2026-10-30 06:30:15', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1204, '202609005', '2026-10-30 06:30:19', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1205, '10177', '2026-10-30 06:30:38', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1206, '202610001', '2026-10-30 06:30:49', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1207, '202610008', '2026-10-30 06:32:25', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1208, '10090', '2026-10-30 06:37:26', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1209, '202610004', '2026-10-30 06:38:29', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1210, '202610002', '2026-10-30 06:38:33', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1211, '10209', '2026-10-30 06:40:13', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1212, '202610009', '2026-10-30 06:41:01', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1213, '10271', '2026-10-30 06:41:52', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1214, '202608004', '2026-10-30 06:42:34', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1215, '10113', '2026-10-30 06:44:46', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1216, '10270', '2026-10-30 06:44:50', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1217, '202610010', '2026-10-30 06:45:36', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1218, '202609009', '2026-10-30 06:45:39', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1219, '202609001', '2026-10-30 06:46:23', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1220, '10093', '2026-10-30 06:46:58', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1221, '10143', '2026-10-30 06:47:11', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1222, '10144', '2026-10-30 06:47:16', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1223, '10020', '2026-10-30 06:47:55', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1224, '10157', '2026-10-30 06:48:40', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1225, '202608010', '2026-10-30 06:48:48', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1226, '202610016', '2026-10-30 06:49:20', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1227, '202609003', '2026-10-30 06:50:08', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1228, '10188', '2026-10-30 06:50:27', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1229, '202608003', '2026-10-30 06:50:36', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1230, '30102', '2026-10-30 06:50:57', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1231, '10061', '2026-10-30 06:51:03', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1232, '10066', '2026-10-30 06:51:07', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1233, '10207', '2026-10-30 06:51:15', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1234, '202610013', '2026-10-30 06:51:22', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1235, '202610012', '2026-10-30 06:51:27', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1236, '10072', '2026-10-30 06:51:39', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1237, '10190', '2026-10-30 06:51:42', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1238, '202610011', '2026-10-30 06:51:47', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1239, '10452', '2026-10-30 06:51:50', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1240, '10068', '2026-10-30 06:51:54', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1241, '10073', '2026-10-30 06:52:01', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1242, '202610015', '2026-10-30 06:52:05', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1243, '10017', '2026-10-30 06:52:10', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1244, '10016', '2026-10-30 06:52:55', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1245, '10162', '2026-10-30 06:53:00', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1246, '10082', '2026-10-30 06:54:14', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1247, '202609016', '2026-10-30 06:54:41', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1248, '10111', '2026-10-30 06:55:02', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1249, '10097', '2026-10-30 06:55:08', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1250, '103333', '2026-10-30 06:55:53', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1251, '2026090010', '2026-10-30 06:56:49', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1252, '10092', '2026-10-30 06:57:02', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1253, '10079', '2026-10-30 06:57:05', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1254, '10105', '2026-10-30 06:57:08', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1255, '10491', '2026-10-30 06:57:44', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1256, '10165', '2026-10-30 06:59:10', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1257, '10091', '2026-10-30 06:59:15', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1258, '10252', '2026-10-30 06:59:38', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1259, '10211', '2026-10-30 07:00:56', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1260, '10129', '2026-10-30 07:01:01', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1261, '10246', '2026-10-30 07:01:08', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1262, '10056', '2026-10-30 07:01:59', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1263, '10453', '2026-10-30 07:02:39', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1264, '10242', '2026-10-30 07:03:17', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1265, '10030', '2026-10-30 07:03:23', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1266, '10497', '2026-10-30 07:03:32', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1267, '202609021', '2026-10-30 07:03:41', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1268, '202609011', '2026-10-30 07:03:47', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1269, '10002', '2026-10-30 07:04:29', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1270, '10027', '2026-10-30 07:05:13', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1271, '10028', '2026-10-30 07:05:17', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1272, '10021', '2026-10-30 07:05:38', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1273, '10146', '2026-10-30 07:05:56', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1274, '10008', '2026-10-30 07:06:04', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1275, '202609030', '2026-10-30 07:06:36', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1276, '10263', '2026-10-30 07:06:42', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1277, '10173', '2026-10-30 07:07:36', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1278, '10273', '2026-10-30 07:08:04', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1279, '10003', '2026-10-30 07:08:09', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1280, '100323', '2026-10-30 07:08:24', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1281, '10010', '2026-10-30 07:08:37', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1282, '202609026', '2026-10-30 07:08:46', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1283, '10486', '2026-10-30 07:09:37', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1284, '10492', '2026-10-30 07:09:41', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1285, '10315', '2026-10-30 07:09:43', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1286, '10493', '2026-10-30 07:09:48', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1287, '10487', '2026-10-30 07:09:51', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1288, '10225', '2026-10-30 07:10:02', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1289, '10276', '2026-10-30 07:10:36', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1290, '10026', '2026-10-30 07:10:51', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1291, '10014', '2026-10-30 07:11:00', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1292, '10118', '2026-10-30 07:11:06', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1293, '10019', '2026-10-30 07:11:31', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1294, '10244', '2026-10-30 07:11:55', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1295, '10259', '2026-10-30 07:11:59', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1296, '10459', '2026-10-30 07:12:04', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1297, '10215', '2026-10-30 07:12:06', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1298, '10023', '2026-10-30 07:12:13', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1299, '202609018', '2026-10-30 07:12:19', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1300, '202609012', '2026-10-30 07:12:21', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1301, '202609020', '2026-10-30 07:12:24', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1302, '202609019', '2026-10-30 07:12:29', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1303, '10138', '2026-10-30 07:12:32', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1304, '10001', '2026-10-30 07:12:35', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1305, '202609027', '2026-10-30 07:12:38', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1306, '10029', '2026-10-30 07:12:41', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1307, '100237', '2026-10-30 07:12:47', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1308, '10128', '2026-10-30 07:12:53', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1309, '10250', '2026-10-30 07:12:56', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1310, '10232', '2026-10-30 07:13:00', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1311, '10036', '2026-10-30 07:13:02', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1312, '100231', '2026-10-30 07:13:05', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1313, '100348', '2026-10-30 07:13:26', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1314, '10013', '2026-10-30 07:13:37', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1315, '10005', '2026-10-30 07:13:43', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1316, '10256', '2026-10-30 07:13:47', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1317, '10254', '2026-10-30 07:13:51', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1318, '10012', '2026-10-30 07:13:57', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1319, '10038', '2026-10-30 07:14:39', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1320, '10224', '2026-10-30 07:14:41', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1321, '10011', '2026-10-30 07:14:53', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1322, '10042', '2026-10-30 07:15:00', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1323, '10052', '2026-10-30 07:15:08', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1324, '10117', '2026-10-30 07:15:31', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1325, '10108', '2026-10-30 07:16:25', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1326, '202610017', '2026-10-30 07:16:30', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1327, '10006', '2026-10-30 07:17:58', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1328, '10004', '2026-10-30 07:21:20', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1329, '10054', '2026-10-30 07:24:21', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1330, '10101', '2026-10-30 07:30:24', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1331, '10018', '2026-10-30 07:30:43', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1332, '10046', '2026-10-30 07:37:56', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1333, '202610003', '2026-10-30 07:44:00', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1334, '10133', '2026-10-30 07:50:06', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1335, '200608001', '2026-10-30 07:56:17', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1336, '202507001', '2026-10-30 07:56:24', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1337, '202510001', '2026-10-30 07:58:50', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1338, '10024', '2026-10-30 08:00:28', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1339, '10495', '2026-10-30 08:02:02', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1340, '10488', '2026-10-30 08:07:26', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1341, '10125', '2026-10-30 08:27:17', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1342, '202411001', '2026-10-30 08:27:36', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1343, '10485', '2026-10-30 08:30:01', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1344, '10044', '2026-10-30 08:45:08', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1345, '10126', '2026-10-30 08:47:12', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1346, '10047', '2026-10-30 09:02:26', '2026-10-29 20:01:54', '2026-10-29 20:01:54'),
(1347, '19477', '2026-10-29 16:15:53', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1348, '20018', '2026-10-29 16:16:03', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1349, '20416', '2026-10-29 16:16:05', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1350, '21400', '2026-10-29 16:16:07', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1351, '20954', '2026-10-29 16:16:13', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1352, '20947', '2026-10-29 16:16:16', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1353, '19342', '2026-10-29 16:16:24', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1354, '19767', '2026-10-29 16:16:33', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1355, '20957', '2026-10-29 16:16:40', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1356, '19266', '2026-10-29 16:16:48', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1357, '21545', '2026-10-29 16:16:56', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1358, '19426', '2026-10-29 16:17:06', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1359, '21392', '2026-10-29 16:17:13', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1360, '19768', '2026-10-29 16:17:22', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1361, '19354', '2026-10-29 16:17:28', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1362, '21332', '2026-10-29 16:17:31', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1363, '20533', '2026-10-29 16:17:34', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1364, '19079', '2026-10-29 16:17:39', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1365, '20218', '2026-10-29 16:17:43', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1366, '20274', '2026-10-29 16:17:46', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1367, '21008', '2026-10-29 16:17:59', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1368, '19239', '2026-10-29 16:18:06', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1369, '21538', '2026-10-29 16:18:08', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1370, '19769', '2026-10-29 16:18:13', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1371, '202405038', '2026-10-29 16:18:19', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1372, '20412', '2026-10-29 16:18:23', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1373, '21153', '2026-10-29 16:18:27', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1374, '19244', '2026-10-29 16:18:32', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1375, '21542', '2026-10-29 16:18:39', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1376, '18035', '2026-10-29 16:18:48', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1377, '20855', '2026-10-29 16:18:56', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1378, '19286', '2026-10-29 16:19:04', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1379, '19312', '2026-10-29 16:19:15', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1380, '19242', '2026-10-29 16:19:19', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1381, '19298', '2026-10-29 16:19:22', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1382, '19077', '2026-10-29 16:19:26', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1383, '20601', '2026-10-29 16:19:35', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1384, '19457', '2026-10-29 16:20:01', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1385, '19314', '2026-10-29 16:20:18', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1386, '19453', '2026-10-29 16:20:21', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1387, '19662', '2026-10-29 16:22:20', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1388, '21330', '2026-10-29 16:23:51', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1389, '19736', '2026-10-29 16:26:01', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1390, '20981', '2026-10-29 17:58:22', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1391, '20208', '2026-10-29 17:58:31', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1392, '21216', '2026-10-29 17:59:41', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1393, '21074', '2026-10-29 17:59:55', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1394, '19764', '2026-10-29 18:00:14', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1395, '19236', '2026-10-29 18:00:20', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1396, '19232', '2026-10-29 18:00:26', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1397, '20753', '2026-10-29 18:00:32', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1398, '19433', '2026-10-29 18:00:39', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1399, '20951', '2026-10-29 18:00:45', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1400, '21233', '2026-10-29 18:00:49', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1401, '21334', '2026-10-29 18:00:55', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1402, '21310', '2026-10-29 18:02:38', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1403, '21405', '2026-10-29 18:02:41', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1404, '19278', '2026-10-29 18:02:44', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1405, '19341', '2026-10-29 18:03:11', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1406, '19080', '2026-10-29 18:03:14', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1407, '20335', '2026-10-29 18:03:50', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1408, '21334', '2026-10-30 06:18:34', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1409, '19767', '2026-10-30 06:21:37', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1410, '19764', '2026-10-30 06:31:44', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1411, '19341', '2026-10-30 06:40:38', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1412, '21405', '2026-10-30 06:42:37', '2026-10-29 20:02:16', '2026-10-29 20:02:16'),
(1413, '19286', '2026-10-30 06:43:46', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1414, '19426', '2026-10-30 06:49:32', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1415, '20274', '2026-10-30 06:49:41', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1416, '19242', '2026-10-30 06:51:14', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1417, '19433', '2026-10-30 06:51:20', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1418, '21074', '2026-10-30 06:51:33', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1419, '19312', '2026-10-30 06:54:01', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1420, '21392', '2026-10-30 06:55:20', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1421, '19239', '2026-10-30 06:58:47', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1422, '20218', '2026-10-30 07:02:54', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1423, '20981', '2026-10-30 07:02:59', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1424, '20416', '2026-10-30 07:03:03', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1425, '20855', '2026-10-30 07:03:46', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1426, '19314', '2026-10-30 07:04:59', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1427, '21233', '2026-10-30 07:05:15', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1428, '19266', '2026-10-30 07:05:28', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1429, '21310', '2026-10-30 07:05:42', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1430, '202405038', '2026-10-30 07:07:04', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1431, '18035', '2026-10-30 07:07:18', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1432, '21008', '2026-10-30 07:07:26', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1433, '19354', '2026-10-30 07:07:30', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1434, '20753', '2026-10-30 07:07:34', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1435, '21538', '2026-10-30 07:07:41', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1436, '21545', '2026-10-30 07:07:47', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1437, '19244', '2026-10-30 07:08:11', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1438, '19768', '2026-10-30 07:09:12', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1439, '19342', '2026-10-30 07:10:21', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1440, '19477', '2026-10-30 07:10:47', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1441, '20018', '2026-10-30 07:10:55', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1442, '19769', '2026-10-30 07:11:04', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1443, '19298', '2026-10-30 07:11:08', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1444, '20601', '2026-10-30 07:11:20', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1445, '21330', '2026-10-30 07:11:56', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1446, '20208', '2026-10-30 07:12:36', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1447, '20957', '2026-10-30 07:12:47', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1448, '20951', '2026-10-30 07:12:53', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1449, '21153', '2026-10-30 07:13:12', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1450, '21332', '2026-10-30 07:13:16', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1451, '20947', '2026-10-30 07:13:20', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1452, '19232', '2026-10-30 07:14:01', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1453, '20412', '2026-10-30 07:14:13', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1454, '20965', '2026-10-30 07:14:31', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1455, '21216', '2026-10-30 07:14:34', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1456, '21400', '2026-10-30 07:14:37', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1457, '20954', '2026-10-30 07:14:40', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1458, '19736', '2026-10-30 07:15:14', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1459, '19080', '2026-10-30 07:16:19', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1460, '19278', '2026-10-30 07:16:57', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1461, '20335', '2026-10-30 07:20:11', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1462, '21542', '2026-10-30 07:20:30', '2026-10-29 20:02:17', '2026-10-29 20:02:17'),
(1463, '10018', '2026-10-31 15:58:38', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1464, '100323', '2026-10-31 15:58:45', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1465, '10215', '2026-10-31 15:58:51', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1466, '10056', '2026-10-31 15:58:56', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1467, '10036', '2026-10-31 15:58:58', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1468, '10459', '2026-10-31 15:59:00', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1469, '10011', '2026-10-31 15:59:03', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1470, '10252', '2026-10-31 15:59:05', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1471, '10013', '2026-10-31 15:59:08', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1472, '10113', '2026-10-31 15:59:18', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1473, '202609026', '2026-10-31 15:59:21', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1474, '10250', '2026-10-31 15:59:32', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1475, '10129', '2026-10-31 15:59:34', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1476, '10144', '2026-10-31 15:59:36', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1477, '10111', '2026-10-31 15:59:38', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1478, '10004', '2026-10-31 15:59:45', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1479, '10256', '2026-10-31 15:59:48', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1480, '10005', '2026-10-31 15:59:50', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1481, '10271', '2026-10-31 15:59:52', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1482, '202610015', '2026-10-31 15:59:54', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1483, '202609007', '2026-10-31 15:59:56', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1484, '10165', '2026-10-31 16:00:10', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1485, '202608003', '2026-10-31 16:00:20', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1486, '202609003', '2026-10-31 16:00:23', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1487, '10014', '2026-10-31 16:00:30', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1488, '10075', '2026-10-31 16:00:43', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1489, '100231', '2026-10-31 16:00:48', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1490, '202609009', '2026-10-31 16:00:50', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1491, '10072', '2026-10-31 16:00:54', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1492, '10255', '2026-10-31 16:00:56', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1493, '103333', '2026-10-31 16:00:59', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1494, '202609018', '2026-10-31 16:01:01', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1495, '202609019', '2026-10-31 16:01:03', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1496, '202609012', '2026-10-31 16:01:06', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1497, '10190', '2026-10-31 16:01:08', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1498, '10178', '2026-10-31 16:01:10', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1499, '10066', '2026-10-31 16:01:12', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1500, '10030', '2026-10-31 16:01:14', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1501, '202609021', '2026-10-31 16:01:21', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1502, '10027', '2026-10-31 16:01:23', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1503, '10105', '2026-10-31 16:01:26', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1504, '202610010', '2026-10-31 16:01:28', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1505, '10003', '2026-10-31 16:01:30', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1506, '10154', '2026-10-31 16:01:33', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1507, '10021', '2026-10-31 16:01:35', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1508, '10023', '2026-10-31 16:01:38', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1509, '10207', '2026-10-31 16:01:42', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1510, '10188', '2026-10-31 16:01:47', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1511, '202609020', '2026-10-31 16:01:49', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1512, '10497', '2026-10-31 16:01:55', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1513, '202609016', '2026-10-31 16:01:57', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1514, '10162', '2026-10-31 16:02:01', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1515, '10026', '2026-10-31 16:02:03', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1516, '202610009', '2026-10-31 16:02:09', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1517, '10086', '2026-10-31 16:02:11', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1518, '10097', '2026-10-31 16:02:13', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1519, '202609008', '2026-10-31 16:02:18', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1520, '10177', '2026-10-31 16:02:24', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1521, '202610006', '2026-10-31 16:02:29', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1522, '202610013', '2026-10-31 16:02:31', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1523, '202608004', '2026-10-31 16:02:37', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1524, '10020', '2026-10-31 16:02:40', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1525, '10008', '2026-10-31 16:02:42', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1526, '10010', '2026-10-31 16:02:45', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1527, '202610007', '2026-10-31 16:02:47', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1528, '10453', '2026-10-31 16:02:49', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1529, '10084', '2026-10-31 16:02:53', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1530, '10143', '2026-10-31 16:02:55', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1531, '202610001', '2026-10-31 16:02:57', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1532, '202609005', '2026-10-31 16:02:59', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1533, '10225', '2026-10-31 16:03:03', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1534, '202609002', '2026-10-31 16:03:06', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1535, '202609001', '2026-10-31 16:03:08', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1536, '202610011', '2026-10-31 16:03:11', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1537, '202610002', '2026-10-31 16:03:16', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1538, '202610004', '2026-10-31 16:03:18', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1539, '10017', '2026-10-31 16:03:20', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1540, '202610008', '2026-10-31 16:03:23', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1541, '10491', '2026-10-31 16:03:25', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1542, '10092', '2026-10-31 16:03:27', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1543, '202610012', '2026-10-31 16:03:29', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1544, '10091', '2026-10-31 16:03:38', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1545, '10146', '2026-10-31 16:03:41', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1546, '10068', '2026-10-31 16:03:45', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1547, '10061', '2026-10-31 16:03:47', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1548, '10082', '2026-10-31 16:03:51', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1549, '2026090010', '2026-10-31 16:03:54', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1550, '10079', '2026-10-31 16:03:58', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1551, '10090', '2026-10-31 16:04:00', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1552, '10069', '2026-10-31 16:04:04', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1553, '10093', '2026-10-31 16:04:07', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1554, '10073', '2026-10-31 16:04:10', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1555, '202610016', '2026-10-31 16:04:13', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1556, '10118', '2026-10-31 16:04:17', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1557, '202609011', '2026-10-31 16:04:22', '2026-11-01 22:37:34', '2026-11-01 22:37:34'),
(1558, '10490', '2026-10-31 16:04:24', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1559, '10157', '2026-10-31 16:04:27', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1560, '202608010', '2026-10-31 16:04:37', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1561, '10012', '2026-10-31 16:04:40', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1562, '100237', '2026-10-31 16:04:42', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1563, '10224', '2026-10-31 16:04:45', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1564, '10273', '2026-10-31 16:04:47', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1565, '202609030', '2026-10-31 16:04:50', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1566, '10029', '2026-10-31 16:04:52', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1567, '10209', '2026-10-31 16:04:54', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1568, '10135', '2026-10-31 16:04:57', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1569, '10128', '2026-10-31 16:04:59', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1570, '10108', '2026-10-31 16:05:03', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1571, '10019', '2026-10-31 16:05:17', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1572, '10211', '2026-10-31 16:05:20', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1573, '10057', '2026-10-31 16:06:00', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1574, '10057', '2026-11-02 05:46:58', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1575, '202609002', '2026-11-02 06:22:26', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1576, '10069', '2026-11-02 06:22:32', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1577, '10490', '2026-11-02 06:22:38', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1578, '202609008', '2026-11-02 06:22:43', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1579, '10084', '2026-11-02 06:26:52', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1580, '202610006', '2026-11-02 06:29:11', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1581, '202610007', '2026-11-02 06:29:17', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1582, '202609005', '2026-11-02 06:31:45', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1583, '100233', '2026-11-02 06:32:17', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1584, '202609007', '2026-11-02 06:32:45', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1585, '10178', '2026-11-02 06:34:04', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1586, '202610001', '2026-11-02 06:34:18', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1587, '202608004', '2026-11-02 06:36:15', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1588, '10086', '2026-11-02 06:36:18', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1589, '202608003', '2026-11-02 06:37:25', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1590, '202610015', '2026-11-02 06:39:05', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1591, '10093', '2026-11-02 06:39:15', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1592, '10271', '2026-11-02 06:40:20', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1593, '202610008', '2026-11-02 06:41:52', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1594, '202610016', '2026-11-02 06:42:35', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1595, '10270', '2026-11-02 06:43:02', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1596, '10157', '2026-11-02 06:43:27', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1597, '10177', '2026-11-02 06:44:15', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1598, '10061', '2026-11-02 06:44:48', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1599, '10119', '2026-11-02 06:45:08', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1600, '202610002', '2026-11-02 06:45:43', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1601, '10090', '2026-11-02 06:45:48', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1602, '10154', '2026-11-02 06:45:55', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1603, '202610010', '2026-11-02 06:45:57', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1604, '10016', '2026-11-02 06:46:03', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1605, '202609001', '2026-11-02 06:46:06', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1606, '10143', '2026-11-02 06:47:16', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1607, '10144', '2026-11-02 06:47:20', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1608, '10113', '2026-11-02 06:49:59', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1609, '10242', '2026-11-02 06:50:09', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1610, '10452', '2026-11-02 06:50:22', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1611, '202610012', '2026-11-02 06:50:27', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1612, '10097', '2026-11-02 06:50:31', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1613, '202609003', '2026-11-02 06:50:48', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1614, '10209', '2026-11-02 06:51:36', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1615, '100231', '2026-11-02 06:52:12', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1616, '10188', '2026-11-02 06:52:23', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1617, '202609016', '2026-11-02 06:52:28', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1618, '202610009', '2026-11-02 06:52:32', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1619, '202608010', '2026-11-02 06:52:59', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1620, '202610011', '2026-11-02 06:53:03', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1621, '30102', '2026-11-02 06:53:12', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1622, '10072', '2026-11-02 06:53:46', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1623, '10073', '2026-11-02 06:53:55', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1624, '103333', '2026-11-02 06:54:10', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1625, '2026090010', '2026-11-02 06:54:15', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1626, '10082', '2026-11-02 06:54:19', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1627, '10105', '2026-11-02 06:54:25', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1628, '10017', '2026-11-02 06:54:31', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1629, '10079', '2026-11-02 06:54:34', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1630, '10092', '2026-11-02 06:54:41', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1631, '10066', '2026-11-02 06:54:48', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1632, '202610013', '2026-11-02 06:54:58', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1633, '10207', '2026-11-02 06:55:12', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1634, '10162', '2026-11-02 06:55:19', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1635, '10111', '2026-11-02 06:56:02', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1636, '10165', '2026-11-02 06:56:31', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1637, '10091', '2026-11-02 06:56:55', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1638, '10068', '2026-11-02 06:56:58', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1639, '10146', '2026-11-02 06:57:10', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1640, '202609009', '2026-11-02 06:57:30', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1641, '10491', '2026-11-02 06:57:37', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1642, '10190', '2026-11-02 06:57:44', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1643, '202610004', '2026-11-02 06:58:59', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1644, '202609027', '2026-11-02 06:59:22', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1645, '10129', '2026-11-02 07:00:32', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1646, '10035', '2026-11-02 07:00:52', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1647, '10497', '2026-11-02 07:01:37', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1648, '10453', '2026-11-02 07:01:53', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1649, '202609021', '2026-11-02 07:02:56', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1650, '202609030', '2026-11-02 07:03:00', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1651, '10020', '2026-11-02 07:03:46', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1652, '10173', '2026-11-02 07:03:56', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1653, '10021', '2026-11-02 07:04:28', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1654, '10246', '2026-11-02 07:04:48', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1655, '10492', '2026-11-02 07:05:23', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1656, '10014', '2026-11-02 07:05:51', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1657, '10486', '2026-11-02 07:06:02', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1658, '10244', '2026-11-02 07:06:08', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1659, '10056', '2026-11-02 07:06:12', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1660, '10028', '2026-11-02 07:06:14', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1661, '10118', '2026-11-02 07:06:40', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1662, '10252', '2026-11-02 07:06:48', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1663, '10315', '2026-11-02 07:07:08', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1664, '10010', '2026-11-02 07:07:14', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1665, '202609026', '2026-11-02 07:07:23', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1666, '202609011', '2026-11-02 07:07:28', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1667, '10005', '2026-11-02 07:07:31', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1668, '10138', '2026-11-02 07:07:41', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1669, '10030', '2026-11-02 07:07:48', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1670, '10213', '2026-11-02 07:08:01', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1671, '100237', '2026-11-02 07:08:16', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1672, '10493', '2026-11-02 07:08:18', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1673, '100323', '2026-11-02 07:08:21', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1674, '10008', '2026-11-02 07:08:43', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1675, '10027', '2026-11-02 07:09:09', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1676, '10267', '2026-11-02 07:09:28', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1677, '10004', '2026-11-02 07:09:53', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1678, '10003', '2026-11-02 07:09:56', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1679, '10276', '2026-11-02 07:10:35', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1680, '10263', '2026-11-02 07:10:41', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1681, '10225', '2026-11-02 07:10:56', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1682, '10026', '2026-11-02 07:11:03', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1683, '10250', '2026-11-02 07:11:13', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1684, '202609018', '2026-11-02 07:11:17', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1685, '202609012', '2026-11-02 07:11:19', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1686, '202609013', '2026-11-02 07:11:21', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1687, '202609020', '2026-11-02 07:11:24', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1688, '10459', '2026-11-02 07:11:27', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1689, '10128', '2026-11-02 07:11:39', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1690, '10135', '2026-11-02 07:11:57', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1691, '10052', '2026-11-02 07:12:19', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1692, '10001', '2026-11-02 07:12:43', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1693, '10487', '2026-11-02 07:13:00', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1694, '10029', '2026-11-02 07:13:06', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1695, '10232', '2026-11-02 07:13:12', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1696, '10224', '2026-11-02 07:13:22', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1697, '10256', '2026-11-02 07:13:33', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1698, '10254', '2026-11-02 07:13:36', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1699, '100348', '2026-11-02 07:13:43', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1700, '10036', '2026-11-02 07:13:47', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1701, '10013', '2026-11-02 07:14:01', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1702, '10023', '2026-11-02 07:14:04', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1703, '10273', '2026-11-02 07:14:07', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1704, '10012', '2026-11-02 07:14:09', '2026-11-01 22:37:35', '2026-11-01 22:37:35'),
(1705, '10006', '2026-11-02 07:14:37', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1706, '10042', '2026-11-02 07:15:05', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1707, '10117', '2026-11-02 07:15:07', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1708, '10259', '2026-11-02 07:15:11', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1709, '202610003', '2026-11-02 07:16:09', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1710, '10108', '2026-11-02 07:16:26', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1711, '10019', '2026-11-02 07:16:37', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1712, '10011', '2026-11-02 07:17:53', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1713, '10054', '2026-11-02 07:20:56', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1714, '202610017', '2026-11-02 07:31:57', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1715, '10018', '2026-11-02 07:33:37', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1716, '10046', '2026-11-02 07:37:30', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1717, '10024', '2026-11-02 07:40:43', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1718, '200608001', '2026-11-02 07:58:36', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1719, '10495', '2026-11-02 07:58:44', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1720, '10488', '2026-11-02 08:01:27', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1721, '10133', '2026-11-02 08:01:34', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1722, '10044', '2026-11-02 08:10:20', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1723, '202510001', '2026-11-02 08:13:22', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1724, '202507001', '2026-11-02 08:21:58', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1725, '202411001', '2026-11-02 08:28:21', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1726, '10485', '2026-11-02 08:29:59', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1727, '10125', '2026-11-02 08:34:16', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1728, '10126', '2026-11-02 08:46:19', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1729, '10047', '2026-11-02 09:01:23', '2026-11-01 22:37:36', '2026-11-01 22:37:36'),
(1730, '19342', '2026-10-31 15:59:17', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1731, '20957', '2026-10-31 15:59:23', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1732, '21545', '2026-10-31 15:59:34', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1733, '19767', '2026-10-31 15:59:37', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1734, '19080', '2026-10-31 15:59:40', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1735, '20954', '2026-10-31 15:59:49', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1736, '20947', '2026-10-31 15:59:51', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1737, '19477', '2026-10-31 16:00:02', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1738, '20416', '2026-10-31 16:00:05', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1739, '19769', '2026-10-31 16:00:10', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1740, '21153', '2026-10-31 16:00:13', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1741, '19768', '2026-10-31 16:00:19', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1742, '21542', '2026-10-31 16:00:26', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1743, '19354', '2026-10-31 16:00:31', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1744, '19426', '2026-10-31 16:00:35', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1745, '21330', '2026-10-31 16:00:40', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1746, '19341', '2026-10-31 16:00:43', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1747, '21392', '2026-10-31 16:00:47', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1748, '20218', '2026-10-31 16:00:49', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1749, '21332', '2026-10-31 16:00:52', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1750, '19298', '2026-10-31 16:00:55', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1751, '21216', '2026-10-31 16:00:58', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1752, '20753', '2026-10-31 16:01:00', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1753, '19314', '2026-10-31 16:01:05', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1754, '21008', '2026-10-31 16:01:15', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1755, '19312', '2026-10-31 16:01:26', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1756, '20855', '2026-10-31 16:01:32', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1757, '21074', '2026-10-31 16:01:37', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1758, '19232', '2026-10-31 16:01:41', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1759, '21233', '2026-10-31 16:01:45', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1760, '21334', '2026-10-31 16:01:48', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1761, '20412', '2026-10-31 16:01:51', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1762, '19242', '2026-10-31 16:01:55', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1763, '20335', '2026-10-31 16:02:54', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1764, '21310', '2026-10-31 16:03:24', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1765, '19736', '2026-10-31 16:04:38', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1766, '19278', '2026-10-31 16:04:46', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1767, '19767', '2026-11-02 06:19:46', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1768, '21334', '2026-11-02 06:23:19', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1769, '19764', '2026-11-02 06:30:50', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1770, '19341', '2026-11-02 06:35:41', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1771, '21405', '2026-11-02 06:41:34', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1772, '19286', '2026-11-02 06:42:56', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1773, '20533', '2026-11-02 06:44:20', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1774, '20416', '2026-11-02 06:46:32', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1775, '19433', '2026-11-02 06:47:19', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1776, '20274', '2026-11-02 06:49:44', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1777, '19312', '2026-11-02 06:50:58', '2026-11-01 22:37:59', '2026-11-01 22:37:59');
INSERT INTO `finger_logs` (`id`, `pin`, `scan_time`, `created_at`, `updated_at`) VALUES
(1778, '21074', '2026-11-02 06:53:37', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1779, '21233', '2026-11-02 06:55:09', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1780, '20218', '2026-11-02 06:56:36', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1781, '19242', '2026-11-02 06:56:46', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1782, '19426', '2026-11-02 06:57:12', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1783, '19266', '2026-11-02 06:58:02', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1784, '19236', '2026-11-02 06:58:45', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1785, '19314', '2026-11-02 07:00:17', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1786, '20957', '2026-11-02 07:03:05', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1787, '20753', '2026-11-02 07:04:48', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1788, '21538', '2026-11-02 07:04:55', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1789, '20981', '2026-11-02 07:07:14', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1790, '19232', '2026-11-02 07:07:27', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1791, '19477', '2026-11-02 07:07:30', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1792, '21545', '2026-11-02 07:07:33', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1793, '21310', '2026-11-02 07:07:49', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1794, '19239', '2026-11-02 07:08:15', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1795, '20855', '2026-11-02 07:08:21', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1796, '202405038', '2026-11-02 07:08:27', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1797, '19769', '2026-11-02 07:08:34', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1798, '20018', '2026-11-02 07:09:17', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1799, '21008', '2026-11-02 07:09:28', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1800, '20947', '2026-11-02 07:10:20', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1801, '19298', '2026-11-02 07:10:28', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1802, '19079', '2026-11-02 07:10:34', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1803, '18035', '2026-11-02 07:10:46', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1804, '20601', '2026-11-02 07:11:03', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1805, '21330', '2026-11-02 07:11:10', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1806, '19077', '2026-11-02 07:11:45', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1807, '19244', '2026-11-02 07:11:52', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1808, '19278', '2026-11-02 07:12:31', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1809, '21332', '2026-11-02 07:13:06', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1810, '20412', '2026-11-02 07:13:12', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1811, '20208', '2026-11-02 07:13:29', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1812, '19342', '2026-11-02 07:13:37', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1813, '19453', '2026-11-02 07:13:49', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1814, '21542', '2026-11-02 07:13:57', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1815, '21153', '2026-11-02 07:14:01', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1816, '19768', '2026-11-02 07:14:13', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1817, '20965', '2026-11-02 07:14:21', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1818, '20954', '2026-11-02 07:14:27', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1819, '21216', '2026-11-02 07:14:33', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1820, '21400', '2026-11-02 07:14:40', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1821, '19736', '2026-11-02 07:14:44', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1822, '19662', '2026-11-02 07:14:55', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1823, '20335', '2026-11-02 07:22:14', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1824, '19354', '2026-11-02 08:25:45', '2026-11-01 22:37:59', '2026-11-01 22:37:59'),
(1825, '30102', '2026-11-02 16:11:46', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1826, '10270', '2026-11-02 16:15:38', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1827, '10111', '2026-11-02 16:16:37', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1828, '10129', '2026-11-02 16:16:45', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1829, '10056', '2026-11-02 16:16:48', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1830, '30102', '2026-11-02 16:11:46', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1831, '10035', '2026-11-02 16:16:51', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1832, '10036', '2026-11-02 16:16:53', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1833, '10244', '2026-11-02 16:16:58', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1834, '10213', '2026-11-02 16:17:01', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1835, '10459', '2026-11-02 16:17:03', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1836, '202609013', '2026-11-02 16:17:05', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1837, '202609021', '2026-11-02 16:17:07', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1838, '10001', '2026-11-02 16:17:10', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1839, '10011', '2026-11-02 16:17:12', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1840, '10011', '2026-11-02 16:17:12', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1841, '202609016', '2026-11-02 16:17:15', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1842, '202609016', '2026-11-02 16:17:15', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1843, '10027', '2026-11-02 16:17:17', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1844, '10027', '2026-11-02 16:17:17', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1845, '10052', '2026-11-02 16:17:20', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1846, '10252', '2026-11-02 16:17:23', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1847, '10026', '2026-11-02 16:17:27', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1848, '10252', '2026-11-02 16:17:23', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1849, '10021', '2026-11-02 16:17:31', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1850, '100233', '2026-11-02 16:17:34', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1851, '100233', '2026-11-02 16:17:34', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1852, '10042', '2026-11-02 16:17:37', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1853, '10042', '2026-11-02 16:17:37', '2026-11-03 19:24:57', '2026-11-03 19:24:57'),
(1854, '10263', '2026-11-02 16:17:39', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1855, '10263', '2026-11-02 16:17:39', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1856, '10135', '2026-11-02 16:17:41', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1857, '10135', '2026-11-02 16:17:41', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1858, '10486', '2026-11-02 16:17:45', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1859, '10492', '2026-11-02 16:17:48', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1860, '10492', '2026-11-02 16:17:48', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1861, '10493', '2026-11-02 16:17:50', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1862, '10493', '2026-11-02 16:17:50', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1863, '10119', '2026-11-02 16:17:53', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1864, '10119', '2026-11-02 16:17:53', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1865, '10066', '2026-11-02 16:17:59', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1866, '10030', '2026-11-02 16:18:02', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1867, '10030', '2026-11-02 16:18:02', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1868, '100231', '2026-11-02 16:18:07', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1869, '100231', '2026-11-02 16:18:07', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1870, '10023', '2026-11-02 16:18:09', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1871, '10023', '2026-11-02 16:18:09', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1872, '202609011', '2026-11-02 16:18:17', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1873, '202609011', '2026-11-02 16:18:17', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1874, '10246', '2026-11-02 16:18:20', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1875, '10246', '2026-11-02 16:18:20', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1876, '10118', '2026-11-02 16:18:25', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1877, '10118', '2026-11-02 16:18:25', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1878, '10020', '2026-11-02 16:18:29', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1879, '10020', '2026-11-02 16:18:29', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1880, '10225', '2026-11-02 16:18:31', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1881, '10225', '2026-11-02 16:18:31', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1882, '10452', '2026-11-02 16:18:34', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1883, '10452', '2026-11-02 16:18:34', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1884, '10054', '2026-11-02 16:18:41', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1885, '10054', '2026-11-02 16:18:41', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1886, '202609012', '2026-11-02 16:18:43', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1887, '202609012', '2026-11-02 16:18:43', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1888, '202609018', '2026-11-02 16:18:46', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1889, '202609018', '2026-11-02 16:18:46', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1890, '10117', '2026-11-02 16:18:49', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1891, '10117', '2026-11-02 16:18:49', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1892, '202609027', '2026-11-02 16:18:51', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1893, '202609027', '2026-11-02 16:18:51', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1894, '10128', '2026-11-02 16:18:53', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1895, '10128', '2026-11-02 16:18:53', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1896, '10259', '2026-11-02 16:18:56', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1897, '10259', '2026-11-02 16:18:56', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1898, '10315', '2026-11-02 16:19:01', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1899, '10315', '2026-11-02 16:19:01', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1900, '202609030', '2026-11-02 16:19:04', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1901, '202609030', '2026-11-02 16:19:04', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1902, '10254', '2026-11-02 16:19:07', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1903, '10254', '2026-11-02 16:19:07', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1904, '10006', '2026-11-02 16:19:10', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1905, '10006', '2026-11-02 16:19:10', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1906, '10038', '2026-11-02 16:19:13', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1907, '10038', '2026-11-02 16:19:13', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1908, '100348', '2026-11-02 16:19:17', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1909, '100348', '2026-11-02 16:19:17', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1910, '10029', '2026-11-02 16:19:20', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1911, '10029', '2026-11-02 16:19:20', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1912, '10138', '2026-11-02 16:19:24', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1913, '10138', '2026-11-02 16:19:24', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1914, '10014', '2026-11-02 16:19:33', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1915, '10018', '2026-11-02 16:19:39', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1916, '10018', '2026-11-02 16:19:39', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1917, '100237', '2026-11-02 16:20:16', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1918, '100237', '2026-11-02 16:20:16', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1919, '10019', '2026-11-02 16:20:33', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1920, '10019', '2026-11-02 16:20:33', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1921, '10267', '2026-11-02 16:20:58', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1922, '10267', '2026-11-02 16:20:58', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1923, '10173', '2026-11-02 16:22:01', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1924, '10232', '2026-11-02 16:22:06', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1925, '10232', '2026-11-02 16:22:06', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1926, '10242', '2026-11-02 16:23:34', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1927, '10242', '2026-11-02 16:23:34', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1928, '10028', '2026-11-02 16:23:52', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1929, '10028', '2026-11-02 16:23:52', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1930, '10125', '2026-11-02 16:55:44', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1931, '10125', '2026-11-02 16:55:44', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1932, '10046', '2026-11-02 16:55:49', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1933, '10046', '2026-11-02 16:55:49', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1934, '10485', '2026-11-02 17:03:26', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1935, '10485', '2026-11-02 17:03:26', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1936, '10495', '2026-11-02 17:03:30', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1937, '10495', '2026-11-02 17:03:30', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1938, '10024', '2026-11-02 17:03:34', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1939, '10024', '2026-11-02 17:03:34', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1940, '10488', '2026-11-02 17:03:37', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1941, '10488', '2026-11-02 17:03:37', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1942, '202610017', '2026-11-02 17:03:42', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1943, '10133', '2026-11-02 17:05:39', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1944, '10133', '2026-11-02 17:05:39', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1945, '202510001', '2026-11-02 17:14:29', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1946, '202510001', '2026-11-02 17:14:29', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1947, '200608001', '2026-11-02 17:15:03', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1948, '200608001', '2026-11-02 17:15:03', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1949, '10485', '2026-11-02 17:15:05', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1950, '10485', '2026-11-02 17:15:05', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1951, '10126', '2026-11-02 17:15:10', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1952, '10126', '2026-11-02 17:15:10', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1953, '10044', '2026-11-02 17:18:54', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1954, '10044', '2026-11-02 17:18:54', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1955, '202411001', '2026-11-02 17:30:06', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1956, '202411001', '2026-11-02 17:30:06', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1957, '202507001', '2026-11-02 17:30:21', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1958, '202507001', '2026-11-02 17:30:21', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1959, '202610003', '2026-11-02 17:30:25', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1960, '202610003', '2026-11-02 17:30:25', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1961, '10047', '2026-11-02 17:48:45', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1962, '10047', '2026-11-02 17:48:45', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1963, '202610006', '2026-11-02 17:59:21', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1964, '202610006', '2026-11-02 17:59:21', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1965, '202610007', '2026-11-02 17:59:26', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1966, '202610007', '2026-11-02 17:59:26', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1967, '202610013', '2026-11-02 17:59:33', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1968, '202610013', '2026-11-02 17:59:33', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1969, '10177', '2026-11-02 17:59:36', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1970, '10177', '2026-11-02 17:59:36', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1971, '202609003', '2026-11-02 17:59:39', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1972, '202609003', '2026-11-02 17:59:39', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1973, '10162', '2026-11-02 17:59:41', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1974, '10162', '2026-11-02 17:59:41', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1975, '202610008', '2026-11-02 17:59:44', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1976, '202610008', '2026-11-02 17:59:44', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1977, '10271', '2026-11-02 17:59:46', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1978, '10271', '2026-11-02 17:59:46', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1979, '10013', '2026-11-02 17:59:48', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1980, '10013', '2026-11-02 17:59:48', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1981, '10211', '2026-11-02 17:59:51', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1982, '10211', '2026-11-02 17:59:51', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1983, '202609009', '2026-11-02 17:59:53', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1984, '202609009', '2026-11-02 17:59:53', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1985, '202609002', '2026-11-02 17:59:55', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1986, '202609002', '2026-11-02 17:59:55', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1987, '10144', '2026-11-02 17:59:57', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1988, '10144', '2026-11-02 17:59:57', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1989, '10008', '2026-11-02 18:00:01', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1990, '10008', '2026-11-02 18:00:01', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1991, '10012', '2026-11-02 18:00:04', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1992, '10012', '2026-11-02 18:00:04', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1993, '10005', '2026-11-02 18:00:06', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1994, '10005', '2026-11-02 18:00:06', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1995, '10250', '2026-11-02 18:00:08', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1996, '10250', '2026-11-02 18:00:08', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1997, '10256', '2026-11-02 18:00:12', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1998, '10256', '2026-11-02 18:00:12', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(1999, '10113', '2026-11-02 18:00:17', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(2000, '10113', '2026-11-02 18:00:17', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(2001, '10072', '2026-11-02 18:00:19', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(2002, '10072', '2026-11-02 18:00:19', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(2003, '202609008', '2026-11-02 18:00:21', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(2004, '202609008', '2026-11-02 18:00:21', '2026-11-03 19:24:58', '2026-11-03 19:24:58'),
(2005, '10207', '2026-11-02 18:00:23', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2006, '10207', '2026-11-02 18:00:23', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2007, '202608004', '2026-11-02 18:00:26', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2008, '202608004', '2026-11-02 18:00:26', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2009, '202610004', '2026-11-02 18:00:30', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2010, '202610004', '2026-11-02 18:00:30', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2011, '10082', '2026-11-02 18:00:36', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2012, '10082', '2026-11-02 18:00:36', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2013, '10178', '2026-11-02 18:00:40', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2014, '10178', '2026-11-02 18:00:40', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2015, '202610002', '2026-11-02 18:00:45', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2016, '202610002', '2026-11-02 18:00:45', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2017, '10190', '2026-11-02 18:00:47', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2018, '10190', '2026-11-02 18:00:47', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2019, '2026090010', '2026-11-02 18:00:49', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2020, '2026090010', '2026-11-02 18:00:49', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2021, '10143', '2026-11-02 18:00:52', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2022, '10143', '2026-11-02 18:00:52', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2023, '10487', '2026-11-02 18:00:54', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2024, '10487', '2026-11-02 18:00:54', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2025, '202610011', '2026-11-02 18:00:56', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2026, '202610011', '2026-11-02 18:00:56', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2027, '202609001', '2026-11-02 18:00:58', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2028, '202609001', '2026-11-02 18:00:58', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2029, '10097', '2026-11-02 18:01:02', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2030, '10097', '2026-11-02 18:01:02', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2031, '10093', '2026-11-02 18:01:04', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2032, '202609007', '2026-11-02 18:01:06', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2033, '202609007', '2026-11-02 18:01:06', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2034, '10091', '2026-11-02 18:01:13', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2035, '202610010', '2026-11-02 18:01:15', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2036, '202610010', '2026-11-02 18:01:15', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2037, '103333', '2026-11-02 18:01:17', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2038, '103333', '2026-11-02 18:01:17', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2039, '202609005', '2026-11-02 18:01:27', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2040, '202609005', '2026-11-02 18:01:27', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2041, '10453', '2026-11-02 18:01:38', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2042, '10453', '2026-11-02 18:01:38', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2043, '10165', '2026-11-02 18:01:41', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2044, '10165', '2026-11-02 18:01:41', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2045, '202610016', '2026-11-02 18:01:45', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2046, '10276', '2026-11-02 18:01:47', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2047, '10084', '2026-11-02 18:01:53', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2048, '10084', '2026-11-02 18:01:53', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2049, '10105', '2026-11-02 18:01:56', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2050, '10105', '2026-11-02 18:01:56', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2051, '10092', '2026-11-02 18:01:59', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2052, '10092', '2026-11-02 18:01:59', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2053, '100323', '2026-11-02 18:02:01', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2054, '100323', '2026-11-02 18:02:01', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2055, '10017', '2026-11-02 18:02:04', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2056, '10017', '2026-11-02 18:02:04', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2057, '202608003', '2026-11-02 18:02:06', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2058, '202608003', '2026-11-02 18:02:06', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2059, '10209', '2026-11-02 18:02:08', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2060, '10209', '2026-11-02 18:02:08', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2061, '10086', '2026-11-02 18:02:11', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2062, '10086', '2026-11-02 18:02:11', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2063, '10491', '2026-11-02 18:02:13', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2064, '10154', '2026-11-02 18:02:15', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2065, '10154', '2026-11-02 18:02:15', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2066, '10188', '2026-11-02 18:02:20', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2067, '10188', '2026-11-02 18:02:20', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2068, '10073', '2026-11-02 18:02:25', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2069, '10073', '2026-11-02 18:02:25', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2070, '10069', '2026-11-02 18:02:28', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2071, '10069', '2026-11-02 18:02:28', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2072, '202610012', '2026-11-02 18:02:31', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2073, '202610012', '2026-11-02 18:02:31', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2074, '202609026', '2026-11-02 18:02:34', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2075, '10010', '2026-11-02 18:02:37', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2076, '10010', '2026-11-02 18:02:37', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2077, '202610001', '2026-11-02 18:02:40', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2078, '202610001', '2026-11-02 18:02:40', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2079, '10061', '2026-11-02 18:02:43', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2080, '10061', '2026-11-02 18:02:43', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2081, '202610009', '2026-11-02 18:02:46', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2082, '202610009', '2026-11-02 18:02:46', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2083, '202610015', '2026-11-02 18:02:50', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2084, '202610015', '2026-11-02 18:02:50', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2085, '10146', '2026-11-02 18:02:55', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2086, '10146', '2026-11-02 18:02:55', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2087, '10079', '2026-11-02 18:02:58', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2088, '10079', '2026-11-02 18:02:58', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2089, '10490', '2026-11-02 18:03:00', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2090, '10090', '2026-11-02 18:03:03', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2091, '10090', '2026-11-02 18:03:03', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2092, '10068', '2026-11-02 18:03:07', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2093, '10068', '2026-11-02 18:03:07', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2094, '10157', '2026-11-02 18:03:10', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2095, '10157', '2026-11-02 18:03:10', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2096, '202608010', '2026-11-02 18:03:12', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2097, '202608010', '2026-11-02 18:03:12', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2098, '10273', '2026-11-02 18:03:16', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2099, '10224', '2026-11-02 18:03:19', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2100, '10224', '2026-11-02 18:03:19', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2101, '10497', '2026-11-02 18:03:21', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2102, '10497', '2026-11-02 18:03:21', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2103, '10108', '2026-11-02 18:03:37', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2104, '10108', '2026-11-02 18:03:37', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2105, '10016', '2026-11-02 18:03:43', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2106, '10016', '2026-11-02 18:03:43', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2107, '10004', '2026-11-02 18:03:52', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2108, '10004', '2026-11-02 18:03:52', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2109, '10057', '2026-11-02 18:06:05', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2110, '10057', '2026-11-02 18:06:05', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2111, '10057', '2026-11-03 06:21:32', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2112, '10057', '2026-11-03 06:21:32', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2113, '10075', '2026-11-03 06:22:06', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2114, '10075', '2026-11-03 06:22:06', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2115, '10069', '2026-11-03 06:22:11', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2116, '10069', '2026-11-03 06:22:11', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2117, '10490', '2026-11-03 06:22:19', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2118, '202609008', '2026-11-03 06:22:24', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2119, '202609008', '2026-11-03 06:22:24', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2120, '10086', '2026-11-03 06:28:00', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2121, '10086', '2026-11-03 06:28:00', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2122, '202609007', '2026-11-03 06:28:48', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2123, '202609007', '2026-11-03 06:28:48', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2124, '10178', '2026-11-03 06:28:52', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2125, '10178', '2026-11-03 06:28:52', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2126, '202609002', '2026-11-03 06:29:29', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2127, '202609002', '2026-11-03 06:29:29', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2128, '10090', '2026-11-03 06:30:47', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2129, '10090', '2026-11-03 06:30:47', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2130, '10084', '2026-11-03 06:32:52', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2131, '10084', '2026-11-03 06:32:52', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2132, '10061', '2026-11-03 06:33:24', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2133, '10061', '2026-11-03 06:33:24', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2134, '202610006', '2026-11-03 06:33:39', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2135, '202610006', '2026-11-03 06:33:39', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2136, '202609005', '2026-11-03 06:34:23', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2137, '202609005', '2026-11-03 06:34:23', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2138, '202610001', '2026-11-03 06:34:50', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2139, '202610001', '2026-11-03 06:34:50', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2140, '202610010', '2026-11-03 06:34:54', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2141, '202608004', '2026-11-03 06:37:37', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2142, '10113', '2026-11-03 06:39:05', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2143, '202610009', '2026-11-03 06:41:33', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2144, '202610008', '2026-11-03 06:41:39', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2145, '202608003', '2026-11-03 06:41:42', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2146, '100233', '2026-11-03 06:41:46', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2147, '10271', '2026-11-03 06:42:28', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2148, '10119', '2026-11-03 06:44:23', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2149, '202610015', '2026-11-03 06:44:31', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2150, '202610012', '2026-11-03 06:45:43', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2151, '10209', '2026-11-03 06:46:32', '2026-11-03 19:24:59', '2026-11-03 19:24:59'),
(2152, '10270', '2026-11-03 06:46:50', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2153, '10017', '2026-11-03 06:47:26', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2154, '202610002', '2026-11-03 06:47:33', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2155, '10066', '2026-11-03 06:48:08', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2156, '202609016', '2026-11-03 06:48:15', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2157, '10111', '2026-11-03 06:48:21', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2158, '202610016', '2026-11-03 06:48:31', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2159, '202609003', '2026-11-03 06:50:01', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2160, '10188', '2026-11-03 06:50:04', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2161, '202610004', '2026-11-03 06:50:13', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2162, '10144', '2026-11-03 06:51:15', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2163, '10143', '2026-11-03 06:51:19', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2164, '202608010', '2026-11-03 06:51:24', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2165, '10157', '2026-11-03 06:51:28', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2166, '202609001', '2026-11-03 06:51:37', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2167, '10452', '2026-11-03 06:51:41', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2168, '10093', '2026-11-03 06:51:48', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2169, '10154', '2026-11-03 06:51:53', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2170, '202610011', '2026-11-03 06:52:25', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2171, '10097', '2026-11-03 06:52:30', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2172, '10020', '2026-11-03 06:52:39', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2173, '30102', '2026-11-03 06:52:46', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2174, '10092', '2026-11-03 06:53:19', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2175, '10082', '2026-11-03 06:53:35', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2176, '10079', '2026-11-03 06:53:37', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2177, '10073', '2026-11-03 06:53:40', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2178, '10072', '2026-11-03 06:53:43', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2179, '10068', '2026-11-03 06:53:47', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2180, '10177', '2026-11-03 06:53:51', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2181, '10190', '2026-11-03 06:54:52', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2182, '10091', '2026-11-03 06:55:26', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2183, '10162', '2026-11-03 06:55:34', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2184, '10016', '2026-11-03 06:57:24', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2185, '10497', '2026-11-03 06:57:31', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2186, '10491', '2026-11-03 06:57:41', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2187, '10242', '2026-11-03 06:58:39', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2188, '10165', '2026-11-03 06:58:48', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2189, '10207', '2026-11-03 06:58:54', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2190, '202609009', '2026-11-03 06:59:00', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2191, '10146', '2026-11-03 06:59:28', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2192, '10105', '2026-11-03 07:00:13', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2193, '100231', '2026-11-03 07:00:25', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2194, '103333', '2026-11-03 07:00:28', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2195, '2026090010', '2026-11-03 07:00:35', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2196, '202610013', '2026-11-03 07:00:44', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2197, '10129', '2026-11-03 07:01:23', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2198, '10252', '2026-11-03 07:02:00', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2199, '10246', '2026-11-03 07:02:24', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2200, '10453', '2026-11-03 07:02:27', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2201, '10492', '2026-11-03 07:02:59', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2202, '202609011', '2026-11-03 07:03:56', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2203, '202609030', '2026-11-03 07:04:44', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2204, '10008', '2026-11-03 07:05:00', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2205, '10021', '2026-11-03 07:05:17', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2206, '10056', '2026-11-03 07:05:25', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2207, '10211', '2026-11-03 07:05:31', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2208, '202609021', '2026-11-03 07:05:43', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2209, '202609026', '2026-11-03 07:06:44', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2210, '10118', '2026-11-03 07:06:47', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2211, '10487', '2026-11-03 07:06:52', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2212, '10035', '2026-11-03 07:07:22', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2213, '10028', '2026-11-03 07:07:29', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2214, '10010', '2026-11-03 07:07:33', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2215, '10027', '2026-11-03 07:07:58', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2216, '10003', '2026-11-03 07:08:02', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2217, '10250', '2026-11-03 07:08:12', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2218, '10005', '2026-11-03 07:08:15', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2219, '10014', '2026-11-03 07:08:21', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2220, '10244', '2026-11-03 07:09:22', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2221, '10004', '2026-11-03 07:09:28', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2222, '10052', '2026-11-03 07:09:30', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2223, '10173', '2026-11-03 07:09:34', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2224, '10315', '2026-11-03 07:09:43', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2225, '10273', '2026-11-03 07:09:59', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2226, '10213', '2026-11-03 07:10:07', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2227, '10263', '2026-11-03 07:10:34', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2228, '10135', '2026-11-03 07:10:37', '2026-11-03 19:25:00', '2026-11-03 19:25:00'),
(2229, '202609027', '2026-11-03 07:10:40', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2230, '10036', '2026-11-03 07:10:43', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2231, '202609013', '2026-11-03 07:10:46', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2232, '202609020', '2026-11-03 07:10:51', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2233, '10225', '2026-11-03 07:10:59', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2234, '202609012', '2026-11-03 07:11:02', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2235, '202609018', '2026-11-03 07:11:05', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2236, '202609019', '2026-11-03 07:11:07', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2237, '100323', '2026-11-03 07:11:10', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2238, '10493', '2026-11-03 07:11:13', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2239, '10108', '2026-11-03 07:11:18', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2240, '10276', '2026-11-03 07:11:40', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2241, '10459', '2026-11-03 07:12:03', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2242, '10232', '2026-11-03 07:12:06', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2243, '100348', '2026-11-03 07:12:10', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2244, '10030', '2026-11-03 07:12:36', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2245, '10001', '2026-11-03 07:12:44', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2246, '10215', '2026-11-03 07:12:46', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2247, '10224', '2026-11-03 07:12:49', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2248, '10029', '2026-11-03 07:13:04', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2249, '10267', '2026-11-03 07:13:13', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2250, '10023', '2026-11-03 07:13:34', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2251, '10128', '2026-11-03 07:13:38', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2252, '10006', '2026-11-03 07:13:41', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2253, '10256', '2026-11-03 07:13:45', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2254, '10254', '2026-11-03 07:13:48', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2255, '100237', '2026-11-03 07:13:50', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2256, '10486', '2026-11-03 07:13:56', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2257, '10138', '2026-11-03 07:14:01', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2258, '10013', '2026-11-03 07:14:05', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2259, '10038', '2026-11-03 07:14:21', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2260, '10012', '2026-11-03 07:14:53', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2261, '10259', '2026-11-03 07:15:11', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2262, '10117', '2026-11-03 07:16:31', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2263, '10019', '2026-11-03 07:16:38', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2264, '10042', '2026-11-03 07:22:07', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2265, '10054', '2026-11-03 07:26:23', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2266, '10011', '2026-11-03 07:27:08', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2267, '202610017', '2026-11-03 07:34:45', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2268, '10046', '2026-11-03 07:37:48', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2269, '10018', '2026-11-03 07:39:07', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2270, '10024', '2026-11-03 07:39:41', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2271, '202510001', '2026-11-03 07:48:00', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2272, '10495', '2026-11-03 07:57:23', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2273, '202610003', '2026-11-03 08:01:59', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2274, '10488', '2026-11-03 08:03:14', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2275, '202507001', '2026-11-03 08:03:26', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2276, '200608001', '2026-11-03 08:05:30', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2277, '202411001', '2026-11-03 08:23:43', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2278, '10126', '2026-11-03 08:27:19', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2279, '10485', '2026-11-03 08:31:36', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2280, '10044', '2026-11-03 08:40:15', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2281, '10125', '2026-11-03 08:41:06', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2282, '10133', '2026-11-03 08:50:41', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2283, '10047', '2026-11-03 09:12:34', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2284, '30102', '2026-11-03 16:11:16', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2285, '10028', '2026-11-03 16:14:37', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2286, '10119', '2026-11-03 16:16:05', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2287, '10270', '2026-11-03 16:16:11', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2288, '10242', '2026-11-03 16:16:15', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2289, '202609012', '2026-11-03 16:16:20', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2290, '202609018', '2026-11-03 16:16:22', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2291, '10213', '2026-11-03 16:16:27', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2292, '202609019', '2026-11-03 16:16:29', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2293, '10035', '2026-11-03 16:16:31', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2294, '202609027', '2026-11-03 16:16:34', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2295, '10459', '2026-11-03 16:16:36', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2296, '10042', '2026-11-03 16:16:38', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2297, '10252', '2026-11-03 16:16:41', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2298, '10111', '2026-11-03 16:16:43', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2299, '202609013', '2026-11-03 16:16:47', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2300, '10244', '2026-11-03 16:16:49', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2301, '10001', '2026-11-03 16:16:52', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2302, '10036', '2026-11-03 16:16:54', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2303, '10215', '2026-11-03 16:17:02', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2304, '10271', '2026-11-03 16:17:04', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2305, '10225', '2026-11-03 16:17:07', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2306, '10129', '2026-11-03 16:17:11', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2307, '10486', '2026-11-03 16:17:14', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2308, '10492', '2026-11-03 16:17:20', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2309, '10493', '2026-11-03 16:17:26', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2310, '100233', '2026-11-03 16:17:29', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2311, '202609020', '2026-11-03 16:17:31', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2312, '10056', '2026-11-03 16:17:34', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2313, '202609016', '2026-11-03 16:17:36', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2314, '10452', '2026-11-03 16:17:43', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2315, '10052', '2026-11-03 16:17:50', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2316, '10030', '2026-11-03 16:17:55', '2026-11-03 19:25:01', '2026-11-03 19:25:01'),
(2317, '10118', '2026-11-03 16:17:59', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2318, '10263', '2026-11-03 16:18:01', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2319, '10135', '2026-11-03 16:18:04', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2320, '10246', '2026-11-03 16:18:08', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2321, '10254', '2026-11-03 16:18:25', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2322, '10259', '2026-11-03 16:18:29', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2323, '202609030', '2026-11-03 16:18:36', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2324, '10117', '2026-11-03 16:18:41', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2325, '100348', '2026-11-03 16:18:43', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2326, '202609021', '2026-11-03 16:18:46', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2327, '10011', '2026-11-03 16:18:55', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2328, '10038', '2026-11-03 16:18:59', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2329, '202609011', '2026-11-03 16:19:15', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2330, '10315', '2026-11-03 16:19:19', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2331, '10138', '2026-11-03 16:19:54', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2332, '10018', '2026-11-03 16:19:57', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2333, '10029', '2026-11-03 16:20:01', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2334, '10173', '2026-11-03 16:20:07', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2335, '10054', '2026-11-03 16:20:59', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2336, '10014', '2026-11-03 16:22:26', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2337, '10126', '2026-11-03 16:53:06', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2338, '202510001', '2026-11-03 16:57:11', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2339, '10488', '2026-11-03 16:57:16', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2340, '10495', '2026-11-03 16:57:42', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2341, '200608001', '2026-11-03 16:57:46', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2342, '10485', '2026-11-03 16:57:48', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2343, '10024', '2026-11-03 16:57:54', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2344, '202610017', '2026-11-03 16:58:00', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2345, '10046', '2026-11-03 16:58:18', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2346, '10125', '2026-11-03 16:58:26', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2347, '10133', '2026-11-03 17:08:21', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2348, '10044', '2026-11-03 17:14:43', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2349, '202411001', '2026-11-03 17:48:21', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2350, '202507001', '2026-11-03 17:48:25', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2351, '202610003', '2026-11-03 17:48:34', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2352, '10047', '2026-11-03 17:54:01', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2353, '10250', '2026-11-03 18:00:11', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2354, '202609026', '2026-11-03 18:00:15', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2355, '10013', '2026-11-03 18:00:17', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2356, '10012', '2026-11-03 18:00:20', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2357, '10003', '2026-11-03 18:00:22', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2358, '10010', '2026-11-03 18:00:26', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2359, '10256', '2026-11-03 18:00:28', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2360, '10005', '2026-11-03 18:00:31', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2361, '100231', '2026-11-03 18:00:34', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2362, '10066', '2026-11-03 18:00:36', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2363, '10113', '2026-11-03 18:00:38', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2364, '10273', '2026-11-03 18:00:41', '2026-11-03 19:25:02', '2026-11-03 19:25:02');
INSERT INTO `finger_logs` (`id`, `pin`, `scan_time`, `created_at`, `updated_at`) VALUES
(2365, '10004', '2026-11-03 18:00:48', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2366, '10453', '2026-11-03 18:00:50', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2367, '10020', '2026-11-03 18:00:56', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2368, '10072', '2026-11-03 18:00:59', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2369, '10224', '2026-11-03 18:01:01', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2370, '202609003', '2026-11-03 18:01:03', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2371, '10190', '2026-11-03 18:01:05', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2372, '103333', '2026-11-03 18:01:09', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2373, '10177', '2026-11-03 18:01:14', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2374, '10162', '2026-11-03 18:01:16', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2375, '202608004', '2026-11-03 18:01:21', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2376, '10075', '2026-11-03 18:01:25', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2377, '10144', '2026-11-03 18:01:27', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2378, '202610004', '2026-11-03 18:01:29', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2379, '10276', '2026-11-03 18:01:34', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2380, '202610013', '2026-11-03 18:01:38', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2381, '10211', '2026-11-03 18:01:40', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2382, '202610010', '2026-11-03 18:01:47', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2383, '10097', '2026-11-03 18:01:49', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2384, '202610009', '2026-11-03 18:02:00', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2385, '10027', '2026-11-03 18:02:06', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2386, '10023', '2026-11-03 18:02:08', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2387, '10207', '2026-11-03 18:02:10', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2388, '10105', '2026-11-03 18:02:13', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2389, '10154', '2026-11-03 18:02:17', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2390, '10008', '2026-11-03 18:02:26', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2391, '10178', '2026-11-03 18:02:32', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2392, '202609008', '2026-11-03 18:02:36', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2393, '10143', '2026-11-03 18:02:39', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2394, '202609007', '2026-11-03 18:02:44', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2395, '202609002', '2026-11-03 18:02:46', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2396, '202610006', '2026-11-03 18:02:49', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2397, '10165', '2026-11-03 18:02:56', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2398, '10084', '2026-11-03 18:02:58', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2399, '10487', '2026-11-03 18:03:00', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2400, '202609009', '2026-11-03 18:03:09', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2401, '202610011', '2026-11-03 18:03:11', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2402, '202610001', '2026-11-03 18:03:15', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2403, '202610008', '2026-11-03 18:03:29', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2404, '10091', '2026-11-03 18:03:40', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2405, '202609001', '2026-11-03 18:03:42', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2406, '10082', '2026-11-03 18:03:47', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2407, '202610002', '2026-11-03 18:03:50', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2408, '10017', '2026-11-03 18:03:52', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2409, '10188', '2026-11-03 18:03:54', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2410, '10073', '2026-11-03 18:03:59', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2411, '202610016', '2026-11-03 18:04:03', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2412, '202608003', '2026-11-03 18:04:06', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2413, '10092', '2026-11-03 18:04:08', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2414, '2026090010', '2026-11-03 18:04:10', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2415, '10079', '2026-11-03 18:04:24', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2416, '202610015', '2026-11-03 18:04:30', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2417, '10497', '2026-11-03 18:04:32', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2418, '202610012', '2026-11-03 18:04:34', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2419, '10069', '2026-11-03 18:04:38', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2420, '10061', '2026-11-03 18:04:41', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2421, '10146', '2026-11-03 18:04:43', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2422, '10490', '2026-11-03 18:04:47', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2423, '10090', '2026-11-03 18:04:49', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2424, '10086', '2026-11-03 18:04:53', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2425, '10093', '2026-11-03 18:04:56', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2426, '10491', '2026-11-03 18:04:58', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2427, '10267', '2026-11-03 18:05:01', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2428, '10068', '2026-11-03 18:05:04', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2429, '10157', '2026-11-03 18:05:10', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2430, '202608010', '2026-11-03 18:05:17', '2026-11-03 19:25:02', '2026-11-03 19:25:02'),
(2431, '10209', '2026-11-03 18:05:22', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2432, '100237', '2026-11-03 18:05:25', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2433, '10016', '2026-11-03 18:05:28', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2434, '10021', '2026-11-03 18:05:30', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2435, '10108', '2026-11-03 18:05:35', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2436, '100323', '2026-11-03 18:05:41', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2437, '10128', '2026-11-03 18:05:44', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2438, '10057', '2026-11-03 18:05:49', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2439, '10019', '2026-11-03 18:06:28', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2440, '10057', '2026-11-04 05:49:08', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2441, '202609002', '2026-11-04 06:05:46', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2442, '10069', '2026-11-04 06:11:09', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2443, '10490', '2026-11-04 06:11:16', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2444, '202609008', '2026-11-04 06:17:05', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2445, '10075', '2026-11-04 06:17:43', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2446, '10086', '2026-11-04 06:26:43', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2447, '10177', '2026-11-04 06:28:47', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2448, '202609007', '2026-11-04 06:29:51', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2449, '10178', '2026-11-04 06:29:57', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2450, '202610001', '2026-11-04 06:30:28', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2451, '10113', '2026-11-04 06:31:13', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2452, '10066', '2026-11-04 06:31:16', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2453, '100233', '2026-11-04 06:31:32', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2454, '202610006', '2026-11-04 06:36:15', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2455, '202610007', '2026-11-04 06:36:18', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2456, '10090', '2026-11-04 06:37:53', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2457, '202610010', '2026-11-04 06:39:33', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2458, '10035', '2026-11-04 06:40:18', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2459, '202610015', '2026-11-04 06:41:34', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2460, '10271', '2026-11-04 06:43:06', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2461, '10061', '2026-11-04 06:44:01', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2462, '202608004', '2026-11-04 06:44:11', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2463, '10119', '2026-11-04 06:44:59', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2464, '202608003', '2026-11-04 06:45:09', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2465, '10144', '2026-11-04 06:46:25', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2466, '202610004', '2026-11-04 06:46:28', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2467, '10143', '2026-11-04 06:46:32', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2468, '10270', '2026-11-04 06:46:41', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2469, '202608010', '2026-11-04 06:47:18', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2470, '202610002', '2026-11-04 06:48:14', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2471, '202609005', '2026-11-04 06:48:16', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2472, '202610012', '2026-11-04 06:49:08', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2473, '202609016', '2026-11-04 06:50:02', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2474, '10072', '2026-11-04 06:50:52', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2475, '10068', '2026-11-04 06:50:56', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2476, '10073', '2026-11-04 06:51:00', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2477, '10092', '2026-11-04 06:51:25', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2478, '10082', '2026-11-04 06:51:28', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2479, '10093', '2026-11-04 06:51:42', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2480, '10084', '2026-11-04 06:51:46', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2481, '10017', '2026-11-04 06:51:50', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2482, '202610013', '2026-11-04 06:51:56', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2483, '10079', '2026-11-04 06:51:59', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2484, '202609003', '2026-11-04 06:52:03', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2485, '10190', '2026-11-04 06:52:06', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2486, '202610016', '2026-11-04 06:52:48', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2487, '10111', '2026-11-04 06:53:03', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2488, '202610011', '2026-11-04 06:53:23', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2489, '202610009', '2026-11-04 06:53:34', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2490, '103333', '2026-11-04 06:53:50', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2491, '10154', '2026-11-04 06:53:53', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2492, '10188', '2026-11-04 06:53:57', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2493, '30102', '2026-11-04 06:54:10', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2494, '10162', '2026-11-04 06:54:27', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2495, '10091', '2026-11-04 06:54:32', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2496, '202609001', '2026-11-04 06:54:39', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2497, '10105', '2026-11-04 06:54:51', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2498, '2026090010', '2026-11-04 06:54:55', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2499, '10097', '2026-11-04 06:55:30', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2500, '10157', '2026-11-04 06:55:49', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2501, '10209', '2026-11-04 06:55:52', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2502, '10491', '2026-11-04 06:57:16', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2503, '10165', '2026-11-04 06:57:20', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2504, '10207', '2026-11-04 06:57:32', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2505, '10242', '2026-11-04 06:57:39', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2506, '10497', '2026-11-04 06:57:54', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2507, '10146', '2026-11-04 06:58:30', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2508, '10129', '2026-11-04 07:01:54', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2509, '202609030', '2026-11-04 07:01:58', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2510, '10246', '2026-11-04 07:02:02', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2511, '202609009', '2026-11-04 07:02:11', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2512, '10211', '2026-11-04 07:02:14', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2513, '10030', '2026-11-04 07:02:43', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2514, '10056', '2026-11-04 07:02:45', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2515, '10486', '2026-11-04 07:02:48', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2516, '10492', '2026-11-04 07:02:53', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2517, '10453', '2026-11-04 07:02:55', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2518, '10252', '2026-11-04 07:03:12', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2519, '202609011', '2026-11-04 07:03:50', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2520, '10008', '2026-11-04 07:04:08', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2521, '10016', '2026-11-04 07:04:24', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2522, '10173', '2026-11-04 07:05:06', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2523, '10244', '2026-11-04 07:05:41', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2524, '10021', '2026-11-04 07:05:47', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2525, '10003', '2026-11-04 07:06:05', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2526, '202609021', '2026-11-04 07:06:25', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2527, '10020', '2026-11-04 07:06:41', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2528, '10118', '2026-11-04 07:06:48', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2529, '10452', '2026-11-04 07:07:17', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2530, '10026', '2026-11-04 07:08:35', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2531, '10052', '2026-11-04 07:09:01', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2532, '10027', '2026-11-04 07:09:07', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2533, '10213', '2026-11-04 07:10:56', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2534, '202609027', '2026-11-04 07:11:06', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2535, '10135', '2026-11-04 07:11:17', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2536, '10263', '2026-11-04 07:11:19', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2537, '10004', '2026-11-04 07:11:24', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2538, '10005', '2026-11-04 07:11:28', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2539, '202609013', '2026-11-04 07:11:35', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2540, '202609020', '2026-11-04 07:11:37', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2541, '100231', '2026-11-04 07:11:40', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2542, '10036', '2026-11-04 07:11:43', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2543, '10459', '2026-11-04 07:11:46', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2544, '202609018', '2026-11-04 07:11:57', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2545, '202609019', '2026-11-04 07:11:59', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2546, '202609012', '2026-11-04 07:12:07', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2547, '10001', '2026-11-04 07:12:13', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2548, '10128', '2026-11-04 07:12:17', '2026-11-03 19:25:03', '2026-11-03 19:25:03'),
(2549, '10276', '2026-11-04 07:12:23', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2550, '10273', '2026-11-04 07:12:35', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2551, '10029', '2026-11-04 07:13:27', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2552, '10224', '2026-11-04 07:13:30', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2553, '10267', '2026-11-04 07:13:34', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2554, '10250', '2026-11-04 07:14:01', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2555, '202609026', '2026-11-04 07:14:05', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2556, '10138', '2026-11-04 07:14:09', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2557, '100323', '2026-11-04 07:14:12', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2558, '10232', '2026-11-04 07:14:16', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2559, '10028', '2026-11-04 07:14:19', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2560, '100237', '2026-11-04 07:14:21', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2561, '10012', '2026-11-04 07:14:24', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2562, '10011', '2026-11-04 07:14:27', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2563, '10013', '2026-11-04 07:14:29', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2564, '10256', '2026-11-04 07:14:32', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2565, '10225', '2026-11-04 07:14:34', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2566, '10254', '2026-11-04 07:14:37', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2567, '100348', '2026-11-04 07:14:40', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2568, '10038', '2026-11-04 07:14:46', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2569, '10014', '2026-11-04 07:14:49', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2570, '10023', '2026-11-04 07:14:55', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2571, '10259', '2026-11-04 07:15:35', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2572, '10117', '2026-11-04 07:16:13', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2573, '10019', '2026-11-04 07:16:43', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2574, '10108', '2026-11-04 07:16:48', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2575, '10054', '2026-11-04 07:23:17', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2576, '10006', '2026-11-04 07:29:59', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2577, '10018', '2026-11-04 07:38:42', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2578, '10046', '2026-11-04 07:40:04', '2026-11-03 19:25:04', '2026-11-03 19:25:04'),
(2579, '10024', '2026-11-04 07:44:17', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2580, '202610017', '2026-11-04 07:44:22', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2581, '202610003', '2026-11-04 07:53:41', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2582, '10495', '2026-11-04 07:57:39', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2583, '10133', '2026-11-04 08:01:07', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2584, '200608001', '2026-11-04 08:05:28', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2585, '10488', '2026-11-04 08:05:34', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2586, '202510001', '2026-11-04 08:11:27', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2587, '202507001', '2026-11-04 08:24:21', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2588, '202411001', '2026-11-04 08:24:54', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2589, '10485', '2026-11-04 08:25:45', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2590, '10125', '2026-11-04 08:37:36', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2591, '10044', '2026-11-04 08:42:02', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2592, '10126', '2026-11-04 08:51:40', '2026-11-03 19:25:05', '2026-11-03 19:25:05'),
(2593, '10047', '2026-11-04 09:00:55', '2026-11-03 19:25:05', '2026-11-03 19:25:05');

-- --------------------------------------------------------

--
-- Struktur dari tabel `holidays`
--

CREATE TABLE `holidays` (
  `id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_national` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `holidays`
--

INSERT INTO `holidays` (`id`, `date`, `name`, `is_national`, `created_at`, `updated_at`) VALUES
(1, '2026-01-01', 'Tahun Baru Masehi', 1, '2026-10-25 22:54:49', '2026-10-25 22:54:49'),
(2, '2026-04-03', 'Wafat Isa Almasih', 1, '2026-10-25 22:54:49', '2026-10-25 22:54:49'),
(3, '2026-04-05', 'Paskah', 1, '2026-10-25 22:54:49', '2026-10-25 22:54:49'),
(4, '2026-05-01', 'Hari Buruh Internasional', 1, '2026-10-25 22:54:49', '2026-10-25 22:54:49'),
(5, '2026-05-14', 'Kenaikan Isa Almasih', 1, '2026-10-25 22:54:49', '2026-10-25 22:54:49'),
(6, '2026-06-01', 'Hari Lahir Pancasila', 1, '2026-10-25 22:54:49', '2026-10-25 22:54:49'),
(7, '2026-08-17', 'Hari Ulang Tahun Kemerdekaan Republik Indonesia', 1, '2026-10-25 22:54:49', '2026-10-25 22:54:49'),
(8, '2026-12-25', 'Hari Raya Natal', 1, '2026-10-25 22:54:49', '2026-10-25 22:54:49');

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `leave_requests`
--

CREATE TABLE `leave_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `type` enum('sakit','cuti','izin_setengah_hari') COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approval_note` text COLLATE utf8mb4_unicode_ci,
  `cancelled_by` bigint UNSIGNED DEFAULT NULL,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `cancel_reason` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `menus`
--

CREATE TABLE `menus` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `route` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `permission_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `menus`
--

INSERT INTO `menus` (`id`, `name`, `route`, `icon`, `order`, `permission_name`, `created_at`, `updated_at`) VALUES
(2, 'Profil Saya', '/settings/profile', 'user', 2, 'view-profile', '2026-10-20 22:50:56', '2026-10-30 01:44:33'),
(7, 'MASTER DATA', NULL, 'FILE', 3, 'manage-master-data', '2026-10-21 19:55:28', '2026-10-29 22:22:22'),
(8, 'HRIS', NULL, NULL, 7, 'manage-hris', '2026-10-22 20:09:03', '2026-10-29 22:23:36'),
(9, 'Produksi', NULL, NULL, 8, 'manage-produksi', '2026-10-26 02:39:22', '2026-10-29 22:23:45'),
(10, 'Data Pengguna', '/admin/users', 'users', 1, 'manage-users', '2026-10-29 22:13:21', '2026-10-30 01:44:33'),
(11, 'Data Peran', '/admin/roles', 'shield', 3, 'manage-roles', '2026-10-29 22:13:21', '2026-10-30 01:44:33'),
(12, 'Data Menu', '/admin/menus', 'menu', 4, 'manage-menus', '2026-10-29 22:13:21', '2026-10-30 01:44:33'),
(13, 'Data Submenu', '/admin/submenus', 'list', 5, 'manage-submenus', '2026-10-29 22:13:21', '2026-10-30 01:44:33'),
(14, 'Inventaris Aset', '/admin/assets', 'package', 6, 'manage-assets', '2026-10-29 22:13:21', '2026-10-30 01:44:33'),
(15, 'Penggajian', '/admin/payroll', 'banknote', 7, 'manage-payroll', '2026-10-30 01:44:33', '2026-10-30 01:44:33');

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2024_01_01_000000_create_passkeys_table', 1),
(5, '2025_08_14_170933_add_two_factor_columns_to_users_table', 1),
(6, '2026_01_27_000001_create_teams_table', 1),
(7, '2026_01_27_000002_add_current_team_id_to_users_table', 1),
(8, '2026_10_21_045516_create_permission_tables', 2),
(9, '2026_10_21_050356_create_menus_table', 3),
(10, '2026_10_21_050406_create_sub_menus_table', 3),
(11, '2026_10_23_025859_create_employees_table', 4),
(12, '2026_10_23_035738_create_attendances_table', 5),
(13, '2026_10_26_024105_create_overtimes_table', 6),
(14, '2026_10_26_024106_create_overtime_employees_table', 6),
(15, '2026_10_26_030338_add_duration_to_overtime_employees_table', 7),
(19, '2026_10_26_041247_create_holidays_table', 8),
(20, '2026_10_26_081112_create_leave_requests_table', 9),
(21, '2026_10_26_091602_create_brands_table', 10),
(22, '2026_10_26_091604_create_size_runs_table', 10),
(23, '2026_10_26_093246_create_spks_table', 11),
(24, '2026_10_26_093247_create_spk_details_table', 11),
(25, '2026_10_26_100641_add_barcode_to_spk_details_table', 12),
(26, '2026_10_27_030643_add_status_and_department_to_spks_table', 13),
(27, '2026_10_27_030806_create_production_scans_table', 13),
(28, '2026_10_27_034216_create_defect_categories_table', 14),
(29, '2026_10_27_034218_create_production_defects_table', 14),
(30, '2026_10_27_043105_add_image_to_spks_table', 15),
(31, '2026_10_27_080702_create_zkteco_tables', 16),
(32, '2026_10_27_082352_create_finger_logs_table', 17),
(33, '2026_10_28_015910_add_created_by_to_overtimes_table', 18),
(34, '2026_10_29_030116_create_spk_batches_table', 19),
(35, '2026_10_29_030118_create_spk_batch_tracks_table', 19),
(36, '2026_10_29_034134_add_start_date_to_spks_table', 20),
(37, '2026_10_29_062650_create_production_dailies_table', 20),
(38, '2026_10_29_064645_add_sizes_to_spk_batches_table', 21),
(39, '2026_10_30_000001_create_asset_inventory_tables', 22),
(40, '2026_10_30_120000_create_payroll_tables', 23),
(41, '2026_10_30_130000_add_employee_overtime_rate_to_payroll_items', 24),
(42, '2026_11_02_110000_add_cancellation_to_leave_requests_table', 24),
(43, '2026_11_02_120000_add_view_employee_salary_permission', 25);

-- --------------------------------------------------------

--
-- Struktur dari tabel `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(2, 'App\\Models\\User', 13),
(2, 'App\\Models\\User', 14),
(2, 'App\\Models\\User', 15),
(2, 'App\\Models\\User', 16),
(2, 'App\\Models\\User', 17),
(2, 'App\\Models\\User', 18),
(2, 'App\\Models\\User', 19),
(2, 'App\\Models\\User', 20),
(2, 'App\\Models\\User', 21),
(2, 'App\\Models\\User', 22),
(2, 'App\\Models\\User', 23),
(2, 'App\\Models\\User', 24),
(2, 'App\\Models\\User', 25),
(2, 'App\\Models\\User', 26),
(2, 'App\\Models\\User', 27),
(2, 'App\\Models\\User', 28),
(2, 'App\\Models\\User', 29),
(2, 'App\\Models\\User', 30),
(2, 'App\\Models\\User', 31),
(2, 'App\\Models\\User', 32),
(2, 'App\\Models\\User', 33),
(2, 'App\\Models\\User', 34),
(2, 'App\\Models\\User', 35),
(2, 'App\\Models\\User', 36),
(2, 'App\\Models\\User', 37),
(2, 'App\\Models\\User', 38),
(2, 'App\\Models\\User', 39),
(2, 'App\\Models\\User', 40),
(2, 'App\\Models\\User', 41),
(2, 'App\\Models\\User', 42),
(2, 'App\\Models\\User', 43),
(2, 'App\\Models\\User', 44),
(2, 'App\\Models\\User', 45),
(2, 'App\\Models\\User', 46),
(2, 'App\\Models\\User', 47),
(2, 'App\\Models\\User', 48),
(2, 'App\\Models\\User', 49),
(2, 'App\\Models\\User', 50),
(2, 'App\\Models\\User', 51),
(2, 'App\\Models\\User', 52),
(2, 'App\\Models\\User', 53),
(2, 'App\\Models\\User', 54),
(2, 'App\\Models\\User', 55),
(2, 'App\\Models\\User', 56),
(2, 'App\\Models\\User', 57),
(2, 'App\\Models\\User', 58),
(2, 'App\\Models\\User', 59),
(2, 'App\\Models\\User', 60),
(2, 'App\\Models\\User', 61),
(2, 'App\\Models\\User', 62),
(2, 'App\\Models\\User', 63),
(2, 'App\\Models\\User', 64),
(2, 'App\\Models\\User', 65),
(2, 'App\\Models\\User', 66),
(2, 'App\\Models\\User', 67),
(2, 'App\\Models\\User', 68),
(2, 'App\\Models\\User', 69),
(2, 'App\\Models\\User', 70),
(2, 'App\\Models\\User', 71),
(2, 'App\\Models\\User', 72),
(2, 'App\\Models\\User', 73),
(2, 'App\\Models\\User', 74),
(2, 'App\\Models\\User', 75),
(2, 'App\\Models\\User', 76),
(2, 'App\\Models\\User', 77),
(2, 'App\\Models\\User', 78),
(2, 'App\\Models\\User', 79),
(2, 'App\\Models\\User', 80),
(2, 'App\\Models\\User', 81),
(2, 'App\\Models\\User', 82),
(2, 'App\\Models\\User', 83),
(2, 'App\\Models\\User', 84),
(2, 'App\\Models\\User', 85),
(2, 'App\\Models\\User', 86),
(2, 'App\\Models\\User', 87),
(2, 'App\\Models\\User', 88),
(2, 'App\\Models\\User', 89),
(2, 'App\\Models\\User', 90),
(2, 'App\\Models\\User', 91),
(2, 'App\\Models\\User', 92),
(2, 'App\\Models\\User', 93),
(2, 'App\\Models\\User', 94),
(2, 'App\\Models\\User', 95),
(2, 'App\\Models\\User', 96),
(2, 'App\\Models\\User', 97),
(2, 'App\\Models\\User', 98),
(2, 'App\\Models\\User', 99),
(2, 'App\\Models\\User', 100),
(2, 'App\\Models\\User', 101),
(2, 'App\\Models\\User', 102),
(2, 'App\\Models\\User', 103),
(2, 'App\\Models\\User', 104),
(2, 'App\\Models\\User', 105),
(2, 'App\\Models\\User', 106),
(2, 'App\\Models\\User', 107),
(2, 'App\\Models\\User', 108),
(2, 'App\\Models\\User', 109),
(2, 'App\\Models\\User', 110),
(2, 'App\\Models\\User', 111),
(2, 'App\\Models\\User', 112),
(2, 'App\\Models\\User', 113),
(2, 'App\\Models\\User', 114),
(2, 'App\\Models\\User', 115),
(2, 'App\\Models\\User', 116),
(2, 'App\\Models\\User', 117),
(2, 'App\\Models\\User', 118),
(2, 'App\\Models\\User', 119),
(2, 'App\\Models\\User', 120),
(2, 'App\\Models\\User', 121),
(2, 'App\\Models\\User', 122),
(2, 'App\\Models\\User', 123),
(2, 'App\\Models\\User', 124),
(2, 'App\\Models\\User', 125),
(2, 'App\\Models\\User', 126),
(2, 'App\\Models\\User', 127),
(2, 'App\\Models\\User', 128),
(2, 'App\\Models\\User', 129),
(2, 'App\\Models\\User', 130),
(2, 'App\\Models\\User', 131),
(2, 'App\\Models\\User', 132),
(2, 'App\\Models\\User', 133),
(2, 'App\\Models\\User', 134),
(2, 'App\\Models\\User', 135),
(2, 'App\\Models\\User', 136),
(2, 'App\\Models\\User', 137),
(2, 'App\\Models\\User', 138),
(2, 'App\\Models\\User', 139),
(2, 'App\\Models\\User', 140),
(2, 'App\\Models\\User', 141),
(2, 'App\\Models\\User', 142),
(2, 'App\\Models\\User', 143),
(2, 'App\\Models\\User', 144),
(2, 'App\\Models\\User', 145),
(2, 'App\\Models\\User', 146),
(2, 'App\\Models\\User', 147),
(2, 'App\\Models\\User', 148),
(2, 'App\\Models\\User', 149),
(2, 'App\\Models\\User', 150),
(2, 'App\\Models\\User', 151),
(2, 'App\\Models\\User', 152),
(2, 'App\\Models\\User', 153),
(2, 'App\\Models\\User', 154),
(2, 'App\\Models\\User', 155),
(2, 'App\\Models\\User', 156),
(2, 'App\\Models\\User', 157),
(2, 'App\\Models\\User', 158),
(2, 'App\\Models\\User', 159),
(2, 'App\\Models\\User', 160),
(2, 'App\\Models\\User', 161),
(2, 'App\\Models\\User', 162),
(2, 'App\\Models\\User', 163),
(2, 'App\\Models\\User', 164),
(2, 'App\\Models\\User', 165),
(2, 'App\\Models\\User', 166),
(2, 'App\\Models\\User', 167),
(2, 'App\\Models\\User', 168),
(2, 'App\\Models\\User', 169),
(2, 'App\\Models\\User', 170),
(2, 'App\\Models\\User', 171),
(2, 'App\\Models\\User', 172),
(2, 'App\\Models\\User', 173),
(2, 'App\\Models\\User', 174),
(2, 'App\\Models\\User', 175),
(2, 'App\\Models\\User', 176),
(2, 'App\\Models\\User', 177),
(2, 'App\\Models\\User', 178),
(2, 'App\\Models\\User', 179),
(2, 'App\\Models\\User', 180),
(2, 'App\\Models\\User', 181),
(2, 'App\\Models\\User', 182),
(2, 'App\\Models\\User', 183),
(2, 'App\\Models\\User', 184),
(2, 'App\\Models\\User', 185),
(2, 'App\\Models\\User', 186),
(2, 'App\\Models\\User', 187),
(2, 'App\\Models\\User', 188),
(2, 'App\\Models\\User', 189),
(2, 'App\\Models\\User', 190),
(2, 'App\\Models\\User', 191),
(2, 'App\\Models\\User', 192),
(2, 'App\\Models\\User', 193),
(2, 'App\\Models\\User', 194),
(2, 'App\\Models\\User', 195),
(2, 'App\\Models\\User', 196),
(2, 'App\\Models\\User', 197),
(2, 'App\\Models\\User', 198),
(2, 'App\\Models\\User', 199),
(2, 'App\\Models\\User', 200),
(2, 'App\\Models\\User', 201),
(2, 'App\\Models\\User', 202),
(2, 'App\\Models\\User', 203),
(2, 'App\\Models\\User', 204),
(2, 'App\\Models\\User', 205),
(2, 'App\\Models\\User', 206),
(2, 'App\\Models\\User', 207),
(2, 'App\\Models\\User', 208),
(2, 'App\\Models\\User', 209),
(2, 'App\\Models\\User', 210),
(2, 'App\\Models\\User', 211),
(2, 'App\\Models\\User', 212),
(2, 'App\\Models\\User', 213),
(2, 'App\\Models\\User', 214),
(2, 'App\\Models\\User', 215),
(2, 'App\\Models\\User', 216),
(2, 'App\\Models\\User', 217),
(2, 'App\\Models\\User', 218),
(2, 'App\\Models\\User', 219),
(2, 'App\\Models\\User', 220),
(2, 'App\\Models\\User', 221),
(2, 'App\\Models\\User', 222),
(2, 'App\\Models\\User', 223),
(2, 'App\\Models\\User', 224),
(2, 'App\\Models\\User', 225),
(2, 'App\\Models\\User', 226),
(2, 'App\\Models\\User', 227),
(2, 'App\\Models\\User', 228),
(2, 'App\\Models\\User', 229),
(2, 'App\\Models\\User', 230),
(2, 'App\\Models\\User', 231),
(2, 'App\\Models\\User', 232),
(2, 'App\\Models\\User', 233),
(2, 'App\\Models\\User', 234),
(2, 'App\\Models\\User', 235),
(2, 'App\\Models\\User', 236),
(2, 'App\\Models\\User', 237),
(2, 'App\\Models\\User', 238),
(2, 'App\\Models\\User', 239),
(2, 'App\\Models\\User', 240),
(2, 'App\\Models\\User', 241),
(2, 'App\\Models\\User', 242),
(2, 'App\\Models\\User', 243),
(2, 'App\\Models\\User', 244),
(2, 'App\\Models\\User', 245),
(2, 'App\\Models\\User', 246),
(2, 'App\\Models\\User', 247),
(2, 'App\\Models\\User', 248),
(2, 'App\\Models\\User', 249),
(2, 'App\\Models\\User', 250),
(2, 'App\\Models\\User', 251),
(2, 'App\\Models\\User', 252),
(2, 'App\\Models\\User', 253),
(2, 'App\\Models\\User', 254),
(2, 'App\\Models\\User', 255),
(2, 'App\\Models\\User', 256),
(2, 'App\\Models\\User', 257),
(2, 'App\\Models\\User', 258),
(2, 'App\\Models\\User', 259),
(2, 'App\\Models\\User', 260),
(2, 'App\\Models\\User', 261),
(2, 'App\\Models\\User', 262),
(2, 'App\\Models\\User', 263),
(2, 'App\\Models\\User', 264),
(2, 'App\\Models\\User', 265),
(2, 'App\\Models\\User', 266),
(2, 'App\\Models\\User', 267),
(2, 'App\\Models\\User', 268),
(2, 'App\\Models\\User', 269),
(2, 'App\\Models\\User', 270),
(2, 'App\\Models\\User', 271),
(2, 'App\\Models\\User', 272),
(2, 'App\\Models\\User', 273),
(2, 'App\\Models\\User', 274),
(2, 'App\\Models\\User', 275),
(2, 'App\\Models\\User', 276),
(2, 'App\\Models\\User', 277),
(2, 'App\\Models\\User', 278),
(2, 'App\\Models\\User', 279),
(2, 'App\\Models\\User', 280),
(2, 'App\\Models\\User', 281),
(2, 'App\\Models\\User', 282),
(2, 'App\\Models\\User', 283),
(2, 'App\\Models\\User', 284),
(2, 'App\\Models\\User', 285),
(2, 'App\\Models\\User', 286),
(2, 'App\\Models\\User', 287),
(2, 'App\\Models\\User', 288),
(3, 'App\\Models\\User', 289),
(1, 'App\\Models\\User', 290),
(3, 'App\\Models\\User', 291),
(2, 'App\\Models\\User', 292),
(2, 'App\\Models\\User', 293),
(2, 'App\\Models\\User', 294),
(2, 'App\\Models\\User', 295),
(2, 'App\\Models\\User', 296),
(2, 'App\\Models\\User', 297),
(2, 'App\\Models\\User', 298),
(2, 'App\\Models\\User', 299),
(2, 'App\\Models\\User', 300),
(2, 'App\\Models\\User', 301),
(2, 'App\\Models\\User', 302),
(2, 'App\\Models\\User', 303),
(2, 'App\\Models\\User', 304),
(2, 'App\\Models\\User', 305),
(2, 'App\\Models\\User', 306),
(2, 'App\\Models\\User', 307),
(2, 'App\\Models\\User', 308),
(2, 'App\\Models\\User', 309),
(2, 'App\\Models\\User', 310),
(2, 'App\\Models\\User', 311),
(2, 'App\\Models\\User', 312),
(2, 'App\\Models\\User', 313),
(2, 'App\\Models\\User', 314),
(2, 'App\\Models\\User', 315),
(2, 'App\\Models\\User', 316),
(2, 'App\\Models\\User', 317),
(2, 'App\\Models\\User', 318),
(2, 'App\\Models\\User', 319),
(2, 'App\\Models\\User', 320),
(2, 'App\\Models\\User', 321),
(2, 'App\\Models\\User', 322),
(2, 'App\\Models\\User', 323),
(2, 'App\\Models\\User', 324),
(2, 'App\\Models\\User', 325),
(2, 'App\\Models\\User', 326),
(2, 'App\\Models\\User', 327),
(2, 'App\\Models\\User', 328),
(2, 'App\\Models\\User', 329),
(2, 'App\\Models\\User', 330),
(2, 'App\\Models\\User', 331),
(2, 'App\\Models\\User', 332),
(2, 'App\\Models\\User', 333),
(2, 'App\\Models\\User', 334),
(2, 'App\\Models\\User', 335);

-- --------------------------------------------------------

--
-- Struktur dari tabel `overtimes`
--

CREATE TABLE `overtimes` (
  `id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `purpose` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pic` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `overtimes`
--

INSERT INTO `overtimes` (`id`, `date`, `department`, `purpose`, `pic`, `created_at`, `updated_at`, `created_by`) VALUES
(3, '2026-10-28', 'IT', 'test', 'Wisnu', '2026-10-27 19:05:38', '2026-10-27 19:05:38', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `overtime_employees`
--

CREATE TABLE `overtime_employees` (
  `id` bigint UNSIGNED NOT NULL,
  `overtime_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'reguler',
  `duration` decimal(5,2) NOT NULL DEFAULT '1.00',
  `mutation_reason` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `overtime_employees`
--

INSERT INTO `overtime_employees` (`id`, `overtime_id`, `employee_id`, `type`, `duration`, `mutation_reason`, `created_at`, `updated_at`) VALUES
(25, 3, 1, 'reguler', 2.00, NULL, '2026-10-27 19:05:38', '2026-10-27 19:05:38');

-- --------------------------------------------------------

--
-- Struktur dari tabel `passkeys`
--

CREATE TABLE `passkeys` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `credential_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `credential` json NOT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_adjustments`
--

CREATE TABLE `payroll_adjustments` (
  `id` bigint UNSIGNED NOT NULL,
  `payroll_item_id` bigint UNSIGNED NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_items`
--

CREATE TABLE `payroll_items` (
  `id` bigint UNSIGNED NOT NULL,
  `payroll_run_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED DEFAULT NULL,
  `employee_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `employee_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `basic_salary` decimal(15,2) NOT NULL DEFAULT '0.00',
  `daily_rate` decimal(15,2) NOT NULL DEFAULT '0.00',
  `unpaid_absence_days` smallint UNSIGNED NOT NULL DEFAULT '0',
  `absence_deduction` decimal(15,2) NOT NULL DEFAULT '0.00',
  `overtime_hours` decimal(8,2) NOT NULL DEFAULT '0.00',
  `overtime_hourly_rate` decimal(15,2) NOT NULL DEFAULT '0.00',
  `overtime_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `payroll_items`
--

INSERT INTO `payroll_items` (`id`, `payroll_run_id`, `employee_id`, `employee_code`, `employee_name`, `department`, `basic_salary`, `daily_rate`, `unpaid_absence_days`, `absence_deduction`, `overtime_hours`, `overtime_hourly_rate`, `overtime_amount`, `created_at`, `updated_at`) VALUES
(15, 3, 159, '202410001', 'AAM AMELIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(16, 3, 60, '202206001', 'ABDUL ROHIM', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(17, 3, 18, '202004001', 'ACHMAD FAUZI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(18, 3, 79, '202405001', 'ADE KOMARUDIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(19, 3, 126, '202408001', 'ADE NOVIANTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(20, 3, 286, '202610001', 'Adhika Eka Putta', 'HR', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(21, 3, 160, '202410002', 'Adib Prasetyo Hadi', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(22, 3, 80, '202405002', 'ADITYA CATUR SAYOGA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(23, 3, 127, '202408002', 'ADLIL DZIL IKRAM', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(24, 3, 161, '202410003', 'Agus Budi Santoso', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(25, 3, 208, '202505001', 'AGUS SETIAWAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(26, 3, 70, '202211001', 'AHMAD NURWAHID', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(27, 3, 218, '202507002', 'AHMAD SUHAEMI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(28, 3, 235, '202604001', 'AJENG MAYANG SARI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(29, 3, 128, '202408003', 'AKMAL MAULANA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(30, 3, 214, '202506001', 'AL ZAHRA DWI AGRINA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(31, 3, 21, '202005001', 'ALGIA RIZKI ANANDA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(32, 3, 81, '202405003', 'ALYA SERA SETIAWATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(33, 3, 162, '202410004', 'ANGGA PRIANANDA PUTRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(34, 3, 177, '202411002', 'Anisa Marcela', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(35, 3, 236, '202604002', 'ANISAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(36, 3, 49, '202107001', 'ANITA PUSPITA SARI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(37, 3, 123, '202407001', 'ANNISYA ALIF RIDHOLLAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(38, 3, 82, '202405004', 'APRIYATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(39, 3, 237, '202604003', 'AQQIL WAHID SUFIAN F', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(40, 3, 167, '202410009', 'Arif Rohimat', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(41, 3, 219, '202507003', 'Arinda Estriana Arnianto', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(42, 3, 129, '202408004', 'ARIO HERMANSA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(43, 3, 201, '202502001', 'ARUFI DIANA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(44, 3, 28, '202006001', 'ASEP JIDAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(45, 3, 130, '202408005', 'ASEP RUSTIANA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(46, 3, 164, '202410006', 'Aulia Valentica', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(47, 3, 131, '202408006', 'AYU ARYANI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(48, 3, 165, '202410007', 'Aziz Fesan Laut', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(49, 3, 176, '202411001', 'Bagas Prastyo Wibowo', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(50, 3, 163, '202410005', 'Bagus Wahyu Nurcholis', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(51, 3, 11, '201901002', 'Bai Sobari', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(52, 3, 61, '202206002', 'BENI SAMBODO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(53, 3, 83, '202405005', 'BERKAH MAWAR SILALAHI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(54, 3, 19, '202004002', 'CARDI SUHAYADI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(55, 3, 84, '202405006', 'CARTINI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(56, 3, 238, '202604004', 'CASMIAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(57, 3, 29, '202006002', 'CASWAN AGUSTIAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(58, 3, 34, '202011001', 'CECEP HIDAYAT', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(59, 3, 68, '202208001', 'CETA MARDIANYSAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(60, 3, 220, '202507004', 'DAENG SABAR K', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(61, 3, 124, '202407002', 'DANANG NUR ALIM', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(62, 3, 36, '202101001', 'DANI SUPRIATNA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(63, 3, 178, '202411003', 'Dede Mahjun', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(64, 3, 179, '202411004', 'Deni Ahmad', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(65, 3, 85, '202405007', 'DEVI KOMALASARI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(66, 3, 239, '202604005', 'DIAN FIRMANSAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(67, 3, 240, '202604006', 'DIAN RAMADHAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(68, 3, 241, '202604007', 'DICKY DWI SYAHPUTRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(69, 3, 86, '202405008', 'DINA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(70, 3, 53, '202110001', 'DINAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(71, 3, 242, '202604008', 'DINDA KIRANA AZZAHRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(72, 3, 87, '202405009', 'DINI TITA HANDINI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(73, 3, 243, '202604009', 'DIRA AGUSTINA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(74, 3, 168, '202410010', 'Dodi Aji Yusup', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(75, 3, 244, '202604010', 'DRIANA AGUSLIANTARI S.', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(76, 3, 132, '202408007', 'EBAH HABIBAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(77, 3, 202, '202502002', 'Egi Saputra', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(78, 3, 216, '202506003', 'EKA APRIYANTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(79, 3, 245, '202604011', 'ELSON KEVIN HAUMAHU', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(80, 3, 88, '202405010', 'ENAH HASANAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(81, 3, 232, '202508001', 'ENAH MARYNAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(82, 3, 133, '202408008', 'ENCUM SUMARTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(83, 3, 31, '202009001', 'ENIH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(84, 3, 32, '202009002', 'ENNO AMELIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(85, 3, 89, '202405011', 'EPRONIKA SIHOTANG', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(86, 3, 39, '202105001', 'ERSIH SUKAESIH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(87, 3, 62, '202206003', 'EVA MILANTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(88, 3, 134, '202408009', 'EVAN/RAJANAHOT E GIRSANG', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(89, 3, 203, '202502003', 'Evi Triyanti', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(90, 3, 246, '202604012', 'FAHRI HUSAINI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(91, 3, 135, '202408010', 'FAIZAL AFRIANSYAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(92, 3, 180, '202411005', 'Fatimatu Zahra', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(93, 3, 247, '202604013', 'FAUZIAH RAMADHANI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(94, 3, 248, '202604014', 'FAUZIAH RAMADHANI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(95, 3, 30, '202008001', 'FEBRI SUGIANTORO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(96, 3, 117, '202406001', 'FEBRIANI AULIA PUTRI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(97, 3, 249, '202604015', 'FITRI MULYANI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(98, 3, 90, '202405012', 'FITRI NURWULAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(99, 3, 250, '202604016', 'GILANG PRAYITNO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(100, 3, 204, '202502004', 'HALIMAH LIM', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(101, 3, 91, '202405013', 'HANIFAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(102, 3, 221, '202507005', 'Helmaliani Fransischa', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(103, 3, 136, '202408011', 'HIDUP SOLEHUDIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(104, 3, 137, '202408012', 'IDA HAMIDAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(105, 3, 138, '202408013', 'IDHAM MUNANDAR', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(106, 3, 251, '202604017', 'IIN INAYAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(107, 3, 40, '202105002', 'IIS RISWANTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(108, 3, 181, '202411006', 'Ilham Fadilah', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(109, 3, 125, '202407003', 'ILMA HALIMAHTIS SADIAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(110, 3, 22, '202005002', 'IMAM NUGRAHA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(111, 3, 252, '202604018', 'INTAN ASHARI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(112, 3, 23, '202005003', 'IPAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(113, 3, 65, '202207001', 'ISAK SAMSUDIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(114, 3, 183, '202411008', 'Ismail', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(115, 3, 92, '202405014', 'JAENAL ABIDIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(116, 3, 118, '202406002', 'JAMAL', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(117, 3, 253, '202604019', 'JAYADI ANWAR', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(118, 3, 182, '202411007', 'JELITA CINTA F', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(119, 3, 254, '202604020', 'JEVITHA SETIA LUCHIA WIBOWO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(120, 3, 196, '202501001', 'JUJU MULYAWATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(121, 3, 54, '202110002', 'JULIA RAHMAWATI SIREGAR', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(122, 3, 255, '202604021', 'KAFKHA ATMI PRATIWI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(123, 3, 256, '202604022', 'KAILA TRI AMANDA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(124, 3, 257, '202604023', 'KARDI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(125, 3, 184, '202411009', 'KARINA NATASYA MARDIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(126, 3, 45, '202106001', 'KARNAH HASANAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(127, 3, 139, '202408014', 'KARYANI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(128, 3, 258, '202604024', 'KEYSA PRATAMA PUTRI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(129, 3, 12, '201901003', 'KHARIDIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(130, 3, 41, '202105003', 'KHOTIMAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(131, 3, 140, '202408015', 'KOKOH WAYAN SATRIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(132, 3, 13, '201901004', 'KOKOM KOMARIAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(133, 3, 63, '202206004', 'KORIAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(134, 3, 169, '202410011', 'Kurniadi', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(135, 3, 69, '202208002', 'LAPENIA OKTAPIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(136, 3, 93, '202405015', 'LIANA NURUL AFNI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(137, 3, 94, '202405016', 'LISDA SIDABUTAR', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(138, 3, 170, '202410012', 'Lita Amelia', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(139, 3, 205, '202502005', 'M. Iqbal Kurnia', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(140, 3, 259, '202604025', 'M. KHOLILI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(141, 3, 20, '202004003', 'M. RAMDAN SAUD F', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(142, 3, 222, '202507006', 'M. Rayesa Aditiya', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(143, 3, 260, '202604026', 'M. RENO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(144, 3, 261, '202604027', 'M. RIZKI RAMADHAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(145, 3, 197, '202501002', 'MARGARETA SHAELA O', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(146, 3, 209, '202505002', 'MARIANA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(147, 3, 262, '202604028', 'MARIO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(148, 3, 198, '202501003', 'Melly Permata Sari', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(149, 3, 217, '202506004', 'MERSI PATTIKWARA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(150, 3, 141, '202408016', 'METRINAWATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(151, 3, 24, '202005004', 'MICAH CAHYATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(152, 3, 285, '202605001', 'MIFTAQUL AZIL SAPUTRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(153, 3, 187, '202411012', 'Mila Kuswara', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(154, 3, 142, '202408017', 'MISYATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(155, 3, 66, '202207002', 'MITA NUR AZIZAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(156, 3, 185, '202411010', 'Mohamad Ikbal', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(157, 3, 95, '202405017', 'MUHAMAD LUCKY', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(158, 3, 143, '202408018', 'MUHAMAD NAJIB', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(159, 3, 188, '202411013', 'MUhamad Ridwan', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(160, 3, 144, '202408019', 'MUHAMMAD AGUNG RAMADAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(161, 3, 263, '202604029', 'MUHAMMAD AL FARISI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(162, 3, 173, '202410015', 'MUHAMMAD ARIFIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(163, 3, 145, '202408020', 'MUHAMMAD BAHIR', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(164, 3, 227, '202410018', 'MUHAMMAD JAJULI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(165, 3, 228, '202410019', 'MUHAMMAD RIFKI SAPUTRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(166, 3, 233, '202508002', 'MUHAMMAD RIZKI SAPUTRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(167, 3, 46, '202106002', 'MUJIROH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(168, 3, 96, '202405018', 'MUSIYAM', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(169, 3, 264, '202604030', 'MUTMAINAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(170, 3, 57, '202205001', 'NABILA DILLANI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(171, 3, 186, '202411011', 'Naesya Aulia Kartini', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(172, 3, 73, '202404001', 'NAMAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(173, 3, 234, '202510001', 'NAMIRA ALIFAH ZAHRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(174, 3, 265, '202604031', 'NANA HINDRA MULYANA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(175, 3, 223, '202507007', 'NANIM NABILA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(176, 3, 171, '202410013', 'Naufal Rafi Dzaki', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(177, 3, 266, '202604032', 'NAURISTA SAFITRI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(178, 3, 172, '202410014', 'NAZWA ALIA RAHMAWATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(179, 3, 71, '202306001', 'NAZWA KHAIRUNNISA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(180, 3, 97, '202405019', 'NENENG SHOLIHAT', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(181, 3, 146, '202408021', 'NETTI PURBA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(182, 3, 210, '202505003', 'NGATMI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(183, 3, 267, '202604033', 'NIA NABILA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(184, 3, 25, '202005005', 'NINGSIH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(185, 3, 42, '202105004', 'NIRAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(186, 3, 268, '202604034', 'NISPUDIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(187, 3, 74, '202404002', 'NITA PURNAMASARI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(188, 3, 14, '201901005', 'NOVI NURHAYATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(189, 3, 75, '202404003', 'NOVITASARI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(190, 3, 67, '202207003', 'NUARI GALIH LAKSONO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(191, 3, 98, '202405020', 'NUR FITRIA SARI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(192, 3, 52, '202108001', 'NUR LAELA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(193, 3, 211, '202505004', 'NUR SAROPAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(194, 3, 99, '202405021', 'NURHALIMAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(195, 3, 100, '202405022', 'ODAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(196, 3, 147, '202408022', 'OKKY SAPUTRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(197, 3, 215, '202506002', 'Oktaviona Aidelwys', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(198, 3, 56, '202112001', 'OPIN MAILANI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(199, 3, 72, '202306002', 'PERI FAISAL', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(200, 3, 189, '202411014', 'PUTRI HAYATTUNNISA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(201, 3, 35, '202011002', 'RAMAZAL SAPUTRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(202, 3, 269, '202604035', 'RATNA PRASTIWI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(203, 3, 101, '202405023', 'REKHA ANISA LIANTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(204, 3, 193, '202411018', 'Rianti', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(205, 3, 206, '202502006', 'RIFKI SETIAWAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(206, 3, 270, '202604036', 'RIFQI HIDAYAT', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(207, 3, 102, '202405024', 'RIKY EKA PERMANA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(208, 3, 148, '202408023', 'RINEM', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(209, 3, 149, '202408024', 'RINNY FITRI NURAINI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(210, 3, 55, '202110003', 'RIZKI AGUNG H', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(211, 3, 150, '202408025', 'ROBY IRAWAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(212, 3, 271, '202604037', 'ROHMAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(213, 3, 103, '202405025', 'ROHMAT', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(214, 3, 190, '202411015', 'ROSALINDA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(215, 3, 104, '202405026', 'RUKINAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(216, 3, 224, '202507008', 'RULLI YANSYAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(217, 3, 191, '202411016', 'RYANTI DEWI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(218, 3, 272, '202604038', 'SABRI FAHADI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(219, 3, 273, '202604039', 'SAEPUL ANWAR', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(220, 3, 119, '202406003', 'SAHRUL ROJI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(221, 3, 274, '202604040', 'SALSA ALVIANA ZAHRA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(222, 3, 105, '202405027', 'SALSA ANISA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(223, 3, 151, '202408026', 'SAMAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(224, 3, 152, '202408027', 'SANTA MARYANI D', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(225, 3, 106, '202405028', 'SAPUTRI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(226, 3, 76, '202404004', 'SARI FADILAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(227, 3, 15, '201901006', 'SARMIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(228, 3, 107, '202405029', 'SARWI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(229, 3, 194, '202411019', 'SELVI MARLISA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(230, 3, 153, '202408028', 'SELY RAHMAWATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(231, 3, 275, '202604041', 'SEPTIA NUR ISTIQOMAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(232, 3, 77, '202404005', 'SEPTIAN RAHAYU', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(233, 3, 154, '202408029', 'SHAFA KAROMAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(234, 3, 207, '202502007', 'SILPIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(235, 3, 276, '202604042', 'SILVIA QURROTUL AINNI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(236, 3, 108, '202405030', 'SIMIH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(237, 3, 33, '202009003', 'SINTAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(238, 3, 277, '202604043', 'SIR ROLLAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(239, 3, 120, '202406004', 'SISKA AMELIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(240, 3, 16, '201901007', 'SITI ALINA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(241, 3, 192, '202411017', 'Siti Jamilah', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(242, 3, 37, '202101002', 'SITI MARWAH HARAHAP', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(243, 3, 278, '202604044', 'SITI NUR AULIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:58', '2026-11-01 21:12:58'),
(244, 3, 64, '202206005', 'SITI NURHAYATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(245, 3, 109, '202405031', 'SITI NURUL IDAYANTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(246, 3, 110, '202405032', 'SITI SOLIHAT', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(247, 3, 155, '202408030', 'SRI DOHARNI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(248, 3, 47, '202106003', 'SRI HANDAYANI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(249, 3, 50, '202107002', 'SRI KARNI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(250, 3, 156, '202408031', 'SRI LENA PANJAITAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(251, 3, 48, '202106004', 'SRI SUSANTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(252, 3, 111, '202405033', 'SRI WAHYUNI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(253, 3, 175, '202410017', 'SRI WAHYUNI DEWI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(254, 3, 121, '202406005', 'SUCI NURAENI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(255, 3, 43, '202105005', 'SUHENDRA (REPAIR)', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(256, 3, 51, '202107003', 'SUKESMI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(257, 3, 122, '202406006', 'SULASTRI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(258, 3, 199, '202501004', 'Supriyadi', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(259, 3, 38, '202103001', 'SUPRIYATIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(260, 3, 225, '202507009', 'Suriyah', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(261, 3, 174, '202410016', 'SUTAMAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(262, 3, 1, '202507001', 'Syafiq Wisnu Aarisatyo Putro', 'IT', 0.00, 0.00, 0, 0.00, 2.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(263, 3, 212, '202505005', 'SYAHRUL WAHYU SHOBIRIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(264, 3, 26, '202005006', 'SYARIFUDIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(265, 3, 112, '202405034', 'SYIFA AULIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(266, 3, 279, '202604045', 'TAUFIK HIDAYAT', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(267, 3, 58, '202205002', 'TINI MARDINI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(268, 3, 280, '202604046', 'TITIN NURAINI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(269, 3, 226, '202507010', 'TRI YUSANTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(270, 3, 113, '202405035', 'TUTI SUGIARTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(271, 3, 59, '202205003', 'TUTIK WINARSIH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(272, 3, 166, '202410008', 'Ummi Kalsum', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(273, 3, 157, '202408032', 'UNTUNG SISWOYO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(274, 3, 213, '202505006', 'UYEH YOGIANSYAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(275, 3, 281, '202604047', 'VERAWATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(276, 3, 229, '202506005', 'VERNANDA DIAN A', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(277, 3, 114, '202405036', 'VERONICA FAZRIW AYAZA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(278, 3, 158, '202408033', 'VERONIKA ARITONANG', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(279, 3, 282, '202604048', 'WANAH', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(280, 3, 27, '202005007', 'WAWAN SETIAWAN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(281, 3, 78, '202404006', 'WIDIA WULANDARI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(282, 3, 44, '202105006', 'WINARTI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(283, 3, 200, '202501005', 'Wulandari', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(284, 3, 115, '202405037', 'YANTI KUSWARA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(285, 3, 10, '201901001', 'YANTO SURYANTO', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(286, 3, 231, '202507012', 'YASINTA AMEIA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(287, 3, 116, '202405038', 'YATI', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(288, 3, 283, '202604049', 'YAYIN INTYAS', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(289, 3, 284, '202604050', 'YOFRI MAHALIGA', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(290, 3, 230, '202507011', 'Yoyoh Farida', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(291, 3, 17, '201901008', 'YUYUN BUDI L', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59'),
(292, 3, 195, '202411020', 'ZAINAL ARIFIN', '-', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 0.00, '2026-11-01 21:12:59', '2026-11-01 21:12:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `payroll_runs`
--

CREATE TABLE `payroll_runs` (
  `id` bigint UNSIGNED NOT NULL,
  `month` tinyint UNSIGNED NOT NULL,
  `year` smallint UNSIGNED NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `overtime_hourly_rate` decimal(15,2) NOT NULL DEFAULT '0.00',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `generated_by` bigint UNSIGNED NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `paid_by` bigint UNSIGNED DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `payroll_runs`
--

INSERT INTO `payroll_runs` (`id`, `month`, `year`, `period_start`, `period_end`, `overtime_hourly_rate`, `status`, `generated_by`, `approved_by`, `approved_at`, `paid_by`, `paid_at`, `created_at`, `updated_at`) VALUES
(3, 11, 2026, '2026-10-26', '2026-11-25', 0.00, 'draft', 1, NULL, NULL, NULL, NULL, '2026-11-01 21:12:58', '2026-11-01 21:12:58');

-- --------------------------------------------------------

--
-- Struktur dari tabel `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'manage-users', 'web', '2026-10-20 22:50:56', '2026-10-20 22:50:56'),
(2, 'manage-roles', 'web', '2026-10-20 22:50:56', '2026-10-20 22:50:56'),
(3, 'manage-menus', 'web', '2026-10-20 22:50:56', '2026-10-20 22:50:56'),
(4, 'manage-submenus', 'web', '2026-10-20 22:50:56', '2026-10-20 22:50:56'),
(5, 'view-profile', 'web', '2026-10-20 22:50:56', '2026-10-20 22:50:56'),
(6, 'manage-absen', 'web', '2026-10-21 01:26:30', '2026-10-21 01:26:30'),
(7, 'manage-permissions', 'web', '2026-10-21 02:34:55', '2026-10-21 02:34:55'),
(8, 'manage-employees', 'web', '2026-10-22 20:04:40', '2026-10-22 20:04:40'),
(9, 'manage-attendances', 'web', '2026-10-22 21:05:53', '2026-10-22 21:05:53'),
(10, 'manage-overtimes', 'web', '2026-10-25 19:51:47', '2026-10-25 19:51:47'),
(11, 'manage-holidays', 'web', '2026-10-25 21:15:45', '2026-10-25 21:15:45'),
(12, 'manage-leave-requests', 'web', '2026-10-26 01:18:49', '2026-10-26 01:20:50'),
(13, 'manage-overtimes-daily', 'web', '2026-10-26 02:04:43', '2026-10-26 02:04:43'),
(14, 'manage-brands', 'web', '2026-10-26 02:21:44', '2026-10-26 02:21:44'),
(15, 'manage-spk', 'web', '2026-10-26 02:38:25', '2026-10-26 02:38:25'),
(16, 'manage-scans', 'web', '2026-10-26 20:15:32', '2026-10-26 20:15:32'),
(17, 'manage-defect-categories', 'web', '2026-10-26 20:50:36', '2026-10-26 20:50:36'),
(18, 'manage-defects', 'web', '2026-10-26 20:50:45', '2026-10-26 20:50:45'),
(19, 'manage-report-qc', 'web', '2026-10-26 21:11:41', '2026-10-26 21:12:56'),
(20, 'manage-monitor-qc', 'web', '2026-10-26 21:40:02', '2026-10-26 21:40:02'),
(21, 'manage-rekap-absensi', 'web', '2026-10-27 01:28:59', '2026-10-27 01:28:59'),
(22, 'manage-koneksi', 'web', '2026-10-27 02:56:36', '2026-10-27 02:56:36'),
(23, 'manage-master-data', 'web', '2026-10-27 22:44:44', '2026-10-27 22:44:44'),
(24, 'manage-produksi', 'web', '2026-10-27 22:44:55', '2026-10-27 22:44:55'),
(25, 'manage-hris', 'web', '2026-10-27 22:45:10', '2026-10-27 22:45:10'),
(26, 'manage-assets', 'web', '2026-10-29 22:13:07', '2026-10-29 22:13:07'),
(27, 'manage-payroll', 'web', '2026-10-30 01:44:33', '2026-10-30 01:44:33'),
(28, 'view-employee-salary', 'web', '2026-11-01 21:27:30', '2026-11-01 21:27:30');

-- --------------------------------------------------------

--
-- Struktur dari tabel `production_dailies`
--

CREATE TABLE `production_dailies` (
  `id` bigint UNSIGNED NOT NULL,
  `spk_batch_id` bigint UNSIGNED DEFAULT NULL,
  `spk_id` bigint UNSIGNED DEFAULT NULL,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `report_date` date NOT NULL,
  `qty` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `production_defects`
--

CREATE TABLE `production_defects` (
  `id` bigint UNSIGNED NOT NULL,
  `spk_id` bigint UNSIGNED NOT NULL,
  `defect_category_id` bigint UNSIGNED NOT NULL,
  `department` enum('warehouse','finishing','qc') COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int NOT NULL DEFAULT '1',
  `reported_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `production_defects`
--

INSERT INTO `production_defects` (`id`, `spk_id`, `defect_category_id`, `department`, `qty`, `reported_by`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:39', '2026-10-26 20:55:39'),
(2, 1, 1, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:40', '2026-10-26 20:55:40'),
(3, 1, 1, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:41', '2026-10-26 20:55:41'),
(4, 1, 2, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:42', '2026-10-26 20:55:42'),
(5, 1, 2, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:44', '2026-10-26 20:55:44'),
(6, 1, 2, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:45', '2026-10-26 20:55:45'),
(7, 1, 3, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:46', '2026-10-26 20:55:46'),
(8, 1, 3, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:47', '2026-10-26 20:55:47'),
(9, 1, 4, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:47', '2026-10-26 20:55:47'),
(10, 1, 4, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:48', '2026-10-26 20:55:48'),
(11, 1, 5, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:49', '2026-10-26 20:55:49'),
(12, 1, 5, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:50', '2026-10-26 20:55:50'),
(13, 1, 6, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:55:51', '2026-10-26 20:55:51'),
(14, 1, 6, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:29', '2026-10-26 21:59:29'),
(15, 1, 7, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:30', '2026-10-26 21:59:30'),
(16, 1, 7, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:31', '2026-10-26 21:59:31'),
(17, 1, 8, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:31', '2026-10-26 21:59:31'),
(18, 1, 9, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:32', '2026-10-26 21:59:32'),
(19, 1, 8, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:33', '2026-10-26 21:59:33'),
(20, 1, 9, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:34', '2026-10-26 21:59:34'),
(21, 1, 10, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:35', '2026-10-26 21:59:35'),
(22, 1, 10, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 21:59:36', '2026-10-26 21:59:36'),
(23, 1, 11, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 22:02:03', '2026-10-26 22:02:03'),
(24, 1, 11, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 22:02:04', '2026-10-26 22:02:04'),
(25, 1, 11, 'qc', 1, 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 22:02:04', '2026-10-26 22:02:04');

-- --------------------------------------------------------

--
-- Struktur dari tabel `production_scans`
--

CREATE TABLE `production_scans` (
  `id` bigint UNSIGNED NOT NULL,
  `spk_detail_id` bigint UNSIGNED NOT NULL,
  `department` enum('warehouse','finishing') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pass','defect') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pass',
  `scanned_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `production_scans`
--

INSERT INTO `production_scans` (`id`, `spk_detail_id`, `department`, `status`, `scanned_by`, `created_at`, `updated_at`) VALUES
(1, 15, 'warehouse', 'pass', 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:31:51', '2026-10-26 20:31:51'),
(2, 15, 'warehouse', 'pass', 'Syafiq Wisnu Arisatyo Putro', '2026-10-26 20:31:53', '2026-10-26 20:31:53'),
(3, 15, 'finishing', 'pass', 'Syafiq Wisnu Arisatyo Putro', '2026-10-29 00:42:16', '2026-10-29 00:42:16');

-- --------------------------------------------------------

--
-- Struktur dari tabel `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'super-admin', 'web', '2026-10-20 22:50:56', '2026-10-20 22:50:56'),
(2, 'Operator', 'web', '2026-10-21 01:07:25', '2026-10-21 01:07:25'),
(3, 'HR', 'web', '2026-10-28 00:30:13', '2026-10-28 00:30:13');

-- --------------------------------------------------------

--
-- Struktur dari tabel `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(5, 2),
(1, 3),
(2, 3),
(5, 3),
(6, 3),
(7, 3),
(8, 3),
(9, 3),
(10, 3),
(11, 3),
(12, 3),
(13, 3),
(21, 3),
(23, 3),
(25, 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('aT39sphN6EhvzQIXlOgPr3z8VqAAgDHsMRYHHJFo', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJFZFZDeVF4eW9NZ1FQMkhaRmJiTU5lU1V5VlRtaVlINUVCVjlhSmFCIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL2xvY2FsaG9zdDo4MDAwXC9hZG1pblwvZW1wbG95ZWVzIiwicm91dGUiOiJhZG1pbi5lbXBsb3llZXMuaW5kZXgifSwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI6MSwicGFzc3dvcmRfaGFzaF93ZWIiOiJjYzk0N2FmOGQyZDZjNGEwNDdjNGM4NTJhYWFjZGMzYzBjNmVmODRiMWExOTllOTA4ZjQ4OTk5MjJhOGU0YTdhIn0=', 1793783525);

-- --------------------------------------------------------

--
-- Struktur dari tabel `size_runs`
--

CREATE TABLE `size_runs` (
  `id` bigint UNSIGNED NOT NULL,
  `brand_id` bigint UNSIGNED NOT NULL,
  `size_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `size_runs`
--

INSERT INTO `size_runs` (`id`, `brand_id`, `size_name`, `order`, `created_at`, `updated_at`) VALUES
(18, 1, '6D', 1, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(19, 1, '6.5D', 2, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(20, 1, '7D', 3, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(21, 1, '7.5D', 4, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(22, 1, '8D', 5, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(23, 1, '8.5D', 6, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(24, 1, '9D', 7, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(25, 1, '9.5D', 8, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(26, 1, '10D', 9, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(27, 1, '10.5D', 10, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(28, 1, '11D', 11, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(29, 1, '11.5D', 12, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(30, 1, '12D', 13, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(31, 1, '13D', 14, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(32, 1, '14D', 15, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(33, 1, '15D', 16, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(34, 1, '16D', 17, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(35, 1, '6E', 18, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(36, 1, '6.5E', 19, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(37, 1, '7E', 20, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(38, 1, '7.5E', 21, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(39, 1, '8E', 22, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(40, 1, '8.5E', 23, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(41, 1, '9E', 24, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(42, 1, '9.5E', 25, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(43, 1, '10E', 26, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(44, 1, '10.5E', 27, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(45, 1, '11E', 28, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(46, 1, '11.5E', 29, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(47, 1, '12E', 30, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(48, 1, '13E', 31, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(49, 1, '14E', 32, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(50, 1, '15E', 33, '2026-10-28 19:35:19', '2026-10-28 19:35:19'),
(51, 1, '16E', 34, '2026-10-28 19:35:19', '2026-10-28 19:35:19');

-- --------------------------------------------------------

--
-- Struktur dari tabel `spks`
--

CREATE TABLE `spks` (
  `id` bigint UNSIGNED NOT NULL,
  `po_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `xfd_date` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `brand_id` bigint UNSIGNED NOT NULL,
  `art_color` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` enum('create','active','finished','closed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'create',
  `department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `spks`
--

INSERT INTO `spks` (`id`, `po_number`, `xfd_date`, `start_date`, `brand_id`, `art_color`, `image_path`, `created_at`, `updated_at`, `status`, `department`) VALUES
(1, '12345678', '2026-10-31', NULL, 1, 'test', NULL, '2026-10-26 02:57:04', '2026-10-26 20:19:13', 'active', NULL),
(2, 'testin', '2026-10-31', NULL, 1, 'test', NULL, '2026-10-26 21:41:38', '2026-10-26 21:43:25', 'active', NULL),
(3, '123', '2026-10-31', NULL, 1, 'wawa', 'spk_images/0O2zLZcfg9govnn4qgXRXEy0UHHSU9Q2hUberD4B.jpg', '2026-10-29 00:48:17', '2026-11-03 01:28:40', 'active', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `spk_batches`
--

CREATE TABLE `spk_batches` (
  `id` bigint UNSIGNED NOT NULL,
  `spk_id` bigint UNSIGNED NOT NULL,
  `batch_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int NOT NULL,
  `sizes` json DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `current_department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','in_progress','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `spk_batches`
--

INSERT INTO `spk_batches` (`id`, `spk_id`, `batch_code`, `qty`, `sizes`, `start_date`, `current_department`, `status`, `created_at`, `updated_at`) VALUES
(7, 1, 'B1', 4, '[{\"qty\": 1, \"size_name\": \"6D\"}, {\"qty\": 0, \"size_name\": \"6.5D\"}, {\"qty\": 1, \"size_name\": \"7D\"}, {\"qty\": 0, \"size_name\": \"7.5D\"}, {\"qty\": 1, \"size_name\": \"8.5D\"}, {\"qty\": 0, \"size_name\": \"9D\"}, {\"qty\": 1, \"size_name\": \"9.5D\"}]', NULL, NULL, 'pending', '2026-10-29 00:32:23', '2026-10-29 00:32:23'),
(8, 1, 'B2', 3, '[{\"qty\": 0, \"size_name\": \"6D\"}, {\"qty\": 1, \"size_name\": \"6.5D\"}, {\"qty\": 0, \"size_name\": \"7D\"}, {\"qty\": 1, \"size_name\": \"7.5D\"}, {\"qty\": 0, \"size_name\": \"8.5D\"}, {\"qty\": 1, \"size_name\": \"9D\"}, {\"qty\": 0, \"size_name\": \"9.5D\"}]', NULL, NULL, 'pending', '2026-10-29 00:32:23', '2026-10-29 00:32:23'),
(15, 3, 'B1', 7, '[{\"qty\": 5, \"size_name\": \"6D\"}, {\"qty\": 0, \"size_name\": \"6.5D\"}, {\"qty\": 1, \"size_name\": \"7D\"}, {\"qty\": 0, \"size_name\": \"8D\"}, {\"qty\": 1, \"size_name\": \"8E\"}]', NULL, NULL, 'pending', '2026-10-29 00:54:25', '2026-10-29 00:54:25'),
(16, 3, 'B2', 8, '[{\"qty\": 5, \"size_name\": \"6D\"}, {\"qty\": 0, \"size_name\": \"6.5D\"}, {\"qty\": 1, \"size_name\": \"7D\"}, {\"qty\": 1, \"size_name\": \"8D\"}, {\"qty\": 1, \"size_name\": \"8E\"}]', NULL, NULL, 'pending', '2026-10-29 00:54:25', '2026-10-29 00:54:25'),
(17, 3, 'B3', 8, '[{\"qty\": 0, \"size_name\": \"6D\"}, {\"qty\": 5, \"size_name\": \"6.5D\"}, {\"qty\": 1, \"size_name\": \"7D\"}, {\"qty\": 1, \"size_name\": \"8D\"}, {\"qty\": 1, \"size_name\": \"8E\"}]', NULL, NULL, 'pending', '2026-10-29 00:54:25', '2026-10-29 00:54:25'),
(18, 3, 'B4', 7, '[{\"qty\": 0, \"size_name\": \"6D\"}, {\"qty\": 5, \"size_name\": \"6.5D\"}, {\"qty\": 0, \"size_name\": \"7D\"}, {\"qty\": 1, \"size_name\": \"8D\"}, {\"qty\": 1, \"size_name\": \"8E\"}]', NULL, NULL, 'pending', '2026-10-29 00:54:25', '2026-10-29 00:54:25');

-- --------------------------------------------------------

--
-- Struktur dari tabel `spk_batch_tracks`
--

CREATE TABLE `spk_batch_tracks` (
  `id` bigint UNSIGNED NOT NULL,
  `spk_batch_id` bigint UNSIGNED NOT NULL,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `spk_details`
--

CREATE TABLE `spk_details` (
  `id` bigint UNSIGNED NOT NULL,
  `spk_id` bigint UNSIGNED NOT NULL,
  `size_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int NOT NULL DEFAULT '0',
  `barcode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `spk_details`
--

INSERT INTO `spk_details` (`id`, `spk_id`, `size_name`, `qty`, `barcode`, `created_at`, `updated_at`) VALUES
(15, 1, '6D', 1, '192904724752', '2026-10-26 20:07:12', '2026-10-26 20:07:12'),
(16, 1, '6.5D', 1, '123', '2026-10-26 20:07:12', '2026-10-26 20:07:12'),
(17, 1, '7D', 1, NULL, '2026-10-26 20:07:12', '2026-10-26 20:07:12'),
(18, 1, '7.5D', 1, NULL, '2026-10-26 20:07:12', '2026-10-26 20:07:12'),
(19, 1, '8.5D', 1, NULL, '2026-10-26 20:07:12', '2026-10-26 20:07:12'),
(20, 1, '9D', 1, NULL, '2026-10-26 20:07:12', '2026-10-26 20:07:12'),
(21, 1, '9.5D', 1, NULL, '2026-10-26 20:07:12', '2026-10-26 20:07:12'),
(23, 2, '6D', 1, NULL, '2026-10-28 20:49:42', '2026-10-28 20:49:42'),
(29, 3, '6D', 10, '1234567890', '2026-11-03 01:28:40', '2026-11-03 01:28:40'),
(30, 3, '6.5D', 10, NULL, '2026-11-03 01:28:40', '2026-11-03 01:28:40'),
(31, 3, '7D', 3, NULL, '2026-11-03 01:28:40', '2026-11-03 01:28:40'),
(32, 3, '8D', 3, NULL, '2026-11-03 01:28:40', '2026-11-03 01:28:40'),
(33, 3, '8E', 4, NULL, '2026-11-03 01:28:40', '2026-11-03 01:28:40');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sub_menus`
--

CREATE TABLE `sub_menus` (
  `id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `route` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `permission_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sub_menus`
--

INSERT INTO `sub_menus` (`id`, `menu_id`, `name`, `route`, `order`, `permission_name`, `created_at`, `updated_at`) VALUES
(6, 7, 'Data Permissions', '/admin/permissions', 5, 'manage-permissions', '2026-10-21 20:00:10', '2026-10-21 20:44:44'),
(7, 8, 'Data Karyawan', '/admin/employees', 1, 'manage-employees', '2026-10-22 20:09:45', '2026-10-22 20:10:22'),
(8, 8, 'Input Absensi', '/admin/attendances', 2, 'manage-attendances', '2026-10-22 21:04:29', '2026-10-22 21:15:44'),
(9, 8, 'Laporan Absensi', '/admin/reports', 3, 'manage-attendances', '2026-10-22 23:15:51', '2026-10-22 23:15:51'),
(10, 8, 'Data Lembur', '/admin/overtimes', 4, 'manage-overtimes', '2026-10-25 19:51:20', '2026-10-25 19:52:33'),
(11, 8, 'Data Libur', '/admin/holidays', 5, 'manage-holidays', '2026-10-25 21:15:31', '2026-10-25 21:15:55'),
(12, 8, 'Form Izin', '/admin/leave-requests', 6, 'manage-leave-requests', '2026-10-26 01:21:41', '2026-10-26 02:05:36'),
(13, 8, 'Jadwal Lembur Harian', '/admin/overtimes/daily', 6, 'manage-overtimes-daily', '2026-10-26 02:03:48', '2026-10-26 02:38:39'),
(14, 7, 'Data Brands', '/admin/brands', 5, 'manage-brands', '2026-10-26 02:22:10', '2026-10-26 02:22:10'),
(15, 9, 'SPK', '/produksi/spks', 1, 'manage-spk', '2026-10-26 02:40:24', '2026-10-26 02:43:45'),
(16, 9, 'Produksi Scan', '/produksi/scan', 2, 'manage-scans', '2026-10-26 20:16:07', '2026-10-26 20:16:51'),
(17, 7, 'Data Defect', '/admin/defect-categories', 7, 'manage-defect-categories', '2026-10-26 20:51:29', '2026-10-26 20:51:29'),
(18, 9, 'Daily Defect', '/produksi/defects', 3, 'manage-defects', '2026-10-26 20:52:01', '2026-10-26 20:52:01'),
(19, 9, 'Report QC', '/produksi/report-qc', 4, 'manage-report-qc', '2026-10-26 21:13:38', '2026-10-26 21:13:38'),
(20, 9, 'Monitor QC', '/produksi/monitor-qc', 5, 'manage-monitor-qc', '2026-10-26 21:40:31', '2026-10-26 21:40:31'),
(21, 8, 'Rekap Absensi Finger', '/admin/rekap-absensi', 9, 'manage-rekap-absensi', '2026-10-27 01:29:14', '2026-10-27 01:29:50'),
(22, 8, 'Koneksi FInger', '/admin/setting-finger', 9, 'manage-koneksi', '2026-10-27 02:58:09', '2026-10-27 02:58:09'),
(23, 9, 'PPS (Schedule)', '/produksi/spk-schedules', 3, 'manage-spk', '2026-10-28 20:48:41', '2026-10-28 20:48:41'),
(24, 10, 'Tambah Pengguna', '/admin/users/create', 1, 'manage-users', '2026-10-29 22:13:21', '2026-10-30 01:44:33'),
(25, 10, 'Daftar Pengguna', '/admin/users', 2, 'manage-users', '2026-10-29 22:13:21', '2026-10-30 01:44:33'),
(26, 14, 'Daftar Aset', '/admin/assets', 1, 'manage-assets', '2026-10-29 22:13:21', '2026-10-29 22:18:19'),
(27, 14, 'Kategori & Lokasi', '/admin/assets/catalog', 2, 'manage-assets', '2026-10-29 22:13:21', '2026-10-29 22:18:19'),
(28, 14, 'Laporan & Penyusutan', '/admin/assets/reports', 3, 'manage-assets', '2026-10-29 22:13:21', '2026-10-29 22:18:19');

-- --------------------------------------------------------

--
-- Struktur dari tabel `teams`
--

CREATE TABLE `teams` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_personal` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `teams`
--

INSERT INTO `teams` (`id`, `name`, `slug`, `is_personal`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Syafiq Wisnu Arisatyo Putro\'s Team', 'syafiq-wisnu-arisatyo-putros-team', 1, '2026-10-20 21:33:48', '2026-10-20 21:33:48', NULL),
(2, 'Wisnu\'s Team', 'wisnus-team', 1, '2026-10-21 23:07:42', '2026-10-21 23:07:42', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `team_invitations`
--

CREATE TABLE `team_invitations` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `team_id` bigint UNSIGNED NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `invited_by` bigint UNSIGNED NOT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `accepted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `team_members`
--

CREATE TABLE `team_members` (
  `id` bigint UNSIGNED NOT NULL,
  `team_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `team_members`
--

INSERT INTO `team_members` (`id`, `team_id`, `user_id`, `role`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'owner', '2026-10-20 21:33:48', '2026-10-20 21:33:48');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_team_id` bigint UNSIGNED DEFAULT NULL,
  `two_factor_secret` text COLLATE utf8mb4_unicode_ci,
  `two_factor_recovery_codes` text COLLATE utf8mb4_unicode_ci,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `current_team_id`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Wisnu', 's.wisnu1106@gmail.com', '2026-10-20 21:44:09', '$2y$12$y4qTfHos.PsYSpwE9fCGIeU6j1tVU.zNhXP0mEgi.1U9/wupTHz.2', 1, NULL, NULL, NULL, 'jJZgmgH7tNub7mbwEozyGYKuxknT26N3VpsrVWPBgD5KaoHpnfMO2B6aAQAV', '2026-10-20 21:33:48', '2026-10-29 19:54:28'),
(13, 'YANTO SURYANTO', 'employee-2f88a9082f33e0c0ae5e0c43c627e2902f8fe83049279c6d63070d7435768ef9@employees.invalid', NULL, '$2y$12$y5AqnYHduLPQD594z9HpqOch0t6k9CHyOTqP0RFePXePwtP1ResZS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:30', '2026-11-01 20:37:30'),
(14, 'Bai Sobari', 'employee-14a9258ae3e88a28fc28b8c943210e5d3cdcf276a9256475da019b54f71c8412@employees.invalid', NULL, '$2y$12$VL6eW05M0h4C4td9Bw/k9OZL8saYWc.LkRgrrXwiRRPI.GGY3zf8W', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:30', '2026-11-01 20:37:30'),
(15, 'KHARIDIN', 'employee-d2ff4d4a0b33c3dad1bc18382d53e7ce0458e27d0ee0cf914fde42da7ecb640b@employees.invalid', NULL, '$2y$12$8v0QvVjjxCxnxoEAS0nssu1If9VhGo5TnfHvv3c/VSUuHEzqpYP5S', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:30', '2026-11-01 20:37:30'),
(16, 'KOKOM KOMARIAH', 'employee-cc1601824fa3ed0b66433d8ff6ff17042893f685f8b435c0b2b30098d7b06dab@employees.invalid', NULL, '$2y$12$.UKy5E3oIDEJ7w7smvfXuO2.yLmR1W2m67owf6XYAMbeHaFWuaP7.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:31', '2026-11-01 20:37:31'),
(17, 'NOVI NURHAYATI', 'employee-753498ca351fa7e0781546262f02981d0bd2f5d7fb4a2d8572854dc3d7761411@employees.invalid', NULL, '$2y$12$td91whBPd.eyGbp2GpoUQuCJNr.MCBzyunrP3lgwj/fs9qBxAYfrS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:31', '2026-11-01 20:37:31'),
(18, 'SARMIN', 'employee-cc7e7f42fac6f488596c99c887a9c1eb1264614fb54bcd47f41b2be0cd95b0dc@employees.invalid', NULL, '$2y$12$wL5kyuxVn7sdGVWvPZnxIOqhobxWUlNVXK.bCZn8nihTh.qIk08yK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:31', '2026-11-01 20:37:31'),
(19, 'SITI ALINA', 'employee-3a7a275cbd2bdfdf788fc95b9b4abd34e1664849ed345d8e6ccb803555ff4149@employees.invalid', NULL, '$2y$12$2Creyu9zbHWNpKVZYBslHuH6EXh6LQzHsMDdjrKghGQb.OyMvO9Gq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:31', '2026-11-01 20:37:31'),
(20, 'YUYUN BUDI L', 'employee-6ca8d88140e30d23f94700c867e5637609debe943c9c7ca40ae3ced7d8ac8f33@employees.invalid', NULL, '$2y$12$n47nQwZPImRJ6D788JHqi.iPDFfQuujZMevzjVz.l6a4FPtzF7w8m', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:32', '2026-11-01 20:37:32'),
(21, 'ACHMAD FAUZI', 'employee-4cbbaa69dc486a9cadf3f9768adffe55814b93b99a078342a4a5519a12df9c09@employees.invalid', NULL, '$2y$12$ICBxxFm6g6s0hq.jHFfQ3eMVTkSpYPjDZNPVqQa9LBFmm5HVf6N.m', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:32', '2026-11-01 20:37:32'),
(22, 'CARDI SUHAYADI', 'employee-88bba83c2bc794f314c73091ba8b5716bad62661de0b50ca454cdace048cc786@employees.invalid', NULL, '$2y$12$PUHircBPdy4VHJEVxOGJH.hCtbxDKpd59Ke3CcSYHUR27DZo4.Uo.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:32', '2026-11-01 20:37:32'),
(23, 'M. RAMDAN SAUD F', 'employee-7ce029451f295188044f8bcb1688a7574b2aefbdc6fb75fcb5dd0f0d77aa61fc@employees.invalid', NULL, '$2y$12$33SMPeW.Z55bbzb9m490e.73h4iIK.DM6wc9b65c.NM5CWYaKUcn2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:33', '2026-11-01 20:37:33'),
(24, 'ALGIA RIZKI ANANDA', 'employee-7b73fc617ec5c4e231d24068d7e78c5e9019ffc7407d990ae983e3bdec7fe8cf@employees.invalid', NULL, '$2y$12$TNV2JLMUMojTbKOkUS0Igewau2rmQE4fmmsdnrXvPWzkbF1GCsfLO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:33', '2026-11-01 20:37:33'),
(25, 'IMAM NUGRAHA', 'employee-ac7ed9e7bc96f338ad0849f2954d909992d6b98c0a0a48579e1a16ea8c183675@employees.invalid', NULL, '$2y$12$MspB7piNgBZLfYSDk2a7mOF3vPspBJyavklRroplCZrP8kiHrSY4W', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:33', '2026-11-01 20:37:33'),
(26, 'IPAH', 'employee-91217e5500f4c88acbd15372e48215b5bb717c69efcd8814af2ac56c00f5ebee@employees.invalid', NULL, '$2y$12$1cVgrBDJQeVBriXMBC5gw.UuFW.nZ0iKRQejKJqgfIgSED/ZYAla2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:34', '2026-11-01 20:37:34'),
(27, 'MICAH CAHYATI', 'employee-7865b2edd31566fda4d23c7614d0f5700ea21f94d4315b5a71f082db2d139528@employees.invalid', NULL, '$2y$12$PnghYS.tjjUw7PY/b.HAj.0S/cOdmSY3rDHxl6e.5/qqLrx3O7yJC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:34', '2026-11-01 20:37:34'),
(28, 'NINGSIH', 'employee-69432a10b84b195416c24b662c91e8aca13ce2aecdb9afefa663cb672c42923b@employees.invalid', NULL, '$2y$12$p/3/.htErcM4X1kS3XF7X.94rK8GNA/lqiu6giK7frAMmDygAFX2q', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:34', '2026-11-01 20:37:34'),
(29, 'SYARIFUDIN', 'employee-bb81918b54abb82e22e2246dc5a73dcfc41195f8491ab61ed32f70f56fe41c6c@employees.invalid', NULL, '$2y$12$V17Fq.G39.IwhYhvWCQj9ejzI8vZXTy.y5YvMI5GgDDCyikloVkdu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:35', '2026-11-01 20:37:35'),
(30, 'WAWAN SETIAWAN', 'employee-0172ec6c65b18b2c8c902c9c13f6c8f1cdb4dd77be5ac08726eab4f56a8cc1f4@employees.invalid', NULL, '$2y$12$mnC2O72EVtday94dB0BCFeWzMUXmW.wPfTKZYRntN7eN//DbbMVve', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:35', '2026-11-01 20:37:35'),
(31, 'ASEP JIDAN', 'employee-7079cebd2273ecd5ff89030d5e3a1795dc8066d23d878972513100c4585d9d41@employees.invalid', NULL, '$2y$12$SR9G65aha3ML.Pv.dK7pbexoS4cfa4F6EbAif76w7l/bKO5Ffa0Si', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:35', '2026-11-01 20:37:35'),
(32, 'CASWAN AGUSTIAN', 'employee-0afafe55d1810fbf470cf95e5f0486c6deb26f998ce86b5e3cc5233c95537f28@employees.invalid', NULL, '$2y$12$8z71FA5aZB20HZRRtaTdcuBjgEzZ5B7RmY5k5wu8zJ904zvK/FbCu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:35', '2026-11-01 20:37:35'),
(33, 'FEBRI SUGIANTORO', 'employee-b9a207ee30b363cee5e46b47ac6b94693f935f44bca56c07b4c6b6243e015299@employees.invalid', NULL, '$2y$12$kcnKZmGPucvGbcKR8jlgqeEhrsRNcSDCsoGeaojPDpKDniCvILnRm', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:36', '2026-11-01 20:37:36'),
(34, 'ENIH', 'employee-73fd11980a28f8de681222b26f7568ea0bce59883af415b273ce42ff6f8a5a6a@employees.invalid', NULL, '$2y$12$gINQnBQYwvIHlDsmRkJYOOL5y586MUz7jpwXGITbKKMiHrU9YCKJ2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:36', '2026-11-01 20:37:36'),
(35, 'ENNO AMELIA', 'employee-30316440c8f79659a3455faed3760421392335e139fa0bab9db0afe62d4ca29b@employees.invalid', NULL, '$2y$12$yGLnQv.wQ.Va.xQbAdaII.zSqAQcyCcKIQ0z9uhY8n4BsNWCyrQd6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:36', '2026-11-01 20:37:36'),
(36, 'SINTAN', 'employee-b100e0ce7b5064f76e4b42c127da2a933ae75daa76b84a6e965f394701c89e6b@employees.invalid', NULL, '$2y$12$Ohw6oLv21SbitN6Z9wgmEO7rWmMhJKvoW/dyC6S4P.383eZM/FCuy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:37', '2026-11-01 20:37:37'),
(37, 'CECEP HIDAYAT', 'employee-09234cc9b1d8744501f1e3eeac36939987c15e81c2f1e9168ec59d1247e4c8ee@employees.invalid', NULL, '$2y$12$JNn/zn8iXdHXOLSo99evNu4wJG3ybC1ySmoFMIdW8nx9EPEuVu.Iu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:37', '2026-11-01 20:37:37'),
(38, 'RAMAZAL SAPUTRA', 'employee-6099452200ba6c999ace76489461cf286b774050663555938480e07228d91180@employees.invalid', NULL, '$2y$12$BLXdYck5MC0O9TK3LKC5geSWjfn3Qj4btuVIJrDekMJXDBm78B/pC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:37', '2026-11-01 20:37:37'),
(39, 'DANI SUPRIATNA', 'employee-20bfa93bca4991ea8222a1296a5d9ec25e0148fe91e928a0062fcdc48f17ca53@employees.invalid', NULL, '$2y$12$p.HRuwS27Z.vHVnVHbHzcesx0d2TeZO.7m7GO4lho9I4vRc0k0c0u', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:38', '2026-11-01 20:37:38'),
(40, 'SITI MARWAH HARAHAP', 'employee-07b9d9e879ef01a0485565b231ebcb310f984228031bcd31ab140e0e436dfb30@employees.invalid', NULL, '$2y$12$ax8w/VY.MLNRdZYl.reJs.QSVQD/Mwuu1ye16QJltA0o3uYWqVcXS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:38', '2026-11-01 20:37:38'),
(41, 'SUPRIYATIN', 'employee-389659da0869c30ecfe7168a40550b2a610d1e7a8aa28ca9c0220a41929ce078@employees.invalid', NULL, '$2y$12$j50gnDCmpVQEiFwjOuibYOkDvFzseDFfQ2Yc7/HcVZ2vGVZDaf0Va', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:38', '2026-11-01 20:37:38'),
(42, 'ERSIH SUKAESIH', 'employee-a39eca2369d1e0858b0e03c14ad45fd52f4373254c99ce02fcf80d04aaa5627f@employees.invalid', NULL, '$2y$12$lKnMvrFqfbTm2/HK8yn30u6GJZB4/m02WInx5Vd3egbrWmJCYc862', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:39', '2026-11-01 20:37:39'),
(43, 'IIS RISWANTI', 'employee-072c0684b9a2ec3d8a1805224c0b3cd52a29369e43faf121379e23c7d67a3e10@employees.invalid', NULL, '$2y$12$M.ZsuKaaF88Go5n/Oa3mpOGB1v2JPUBxRVUrZOAoOO6k9fUmtsW.2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:39', '2026-11-01 20:37:39'),
(44, 'KHOTIMAH', 'employee-7768d597e6037c0857eea38709a5c4c1dff1debe76bd865b201b2efb0e5d1193@employees.invalid', NULL, '$2y$12$SFVgeTHAZpWChBFoqD7dFuC0BOWHt0Y2lmMjnk.VZl8YjGLvJSTgq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:39', '2026-11-01 20:37:39'),
(45, 'NIRAH', 'employee-cf7e91062f8553e01400cb3d3b99475efbf729eb5adf259d816c9cb2fbcd065d@employees.invalid', NULL, '$2y$12$7L.1kHoFa55jE6qf6CygduDvrnsQ3r8LonVV21Uw.e0AT9ec45CiC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:39', '2026-11-01 20:37:39'),
(46, 'SUHENDRA (REPAIR)', 'employee-d9d265c523e18597e439864988f75c71395ccda7c2452de81276550f94d92e20@employees.invalid', NULL, '$2y$12$ngHhOzEmr5R38Iqn/ikwWeepgK8rFJuV/.KrdCsdCwQx/uiEKAWzS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:40', '2026-11-01 20:37:40'),
(47, 'WINARTI', 'employee-cccf2fe748227724d9bcc17e7f70e55682135e29f020bad150e4c69da675e5eb@employees.invalid', NULL, '$2y$12$RA7YNK7zx6KF0fj8v0A6Yuc4QY.TxKezycXR.WmSVTIt5L2pjIrYC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:40', '2026-11-01 20:37:40'),
(48, 'KARNAH HASANAH', 'employee-01377ba4df4d4bd465cbdfbbec70685367de5cc267cb322da809a50286b65ddf@employees.invalid', NULL, '$2y$12$8y5LC9uq5xXXY.lgJVvg8.QkOcVtdfGzGEhcu3LRxg8i3IEv/PhR6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:40', '2026-11-01 20:37:40'),
(49, 'MUJIROH', 'employee-620bb15c26a906984fff3d842fb26d29904b3b6db575557751de9a1983fe8b31@employees.invalid', NULL, '$2y$12$jtg8pDLIVmsJIHGDgLeC1.NNd0RvFNmN4zO45o.zDe73Nv29YexLm', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:41', '2026-11-01 20:37:41'),
(50, 'SRI HANDAYANI', 'employee-7ebd5a9707acc048e1078147af4624c21cad5891827dc7ef5104e21a27533f67@employees.invalid', NULL, '$2y$12$uF/MEFz9S3mAJAwWePaDsO31hwOXxLCFTJBfoAZQNQbarnIwAoLRC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:41', '2026-11-01 20:37:41'),
(51, 'SRI SUSANTI', 'employee-437a3296837be1ec9bcf1b00271dfa31c3fb4793839e0e77c48888b0984617d0@employees.invalid', NULL, '$2y$12$fUym9SWCmWDL5EObZjbpbeNIyWfLzKQaMBjAL20WDtwzKAWVZ2/Eq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:41', '2026-11-01 20:37:41'),
(52, 'ANITA PUSPITA SARI', 'employee-57065bea7746e6cb40a34ff78b5a21ff6afc8c3caa27059843e90456f8ec6102@employees.invalid', NULL, '$2y$12$pbSP4IC912SM1/JsVOGKEuzZNVR95AEkvABXeZQTyoUaIKmGN/GcS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:42', '2026-11-01 20:37:42'),
(53, 'SRI KARNI', 'employee-69cf605fef869c34758ce0c19d53358cceb0f127f5503ed24fbd71a8ce31975e@employees.invalid', NULL, '$2y$12$tLknxax8VYAh661/f4GGZukX3JaM0rHkFwBliqtiQRDX5Tp6Zia7W', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:42', '2026-11-01 20:37:42'),
(54, 'SUKESMI', 'employee-a569c992c3985b5c699e9f8a613a74d333084833ad025b363755ad7eeb7d99a4@employees.invalid', NULL, '$2y$12$KrdVSQtP0OPSka/wMPQfv.ZpX6miqb/ZmIlA/LUBFIKuWB4Ln4A7K', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:42', '2026-11-01 20:37:42'),
(55, 'NUR LAELA', 'employee-92888ecdd29f0ccce4301775c02d6b6903537ebd25ba5846d0c829c2c8467f05@employees.invalid', NULL, '$2y$12$qxOBjqMqgnc572OCCWN/iejAbXek8FFnFxDsSRoUDhH5hZvCVRNue', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:43', '2026-11-01 20:37:43'),
(56, 'DINAN', 'employee-9e971b096a6519fcbd61298339ad023cc7ce477872d9e5b84b67912c22e60182@employees.invalid', NULL, '$2y$12$JbHBAKl1L5uSGX1H.t.GfOFhAk7u960pqbDtcKgWk38.ejfILAieu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:43', '2026-11-01 20:37:43'),
(57, 'JULIA RAHMAWATI SIREGAR', 'employee-20b8ddb4fbab006297a5de4beef222905869398989198068676709f0fe9c962f@employees.invalid', NULL, '$2y$12$NnwKJJT1ZvBuKSMzxr0LO.YlB88imF3FM2tHL25ELnGRHzg.3dKye', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:43', '2026-11-01 20:37:43'),
(58, 'RIZKI AGUNG H', 'employee-f1ec4ca1bc284587d924c314905aefa80e97f6dee0d1453c66c52a53da58aed7@employees.invalid', NULL, '$2y$12$yNymR0eBPexG6grfL5HzRuRUDoziWerczo9x15HcmBbwDAr9mNRyK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:43', '2026-11-01 20:37:43'),
(59, 'OPIN MAILANI', 'employee-890e351e656e0ecd84b0504abcf7d8a45d9cf7f301b16909d7b32fabe39e945d@employees.invalid', NULL, '$2y$12$/H/h9EM1JGus/BnWN1LaZOm7RI8HCW/7T0.if0OmKXoXaE9E6A0xW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:44', '2026-11-01 20:37:44'),
(60, 'NABILA DILLANI', 'employee-db6cf4cc5d612c725ee01373228c53915dc40ba6ea028d201602b6a015fefb6f@employees.invalid', NULL, '$2y$12$j9SPXsRfnm8qHWOIotW35OI4dbk84WJ/KlKDbrk/ODVV/ey20InI.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:44', '2026-11-01 20:37:44'),
(61, 'TINI MARDINI', 'employee-8c263948324cd802fa4123fc9671a62dd1f0d7ca078759bbe925f1a13344b0f2@employees.invalid', NULL, '$2y$12$nPTRtt1x78pfXUf53MIwr.C9QXT1EUBiUcS0iPVFaE/TDFkvIrJwy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:44', '2026-11-01 20:37:44'),
(62, 'TUTIK WINARSIH', 'employee-b304e237e1a41672fc2743e61576dab62b22e8c58621bdc2dce9100877e990c9@employees.invalid', NULL, '$2y$12$aLFLN.4njzmez9csRj8BG.6wm4kxhh8kA5KlLiEYg2iq9HE4to0Na', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:45', '2026-11-01 20:37:45'),
(63, 'ABDUL ROHIM', 'employee-0982a04082cf4eeb88151c88cf613ad1b46c13885b46703111090ece85e61cdd@employees.invalid', NULL, '$2y$12$JSHooQqrRPsHfLYG5St8HOHHaZnw6UwTD2mJc4xRg9/VMdna2DlJG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:45', '2026-11-01 20:37:45'),
(64, 'BENI SAMBODO', 'employee-0ad64919d36f802a4fbdb26b873df5bfee5bbe27721c40f1a635a9e58af975f1@employees.invalid', NULL, '$2y$12$jkPNgnj4Gz6sF7b..DkZs.LYls/O5GxnyBloG5bX5tO4bBEZRz/Na', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:45', '2026-11-01 20:37:45'),
(65, 'EVA MILANTI', 'employee-a2fc5c501381be7fd9edec0e9204dc11656b2f62d7f2f106c523db05b8b1c342@employees.invalid', NULL, '$2y$12$FueYgmkNZKyYw0wKzI.5Ne3uveVJhFlxCwVuLeK5.ZUhBkutwzuca', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:46', '2026-11-01 20:37:46'),
(66, 'KORIAH', 'employee-b1f16541bec73924b2ef9750542190ec65f0b5668fdd4fbe33a0d8ff49483bab@employees.invalid', NULL, '$2y$12$ux27OR7FH1SSBz/6WI9lSuGEBIDrqQt9gwMBPL66kKJTpyZIuKmrO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:46', '2026-11-01 20:37:46'),
(67, 'SITI NURHAYATI', 'employee-36fcc89ec85012bd8c53359090288e67450c52881c60de167eeeac7d24e943ce@employees.invalid', NULL, '$2y$12$/0cBUWmiCs1uTxQg7X6MHe6YxeQwQRhphglWG7NNXxYawwEVEz7Iu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:46', '2026-11-01 20:37:46'),
(68, 'ISAK SAMSUDIN', 'employee-7886a035f213c427e9133df370d2225e3d98e1b59429c655c6279fc1c4e04c48@employees.invalid', NULL, '$2y$12$wIX.6PYzV5Ky1o2nqdYwH.7G0Jvvv9M7vEW6agIH8Y5NlbPtwgmMm', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:46', '2026-11-01 20:37:46'),
(69, 'MITA NUR AZIZAH', 'employee-28632e8af21df24cb369e66aa66b7ba8196568a8d5d79aab64e7aaf95ebdbcfc@employees.invalid', NULL, '$2y$12$Kp2CBeY5ATmBu/fpufjARuLr1Y4MLJRrab9EkYwaz5H4yG7sLmjSS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:47', '2026-11-01 20:37:47'),
(70, 'NUARI GALIH LAKSONO', 'employee-58eaa3edc8413c414155e9233280831060a59e2af8c055c72498115c4db5455b@employees.invalid', NULL, '$2y$12$eufAnx2qyQ33MFONQ3rq3.aPvspkhvatppWHKkwo98bSkXTt1DPP6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:47', '2026-11-01 20:37:47'),
(71, 'CETA MARDIANYSAH', 'employee-da2809d9d85e1b897061c29a9b997b7737f41a59c46b848d78fdb9131103ffb4@employees.invalid', NULL, '$2y$12$x2XXvDjWZ6GyyrUq0JcYI.BdvUq7kJ8FCfJ5DtWFyqyz8qSyBa0s.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:47', '2026-11-01 20:37:47'),
(72, 'LAPENIA OKTAPIA', 'employee-b7c67f34e91d2e863a2ecb52e491dec6a5123b583aedc23faf6683a5646ec475@employees.invalid', NULL, '$2y$12$UoYPHU3DttfZK1DoZWzjNeV.RHH05IA6JpLBLgyHQVPv9XJj.//D2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:48', '2026-11-01 20:37:48'),
(73, 'AHMAD NURWAHID', 'employee-91ea3941ae0f99384f22908f23de1228673de287fb8a3038182ae9cc201957cb@employees.invalid', NULL, '$2y$12$btQF94l7wKSZNM4I/TEggOaSXUTTd0Xw2Oq9mvchGbK3pvRdRBes2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:48', '2026-11-01 20:37:48'),
(74, 'NAZWA KHAIRUNNISA', 'employee-f770e80fe53476aaac4fe8790ae599236bb3fd2546e851fd1bb2fa165aae53b8@employees.invalid', NULL, '$2y$12$92k.Q0wDGHrE5nMLbbjlU.irQ11qZs6pPZ.aRaXwMMLqFHvOmJFL2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:48', '2026-11-01 20:37:48'),
(75, 'PERI FAISAL', 'employee-97395de6f739195a536c8ba8e2a5369867195d556b4850de7756cce8dd695248@employees.invalid', NULL, '$2y$12$JJg1TBN7zXiVD/qQoJ.0nOr0O/ghAqB/U7kxRUHR64TXTZjz9WKAC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:48', '2026-11-01 20:37:48'),
(76, 'NAMAH', 'employee-c628b67ac9620520a5de422abae41f50968326b6449ad3eadc65302432c85251@employees.invalid', NULL, '$2y$12$3gVPxEeOxDuAQ/qoMPuNJuf8zfxSaZsNrrDVMUy26BZOUhuRHdwmW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:49', '2026-11-01 20:37:49'),
(77, 'NITA PURNAMASARI', 'employee-f961ba29801ba16b55f940e9ed64a78021353989298f95af5c320df2b23d2d60@employees.invalid', NULL, '$2y$12$2VWS66tLcYzdWcqNHYkW1OFzcrmqjZxt6693VWlI5Dbz/rUvaFKO6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:49', '2026-11-01 20:37:49'),
(78, 'NOVITASARI', 'employee-c596c94efe4a4108884537e763ee4efcc2802fd475d0fffbf4ce50da1d87ad26@employees.invalid', NULL, '$2y$12$Ql/hOQar0MhBIhmLNLUXFeWJgu8e7xEhXKKnx3WMC4BihWkxEjJcC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:49', '2026-11-01 20:37:49'),
(79, 'SARI FADILAH', 'employee-52fb7c034db9f6fee3890d83bcdd5786681f345aabbecd5f317042c7661eb69b@employees.invalid', NULL, '$2y$12$4FjC0lcLi0YHafD960bIb.3ej2ZZypESvpY2OQj.WoSLGk62yqC12', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:50', '2026-11-01 20:37:50'),
(80, 'SEPTIAN RAHAYU', 'employee-00d2191d43cd363d6b6dad25ab556821602e95e41eda5d1ce7f8e1cb52611f3e@employees.invalid', NULL, '$2y$12$gdc0YY2ttliD6uZT9Bt7cOC5SGv/lirkuvv2uZvWYFcwRD9HxJ4By', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:50', '2026-11-01 20:37:50'),
(81, 'WIDIA WULANDARI', 'employee-d46b8190736ade0c1f3664d2f12b6b037f74a49f9f257de79a029dd317984bfd@employees.invalid', NULL, '$2y$12$IZz41LfvuDHHewjspoiRi..Gk0QoFq6wzOUDGJHv7l6npXfFU9UAe', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:50', '2026-11-01 20:37:50'),
(82, 'ADE KOMARUDIN', 'employee-e0220e729483115407da0bff4e350d14926bdfc91e43132caac24de4733a0f27@employees.invalid', NULL, '$2y$12$kyb1P9hpCT2wqDvCL6S2BOGwe.nqX9EZF99hyw0Dg/c92QHuGC.Qi', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:51', '2026-11-01 20:37:51'),
(83, 'ADITYA CATUR SAYOGA', 'employee-05c46f627b40086bf017bc01c79d234e173912dc4cc378f150482134572a6b5e@employees.invalid', NULL, '$2y$12$zlk/v8Hp1lkfp3LVYlf3Ke32wJS4M79ON3Yz9qmbwNxxr2SmPcfzC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:51', '2026-11-01 20:37:51'),
(84, 'ALYA SERA SETIAWATI', 'employee-571c24c2e1cf55c0d3157efd1acd14e6496d9ed02f5269eab74706a07d9deff4@employees.invalid', NULL, '$2y$12$TM2z943ZdqsfNXy.ZmfHz.iskkmUPBGR.mQad8/Gt17J0cXXYaD9a', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:51', '2026-11-01 20:37:51'),
(85, 'APRIYATI', 'employee-6f4e0d0491d4e2c476cd0e0de3eb28013ee3655e1da0bca4015569ffb09f1c9c@employees.invalid', NULL, '$2y$12$Q2eA/Xi.y8/DTkuuoUMkwe8/DRPJ0dTmhRTXmDFhF3UfnhXDO8nuG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:51', '2026-11-01 20:37:51'),
(86, 'BERKAH MAWAR SILALAHI', 'employee-052c0ae969f115aaf8f6ad2eb28d1968c8d1180d4aa922229ab13dfaf0e10b2c@employees.invalid', NULL, '$2y$12$6rWdLg/430o5HxdYGUlrI.DK6sMS2/Jvq6NX3q2yeLtyXwlpln47m', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:52', '2026-11-01 20:37:52'),
(87, 'CARTINI', 'employee-38294f55ad9a248115ae4e02df6ebfa37a7aac6f6ba707a38fb4ee7d77b5e3f4@employees.invalid', NULL, '$2y$12$2oFNmsEdqTIUJTKchqGmvOEIq21DCYQJL1meUNpdl5yel64E2FKva', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:52', '2026-11-01 20:37:52'),
(88, 'DEVI KOMALASARI', 'employee-6def58c5144b564d1cca90aba15c67644b8731a4fcf06977d53cf0a1309c59b6@employees.invalid', NULL, '$2y$12$p0lWAd3WWHxcaKGLjWT0/uZosFFkPAAXVUMvmA7t/dIJhqfWCepCC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:52', '2026-11-01 20:37:52'),
(89, 'DINA', 'employee-0116ffded369147678b96c4816b9dac84eb85f8a8b177220904a95d33d819ce9@employees.invalid', NULL, '$2y$12$JC7q5Sd.2l2nHcUgTEx8u.2qOQbgQ7H1SaAeO3e8F9RHrfbLrTDA.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:53', '2026-11-01 20:37:53'),
(90, 'DINI TITA HANDINI', 'employee-47ee3c1654a9b5dd938f7c8a4dd1018e5108f56eb0d47b27f7cd48b5cf56177e@employees.invalid', NULL, '$2y$12$ZkwTg0S5xeFS0ca6x.nQX.CF/EveCG8Ke8oDSIllIWZ2Qg2zgtQBO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:53', '2026-11-01 20:37:53'),
(91, 'ENAH HASANAH', 'employee-6ecb30ea61cadb8f93dbf3b93e44583fd1e52fc3f977bc90ea9146238486e3f5@employees.invalid', NULL, '$2y$12$k50EXjv6Mtqhq70Q24VHcOam7w3F5oBfR8D9sso.q.5L/yOpQUjbq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:53', '2026-11-01 20:37:53'),
(92, 'EPRONIKA SIHOTANG', 'employee-146f4f382efb26a490be1491915d84dfdca23d51bd443b5cbf76ce77210518a8@employees.invalid', NULL, '$2y$12$blJqkqq04CmfgBb/8g6BX.WUxBS8FVP7KIzqEsRq0IxmrrDY5kX/G', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:53', '2026-11-01 20:37:53'),
(93, 'FITRI NURWULAN', 'employee-1feef13c7176a7438682fa8ebdf61c876ba78b114125e17d3a76845365852729@employees.invalid', NULL, '$2y$12$1GeMhSmb2NqdLosHYn4mXuoiZj4h5ad5IjIf0joE5XCrbT85ASHiq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:54', '2026-11-01 20:37:54'),
(94, 'HANIFAH', 'employee-39d0a8b2d927547bb20ab5b474852920a110f41e147b138ea4238a46e06104cb@employees.invalid', NULL, '$2y$12$ror60hqBaLOwpJyziZdhqupujxoHOvLK.G46khql7tSOzoAs8ottO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:54', '2026-11-01 20:37:54'),
(95, 'JAENAL ABIDIN', 'employee-d3f1886bda98eb601b79bdafdfd852bd9d064dea28b4008bf104cc682729aa71@employees.invalid', NULL, '$2y$12$PjEuKsXdhUBd/IAa1D09Oe0U4UAcZPkkmA/meDk3x9nJnWyxHqW2G', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:54', '2026-11-01 20:37:54'),
(96, 'LIANA NURUL AFNI', 'employee-5d3adb5f56617480ad4b4f199da42665d1078e297d81296086fa7e90dbd05119@employees.invalid', NULL, '$2y$12$CDtDjylPdV7C2JjvSznmVOETaOXAULlY.eHXJlOvPy4TARAaj544G', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:55', '2026-11-01 20:37:55'),
(97, 'LISDA SIDABUTAR', 'employee-c774203c7705f1fe7c0bbafb8ad18292402ef68cd3a61c5764b0c14d43debc90@employees.invalid', NULL, '$2y$12$rLeQu90UJg213Aj49pQvcuzb9cBlG0N4CqB83Grp8560aLbtPLbgq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:55', '2026-11-01 20:37:55'),
(98, 'MUHAMAD LUCKY', 'employee-b126ce2c50d428b5f8d839522a800b068a8cd0dfdc7e41dcaa59faf4756528d3@employees.invalid', NULL, '$2y$12$ZgSD3SjQY6FXL.pjW9s85uScMfcnnq.gX/ofw87jp4LHzWHKUBv2y', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:55', '2026-11-01 20:37:55'),
(99, 'MUSIYAM', 'employee-4d1418ad82e5797b31a7a62b381b2c1476de45cb014b4bef6e0bbdd63ca1b623@employees.invalid', NULL, '$2y$12$YW.POSoZCEUvRjXST3Mbdu2bkES7LFN9nHOHL0lYSsbzLnhDyhUSe', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:56', '2026-11-01 20:37:56'),
(100, 'NENENG SHOLIHAT', 'employee-8f26a1a94c32e8b046630ed9f5089a92f0242c8fd0274d4a33db46cb2531e4a2@employees.invalid', NULL, '$2y$12$nnWhtJJbdPWIPvlbwAg2B.e3s2m11Ba2JZcDp.c/qJKF88t872yai', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:56', '2026-11-01 20:37:56'),
(101, 'NUR FITRIA SARI', 'employee-342c37a1a366ecc173860acb5d1f2fe2b4b9572cb30470af858bb1dfd85b87da@employees.invalid', NULL, '$2y$12$gDbRv/pX.bTe6WAYqbb8TOOTS8/6sAPLWhT1M5Z6r4aWSuxtwhaI2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:56', '2026-11-01 20:37:56'),
(102, 'NURHALIMAH', 'employee-af9a5934907020a00e5de13a834cffb70b500ef2569b43c3bd76ab15a25fccd0@employees.invalid', NULL, '$2y$12$dryxfl3kzqP4//FwPoH1AeZfVscm8GZargII9JkHYBmJ3Thpc1Lty', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:56', '2026-11-01 20:37:56'),
(103, 'ODAH', 'employee-6ec1c243c5b05b729085374b1e70659f478dc99481eb391c359063802073a1a0@employees.invalid', NULL, '$2y$12$8yDz/vc/kQgxA1qBGTb1H.S90hOfgHldzRQz3/HvJISj2LOfwM6V6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:57', '2026-11-01 20:37:57'),
(104, 'REKHA ANISA LIANTI', 'employee-8b5e8d1d5f91959d8a41c7a85e46a4ab861f73556e221d9969fa1a396eb8e8a4@employees.invalid', NULL, '$2y$12$fuHv/SfKOq7dM8J6MhK4ouAJiVLKlyMsqdcAx5jEj0ydgMUw2nV9q', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:57', '2026-11-01 20:37:57'),
(105, 'RIKY EKA PERMANA', 'employee-a9deb7794c16a860d22f2a9d18b41975ab210f282bc8456bd05d05af65ece27b@employees.invalid', NULL, '$2y$12$PPBQMC3xLFfu2sW/JXIv.euuFqSeV5KYXZsHAFQQmec7wHarn3ZuG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:57', '2026-11-01 20:37:57'),
(106, 'ROHMAT', 'employee-1af12395fded16ed2d0520aa0dbdf72bde53b456061c0c44059b45732b01fe10@employees.invalid', NULL, '$2y$12$Yvq7TrhpJhH51a3s85L4JeETUMZ7TAvltPbWgto0D2AdoxueUsuVy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:58', '2026-11-01 20:37:58'),
(107, 'RUKINAH', 'employee-0a4952ca956738c5065822571b7553e6273efb1e90996dbadb8ae5956d14b921@employees.invalid', NULL, '$2y$12$Mx8PWTpc/EYbTuwYW9BzuesFxGmUT.skGeqWkSaY0wGVNkNh4ZgzK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:58', '2026-11-01 20:37:58'),
(108, 'SALSA ANISA', 'employee-cc3b4657f55df8c90fcc7ee160b8c1032e9ff22885da465e9c0c43db34e537ac@employees.invalid', NULL, '$2y$12$idIeg4L.sXR78tLgx6XpHeOAlr2mGRXSwcW8su/HvFl69ptGV6sbW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:58', '2026-11-01 20:37:58'),
(109, 'SAPUTRI', 'employee-ccf94fff00a936e33ae34072984b92608d9531928a53f7283a3e0ce79f4392be@employees.invalid', NULL, '$2y$12$DgOhyRoNHuvn.ntx5xIMPeonEtzeZNI6xlV46TADlXAk.x9yPOmvK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:59', '2026-11-01 20:37:59'),
(110, 'SARWI', 'employee-2d39aa6e215931fb9ccda72f2be91eb2f71975d7e14a2776bb7c7d056e43aa4f@employees.invalid', NULL, '$2y$12$2NWe6BtOv/zkREB.zB4CKOby3C19PL0zN5Yj0lX48pV9Y8IHVo9Ua', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:59', '2026-11-01 20:37:59'),
(111, 'SIMIH', 'employee-fcf2557a6e57b6779d79ef743738764b64985fc55a184db74afa688cf04ffeb5@employees.invalid', NULL, '$2y$12$zMZgnW3XvHzuuVWDuJtP5.hSfyArOS3kpsB..ou8oyironEDLU1.m', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:59', '2026-11-01 20:37:59'),
(112, 'SITI NURUL IDAYANTI', 'employee-a66272839a3be13ac80e3a665d937a41a1dfb6b1777a189e4af6b587883735a7@employees.invalid', NULL, '$2y$12$iXd0wSlkGg3gzFYBkGQiSeZU7hR2UFcLIPd47.8DE47nkFajDQVSq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:37:59', '2026-11-01 20:37:59'),
(113, 'SITI SOLIHAT', 'employee-ec2553a5161b20a85878f7dd7487b58a5f7ede099ec8eebd51141e962c817e66@employees.invalid', NULL, '$2y$12$3824.tOCNRFE2FgXNcMAheumEXWdnU/FCNf3JL8/wz/r1eKefNngu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:00', '2026-11-01 20:38:00'),
(114, 'SRI WAHYUNI', 'employee-40440f058dd3a21a5037f97c8de659d372d7fe4b43d3f3933866437f1b316098@employees.invalid', NULL, '$2y$12$jwt0kE2C46Db6NrXdrHfk.7Fy1DvHBcpYNJLgc4H/1CvkRa5WHlF.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:00', '2026-11-01 20:38:00'),
(115, 'SYIFA AULIA', 'employee-89fe4f7ce644c9681b865c66b8e3e681f752982c4aa5942b15f8f66a61f3cdda@employees.invalid', NULL, '$2y$12$bq9MmcTCGAFP8XG43po90uVMke/SjgaLuT.Q64sOdtAhvp73R4TrW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:00', '2026-11-01 20:38:00'),
(116, 'TUTI SUGIARTI', 'employee-6006a14f3fe8ff97e0dc0e3da9bfb8a45100ed2063bde95556ebfa63061488ee@employees.invalid', NULL, '$2y$12$Tdz0aoUUOAIwUBgNAPD2tONwDVBIGocaKxyB8FA7lDX9Sdzqi/87C', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:01', '2026-11-01 20:38:01'),
(117, 'VERONICA FAZRIW AYAZA', 'employee-099ac30c888c7214882751495ecfe503c3aa878a599d7ba0dafb887dbd7a194b@employees.invalid', NULL, '$2y$12$Run7QEJ/OEG1DX.PyTJim.rL61j.N5A65qmBTZasq4Hv6eprIa3ly', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:01', '2026-11-01 20:38:01'),
(118, 'YANTI KUSWARA', 'employee-5b5f8fa0d36a351844b3cf2fddf7d53c9e452852a2acdc3072b8f31cf996db53@employees.invalid', NULL, '$2y$12$TkV1TlhBHQZe0OF2EO.BVuZTZ0K83fQAQM56575cDbPZW/QpmGPSi', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:01', '2026-11-01 20:38:01'),
(119, 'YATI', 'employee-069e7a9b53b0135e61c4271e2c24a1e7d6688ab7b9f43bd58d8386b2e4f0b232@employees.invalid', NULL, '$2y$12$z7233ykS4iJ8eTopUfX.HeWe/7mIii.1C1FyquOOLrV7uB.KVKdDi', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:02', '2026-11-01 20:38:02'),
(120, 'FEBRIANI AULIA PUTRI', 'employee-30c61fbac012256310108769ef964c4a26ce76e63d6dcb55f46539d215e635e0@employees.invalid', NULL, '$2y$12$rDl1bdlGE936ysMuFX95hepBkgbVL.KvW8I2AUIJ/3kPZ/6xA9Dki', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:02', '2026-11-01 20:38:02'),
(121, 'JAMAL', 'employee-77374ee6262dbc57457ad1ceb7d8dd54797c4f27e3667e7146a542c0f4b019f6@employees.invalid', NULL, '$2y$12$8f8nTe43gI2e5XCY8SvLUOw1mG2KRzKy8Bxnbih7rXIhejmo8qMsO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:02', '2026-11-01 20:38:02'),
(122, 'SAHRUL ROJI', 'employee-0a6ed35091ce6361c18d3c655fbbc786ceec14fbbbef2e703ee9c856fa79f978@employees.invalid', NULL, '$2y$12$dXzK/T63EJCAfCtWJh6CwOUsTgDobJiCSBUh2fh2EKaIDL6J1NDy.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:02', '2026-11-01 20:38:02'),
(123, 'SISKA AMELIA', 'employee-df8cd5171759f7c183b588994367bb59725f3e5694ab17f3457ba8543a2c4081@employees.invalid', NULL, '$2y$12$M1ngWJ/BLbs8w9UQdKxIMOcKdDAyEC5678FAMtBYP671hrzp5aTSK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:03', '2026-11-01 20:38:03'),
(124, 'SUCI NURAENI', 'employee-7333f770f4e808f1889249af488db16ec425c4383a6414de5ba5aa9bfd75022d@employees.invalid', NULL, '$2y$12$XVmoLpwnD/o6E4N5iQhEuu7Pb2NhrcqISu4pPUkNSbJjSAAoqMG6a', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:03', '2026-11-01 20:38:03'),
(125, 'SULASTRI', 'employee-43042856b864eb2c2e60a04e477317298e5283798229799a728d6430e4aa7d91@employees.invalid', NULL, '$2y$12$MHuE9gVerbjzMVYLAlgiuuQGijGBkk2WyzdEdYqjn/KhuqCGD8j3W', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:03', '2026-11-01 20:38:03'),
(126, 'ANNISYA ALIF RIDHOLLAH', 'employee-dfed67c888e538145a0a48c65bbdefdebfafc94a956d02dc8a76e7fce10ca0f2@employees.invalid', NULL, '$2y$12$qVmLXThmV6t4XXhV17w5xupRMzQskkI4clEk5jBYd0WbsdXbaGFLO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:04', '2026-11-01 20:38:04'),
(127, 'DANANG NUR ALIM', 'employee-4905562229cc02352c5b00c62feeffbdec311ee247400763bc6391e4507fe003@employees.invalid', NULL, '$2y$12$8m.YVcrI.15QGQizCHeVKOkqqsw/ZIAPXa2y55z0.JZK9RwPPkSHm', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:04', '2026-11-01 20:38:04'),
(128, 'ILMA HALIMAHTIS SADIAH', 'employee-c9fb9cfe31c014548faca826915b7275f1feaa9c4cbaaafe36f2caf575eda637@employees.invalid', NULL, '$2y$12$BmvEIhoUPwia12RHvnI.5uDW3YfaStlLBXa6iEhc5NV4ONPIgwF6q', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:04', '2026-11-01 20:38:04'),
(129, 'ADE NOVIANTI', 'employee-22007c2bb93f4db7fdcf5d145e367756cf48c7f0335216c72de9b15b14597d43@employees.invalid', NULL, '$2y$12$gK/wpXwt2xbzjxIOJHSfvuv78ruW0Gp1ohSYg7AKO/qEizyy/dTQa', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:05', '2026-11-01 20:38:05'),
(130, 'ADLIL DZIL IKRAM', 'employee-7e031299c475cf53eb75574116c525ee4c42f3fab1613733e164c2a5b1d272bd@employees.invalid', NULL, '$2y$12$FxoLxamS36DecCiSmu8H4Oj0wNDyC0oITwxhPbYJyF93pa1rqhqfS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:05', '2026-11-01 20:38:05'),
(131, 'AKMAL MAULANA', 'employee-ea8044296471dd14ca18ab104fef730ba50e57ee31873c31f6b8848b80013273@employees.invalid', NULL, '$2y$12$Jfc7g8wyivBHU6Js7v11d.tLMdIbALrIpBxVWHgnI77Uj/DZmw.MO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:06', '2026-11-01 20:38:06'),
(132, 'ARIO HERMANSA', 'employee-390ffbeef0eff6627113038ebae5bd350a0f13e5b26a85ddc4987156abcc8388@employees.invalid', NULL, '$2y$12$041uW1KetZKoCvnXsjewEeu/GsJkS.KGKRI4HX2MhqUsznGpILYe2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:06', '2026-11-01 20:38:06'),
(133, 'ASEP RUSTIANA', 'employee-9f3eb40a96a783377da71c66c2bfdec2440daccac5971c4007b077721e4a44d4@employees.invalid', NULL, '$2y$12$uTmh6sLAUt7/jm9XqL0e0eMxOJTmLeUhmnCFX5r.M3kR9kmmiJF32', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:06', '2026-11-01 20:38:06'),
(134, 'AYU ARYANI', 'employee-1cc59586a18f1616d837f3e449392eadd21d03e069012e9b5b862e06f8d4e374@employees.invalid', NULL, '$2y$12$bUQNEem/v.rhT0Cx2nwOMu4awxgQxIUoR0xLWmoRg165/LkBhZZEW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:07', '2026-11-01 20:38:07'),
(135, 'EBAH HABIBAH', 'employee-51109d649a68fdead1e79f6f52f536722dd445dc03cd6f36c763a7ae33d4c04c@employees.invalid', NULL, '$2y$12$hORQk6rxx/YzT5rSxxfsgefnrNkgf0UMpm5nFMCOIWy2NAc3YURY6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:07', '2026-11-01 20:38:07'),
(136, 'ENCUM SUMARTI', 'employee-3383a818060ab72e2223659b3201fdf98483069e60bee9b45dd3c8045e24e91c@employees.invalid', NULL, '$2y$12$/.hm7GH6gSYWbOue6E623OgvWxNhqSjnnvA/AZR1htcdznKBH5XDK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:07', '2026-11-01 20:38:07'),
(137, 'EVAN/RAJANAHOT E GIRSANG', 'employee-089573b818fbc203568ee4d1c85a617366551bb0370c2ec532c74732620045ff@employees.invalid', NULL, '$2y$12$gAdf9i5HEY9S6kZfXzLoIOoUrRxtA.ZmhJSjhK2WNdTttvpWHu.3G', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:08', '2026-11-01 20:38:08'),
(138, 'FAIZAL AFRIANSYAH', 'employee-9ba3039f8178874fad09631e30dcda50de743491bce98045680ce082c49604ef@employees.invalid', NULL, '$2y$12$penijtQ8JSes2YpD4iDkTO22YPfQqIYerbMI8cm6t0tOjXCYcvGeK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:08', '2026-11-01 20:38:08'),
(139, 'HIDUP SOLEHUDIN', 'employee-fe84b77b029534713159878df01febec4553cba0a675d5e29293e835dde08728@employees.invalid', NULL, '$2y$12$9nmZmkOWduvRGOD955NzCuuJbwBZmMJp1g.SMEZXROuPrpA0NXNSe', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:08', '2026-11-01 20:38:08'),
(140, 'IDA HAMIDAH', 'employee-ceb83009aea1c42c4f32fe9d60df9d8c378c69f5431b3bb8724e5724897fd774@employees.invalid', NULL, '$2y$12$V4Yne.fJAi/iedbz77D7yuSAbxOlWXIZqYy59AADzO2d.4frooA2u', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:09', '2026-11-01 20:38:09'),
(141, 'IDHAM MUNANDAR', 'employee-7e09011e6b2c9512691084bd8bb9816489837c154f6a82d69071164b05a4ece5@employees.invalid', NULL, '$2y$12$LbZf8LGPWR2imdKivOFuzuSQjyUmc5UOUsWRY6EzOIFGCswGmG6LK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:09', '2026-11-01 20:38:09'),
(142, 'KARYANI', 'employee-270075525b79cc62b86eed99398635a20301905a1bce72a8e1f7410414a0e513@employees.invalid', NULL, '$2y$12$ncLYeD3rLyE8zZuApiH/mOFnd/IPnbiTWmVC9xcPGwFe3wK8KR6fC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:09', '2026-11-01 20:38:09'),
(143, 'KOKOH WAYAN SATRIA', 'employee-44084e576e77889efd6d4da0cd8d9229ceb9d744c562e74646834e833b333846@employees.invalid', NULL, '$2y$12$FLfx/sEtgV1IbVof86Fd.ONgp3cwu9PBw2.AEEpHo0zGHWbVgxKIW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:10', '2026-11-01 20:38:10'),
(144, 'METRINAWATI', 'employee-9c3942ba607144b876ba34f9e5fd9c9f0635a4bfe8b5fb23758bd92152470e74@employees.invalid', NULL, '$2y$12$.8.wblLxBWKd9uBFhaFNMuzPMDsc6FlULqi6Bg8L6vBneC6PYWkSa', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:10', '2026-11-01 20:38:10'),
(145, 'MISYATI', 'employee-daa7b4a974360e587e6a7b7cf10c4cfa434f79ce1c876ec0864c89115c5b5301@employees.invalid', NULL, '$2y$12$Ej4JgOS8VXPX06SDgleVVuSFy.gCQsWMNQOPUtKTVz/DDJE9Dkt.q', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:10', '2026-11-01 20:38:10'),
(146, 'MUHAMAD NAJIB', 'employee-939815b5a4209d2983ee2fc2eea022ac428be106ba6fe5f4f3a6af6fa0edb43c@employees.invalid', NULL, '$2y$12$y6FRG/Tu.1N3i/X46E/7SOlvhaezM3xAMk.KBNT2YI6VZrwiNaPRK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:11', '2026-11-01 20:38:11'),
(147, 'MUHAMMAD AGUNG RAMADAN', 'employee-0483b38d39d72bfc838aaf354ad0411003782008c943b8efdc1cc05f69c942e8@employees.invalid', NULL, '$2y$12$ZRGX6MwqrSx.a5PuLuMC8O4og8ENRxbRI5YRwSPBeAmmaHmPwXrbq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:11', '2026-11-01 20:38:11'),
(148, 'MUHAMMAD BAHIR', 'employee-252c79b4f44e8d3a49665270014fa72206fa074b4e0d33b7d7fba6d44f2db371@employees.invalid', NULL, '$2y$12$PVKwirFl4Z7rhQPm.3ipqur1.6y5SvFdcX9Un/pyvEUgvisxN0SP6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:11', '2026-11-01 20:38:11'),
(149, 'NETTI PURBA', 'employee-813bfa540c28a8e90176dd00992704117645a510356d283d4879ab2f5db504d4@employees.invalid', NULL, '$2y$12$sr4rcLlrbjH/nxNRGrMbhe9nQQTpE9iPWt5IoCB.hYKhKhRSCeAkO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:12', '2026-11-01 20:38:12'),
(150, 'OKKY SAPUTRA', 'employee-fd68c3fb276a72cc57d7adc649341ebbfb204c2566a2e44e4ce16fc5b0064ea8@employees.invalid', NULL, '$2y$12$DQ1EmzNSZBjBM6HWSbJDeedvrwPJsY/ID2eAj30Gs3M/jYR8LY3b.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:12', '2026-11-01 20:38:12'),
(151, 'RINEM', 'employee-730d4bff04695ea7fb37b8851121e3102dd6be28a1676cc27a4fe8ac7923d5bd@employees.invalid', NULL, '$2y$12$PFgeBITfGLmhqGBBXs.7gOyYg.ukz1kB.FBjMs/W4CXfSA0VZmQke', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:12', '2026-11-01 20:38:12'),
(152, 'RINNY FITRI NURAINI', 'employee-bfd34dc3d811052a4c7d109d791bc9d7fe4466fdda972c5e9b5e671d6f5b3540@employees.invalid', NULL, '$2y$12$I.EpVbG4SEciA4pUIwBieuc6G/xra.50XNwbIdGGd7FuhXj03IpuG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:13', '2026-11-01 20:38:13'),
(153, 'ROBY IRAWAN', 'employee-ca4a51c932231759c26e39d2343e0265de07195a53595bb9a5c48dd06d83608b@employees.invalid', NULL, '$2y$12$LlnH97MBJbkRm6EUbVaW1OnadZtFTMN9eonO3ogLozzwJb.QjvZM2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:13', '2026-11-01 20:38:13'),
(154, 'SAMAH', 'employee-a45e857f38c5923fc0ec3f3481cc8cc6ec884ce91854d3b5454a4f62f551ba8d@employees.invalid', NULL, '$2y$12$Ou6ZFAu5xmIV9ppq9WaLiuDyyvz68xBnRtipANmVROq5PXQ470htC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:13', '2026-11-01 20:38:13'),
(155, 'SANTA MARYANI D', 'employee-bdc3ae282e4245ee63978242600d12161376e838d2d4b9ba2b7b4f2f0e43b76f@employees.invalid', NULL, '$2y$12$PpUSU6eVw5lT4JnjnxrSj.U4E0zY8o44zQBjKfUJzYFqwc91TE18S', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:14', '2026-11-01 20:38:14'),
(156, 'SELY RAHMAWATI', 'employee-ef09aea0645de6d583ff838fee562f4af434eb5ee453c8a818073af9c9b56378@employees.invalid', NULL, '$2y$12$bWVOpkf/oWA8FRxy05PxQehSBSl3vXdN3wLSxLB.opDKRAe.7BHOK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:14', '2026-11-01 20:38:14'),
(157, 'SHAFA KAROMAH', 'employee-a2ebe57a13e1d1202493b31fd86b5ebf41fdefad37fc2243d1565b6baffd9bed@employees.invalid', NULL, '$2y$12$vWCDt1Zy1VNggd9JSutXe.9qHGTDrXN9PwfWA6c1QoopPoYK9xGsq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:14', '2026-11-01 20:38:14'),
(158, 'SRI DOHARNI', 'employee-a1d1e705bc1f62695c3b367d711b7c25be66c09974e07744435c0f61780d13df@employees.invalid', NULL, '$2y$12$VQGk4KvHhMyCZYnVQBGvIuxOaW/NZjkjz0vSKI3.uekN.nIyRF2Oy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:15', '2026-11-01 20:38:15'),
(159, 'SRI LENA PANJAITAN', 'employee-355150081301f05cef22a90727780d3e1658286b7ca779a4bbf2c7f7a40d5beb@employees.invalid', NULL, '$2y$12$7grKQU1XIQQdxHit9S4VYudAPpJA7W8yHyNCxmCFPVG2QNdAJmQyu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:15', '2026-11-01 20:38:15'),
(160, 'UNTUNG SISWOYO', 'employee-0e9a9221e97aaa079cf1b93ed99f2659c733274ba188aa72e5cef3f1b9f02ea8@employees.invalid', NULL, '$2y$12$sd2TdfJ4dmNuKOnwxUSIMOSCES0N1GjQZ6ug3mFuilu54t9u3P/Na', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:15', '2026-11-01 20:38:15'),
(161, 'VERONIKA ARITONANG', 'employee-4d9d1c267b1de02eb0cc6ae010714484d1447ecd3f83cc898b199a32ac60c1a0@employees.invalid', NULL, '$2y$12$RSlRvqNiQeJX6aMyZLaKQeeYv5qzlZmV7v1hH.DtHLz6GBFufEoY6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:15', '2026-11-01 20:38:15'),
(162, 'AAM AMELIA', 'employee-7eb467bd4c776fefdc95a811c3c4e456a5cc38df83084c496a493f7b1cea4406@employees.invalid', NULL, '$2y$12$3nXNiUXPVg9ndD5qnzdRJeKWQ9Gtu2MEU7XWFq10i/wQGH1rSedva', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:16', '2026-11-01 20:38:16'),
(163, 'Adib Prasetyo Hadi', 'employee-c6c67996bb93aaf6d006a87247b8f29a2454b4d911bf17bf665f26fdbb88c881@employees.invalid', NULL, '$2y$12$tPxWOuODWiJIzSrMVRXllecLbkVd2J7p/Y2.3Cg3.qQ8QmCZsDbW2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:16', '2026-11-01 20:38:16'),
(164, 'Agus Budi Santoso', 'employee-73d14835a11436c880195dc3642ad0c1e251b9a87484fb71a9c710fcf964a8aa@employees.invalid', NULL, '$2y$12$Ik2pFdTMbZ4vltjGG6sbwesBXzcB6EI0gAJQOKGHnhVaQyLHr.x0W', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:16', '2026-11-01 20:38:16'),
(165, 'ANGGA PRIANANDA PUTRA', 'employee-cad94483d4d9d6da13dad0155d501746984f8b63888f0ae78953f1e9db0867bf@employees.invalid', NULL, '$2y$12$ta0U0nJN.BeiX0I.rC2gNOZe4HACKrxmoFqJ5agCbNxrdRrU72WUC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:17', '2026-11-01 20:38:17'),
(166, 'Bagus Wahyu Nurcholis', 'employee-7a3d3b0a6e58f06e6a742db66770bbbe2c967ccbe74b7342cd22050b9a89729f@employees.invalid', NULL, '$2y$12$rdMVgRqaPCeYWwWg2d4soemryIgRKulzwnDfHp6SVJ2vu719ZN5b2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:17', '2026-11-01 20:38:17'),
(167, 'Aulia Valentica', 'employee-c4c8b408ef8a02017c9640dd1da29159029a2228eb96ee7904799a9aaa2497e0@employees.invalid', NULL, '$2y$12$imwAyftiLfhNPwB5misfPuuDejUdMHiNNeU9wa0dcIFQYU5UEzlo2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:17', '2026-11-01 20:38:17'),
(168, 'Aziz Fesan Laut', 'employee-f264d6a8dcb9820be8cd9cc306e4674c74a88cb0c9ba362fe27881ec043268b1@employees.invalid', NULL, '$2y$12$QwLj632SuOkjJ1IACQjZ9OpEs10aBTLL9ulpyRm.13HJPTcbJ9kRW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:18', '2026-11-01 20:38:18'),
(169, 'Ummi Kalsum', 'employee-905efed3d16996671991115c8153d67c72026c9c659bb2c8ae57010130b49b8b@employees.invalid', NULL, '$2y$12$VaAw41QrDdohjmymmPRyh.eBhLO2LRn14mScouu1PNp2oYHHBC4R.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:18', '2026-11-01 20:38:18'),
(170, 'Arif Rohimat', 'employee-fa3d58b5d5495f1200b512146cff97644b7aeaffc53035568af6e56051cc7cdb@employees.invalid', NULL, '$2y$12$p69o74TQ2E2cLp60nKVRLuFq3bxEQOEFZa5Gbc1TJJsnW14p9kYva', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:18', '2026-11-01 20:38:18'),
(171, 'Dodi Aji Yusup', 'employee-dff78ce0b7da1eaf1ec3d41f74c123c229d57512b17e4ca58e36bfeb13858e2b@employees.invalid', NULL, '$2y$12$k2CUWZqrQAtiAmedrrQdKO/bnp37UA1HfZRIZXqgLPwHQoY4veYIq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:19', '2026-11-01 20:38:19'),
(172, 'Kurniadi', 'employee-6406c32a9c70fa9b0a20d25f07d83d6b8ddb3503ee40c5f274b1d5797b2389bf@employees.invalid', NULL, '$2y$12$ODh2QcltPpBaR2Z3qCSTCugynTd7k0jtW4Jc7cFpFS9gTlolMNy2a', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:19', '2026-11-01 20:38:19'),
(173, 'Lita Amelia', 'employee-cee5b53b7e1d3c7f2b5d3d23c04f911bbe5e9066578a6d7c523187bfe1beba37@employees.invalid', NULL, '$2y$12$.D4u187bQKS2d96reGluj.wIes2UQi3jKBlNYLnewIsijqlRZP.hm', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:19', '2026-11-01 20:38:19'),
(174, 'Naufal Rafi Dzaki', 'employee-4f1864925fd3f0e2b71fb57ab4f4f899a89a738ba4b02aa989b8d45641e256b4@employees.invalid', NULL, '$2y$12$duk4PK5m6XTfEZnekiwbdepEnpDnMazW1csFV5.ovxowQNJtUAQU6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:20', '2026-11-01 20:38:20'),
(175, 'NAZWA ALIA RAHMAWATI', 'employee-7f0dada70e1eb45bc5f7f3e7846edb8bfe4504b362cc40abdcc214f24108f085@employees.invalid', NULL, '$2y$12$IIvsW7BcO5/3lpEJASLvqOf4u8a90nv4Y0FCzcikOqcD1odqdK.KC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:20', '2026-11-01 20:38:20'),
(176, 'MUHAMMAD ARIFIN', 'employee-f6d6307669cdabcd5732e4910e7e109f58cc618176eee2790d6cbda7394eb103@employees.invalid', NULL, '$2y$12$lJhWrRFt0sKbvY14YnNGHutXEmqh0X6vPVOHozQQzLmuP772TxzZy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:20', '2026-11-01 20:38:20'),
(177, 'SUTAMAN', 'employee-9ece6fc74286a7956e7c5e10129ab5a39c8129202280fe43d6a25d89d38bde68@employees.invalid', NULL, '$2y$12$Q4LsL.aEjzp1.eWrGVbbzuPGH1L0useTN1R7oVxxX9Ew1zWkkdUDO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:21', '2026-11-01 20:38:21'),
(178, 'SRI WAHYUNI DEWI', 'employee-e1c793c00e8ce119671330fb70e480cb385f37d5fe9dc9cc072439b5f346ee02@employees.invalid', NULL, '$2y$12$DF15Ql5Bk.tCTUrvCq9Tx.nhuTyNbPhofw.T.7hAPupmTTtYi3jw2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:21', '2026-11-01 20:38:21'),
(179, 'Bagas Prastyo Wibowo', 'employee-cb380e662c5a7e0510d2bec5a31d6f73f1576ed062652d68a99fa6d0d3178aba@employees.invalid', NULL, '$2y$12$HwRIod965QTcZxcFGLt2PeTS3aTG/w/TV7G3xlq90ylmW.Jyu22R2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:21', '2026-11-01 20:38:21'),
(180, 'Anisa Marcela', 'employee-b81f72fcdb2a5d69c4ba1aade684e771f715ff3440970f43587be32faba3efe7@employees.invalid', NULL, '$2y$12$SJhKjeMbaDZ5eBMF5dO7POOGUJTPytpMMvTEps/tkTmW3g3dCkoJu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:22', '2026-11-01 20:38:22'),
(181, 'Dede Mahjun', 'employee-593d01c819647bb125f89b1a198a2e0282debe0fab8be1413225f34f104913bb@employees.invalid', NULL, '$2y$12$e4zWxlp8t9FpV2fi1vNdnOun8O9YoRSKztDmqPa0.bQ/.Balwmr.C', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:22', '2026-11-01 20:38:22'),
(182, 'Deni Ahmad', 'employee-8c7cf612e74a51d338a7284438ed3d63ee162735c06ce1ced11db1443eb3dfa6@employees.invalid', NULL, '$2y$12$CXfkla24FIGfLGY9KB8OxOvpPDnYH0ZjwYY.4nfxytBSUNeK4fnn.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:22', '2026-11-01 20:38:22'),
(183, 'Fatimatu Zahra', 'employee-b742d140be1c13e65b38619a60e24aa988b67ed3514a3c80d8121b6552f2a509@employees.invalid', NULL, '$2y$12$E1uB6ExZOSpPIl2k0l.YFeSNhEJk4ZhWG2S82QaIuBpL3hBiqafgS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:23', '2026-11-01 20:38:23'),
(184, 'Ilham Fadilah', 'employee-ccb6f289ab1e562d293d84934add6a8a6ce9379c38c4ac44ecef061c91b6d62f@employees.invalid', NULL, '$2y$12$qq/dE7FQonG3xkV00624MeUZ3/DDgheLdeWSJYFR4ZvLmW4NMy9Fe', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:23', '2026-11-01 20:38:23'),
(185, 'JELITA CINTA F', 'employee-cc93321e0ed38a61f1977299c13130083dd81784674916e6e686c477d634dff4@employees.invalid', NULL, '$2y$12$0Rbrdvcc1TdZrZEVJLaQ2epeLojEGYAYC/I0xA4M1R8LIF9GUBzxS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:23', '2026-11-01 20:38:23'),
(186, 'Ismail', 'employee-5ad20eabbecc5863d940132917587823f48be2468d61320f05146d7fc71cbb3f@employees.invalid', NULL, '$2y$12$zThQM/6ZnfKy9bxc0b999eqzwjJYms9su8e8MyOaLj0TFCIsWR3ZG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:23', '2026-11-01 20:38:23'),
(187, 'KARINA NATASYA MARDIA', 'employee-ee005c85853b511e7c5451f7962b9d7d82af1d815558338e145c8defc2d75658@employees.invalid', NULL, '$2y$12$LKeq/NDOrUyui1k4tDI0Re3JUie8cwIFb8XXqyJAbyfmM6nJckQ6e', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:24', '2026-11-01 20:38:24'),
(188, 'Mohamad Ikbal', 'employee-d644cdd5c827d506835360009704b55fbaf7f015a982161d06ce23d1203e4c18@employees.invalid', NULL, '$2y$12$doe7LVZqZnOUVALqFVrSL.f/5tnY9nuprsXjR3BsRnwQSgfqeDn4e', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:24', '2026-11-01 20:38:24'),
(189, 'Naesya Aulia Kartini', 'employee-50705dd85ed8f9051baeedd98b3ff1003ad202fe9dc16c173db990a481500de6@employees.invalid', NULL, '$2y$12$PPZ.PWan57A9qHOk5YiJ/ucHEiv8Ujt/MCUV/nfdbzgjYqqPOAY6.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:24', '2026-11-01 20:38:24'),
(190, 'Mila Kuswara', 'employee-001aeb100487c4c2f9d1e6bb1e340cc2f479acbd73fdc1b99ee3c57677257b95@employees.invalid', NULL, '$2y$12$JGb0Qr2XaoDKO6AUspyPpeKsoqZER5k0eKFnJN6JV/fEkXfdQ5mCO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:25', '2026-11-01 20:38:25'),
(191, 'MUhamad Ridwan', 'employee-6e61bacaee055ea048b2d0a1c4b00e185e470b18d7070b802f87aef2d8749dc4@employees.invalid', NULL, '$2y$12$Kq/U8FQeekZHjmdgjNonwuU6hnVAHVjsADgYvRGmbKRhhOw/2BcPS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:25', '2026-11-01 20:38:25'),
(192, 'PUTRI HAYATTUNNISA', 'employee-39104a28ea40e75a6e9e6b9052b4e51e3caf903593aee23d573d58bff93bc174@employees.invalid', NULL, '$2y$12$XPhU0g5JRq47a/QtvfHPzeI58ECGsc2UCf.xs5abW8UDmK1rgKE4W', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:25', '2026-11-01 20:38:25'),
(193, 'ROSALINDA', 'employee-be26a722e640da44b72ae4e6915d7b5f1b294d32cc8d2405cfaccb1b2729e3f4@employees.invalid', NULL, '$2y$12$etJYm.n91M.9CTTikKBaX.TFGEQex1Jz9hqMEo/1ZYZRNP3U1Pnvu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:26', '2026-11-01 20:38:26'),
(194, 'RYANTI DEWI', 'employee-f797e7432627e37e202cd176be7a4e260e6676929ccb80058ff18cdfc4178d1d@employees.invalid', NULL, '$2y$12$8GWQpZ3k7GjyfyasJzZ2PuO82UtvU0ogy5mIPQzM1s7Hw2/mX.IP6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:26', '2026-11-01 20:38:26'),
(195, 'Siti Jamilah', 'employee-5e09943c7c75c404b242995dac223cf0e0c0e22d2fbc88650f3e4f01260da9cd@employees.invalid', NULL, '$2y$12$.i6fI0er/IR6e9mQCF9p7.z0R4VjHVc9RuyezUzy4E3XCidyFDbry', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:26', '2026-11-01 20:38:26'),
(196, 'Rianti', 'employee-00e3fcd5b26b5834c537e3474f09adea7fdef468d1ef15886ec0e5385349fb69@employees.invalid', NULL, '$2y$12$P0iDRcKUEbg4w1fBK6.TTO./L.6IF/xTeqxydXhsf3hG89RE19Zse', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:27', '2026-11-01 20:38:27'),
(197, 'SELVI MARLISA', 'employee-74b39752223a8704dd570755facfe991c8cf01d804a35e3d93745db48e799ce0@employees.invalid', NULL, '$2y$12$bbsfWWNga3dN4HDDTp0RWuODwGpSlI6m1A4./RO.7M0dTntQ.M4e.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:27', '2026-11-01 20:38:27'),
(198, 'ZAINAL ARIFIN', 'employee-e7167d7c20153d923d09ad8981bbdf2d89fa757a859cbf932620a0f04077ec2e@employees.invalid', NULL, '$2y$12$53BwmaVWq6oKFEAGPN0u5egMdeuuKmfGOKI1BAXj8EX4ujFX.ATzC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:27', '2026-11-01 20:38:27'),
(199, 'JUJU MULYAWATI', 'employee-69d22d57370c34ee191bf2609e11c3237c5be46502e17014c57614a25d990b75@employees.invalid', NULL, '$2y$12$6o0/3H7L.ey.GnEuOb8O2uNjMEmFGGh6YM2N1EEegPM4k.a6dXHOe', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:28', '2026-11-01 20:38:28'),
(200, 'MARGARETA SHAELA O', 'employee-842614e30141c1b53819beb509acf53f02e23995340b0a3106f1c34559c027f2@employees.invalid', NULL, '$2y$12$PxCN3vPwVo6N0iud73zgJOiXcgiWJZe06xpeXj/vnZcKgNO/qs7C6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:28', '2026-11-01 20:38:28');
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `current_team_id`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`) VALUES
(201, 'Melly Permata Sari', 'employee-7edbc212d390cc4550ded618980a29714c0a56e3aa8ce252d54ae5abcdbf03ee@employees.invalid', NULL, '$2y$12$06f6UWA24dE6T6xQVNqeYer2i.MxlD29yakGBMjQvWXpSMmPUHbpy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:29', '2026-11-01 20:38:29'),
(202, 'Supriyadi', 'employee-7be8e405e08c6ddf8c689250cf1a14a8f225f8b64bd5512fded6424cf4cc800d@employees.invalid', NULL, '$2y$12$q.a4anTdTs0ZLycJuQoIGux3Gm7Q0mY0KJ1GgdTYBbV5Bp0wqIE9G', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:29', '2026-11-01 20:38:29'),
(203, 'Wulandari', 'employee-a1f2820ebe82a74342048b9c35a27da938a3366043f0bc594d1eb09d44667cc5@employees.invalid', NULL, '$2y$12$5kxXl0FPrmxvxg5yuFZvj.mqCZsslVhslwQzSEHj8u06SLhZwU5fe', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:30', '2026-11-01 20:38:30'),
(204, 'ARUFI DIANA', 'employee-885df25a6a7a77b286000e36ef081398b87695a08854fe155c88c24b47a5e5e8@employees.invalid', NULL, '$2y$12$qjxOs58rx.JBfdVjY9FRS.W87ZXx1BuHK.mdIs3lW1GpeBIgYQH0i', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:30', '2026-11-01 20:38:30'),
(205, 'Egi Saputra', 'employee-9e0091ef715821802c8e5096195f775892f7afa183517d8055c2c4bc94958567@employees.invalid', NULL, '$2y$12$CkbwylDrj5RZtcWWulmoMeyzOB5KjI1QVm5gkYHnYMZvkep/eLYZy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:30', '2026-11-01 20:38:30'),
(206, 'Evi Triyanti', 'employee-fc016833a1e99c3813f89a5b1a8bd80586e0dba35662cd7ea279cfa140c5676c@employees.invalid', NULL, '$2y$12$8Vfbwb47jF1EmJeAQ8sI0OhwfGS6qJ59NCEwpImMPK7uPCgVSFWKq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:31', '2026-11-01 20:38:31'),
(207, 'HALIMAH LIM', 'employee-bf0374d20d44735d856fcf2e9fb809f24cd7bf8a1c6178666cd60086c68ee4dd@employees.invalid', NULL, '$2y$12$1g9Lew3j85tTlTiF.D6Twun/LkkLW1TVxoljgwhwxqJhV.j2zsqIG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:31', '2026-11-01 20:38:31'),
(208, 'M. Iqbal Kurnia', 'employee-11a5b32a53414dceafbf8f5e065da3464b4530c3958b3e75f5be3af5afac3dc0@employees.invalid', NULL, '$2y$12$6R/GtsLdX8E7xwz/ls1Uee9PmJto4Cxziht.Sg.FBoVf9R/8zTRh.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:31', '2026-11-01 20:38:31'),
(209, 'RIFKI SETIAWAN', 'employee-b258cbed4ca5bee7f8ff7b95e4dcd9b236cd8270cca2c75f8df7f303997203e1@employees.invalid', NULL, '$2y$12$EOQbaBZ.SCwXstsmIthQW.mkuvg8QUYnN4WYcXfeppudghNQ5guGK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:32', '2026-11-01 20:38:32'),
(210, 'SILPIA', 'employee-b7c157f3155c3ae0250d9e6060deddbb42a117bb24d66988e58d590769ffdc58@employees.invalid', NULL, '$2y$12$PQ28kxx7B5DdKYmxbd.sqeN8Dr1Q.4WtJE8vXNcQ9mFdJweXOVkWW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:32', '2026-11-01 20:38:32'),
(211, 'AGUS SETIAWAN', 'employee-c208c0037c331c8eca7c7bf51d7037b8b93e85a5f5f6c4eac94817d85689563c@employees.invalid', NULL, '$2y$12$5nV8l9lYwdDrULBWKD4uNO/.L5QWPmjLrGGd5hRPB8v0KRAxuDjum', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:32', '2026-11-01 20:38:32'),
(212, 'MARIANA', 'employee-dd7817286910d7aa51cd21a0bb7fd087ccf6a7b13736fe8db0a19884e1137109@employees.invalid', NULL, '$2y$12$TSxTwnJAA4JV3pF3F.sgh.PfgRjFgTX1C6O9LiQQazlug.CM91CGe', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:33', '2026-11-01 20:38:33'),
(213, 'NGATMI', 'employee-c9d0f479818d8fe3e2403c9dd57dfd5c02ff41ad512df712b4fbcf779bf98951@employees.invalid', NULL, '$2y$12$hXuTWdcOrlphFPI4qfmYw.TB4hOg8RN7374LvxnyYjwPxN7Dj4SZC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:33', '2026-11-01 20:38:33'),
(214, 'NUR SAROPAH', 'employee-2abe1448408ad576dedc4a47cec775a1dd016d5a4678a61b2c869a2880bb96d1@employees.invalid', NULL, '$2y$12$Lg.8NAlwrs8YvE6foNzWUOpbJL24NbMp5iEfjxyO32b9..U48nS9a', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:33', '2026-11-01 20:38:33'),
(215, 'SYAHRUL WAHYU SHOBIRIN', 'employee-8bd28d5065732efd2cc09ff6768086bd2923466772e1113eb300a467509a9af5@employees.invalid', NULL, '$2y$12$fvYKIa5QN00Jo6QoGLgFyu/5voDcReywNq22r1GbXQwByYGwxSfLq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:34', '2026-11-01 20:38:34'),
(216, 'UYEH YOGIANSYAH', 'employee-dc5e8391c8300197589a6ab4ddbe80ddfed715d14147128640cf96a33f2120d4@employees.invalid', NULL, '$2y$12$QGNvJ8TmIyZFCFRV8HSVw.SYhiEdDNmqgV.Azpue6ZMWjCPe1yGUy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:34', '2026-11-01 20:38:34'),
(217, 'AL ZAHRA DWI AGRINA', 'employee-fd10be787487b46e482886e8f259d9c1f13a08c3d861a5605e00c897e02c48aa@employees.invalid', NULL, '$2y$12$tGj.xvmk1/c/YJj3Cu1YwOSLx0zVan5swa3Sii.2Zfl5.v1K52GVG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:34', '2026-11-01 20:38:34'),
(218, 'Oktaviona Aidelwys', 'employee-6babf21547334b2a5aefc94cdd1c45fdb9e46669cf162fe0495e8989025f808d@employees.invalid', NULL, '$2y$12$wsisL0A32JgLUD5aNJme/.xSvmiUzOGCEg4.ltpUtQe.VfKB1SI.m', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:35', '2026-11-01 20:38:35'),
(219, 'EKA APRIYANTI', 'employee-23bc3b67abc7bd0dbbb907e696e910da8911d780603f9c01b9433e85369ab77b@employees.invalid', NULL, '$2y$12$UVQSWISpsayfT8VGidS8V.jiEsPsmnioNlcJxFeUlkYXlZIT/hYg.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:35', '2026-11-01 20:38:35'),
(220, 'MERSI PATTIKWARA', 'employee-f1807aede7b976242224182588da8af4ebe5deb4f19e455940b56b23ee0a6694@employees.invalid', NULL, '$2y$12$kpxoioTSvfhMQWImh3iiUOEaFOtM37kw6T5o2DHN3I6boIGP4tkgi', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:35', '2026-11-01 20:38:35'),
(221, 'AHMAD SUHAEMI', 'employee-b73cf569867ca66415216da5e4d69d5d4567752c43c2e67a3478e9110b4a02e0@employees.invalid', NULL, '$2y$12$vTtLEULDL/ZX11YgzjUhtuuFpp7L7K/zUu4MKS3dNIAdaH.Yw.kjS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:36', '2026-11-01 20:38:36'),
(222, 'Arinda Estriana Arnianto', 'employee-360a1c5cd10f06a8d9d95ad8798e5141c5329315e16845e7b3947388d8a3bdfc@employees.invalid', NULL, '$2y$12$HtYePm.2c9keT8JMRbD6IOjZk2mzNC8V8Nz29FkUcMEhyMD27L48S', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:36', '2026-11-01 20:38:36'),
(223, 'DAENG SABAR K', 'employee-eac03b923cf96763c0d9fa164b20900fe6e2311457c6fa03fff1f13aa493f344@employees.invalid', NULL, '$2y$12$sEAQLeKnS2OFqinUR0krGe1jO4UK3bj0C/SYtlTKlJW.CVeKX9kfq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:36', '2026-11-01 20:38:36'),
(224, 'Helmaliani Fransischa', 'employee-95c0e6932a42194bbccb0f0baea0d8de04292e84e0c0aac3ce9310d54e2205ed@employees.invalid', NULL, '$2y$12$ok7PnjigPrwlcH6ouBiSeOZ1s4ShMtLT3Jxxj4vOABEBg9AeDF1WO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:37', '2026-11-01 20:38:37'),
(225, 'M. Rayesa Aditiya', 'employee-e1cf62b496d048bfe6a5a921a83abb28b8252f1ee714309ac42c3603ef4aa1a5@employees.invalid', NULL, '$2y$12$3hh3BoFWAF4c3GraPO.0q.iquGOwRY5iznq1LUcmUn7x5iIwfHU2W', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:37', '2026-11-01 20:38:37'),
(226, 'NANIM NABILA', 'employee-c61eef6d14b84578b8bc51a7711dd0ad8849f8a0e40567aea266184cea5b87af@employees.invalid', NULL, '$2y$12$IoT0XhxdBHDohG.gknFAPOCayYcayqlK9w4lIqnzp0W8hGRsvMdty', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:37', '2026-11-01 20:38:37'),
(227, 'RULLI YANSYAH', 'employee-1cbadf5d5cca2b9a44401bf0d9405e5461cb6e621a0fb701ec8ba911c8b5650c@employees.invalid', NULL, '$2y$12$YBLzT2dqtUYwg.P9fieHEOyP4SirbSEedIFttE0FBvWkRNkmLGqjS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:37', '2026-11-01 20:38:37'),
(228, 'Suriyah', 'employee-bc4bff66b37afcdb1e1fa1612dff8cd8f341240758f7f3a3cef08f46b994b102@employees.invalid', NULL, '$2y$12$H79Yazerr/.jP5OKtypHdOnMsfckJERbvae3sI54LBdzuAz/.c/re', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:38', '2026-11-01 20:38:38'),
(229, 'TRI YUSANTI', 'employee-554fcadd68959eafb425d73223b2736521c322356cd9bfb1fa710dfd4d8544d7@employees.invalid', NULL, '$2y$12$NIPz53Vkr.8OMEZXQcmTHuxL.rOk8pb0Y72nVsR//T7HmDaYXdfxS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:38', '2026-11-01 20:38:38'),
(230, 'MUHAMMAD JAJULI', 'employee-12141d604913d43271c91491bfee4309fd01dc9087c022fe8dc57dff86a98dad@employees.invalid', NULL, '$2y$12$AcXyEPLHpMsJZOgSodKMlO.418pUnV0Glzi4OExCXBkOKfiFhYyeq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:38', '2026-11-01 20:38:38'),
(231, 'MUHAMMAD RIFKI SAPUTRA', 'employee-e779f239336020e5cf3a1837ee7b1157dae3f4f3f208b20bb01535662cc94e1f@employees.invalid', NULL, '$2y$12$j7SPDQ2N8kXI9/uIRvf4YuhGiQ4cdrrdTNOcr0faz7f338wW4u2i.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:39', '2026-11-01 20:38:39'),
(232, 'VERNANDA DIAN A', 'employee-cca131721febc1ff412f938ce83d247c7444e0bb562b813c674d0ee46ca0c34b@employees.invalid', NULL, '$2y$12$0dnFbKHv7wfCaIdV5ptqy.jI0iZa2Dtj42tJWXnI805QU8A94NnCG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:39', '2026-11-01 20:38:39'),
(233, 'Yoyoh Farida', 'employee-882b18998c845219006234621baa404ba08f1da45413cea70d9f6ce0fffca27c@employees.invalid', NULL, '$2y$12$utFs.KSi6e8KOoiuBzwG9.hFaeDD5.6ur8onwvxwEfm/klg8wWluS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:39', '2026-11-01 20:38:39'),
(234, 'YASINTA AMEIA', 'employee-61ae60fa35bb1b5be07892d7d62800b05f18d8a0efbf796fa47801614a0330c0@employees.invalid', NULL, '$2y$12$wdJxb4QBQDTYXbwFQwwGb.Kxf8Say6Z/mHpZVTOtVu8nbCMs0VqJy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:40', '2026-11-01 20:38:40'),
(235, 'ENAH MARYNAH', 'employee-ea2d0f9bebbdc6a357315b7bce8ad6b8d82236134bd6b6f7fe30255f5a5f9019@employees.invalid', NULL, '$2y$12$hAtl2DuVfxpA5wBwJyWmH.GhhrmDI7sNQ3ZeH4X8unflxnkiq0e.e', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:40', '2026-11-01 20:38:40'),
(236, 'MUHAMMAD RIZKI SAPUTRA', 'employee-59dba4fbdb00c0520815ea542c2284ec868b6c36bfb47390205b46ca591f15dd@employees.invalid', NULL, '$2y$12$iG39tv4fYNVUt3aTWQLAR.mpWiIc0cfW9m9WIWy34XUY3T0txeDLq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:40', '2026-11-01 20:38:40'),
(237, 'NAMIRA ALIFAH ZAHRA', 'employee-98b4d0ad4a59b4000a87e599574df44e216cf2723fd11a39444218de3a17662d@employees.invalid', NULL, '$2y$12$P7vvR1J86cth/5ivgwfnAuJavDt/91gb/iJq318DC9yPuPAuqr1x.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:41', '2026-11-01 20:38:41'),
(238, 'AJENG MAYANG SARI', 'employee-063401f679d32d777be7580f0ac5ae2ac0ba7c8b251ea6719034828161e5095a@employees.invalid', NULL, '$2y$12$1zkq6cduQyy/jpgthqKdmuUIMfSoIF0QuUF2IWCQP4nbk.VD/BccO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:41', '2026-11-01 20:38:41'),
(239, 'ANISAH', 'employee-5607fda993e0e565c52492350280369e70e2dd196104058d7036374ddf5005d3@employees.invalid', NULL, '$2y$12$uvKA3XzAdzvZw7NFoEJy9.7rCeTFWWhodlr5nT.2xjBkx4Axbcpxq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:42', '2026-11-01 20:38:42'),
(240, 'AQQIL WAHID SUFIAN F', 'employee-b70093da9620f9548a768b4f483c573bb2a5e66ac869e56748d62bdeda47b122@employees.invalid', NULL, '$2y$12$DMb.wH3F7e41LGX.4wtEjey0juE7qwTkjaoKvAs9h5nwfvPLpvelC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:42', '2026-11-01 20:38:42'),
(241, 'CASMIAH', 'employee-abae387d96f52d71add651114dae61ae8dba205907e1579051d2dc42f99e1cf5@employees.invalid', NULL, '$2y$12$FE.RBhIK9g9ilyCiW7YqZ.N8terGUruk2o7uihcVJgekys1zSTgoS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:42', '2026-11-01 20:38:42'),
(242, 'DIAN FIRMANSAH', 'employee-0088cbceac2d91944c1158f78599628e828a44eaea8013c96e9ce197a619e3ce@employees.invalid', NULL, '$2y$12$LAt2CaRERn1ME7QNX0GSy.keVGdfv3el8CEmTkf6e.XrrRu0.pQhC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:43', '2026-11-01 20:38:43'),
(243, 'DIAN RAMADHAN', 'employee-1e043a95ca04e881a045f77cdefccf7c0af0c9f2f8f3a7e676a4d1cf5c0a5556@employees.invalid', NULL, '$2y$12$v.RjpWbqc5L.sLJnrQNdb.34nhO2jC7VWW.tkb6lQjH9ZrPTv1e4.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:43', '2026-11-01 20:38:43'),
(244, 'DICKY DWI SYAHPUTRA', 'employee-85b322d72ac5882a475ff17b476061c4e5ce87e78e7a84f26d4a604fb5f354c2@employees.invalid', NULL, '$2y$12$1LnmZly9PHS/nK74P27XY.EVcFAkAPSMc/fUzDwuZoqpVxEIDeDay', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:43', '2026-11-01 20:38:43'),
(245, 'DINDA KIRANA AZZAHRA', 'employee-3c1b546c290ab446ba585abc424f7ba079518afed9e5ce539f85d5e2b7dcde8c@employees.invalid', NULL, '$2y$12$5/4qIJE2wkLzy5ebYvo0POxcaXzqd5L5J5Bvkw4sYMFTdanQkY4pC', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:43', '2026-11-01 20:38:43'),
(246, 'DIRA AGUSTINA', 'employee-30d7b4e1845c52840276d4566fd770e2feed141e343370da6f24ddb29098a1ca@employees.invalid', NULL, '$2y$12$CANLT5o9w/JnSv6ihWoVxeJ2gPiasE9L.6xCtnhNbIBCOTwtfSDn2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:44', '2026-11-01 20:38:44'),
(247, 'DRIANA AGUSLIANTARI S.', 'employee-25e1a5089a365a47a492fd7a55ad900e039c34df86f49a501bd1378bb69aba0d@employees.invalid', NULL, '$2y$12$hzHHX//ZlOgdv0iieIm2M.IE87bCv3ex.7GFlbO8scv.0T4hUpWeG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:44', '2026-11-01 20:38:44'),
(248, 'ELSON KEVIN HAUMAHU', 'employee-3f2e69b1bd3e6618acda37af19f6c26515b38926ee8f1ab069cb64e8e955d699@employees.invalid', NULL, '$2y$12$12iXye31VRZhGP0yw49s7OUF7eUWs1gsjFG4Wj7gq5Ctsg3gIfKCi', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:44', '2026-11-01 20:38:44'),
(249, 'FAHRI HUSAINI', 'employee-1160ddea492aa2d93f04d67618cb1505e96adf8da12dd68e399cf14f13b6bbf8@employees.invalid', NULL, '$2y$12$acwx6CnCoIiEhrGafIWnHeu80Ir100Ln1CO3SmtQJuj26DmuAp03.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:45', '2026-11-01 20:38:45'),
(250, 'FAUZIAH RAMADHANI', 'employee-0d04c80b904220e81da4d925002e3b1e823cc849ea5bd6cbd16d181d8f078d94@employees.invalid', NULL, '$2y$12$rt1IVXvqNsyn75yitjf8jOSfNVbeGmdqu7CEYgv9MPDuf7GBxQzji', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:45', '2026-11-01 20:38:45'),
(251, 'FAUZIAH RAMADHANI', 'employee-4efa12980ef999e7df410d5b0d794d8043078ac1716ebed931b24d140ef95562@employees.invalid', NULL, '$2y$12$neY9b4wDkwrXGM.YKlhxguGVtrxdscX5VaAUBVi69HEjq02trqj5e', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:45', '2026-11-01 20:38:45'),
(252, 'FITRI MULYANI', 'employee-b4dd48f2bee61a07cf76331f5ed0bffe1abfa922228be8daaa1950c3263fb9e2@employees.invalid', NULL, '$2y$12$dc9mhabk0UuQijEiGt7TUOsXotLgMItaKRvE6DXa1EWnu/9b8gw4e', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:46', '2026-11-01 20:38:46'),
(253, 'GILANG PRAYITNO', 'employee-d1f9834af1ef785a13804bca2eff787a976ebcb7e5f3888980e086742b5b5ea9@employees.invalid', NULL, '$2y$12$9VQnIAUI/PhN2M2cSvVAz.up2XB1xWMKZkTtHX7MLISYH266Iq4qW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:46', '2026-11-01 20:38:46'),
(254, 'IIN INAYAH', 'employee-ee76433b885d840e4039e81918aea9fd6ec12dbcc14cc9af97628be36e900642@employees.invalid', NULL, '$2y$12$DYJAqcYXRrf1hNtqQpYMJu8FtESnYABirbyCTKRr.OKca3CfqO/Jm', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:46', '2026-11-01 20:38:46'),
(255, 'INTAN ASHARI', 'employee-746db709cfc0241c185bb530ebc3cc22c57e8d6b3a85439df791421bfba209a8@employees.invalid', NULL, '$2y$12$LCEzXJUhqGy1VSnhnuLFfuauutSNn/xjXo/ZnIkr3Yu/UhUxVigmW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:47', '2026-11-01 20:38:47'),
(256, 'JAYADI ANWAR', 'employee-834225debc3fd971257ddded7583b7bb17efffcfea9d7386e72c7215128b74d8@employees.invalid', NULL, '$2y$12$AyMcChTjq37JvKXlRBhApO.0mmtJRkxzIe8Qa2nZEtIRKNpCw3pBe', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:47', '2026-11-01 20:38:47'),
(257, 'JEVITHA SETIA LUCHIA WIBOWO', 'employee-634ec3f1ce6ac09db2e313705bcc63ca8a96c1e83e9095c5a579ead592881d22@employees.invalid', NULL, '$2y$12$SDXs6hYxgMz7mLywoyHyL.M3H3LXj/lykgjH.HyvVxemjyNXAkzdO', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:47', '2026-11-01 20:38:47'),
(258, 'KAFKHA ATMI PRATIWI', 'employee-f13ee8f5eb310f6289dc5a7d9b54432b9cb9f20d5c603dd78092fd4fd81b9a18@employees.invalid', NULL, '$2y$12$V4Y7jG4EmGrjI2WBDN.2XOGHDry55XMFsIBawsGOEMF7/Cla7b6cS', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:48', '2026-11-01 20:38:48'),
(259, 'KAILA TRI AMANDA', 'employee-b57b81dee88fa2415d65489d8461c8633b78fce28a5bdbc89f8bae845091fe5c@employees.invalid', NULL, '$2y$12$f6hn3LLOh.RX1wmrVfpbvO8567n24KK5VsccN9lMd4CYgmeI8TZ0.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:48', '2026-11-01 20:38:48'),
(260, 'KARDI', 'employee-c1562d1f28e2a9407598735563de38f7872c57f8778b4acd6c134590c782fad7@employees.invalid', NULL, '$2y$12$A/lRtmPw4Hnj4V0LgNAkje7C1NuM/SKGTBgn.KKtfhHcOnX5L2FMq', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:48', '2026-11-01 20:38:48'),
(261, 'KEYSA PRATAMA PUTRI', 'employee-7ead8d3365bd5c3ba7185c2b5d08e4e332090b0ea96fa82b2dcd4d51842d54ac@employees.invalid', NULL, '$2y$12$VXcIeLXr3IjVntGedtE65uTJ23VdGZXXk/NpQo0CNPFRWSPN.If5C', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:49', '2026-11-01 20:38:49'),
(262, 'M. KHOLILI', 'employee-6ea7743b6140253a3e1e55c5b7a9c57a4fdb8154a9d69ad422fe7dfd4f0a6e91@employees.invalid', NULL, '$2y$12$C8I.LVWEuVbOaRXuM2tB6el1Fy3lZKx7ayhjGkOvyteeXLKQrtFfu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:49', '2026-11-01 20:38:49'),
(263, 'M. RENO', 'employee-27002162ee5bf1712e4f06e7b24154e1968fd8088b76b6c6f6b547232899dcd4@employees.invalid', NULL, '$2y$12$gvseV7Gxe9rM/bz6O5zTHuxsPbrksNK9bWyEN44qLbkJR/K5fhMMy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:50', '2026-11-01 20:38:50'),
(264, 'M. RIZKI RAMADHAN', 'employee-7e7694ec3ca78440aecd60c4fd271c181ba51d20183df7b4aa198e2881e6e42f@employees.invalid', NULL, '$2y$12$Z5MIXiILYauiwHRZAEL7me4lZ/UBwejGNch73JywjmtwwYEWkoYYy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:50', '2026-11-01 20:38:50'),
(265, 'MARIO', 'employee-7ebb7a19faed0e3bff3051849e771bd0094358178bc221a82539335f50aadc83@employees.invalid', NULL, '$2y$12$mqPIdyFPWJxz0w6GmnLqQee7ZyBqCe25RWsTIJ2d9ShWi9Pc3HP4a', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:50', '2026-11-01 20:38:50'),
(266, 'MUHAMMAD AL FARISI', 'employee-58936a6f26b7ddbeb68a087bbf21f456e11c7431ba51d22c23420cbaa3254b9d@employees.invalid', NULL, '$2y$12$BpifOhrTwbVSB8m2iIFicO4JF.0NYWttw3dvt6lfqGBZz7xapAWl6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:51', '2026-11-01 20:38:51'),
(267, 'MUTMAINAH', 'employee-5c7771770c3a69fafcf52ff37c4b7930007aba2646e1e8ecd5413cced8b238b4@employees.invalid', NULL, '$2y$12$Up9Qs4oCCTP7YZfwq0qLJugXXbFR.HewX1EheXYY8.XPexwR.g7re', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:51', '2026-11-01 20:38:51'),
(268, 'NANA HINDRA MULYANA', 'employee-5cc3febf86f4332ea7a135b28d23cecd9f91a76efc0ad68e403252612f4d9f6b@employees.invalid', NULL, '$2y$12$egnCBbfg/s6o73kWVCYM6uk2qHBhGzygqOLorPaGAyr.7TinVB33i', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:52', '2026-11-01 20:38:52'),
(269, 'NAURISTA SAFITRI', 'employee-36c7571f1bedff91f7f462364e5624f3335cf9aec9352afb06952460d18eeff0@employees.invalid', NULL, '$2y$12$6Z1sDN0IaXhkuvD9Q0j/X.WVAafeoA5a/GEJ/DhOi2D7QG7T3Hb7e', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:52', '2026-11-01 20:38:52'),
(270, 'NIA NABILA', 'employee-8535e3abf115b13886c2f28474cd6c329a4ac6f75b15ba9f848b2f11978405d3@employees.invalid', NULL, '$2y$12$O3ElxPjDU/en3LwB/xmFDeAuMP6aLGAD/BNLXcCeuzDcBR8M8x8ua', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:53', '2026-11-01 20:38:53'),
(271, 'NISPUDIN', 'employee-72489fb4cc0f4a4f759fe648eaed5cfc24ae8708f881002e0ce00b68c48cd7e2@employees.invalid', NULL, '$2y$12$jzcUd3TEXloFYW13zJlbkOI1W6sb5XS7ZFD40pZ20a/6il0Bbwr6i', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:53', '2026-11-01 20:38:53'),
(272, 'RATNA PRASTIWI', 'employee-0b0cf94d53ed1bf220f8d5c0b96ea87fef74ea05e513224a83be14529276d7bb@employees.invalid', NULL, '$2y$12$ISBpkOknV.WOUymBkfmKHurVjvT9kPbzoq2rlFnV.uoXldjKOjMh2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:53', '2026-11-01 20:38:53'),
(273, 'RIFQI HIDAYAT', 'employee-f61cc723419def4b9ce456077da85ce610429a34b26516f29e05c5d2bd970bed@employees.invalid', NULL, '$2y$12$KceujJWjrEhbcOMLDj4CS.NvJQPy9RPbn6yvj.9AFQIDf3gtAW0Pa', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:54', '2026-11-01 20:38:54'),
(274, 'ROHMAN', 'employee-4c17367619587e9abfa5b94e396210e78b84287b2fb9540da12958bd513dde43@employees.invalid', NULL, '$2y$12$WsshiRqGXq3dT9VbtPUE4.BE8hG1Pj1UG.FWdovM7ix6sV653vZWW', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:54', '2026-11-01 20:38:54'),
(275, 'SABRI FAHADI', 'employee-c82d0ea031a496df153f7b4f0516900e141f9c44a5dfbc8e69965d630f5d50d4@employees.invalid', NULL, '$2y$12$hhjYL2Bi4meG9aRkeIW8eud/vYcZ8648EV.k5blDkjvyCTQy9e.2O', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:54', '2026-11-01 20:38:54'),
(276, 'SAEPUL ANWAR', 'employee-dec69d88ea566e4690d81fecf251573b5b58a9b43610d09b568d5cdaa91a8ae3@employees.invalid', NULL, '$2y$12$wwvRS2/WbLc8BhO7PxeAA.7SM56U6DzA5Ah6FG0jCJSSiDCyfDVvK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:55', '2026-11-01 20:38:55'),
(277, 'SALSA ALVIANA ZAHRA', 'employee-57ba98da514b1426adc956bd4d8079e75483405499bd68c65575ae70106d13c8@employees.invalid', NULL, '$2y$12$mC8v7lLTRBXj.GpNgkBGrO8ml7my7LhhXNobu9AjxXZrCpmMJjQdK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:55', '2026-11-01 20:38:55'),
(278, 'SEPTIA NUR ISTIQOMAH', 'employee-d43ee5273d4ae6ca0b04754af68826605b24313c653d740afa6f077900f012fe@employees.invalid', NULL, '$2y$12$QFJLV5g0lMQa1xzjEFaDFeHU11MVgp/zQn8RUOIVkF1BELdj/IQPa', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:55', '2026-11-01 20:38:55'),
(279, 'SILVIA QURROTUL AINNI', 'employee-405200d5b9ab6e3cafa98828d1e5bf3a2e570567501a387afa7906545f0edfdc@employees.invalid', NULL, '$2y$12$GzGnpJN2zRApglpali8QuOTIPxEuccjHdFeO/R3vTm/sNF/HnvoHi', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:56', '2026-11-01 20:38:56'),
(280, 'SIR ROLLAN', 'employee-8371e7d21c4c146c610e13218e0081ca4d59cf22d0205f4b259cf23d76568e6a@employees.invalid', NULL, '$2y$12$Q3p9tYXpTkWqGFqQUJ/sB.Myg0VNu.Am08A9vxkJ1qdDzWT3um2vG', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:56', '2026-11-01 20:38:56'),
(281, 'SITI NUR AULIA', 'employee-17cb55ef44cd8b9b96e2d61caf368fd8ffaf766f5b966b2d4a980f31428f6079@employees.invalid', NULL, '$2y$12$qyKEUL1GFbYZE2wQYR4h6OjdglYIAcYc6o6.hQx78zVjApvxNIBdy', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:56', '2026-11-01 20:38:56'),
(282, 'TAUFIK HIDAYAT', 'employee-924c17524f0e76ac1d69d6755c878a82deed3ef83617352c4b155989323366d3@employees.invalid', NULL, '$2y$12$ZbgqMoUh5lBqB4x6F.1toOSXIXPaNwR0ZIsERsQvkq2RNPxc0Vsue', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:57', '2026-11-01 20:38:57'),
(283, 'TITIN NURAINI', 'employee-2d80d3e92b0dd1f388dc55c1ca16c1188f2a3a63d7fab3eb58be53dd62c0cef0@employees.invalid', NULL, '$2y$12$wDV/jdUblnAg0k.2vvYTIezhrEvG.hlRWv5XnL46Vwi9eAf6S0Zda', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:57', '2026-11-01 20:38:57'),
(284, 'VERAWATI', 'employee-b181783d1979ec0ae13a3beca8552993e75e94afe366f23418ac30f0893e3c16@employees.invalid', NULL, '$2y$12$A4synsUvQ62UY/iOdQ0Dw.N9BQVQuOv3F.3Ax4yNe3Q5uL98Y5SKu', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:57', '2026-11-01 20:38:57'),
(285, 'WANAH', 'employee-9182b7aaa552de3df6498b732a0c8610411f3ce8ebf36696693557eb419f65fc@employees.invalid', NULL, '$2y$12$5c6tyqNVPOaoyTyW94y6IeWJfqEMLDpBFTJbfZ730OVVb.5D1.Nl2', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:58', '2026-11-01 20:38:58'),
(286, 'YAYIN INTYAS', 'employee-0552b7f7a26d514ee47486b71b51b09c5190af3640453712e45577322c1813cf@employees.invalid', NULL, '$2y$12$XMoCanjFIAKgBmhMgB.7i.nG2.XuHoNVjzsLgpPzVq4kBglRiLSz6', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:58', '2026-11-01 20:38:58'),
(287, 'YOFRI MAHALIGA', 'employee-d9863b11e9395f59a1b94c42e65624d513e65e1d88ec7f0a2266e50f1b58afeb@employees.invalid', NULL, '$2y$12$3iTJpKamynHNod73afoO0O3LNCj1nQ9KPKzn/gLs1DuY187aOJdrK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:59', '2026-11-01 20:38:59'),
(288, 'MIFTAQUL AZIL SAPUTRA', 'employee-82771a0ca19ed56acc4333fbe01ed137b9763b23638218e22ab0bf290449092f@employees.invalid', NULL, '$2y$12$QKEGIlaoVfMduedN1PwyTeiAohY4JNBOTJx1p/xeF8cAnXVZeqtzm', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:38:59', '2026-11-01 20:38:59'),
(289, 'Adhika Eka Putta', 'employee-cfe0f8b8ba7b849dd3e7b93a61bd31fa1963d33aec95992b5b7a7dc01391b60e@employees.invalid', NULL, '$2y$12$PY2S2k7v.nDiPGchefrjdussp3iGpuZ6dOZmfj2YxXIL1xVGLqdgm', NULL, NULL, NULL, NULL, NULL, '2026-11-01 20:45:45', '2026-11-01 20:45:45'),
(290, 'Super Admin', 'admin@example.com', '2026-11-01 21:27:45', '$2y$12$p2KTo5j6mhn6QSdyoPg2Oe0iVIiULZGg7i26If1tqoflbpfykkcS.', NULL, NULL, NULL, NULL, NULL, '2026-11-01 21:27:45', '2026-11-01 21:27:45'),
(291, 'syafiq', 'wisnu@gmail.com', NULL, '$2y$12$xrMhRlGid/6aSEEBpyVl1e7wd2U8DJzhQ.pBE4jlHEPKk2xJj28YK', NULL, NULL, NULL, NULL, NULL, '2026-11-01 21:38:04', '2026-11-01 21:38:04'),
(292, 'RIAMA RAJA GUK GUK', 'employee-de87edd190e68acc3f43c66b88d9773713006ab89e52756017209d09a1a370f7@employees.invalid', NULL, '$2y$12$NTf1DyHQSsmCTo0M8LQ21..MzYe4VAIjjTTpzX9DJwFfTe89EwvTq', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:08', '2026-11-04 02:02:08'),
(293, 'WANIH', 'employee-e174b81ac0354afb47e60419ce39e1ad6c112df664c4dbd2b83f7c0638c63b9c@employees.invalid', NULL, '$2y$12$gVcKxC33t.Gn7MRLHMq1Ku7ModlM.JFiPbMc1G.pnjxbJYKlK6Cri', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:09', '2026-11-04 02:02:09'),
(294, 'REHAN HAMDI', 'employee-6170a8000188b8d22d603c0237f8e4e74855b06bf1d846da73361440c9706f2f@employees.invalid', NULL, '$2y$12$3jlNViQC04Fi40kp5HAB4eq1yodjRQZ5ifB52W1OyqdHIr5TG9wz2', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:09', '2026-11-04 02:02:09'),
(295, 'PRIMO DARMOWIBOWO', 'employee-3fe83423d0221e1d94b27e18289fb0df985fd7559749f0dc551254034b27e74a@employees.invalid', NULL, '$2y$12$SzuDbF4yH9efwFXVI57NxeRebhB6k/quAI60p5XZs4IZI9UVU87A.', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:10', '2026-11-04 02:02:10'),
(296, 'MUTIARA SHABRYNA IK', 'employee-434d966ceeb3a6675d09eb9dd4aec989370a115da63d6d8d693ac6c7caf594f6@employees.invalid', NULL, '$2y$12$hSDL4hGHbjKpZ9mZTkPo2eIqBjRisAjy/YF3FfT5AipvgbAKCnf4u', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:10', '2026-11-04 02:02:10'),
(297, 'ISTINGANAH', 'employee-3a0a8ce851ba57bedfc2240621dfb2e2c95550ff090425242969bc941150bee3@employees.invalid', NULL, '$2y$12$hjAaw6jY4aAdLlh4srLpEe32cQ7gWeHKCp/zQ.tL5U3eNX6JugE9m', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:10', '2026-11-04 02:02:10'),
(298, 'SITI FARIDA', 'employee-f9ba97e348c1e9d17f541c644bb688a775e10b4f3d361d48b20ed5766f4d54fd@employees.invalid', NULL, '$2y$12$9j0MSFKVnyOo0Yu8NG.6uear2xj6zy5FS5pl6lFp4b7ncpyPQezli', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:11', '2026-11-04 02:02:11'),
(299, 'LOLA SOVIAH', 'employee-df93835c13a19c5116e199d53b70c7dcd89bad41cf9d3aee8838420f0853c258@employees.invalid', NULL, '$2y$12$sH/o//8gvOcztIOfMBjbrOXislVCcnH44.xof2dWZIJj2qvDqpDIa', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:11', '2026-11-04 02:02:11'),
(300, 'SALMAH', 'employee-f625f84e40230f3559ccbe853ca9fc28bf3b0ea1cef4bcbdd082accf0fd0dd3e@employees.invalid', NULL, '$2y$12$WRiTEL0OBbFyHz3sp8kCdOyp1QUFRDU5fUxbLrynX2QAU9gzfYWUO', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:11', '2026-11-04 02:02:11'),
(301, 'UNIH', 'employee-f2fae8e27432da7e72b5148ed02c1d0cf053ad65bba7dd82213a0df4028ac8f2@employees.invalid', NULL, '$2y$12$2/AaEYRQmR4muJmE.Nx32.4MpgsfiUfv6/nEQSJyQVv0unlt65RAu', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:12', '2026-11-04 02:02:12'),
(302, 'DESI SUSILOWATI', 'employee-6371a058ab9ece989d44aa373adf672992ad9453a6f839453e69509e5487d859@employees.invalid', NULL, '$2y$12$RsBmTB4wQ9uF2fgaQJv39OynZLfDCPq12Zn0ZykWP5f7Rh.wslaoy', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:12', '2026-11-04 02:02:12'),
(303, 'RISMA INDRIYANI', 'employee-4a51c370b64c07ec0f7a135eabadfeed7b92e93c4dea4250f4aae27e6f6d1e70@employees.invalid', NULL, '$2y$12$ixGUbROMfsTAmneLVoL8SOyXJ1OtrqTUrdqHUENOsCQTIfPNPOrE.', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:12', '2026-11-04 02:02:12'),
(304, 'ROMI', 'employee-6c278371cee06d4c8111a243168b125ede19701a5263ee075db7f74d79100392@employees.invalid', NULL, '$2y$12$DquHfC1tWgBEOSbXQmrKqOMFQLtiXbKgQcHDZhq4LLZWZZauJSsCG', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:13', '2026-11-04 02:02:13'),
(305, 'SRI YANAH', 'employee-021b16b712821b8d937a0c34b823aa91d19f9e89c25d0faf20cbb49d1cbe19c4@employees.invalid', NULL, '$2y$12$wO/y3hgcok26Oq0nc9vYG.69lupuHrm6MhEKdWxPaY1Vd5rIE/U9K', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:13', '2026-11-04 02:02:13'),
(306, 'NAZLA MUTIARA A L', 'employee-7f28bc75d589b8f0c0ece0ee059a7a165c809e74e8733b0bf581535669a6dd91@employees.invalid', NULL, '$2y$12$Wpgj6CpQ9d1jBTp4XfPXvOSbGdZbe.uD1ZiA0A.qt5ctcqTjzwmxC', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:14', '2026-11-04 02:02:14'),
(307, 'YUSUF MAULANA M', 'employee-f3b9707239f2d3cb9cd031b267523a1432631a74037b08016fe6c92270245f4d@employees.invalid', NULL, '$2y$12$1Y8SXoHaJib1VRoeb.VAaukrqcr4XqxSlaNE5j3kUkv3en35OSCne', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:15', '2026-11-04 02:02:15'),
(308, 'AHMAD RIFAI', 'employee-8a435a51787e6394579e24f2bb37152198403a80895db3093a258cfca3e77fa9@employees.invalid', NULL, '$2y$12$svas9nOwLCyMPhrAWuwM9uZHyQ/dafjszDMv.87vtaf9ibP.LT0fa', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:15', '2026-11-04 02:02:15'),
(309, 'MARYADI', 'employee-4f614f0694945670ae5f20efd38b523c6a6af2989c11edd26a1abd778c75537a@employees.invalid', NULL, '$2y$12$N9k5G.9n.IPPrmAQHQMi0.toOvvfIkWWeo/DNzaXtsceJgWxto3tu', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:16', '2026-11-04 02:02:16'),
(310, 'FAISAL AL FADILLAH', 'employee-efe3c8495cf8602c92e90d0b0f44c5e9f4d90651dedc231b54e59ae157c18bf1@employees.invalid', NULL, '$2y$12$NjzG5o10Lul2K4fVrbBekerL/65XCUvOgydl7LI6eHW8WzHlJPHr.', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:16', '2026-11-04 02:02:16'),
(311, 'NUR FADLI', 'employee-26bcc23f5ac58a68eb282a7a353aa8798e9a8ad7619fcf7a10a96811297f02b7@employees.invalid', NULL, '$2y$12$UFB3MWTfyd5HvqVTOHe8NODkrXKhZuo6UbMvUjT5rjbqV0ImpEG5.', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:16', '2026-11-04 02:02:16'),
(312, 'TARASTI AYU WULANDARI', 'employee-3c8280d40a5fffac024c9f929b3d46562319836c0e5190e2b9a3f896e73b548f@employees.invalid', NULL, '$2y$12$r8QB0Ed3BR8u7tkYAnyLzuhcyHcayV1h8gJtUM/0ndd85z1hXUC4K', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:17', '2026-11-04 02:02:17'),
(313, 'NIKMAT SELAMET SOBIRIN', 'employee-659b1420cc2821b5d7ca89432971f11bf7b4e200b011dfd191eaa308b495bde1@employees.invalid', NULL, '$2y$12$5JuPgxRKFSpRBOLp7Tgnn.7SObGmzHGY0x91pIqCpT5TPCN5O0HQS', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:17', '2026-11-04 02:02:17'),
(314, 'ROSITA', 'employee-0c926498b9cd51479c56df69c0e0ff360641d794d1cc6a071a9bd03eb92dbd34@employees.invalid', NULL, '$2y$12$IbVUrawBySHFbogMF5SJS.w7pAsaQhRTysmyloLBhxNoK7biPWwry', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:17', '2026-11-04 02:02:17'),
(315, 'JELITA CINTA FAJARWATI', 'employee-d256df08dc2206901bdfe72f6a6344d0caf446309170dadaf35ddc1959c4527b@employees.invalid', NULL, '$2y$12$sB3Qo0.8NB20VYkoh1.TnukIVWx71a3LQutMAnIzoiE10fgFcdfFS', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:18', '2026-11-04 02:02:18'),
(316, 'RASWII WULANDARI', 'employee-380b0135f9c35313b96103392c12528e3d154611385ea1b38d26fdcaa4114b19@employees.invalid', NULL, '$2y$12$ggmIBCR5UpQg3wIEzNSyR.WPLUOt65tOa9idTOSKbiZlBXUmxexFy', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:18', '2026-11-04 02:02:18'),
(317, 'KIDZANIA SALSABILA', 'employee-568dbdf7309aeac7ac1a0626a1ac47d0e5ea7247029cd097c855f989caa18f83@employees.invalid', NULL, '$2y$12$jkNH9JyHftdlXEbRPNmgdOq.QCznm9pCAt7JnJEqtlCnmPVVZTJ2e', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:19', '2026-11-04 02:02:19'),
(318, 'LIYA', 'employee-6bb096ec26688873f8ecb3aafd00841abfa23f76dd59603cfd5707f90f307d14@employees.invalid', NULL, '$2y$12$klD.jfM1cWndKI2pffiyTO0GPlwXB4trKYUMNtRbKPC7Lv34TPCPm', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:19', '2026-11-04 02:02:19'),
(319, 'NUNUNG', 'employee-beb60a008e2061951824cb797634637cc0ee195236063a14ad8b07e958df202a@employees.invalid', NULL, '$2y$12$HofswvCceduJZ2tk1SMsvuNBaJL3s7G3kaTBCDeZ2CLMOHCBWi2/a', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:19', '2026-11-04 02:02:19'),
(320, 'SINDI TESILA', 'employee-1d3cd32b90e8d3b782ab5efbafd4192280b4e6f94e80ddc7b931757cbdabddbc@employees.invalid', NULL, '$2y$12$gkJdt74gQSOG07gGckNTuOQBnIgSX7F66pn4hYjNrt6idvi5RMwEa', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:20', '2026-11-04 02:02:20'),
(321, 'NOVA ISMAYA', 'employee-2e83c81a4f24960bde7c50fa6c6df9c14dbae5cd9cd39c897124eb30daac5325@employees.invalid', NULL, '$2y$12$.8zm8MYEWXNs4ZocpUnSkO2bKxypmVAO638fGTFeaOE8dHc/Tp81y', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:20', '2026-11-04 02:02:20'),
(322, 'ALI NURDIN', 'employee-cb7a00b5ec7c4ad8fd8d017e8a2fdf25bf68b8b140c208a59027356091674542@employees.invalid', NULL, '$2y$12$TXsRb7Hn2IGpfzBYzbLMzu90w3O6bHTDUpQLfoPE1liSJ07LKT5Mm', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:20', '2026-11-04 02:02:20'),
(323, 'ANJASMARA', 'employee-2dfbc3484c037799eccf9b875cfd7f3b3a06ad5bc4c4560659501d3614e4ac35@employees.invalid', NULL, '$2y$12$iMDHhW3b/qN.fYclZ6A2xuEL0eyroW.yatOX0FVTorpOFgWgdMyVK', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:21', '2026-11-04 02:02:21'),
(324, 'WINI WIDIARTI', 'employee-025709948459fba0568035e64088aefd43ea558c08ebf9ca12b5b299d7c7eb0b@employees.invalid', NULL, '$2y$12$wKjR/6OjU7jbS.zsgAvPf.mA0e7TbPEtTAbqAbZr.9fI8CsMMos.2', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:21', '2026-11-04 02:02:21'),
(325, 'M RIZKI SAPUTRA', 'employee-f65279763c60dcf2ab8d7f6a4b5906f7fc9d9b41b1bec0de7bf3b634413a71aa@employees.invalid', NULL, '$2y$12$ny0G1wC80krS/z7Kun940eEyz4MYCKyUJlFhmjrTv1IWLfRD3Cra.', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:22', '2026-11-04 02:02:22'),
(326, 'MARIA ULFA', 'employee-af9118ef337535dbac9f9a8da9feac9c73b2223a448425419acae4eba3af5730@employees.invalid', NULL, '$2y$12$785dQ1VOkNv4G4EZx5UfrOk.kUU7OQPPsEc.Cs7yX6k/s82PuMwbG', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:22', '2026-11-04 02:02:22'),
(327, 'HALIMAH', 'employee-bded533130f1157c3c8c0626ee2b9372a3799c6db7db52f860ce8ff5821870e8@employees.invalid', NULL, '$2y$12$QMriw9ORfvIzxeZRtltMoOYHv6n1ZW1Et.ccJIclPEvv82/rK.j6C', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:22', '2026-11-04 02:02:22'),
(328, 'HARUM BUNGA ALVIYANTY', 'employee-164c28064bb7ec415823356da8a423df971f688daa8952a7e3a89555ea60ba23@employees.invalid', NULL, '$2y$12$8lxR3OfG0ljsaIFBh4a91.e7N7MkptdyEZKt0Qusv29ki1SVq3a42', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:23', '2026-11-04 02:02:23'),
(329, 'ADHIKKA EKA PUTTA', 'employee-12458e15a6b9c57ec36ba219a7051ef853216136235469b958ed662662bfcaaf@employees.invalid', NULL, '$2y$12$qq2lgkRlnNCNXOItnpubuuIP7m76.OYCw6m0vQTWT098EONZsK/o2', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:23', '2026-11-04 02:02:23'),
(330, 'DARMI', 'employee-fe7ff5cd9f004136f73d5339f0d460d237aa32a7899cf20fd3ac60b85915ecc9@employees.invalid', NULL, '$2y$12$rDXb3NVBs7dSY1w7cSXvIeY7WoS6V4DujUDDVZR6YHMkomjOJcjNG', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:23', '2026-11-04 02:02:23'),
(331, 'HERLINA BUDIARTI', 'employee-57b65d535bd2bdbbc56acf4c84930f13a3878ce07ebfa45c13219aaab1471914@employees.invalid', NULL, '$2y$12$UucBDEyqyzLY28ccwCZ5g.L1EARhGsOFrtwlGYQXEufGAi/S6/I..', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:24', '2026-11-04 02:02:24'),
(332, 'KARNI', 'employee-31ec0775620753b695606a435f627a22e954d006a7b2fbbb061b8f6dec41540d@employees.invalid', NULL, '$2y$12$Hdij5LkbvDZ39cWDZe4qhe12ErZwKAx9e3kWNdM8J6x55zBksjHv.', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:24', '2026-11-04 02:02:24'),
(333, 'WAHYU RESTIANINGRUM', 'employee-0ba22a37a6fb7411d5225b9970b5bea85eeccb01080979082ea2ea1a2e179c96@employees.invalid', NULL, '$2y$12$GggGlLzJkyNWzpvJFSNiN.NfNemfPUTfOavMaU5gtMZNbuZZt5l2e', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:25', '2026-11-04 02:02:25'),
(334, 'EKA PUTRI OKTAVIANI', 'employee-4144148a90b01519b9342e1bc5df9aac9580a0ed5463e85514d92365c41177ab@employees.invalid', NULL, '$2y$12$ZD54LVeGKqIhhWYs/TuXZeeUbuR9k8Fsigk8lOj5bwCor.K0E04pu', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:25', '2026-11-04 02:02:25'),
(335, 'WINDA HERLINA PUTRI', 'employee-864d375cb37bb57bbedb2e13fb4fc51b36f098ab9b38e6e60ff59554238ba7cf@employees.invalid', NULL, '$2y$12$ojqBV4/Z4neNK9YA6H.Ua./Uh8ounn0LAb4UoBvrv7yU/WLXv2mwG', NULL, NULL, NULL, NULL, NULL, '2026-11-04 02:02:25', '2026-11-04 02:02:25');

-- --------------------------------------------------------

--
-- Struktur dari tabel `zkteco_attendances`
--

CREATE TABLE `zkteco_attendances` (
  `id` bigint UNSIGNED NOT NULL,
  `fingerprint` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uid` int UNSIGNED DEFAULT NULL,
  `punched_at` datetime NOT NULL,
  `timezone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direction` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `verify_method` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `raw_direction` smallint UNSIGNED NOT NULL DEFAULT '0',
  `raw_verify` smallint UNSIGNED NOT NULL DEFAULT '0',
  `work_code` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `zkteco_push_commands`
--

CREATE TABLE `zkteco_push_commands` (
  `id` bigint UNSIGNED NOT NULL,
  `serial_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `command` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `return_code` int DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `zkteco_push_devices`
--

CREATE TABLE `zkteco_push_devices` (
  `id` bigint UNSIGNED NOT NULL,
  `serial_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `details` json DEFAULT NULL,
  `stamps` json DEFAULT NULL,
  `last_seen_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indeks untuk tabel yang dibuang
--

--
-- Indeks untuk tabel `assets`
--
ALTER TABLE `assets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `assets_code_unique` (`code`),
  ADD UNIQUE KEY `assets_serial_number_unique` (`serial_number`),
  ADD KEY `assets_asset_category_id_foreign` (`asset_category_id`),
  ADD KEY `assets_asset_location_id_foreign` (`asset_location_id`),
  ADD KEY `assets_assigned_to_foreign` (`assigned_to`),
  ADD KEY `assets_status_asset_category_id_index` (`status`,`asset_category_id`);

--
-- Indeks untuk tabel `asset_categories`
--
ALTER TABLE `asset_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `asset_categories_name_unique` (`name`);

--
-- Indeks untuk tabel `asset_locations`
--
ALTER TABLE `asset_locations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `asset_locations_name_unique` (`name`);

--
-- Indeks untuk tabel `asset_maintenances`
--
ALTER TABLE `asset_maintenances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_maintenances_performed_by_foreign` (`performed_by`),
  ADD KEY `asset_maintenances_asset_id_service_date_index` (`asset_id`,`service_date`);

--
-- Indeks untuk tabel `asset_movements`
--
ALTER TABLE `asset_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_movements_from_user_id_foreign` (`from_user_id`),
  ADD KEY `asset_movements_to_user_id_foreign` (`to_user_id`),
  ADD KEY `asset_movements_from_location_id_foreign` (`from_location_id`),
  ADD KEY `asset_movements_to_location_id_foreign` (`to_location_id`),
  ADD KEY `asset_movements_performed_by_foreign` (`performed_by`),
  ADD KEY `asset_movements_asset_id_occurred_at_index` (`asset_id`,`occurred_at`);

--
-- Indeks untuk tabel `attendances`
--
ALTER TABLE `attendances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attendances_employee_id_date_unique` (`employee_id`,`date`);

--
-- Indeks untuk tabel `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `brands_name_unique` (`name`),
  ADD UNIQUE KEY `brands_code_unique` (`code`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `defect_categories`
--
ALTER TABLE `defect_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `defect_categories_brand_id_foreign` (`brand_id`);

--
-- Indeks untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `employees_employee_code_unique` (`employee_code`),
  ADD KEY `employees_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  ADD KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`);

--
-- Indeks untuk tabel `finger_logs`
--
ALTER TABLE `finger_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `holidays_date_unique` (`date`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leave_requests_employee_id_foreign` (`employee_id`),
  ADD KEY `leave_requests_approved_by_foreign` (`approved_by`),
  ADD KEY `leave_requests_cancelled_by_foreign` (`cancelled_by`);

--
-- Indeks untuk tabel `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indeks untuk tabel `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indeks untuk tabel `overtimes`
--
ALTER TABLE `overtimes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `overtimes_created_by_foreign` (`created_by`);

--
-- Indeks untuk tabel `overtime_employees`
--
ALTER TABLE `overtime_employees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `overtime_employees_overtime_id_foreign` (`overtime_id`),
  ADD KEY `overtime_employees_employee_id_foreign` (`employee_id`);

--
-- Indeks untuk tabel `passkeys`
--
ALTER TABLE `passkeys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `passkeys_credential_id_unique` (`credential_id`),
  ADD KEY `passkeys_user_id_index` (`user_id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `payroll_adjustments`
--
ALTER TABLE `payroll_adjustments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payroll_adjustments_payroll_item_id_foreign` (`payroll_item_id`);

--
-- Indeks untuk tabel `payroll_items`
--
ALTER TABLE `payroll_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payroll_items_payroll_run_id_employee_code_unique` (`payroll_run_id`,`employee_code`),
  ADD KEY `payroll_items_employee_id_foreign` (`employee_id`);

--
-- Indeks untuk tabel `payroll_runs`
--
ALTER TABLE `payroll_runs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payroll_runs_month_year_unique` (`month`,`year`),
  ADD KEY `payroll_runs_generated_by_foreign` (`generated_by`),
  ADD KEY `payroll_runs_approved_by_foreign` (`approved_by`),
  ADD KEY `payroll_runs_paid_by_foreign` (`paid_by`);

--
-- Indeks untuk tabel `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indeks untuk tabel `production_dailies`
--
ALTER TABLE `production_dailies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `production_dailies_spk_batch_id_foreign` (`spk_batch_id`),
  ADD KEY `production_dailies_spk_id_foreign` (`spk_id`);

--
-- Indeks untuk tabel `production_defects`
--
ALTER TABLE `production_defects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `production_defects_spk_id_foreign` (`spk_id`),
  ADD KEY `production_defects_defect_category_id_foreign` (`defect_category_id`);

--
-- Indeks untuk tabel `production_scans`
--
ALTER TABLE `production_scans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `production_scans_spk_detail_id_foreign` (`spk_detail_id`);

--
-- Indeks untuk tabel `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indeks untuk tabel `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `size_runs`
--
ALTER TABLE `size_runs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `size_runs_brand_id_foreign` (`brand_id`);

--
-- Indeks untuk tabel `spks`
--
ALTER TABLE `spks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `spks_po_number_unique` (`po_number`),
  ADD KEY `spks_brand_id_foreign` (`brand_id`);

--
-- Indeks untuk tabel `spk_batches`
--
ALTER TABLE `spk_batches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `spk_batches_spk_id_foreign` (`spk_id`);

--
-- Indeks untuk tabel `spk_batch_tracks`
--
ALTER TABLE `spk_batch_tracks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `spk_batch_tracks_spk_batch_id_foreign` (`spk_batch_id`);

--
-- Indeks untuk tabel `spk_details`
--
ALTER TABLE `spk_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `spk_details_spk_id_foreign` (`spk_id`);

--
-- Indeks untuk tabel `sub_menus`
--
ALTER TABLE `sub_menus`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_menus_menu_id_foreign` (`menu_id`);

--
-- Indeks untuk tabel `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `teams_slug_unique` (`slug`);

--
-- Indeks untuk tabel `team_invitations`
--
ALTER TABLE `team_invitations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `team_invitations_code_unique` (`code`),
  ADD KEY `team_invitations_team_id_foreign` (`team_id`),
  ADD KEY `team_invitations_invited_by_foreign` (`invited_by`);

--
-- Indeks untuk tabel `team_members`
--
ALTER TABLE `team_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `team_members_team_id_user_id_unique` (`team_id`,`user_id`),
  ADD KEY `team_members_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_current_team_id_foreign` (`current_team_id`);

--
-- Indeks untuk tabel `zkteco_attendances`
--
ALTER TABLE `zkteco_attendances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `zkteco_attendances_fingerprint_unique` (`fingerprint`),
  ADD KEY `zkteco_attendances_user_id_punched_at_index` (`user_id`,`punched_at`),
  ADD KEY `zkteco_attendances_device_index` (`device`),
  ADD KEY `zkteco_attendances_user_id_index` (`user_id`),
  ADD KEY `zkteco_attendances_punched_at_index` (`punched_at`);

--
-- Indeks untuk tabel `zkteco_push_commands`
--
ALTER TABLE `zkteco_push_commands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `zkteco_push_commands_serial_number_status_index` (`serial_number`,`status`),
  ADD KEY `zkteco_push_commands_serial_number_index` (`serial_number`);

--
-- Indeks untuk tabel `zkteco_push_devices`
--
ALTER TABLE `zkteco_push_devices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `zkteco_push_devices_serial_number_unique` (`serial_number`),
  ADD KEY `zkteco_push_devices_status_index` (`status`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `assets`
--
ALTER TABLE `assets`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `asset_categories`
--
ALTER TABLE `asset_categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `asset_locations`
--
ALTER TABLE `asset_locations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `asset_maintenances`
--
ALTER TABLE `asset_maintenances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `asset_movements`
--
ALTER TABLE `asset_movements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `attendances`
--
ALTER TABLE `attendances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=451;

--
-- AUTO_INCREMENT untuk tabel `brands`
--
ALTER TABLE `brands`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `defect_categories`
--
ALTER TABLE `defect_categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `employees`
--
ALTER TABLE `employees`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=331;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `finger_logs`
--
ALTER TABLE `finger_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2594;

--
-- AUTO_INCREMENT untuk tabel `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `leave_requests`
--
ALTER TABLE `leave_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `menus`
--
ALTER TABLE `menus`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT untuk tabel `overtimes`
--
ALTER TABLE `overtimes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `overtime_employees`
--
ALTER TABLE `overtime_employees`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `passkeys`
--
ALTER TABLE `passkeys`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `payroll_adjustments`
--
ALTER TABLE `payroll_adjustments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `payroll_items`
--
ALTER TABLE `payroll_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=293;

--
-- AUTO_INCREMENT untuk tabel `payroll_runs`
--
ALTER TABLE `payroll_runs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT untuk tabel `production_dailies`
--
ALTER TABLE `production_dailies`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `production_defects`
--
ALTER TABLE `production_defects`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT untuk tabel `production_scans`
--
ALTER TABLE `production_scans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `size_runs`
--
ALTER TABLE `size_runs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT untuk tabel `spks`
--
ALTER TABLE `spks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `spk_batches`
--
ALTER TABLE `spk_batches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `spk_batch_tracks`
--
ALTER TABLE `spk_batch_tracks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `spk_details`
--
ALTER TABLE `spk_details`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `sub_menus`
--
ALTER TABLE `sub_menus`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT untuk tabel `teams`
--
ALTER TABLE `teams`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `team_invitations`
--
ALTER TABLE `team_invitations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `team_members`
--
ALTER TABLE `team_members`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=336;

--
-- AUTO_INCREMENT untuk tabel `zkteco_attendances`
--
ALTER TABLE `zkteco_attendances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `zkteco_push_commands`
--
ALTER TABLE `zkteco_push_commands`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `zkteco_push_devices`
--
ALTER TABLE `zkteco_push_devices`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `assets`
--
ALTER TABLE `assets`
  ADD CONSTRAINT `assets_asset_category_id_foreign` FOREIGN KEY (`asset_category_id`) REFERENCES `asset_categories` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `assets_asset_location_id_foreign` FOREIGN KEY (`asset_location_id`) REFERENCES `asset_locations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `assets_assigned_to_foreign` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `asset_maintenances`
--
ALTER TABLE `asset_maintenances`
  ADD CONSTRAINT `asset_maintenances_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `asset_maintenances_performed_by_foreign` FOREIGN KEY (`performed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `asset_movements`
--
ALTER TABLE `asset_movements`
  ADD CONSTRAINT `asset_movements_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `asset_movements_from_location_id_foreign` FOREIGN KEY (`from_location_id`) REFERENCES `asset_locations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `asset_movements_from_user_id_foreign` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `asset_movements_performed_by_foreign` FOREIGN KEY (`performed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `asset_movements_to_location_id_foreign` FOREIGN KEY (`to_location_id`) REFERENCES `asset_locations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `asset_movements_to_user_id_foreign` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `attendances`
--
ALTER TABLE `attendances`
  ADD CONSTRAINT `attendances_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `defect_categories`
--
ALTER TABLE `defect_categories`
  ADD CONSTRAINT `defect_categories_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD CONSTRAINT `leave_requests_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `leave_requests_cancelled_by_foreign` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `leave_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `overtimes`
--
ALTER TABLE `overtimes`
  ADD CONSTRAINT `overtimes_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `overtime_employees`
--
ALTER TABLE `overtime_employees`
  ADD CONSTRAINT `overtime_employees_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `overtime_employees_overtime_id_foreign` FOREIGN KEY (`overtime_id`) REFERENCES `overtimes` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `passkeys`
--
ALTER TABLE `passkeys`
  ADD CONSTRAINT `passkeys_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_adjustments`
--
ALTER TABLE `payroll_adjustments`
  ADD CONSTRAINT `payroll_adjustments_payroll_item_id_foreign` FOREIGN KEY (`payroll_item_id`) REFERENCES `payroll_items` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_items`
--
ALTER TABLE `payroll_items`
  ADD CONSTRAINT `payroll_items_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `payroll_items_payroll_run_id_foreign` FOREIGN KEY (`payroll_run_id`) REFERENCES `payroll_runs` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payroll_runs`
--
ALTER TABLE `payroll_runs`
  ADD CONSTRAINT `payroll_runs_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `payroll_runs_generated_by_foreign` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `payroll_runs_paid_by_foreign` FOREIGN KEY (`paid_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `production_dailies`
--
ALTER TABLE `production_dailies`
  ADD CONSTRAINT `production_dailies_spk_batch_id_foreign` FOREIGN KEY (`spk_batch_id`) REFERENCES `spk_batches` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `production_dailies_spk_id_foreign` FOREIGN KEY (`spk_id`) REFERENCES `spks` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `production_defects`
--
ALTER TABLE `production_defects`
  ADD CONSTRAINT `production_defects_defect_category_id_foreign` FOREIGN KEY (`defect_category_id`) REFERENCES `defect_categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `production_defects_spk_id_foreign` FOREIGN KEY (`spk_id`) REFERENCES `spks` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `production_scans`
--
ALTER TABLE `production_scans`
  ADD CONSTRAINT `production_scans_spk_detail_id_foreign` FOREIGN KEY (`spk_detail_id`) REFERENCES `spk_details` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `size_runs`
--
ALTER TABLE `size_runs`
  ADD CONSTRAINT `size_runs_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `spks`
--
ALTER TABLE `spks`
  ADD CONSTRAINT `spks_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`);

--
-- Ketidakleluasaan untuk tabel `spk_batches`
--
ALTER TABLE `spk_batches`
  ADD CONSTRAINT `spk_batches_spk_id_foreign` FOREIGN KEY (`spk_id`) REFERENCES `spks` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `spk_batch_tracks`
--
ALTER TABLE `spk_batch_tracks`
  ADD CONSTRAINT `spk_batch_tracks_spk_batch_id_foreign` FOREIGN KEY (`spk_batch_id`) REFERENCES `spk_batches` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `spk_details`
--
ALTER TABLE `spk_details`
  ADD CONSTRAINT `spk_details_spk_id_foreign` FOREIGN KEY (`spk_id`) REFERENCES `spks` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `sub_menus`
--
ALTER TABLE `sub_menus`
  ADD CONSTRAINT `sub_menus_menu_id_foreign` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `team_invitations`
--
ALTER TABLE `team_invitations`
  ADD CONSTRAINT `team_invitations_invited_by_foreign` FOREIGN KEY (`invited_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `team_invitations_team_id_foreign` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `team_members`
--
ALTER TABLE `team_members`
  ADD CONSTRAINT `team_members_team_id_foreign` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `team_members_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_current_team_id_foreign` FOREIGN KEY (`current_team_id`) REFERENCES `teams` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
