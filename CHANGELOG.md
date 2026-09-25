# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-09-26

### Added

- **Restore mode pilihan**: "Ganti Semua Data" atau "Gabungkan dengan Data Saya" saat restore. Mode gabungkan mencocokkan produk berdasarkan nama dan rekap berdasarkan tanggal, sehingga data yang sudah ada tidak pernah dihitung dua kali.
- **Checksum SHA-256 pada file backup**: file yang terpotong, rusak, atau diedit tangan ditolak sebelum menyentuh database. File backup versi lama (tanpa checksum) tetap bisa dipulihkan.
- **Satuan produk bebas**: kolom satuan sekarang bisa diketik bebas (mis. "Renteng", "Bungkus 250g") di samping pilihan cepat, bukan lagi daftar tertutup.
- **Laporan error lokal**: error yang tercatat di aplikasi bisa dilihat, disalin, dihapus, atau dibagikan dari Pengaturan → Laporan Error. Tidak ada data yang dikirim otomatis ke server.
- **Integration test**: `integration_test/backup_roundtrip_test.dart` memverifikasi alur rekap → file backup → restore pada SQLite file sungguhan.

### Changed

- **Package name resmi**: `com.example.*` → `id.ardhikaxx.catat_untueng` (Android `applicationId`/`namespace`, iOS bundle id, package `MainActivity`), agar siap dikirim ke Play Store.
- **Nomor versi dari satu sumber kebenaran**: About, Pengaturan, dan footer laporan PDF/CSV kini membaca versi dari `pubspec.yaml` lewat `package_info_plus`; konstanta `AppConstants.appVersion` dihapus sehingga tidak bisa lagi tidak sinkron dengan rilis.
- **APK lebih kecil**: R8 `minifyEnabled` + `shrinkResources` aktif dengan `android/app/proguard-rules.pro`; nama class tetap utuh agar log error masih terbaca.
- **Workflow rilis tanpa hardcode versi**: `release.yml` menurunkan nama release, judul, dan link unduhan dari tag, serta memverifikasi tag cocok dengan versi `pubspec.yaml` sebelum build.
- **CI**: `flutter test --coverage` dan artefak `coverage/lcov.info` diunggah tiap push.

### Removed

- `lib/l10n/staging/*.json` (26 file sisa proses penyusunan terjemahan yang tidak lagi dipakai).
- Teks error yang menampilkan pesan exception mentah ke pengguna; sekarang diganti pesan singkat terbaca + detail ada di Laporan Error.

## [1.0.1] - 2026-09-25

### Added

- Localization UI (Bahasa Indonesia / English /Ikuti sistem).
- UI refresh on dashboard, rekap, catalog, riwayat, laporan, and pengaturan.
- Backup/restore service and database migration.

## [1.0.0] - 2026-09-14

### Added

- **Offline Local Architecture**: 100% offline database using SQLite via Drift ORM and Drift Dev code generation.
- **State Management**: Reactive state management with Flutter Riverpod 2.x and auto-disposed stream/future providers.
- **Dashboard & Analytics**:
  - Live summary hero card for total omzet, laba bersih, and modal HPP.
  - Interactive 7-day profit bar chart powered by FL Chart.
  - Performance breakdown per-item for today's sales.
- **Quick Rekap Harian**:
  - 30-second daily recap workflow with live margin calculation.
  - Product selector modal with real-time catalog search.
  - Auto-calculation of subtotal revenue, modal cost, and net profit.
- **Product Catalog Management**:
  - Master product catalog with HPP (modal), selling price, unit types, and active status.
  - Live profit margin health indicators (Sehat, Tipis, Rugi).
  - Search, sort, and filter bar for fast navigation.
- **HPP Calculator**:
  - Comprehensive raw materials, packaging, and operational overhead calculator.
  - Target profit margin slider and chip selector with recommended selling price formula.
- **History & Calendar**:
  - Month hero view and interactive calendar with day-by-day profit indicators.
  - Detailed daily transaction modal and breakdown.
- **Reporting & Export**:
  - Business report summary with Best Seller ranking.
  - Clean PDF document generation with store branding and table view.
  - CSV spreadsheet export with direct sharing to WhatsApp/Drive.
- **Data Backup & Restore**:
  - One-click JSON backup to device storage.
  - Instant data recovery for phone migration.
- **Brand Identity & Iconography**:
  - Custom brand logo integration for splash screen and header widgets.
  - Android & iOS launcher icon generation via `flutter_launcher_icons: ^0.14.4` with adaptive icon support.
  - Complete migration to modern `lucide_icons` across 44 files.
  - iOS-style back navigation chevrons on all headers.
- **Documentation**: Comprehensive README, Contributing guidelines, Security policy, and QRIS donation support.
