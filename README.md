# Catat Untung — Rekap Penjualan Harian Tanpa Internet

<p align="center">
  <img src="./assets/logo.png" alt="Catat Untung Logo" width="120" style="border-radius: 28px;"/>
</p>

<p align="center">
  <b>Aplikasi Kasir & Rekap Keuangan Harian UMKM 100% Offline Tanpa Internet</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Database-SQLite%20via%20Drift-003B57?logo=sqlite" alt="SQLite Drift"/>
  <img src="https://img.shields.io/badge/State-Riverpod%202.x-00AA13" alt="Riverpod"/>
  <img src="https://img.shields.io/badge/Icons-Lucide%20Icons-F59E0B" alt="Lucide Icons"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green" alt="Platform"/>
  <img src="https://img.shields.io/badge/License-MIT-blue" alt="License"/>
</p>

---

## 📌 Tentang Aplikasi

**Catat Untung** diciptakan khusus bagi pemilik warung, pengusaha kuliner, kedai kopi, toko kelontong, dan pelaku UMKM Indonesia yang membutuhkan solusi pembukuan yang praktis, cepat, dan **tanpa biaya langganan bulanan**.

Aplikasi ini beroperasi **100% secara offline** di perangkat smartphone Anda. Semua data transaksi, rekap laba kotor, HPP (Harga Pokok Penjualan), dan keuntungan bersih disimpan secara lokal di memori internal menggunakan basis data SQLite terenkripsi lokal, menjaga kerahasiaan dapur bisnis Anda tanpa risiko kebocoran data ke server luar.

---

## ✨ Fitur Utama

- 📊 **Dashboard Keuangan Real-Time**
  - Ringkasan total omzet kotor, modal bahan terpakai, laba bersih, dan jumlah produk terjual.
  - Grafik batang tren laba 7 hari terakhir secara visual.
  - Pemecahan performa penjualan hari ini (*Performance Breakdown*).
  
- 📝 **Rekap Penjualan Cepat (Quick Rekap)**
  - Catat penjualan harian hanya dalam hitungan 30 detik saat toko tutup.
  - Live summary margin keuntungan langsung saat memasukkan jumlah unit terjual.
  - Selektor produk modal interaktif dengan pencarian instan.

- 📦 **Manajemen Katalog Produk**
  - Kelola daftar produk, satuan unit (*pcs, botol, kg, porsi, box, dll.*).
  - Penetapan harga jual dan HPP modal per unit.
  - Analisis margin otomatis (kategori margin sehat vs tipis).

- 🧮 **Kalkulator HPP Otomatis**
  - Hitung modal bahan baku, kemasan (cup/plastik), dan operasional (gas LPG/listrik).
  - Rekomendasi harga jual berdasarkan target persentase margin keuntungan yang diinginkan.

- 📅 **Kalender & Riwayat Penjualan**
  - Tampilan kalender interaktif dengan indikator status untung/rugi per tanggal.
  - Ringkasan hero bulanan untuk mengevaluasi pertumbuhan omzet toko.
  - Detail item transaksi setiap hari lengkap dengan catatan waktu.

- 📈 **Laporan & Analisis Statistik**
  - Pemeringkatan Produk Terlaris (*Best Seller*).
  - Metrik efisiensi biaya modal terhadap omzet kotor.
  - Filter periode kustom (7 hari, 30 hari, bulan ini, atau rentang tanggal kustom).

- 📄 **Ekspor Multi-Format (PDF & CSV)**
  - Ekspor laporan penjualan berformat PDF profesional siap cetak lengkap dengan kop logo toko.
  - Ekspor format spreadsheet CSV untuk diolah lebih lanjut di Microsoft Excel / Google Sheets.
  - Integrasi fitur share langsung ke WhatsApp atau Google Drive.

- 💾 **Cadangan & Pemulihan Data (Backup & Restore)**
  - Backup seluruh database ke file JSON aman dengan satu kali klik.
  - Pulihkan data secara instan saat berpindah perangkat smartphone baru.

---

## 🛠️ Spesifikasi Teknologi

| Komponen | Teknologi yang Digunakan |
| --- | --- |
| **Framework** | Flutter 3.8+ (Dart 3.8+) |
| **Arsitektur State** | Riverpod 2.x Architecture (`flutter_riverpod`, `riverpod_generator`) |
| **Mesin Database** | SQLite Engine via Drift ORM (`drift`, `sqlite3_flutter_libs`) |
| **Sistem Navigasi** | GoRouter (`go_router`) |
| **Ikonografi** | Lucide Icons (`lucide_icons`) |
| **Visualisasi Grafik** | FL Chart (`fl_chart`) |
| **Kalender** | Table Calendar (`table_calendar`) |
| **Dokumen & Cetak** | PDF Document & Printing (`pdf`, `printing`, `csv`) |
| **Launcher Icon** | Flutter Launcher Icons (`flutter_launcher_icons: ^0.14.4`) |

---

## 📋 Persyaratan Sistem

- **Flutter SDK**: `>= 3.8.1`
- **Dart SDK**: `>= 3.8.1 < 4.0.0`
- **Android**: Minimal Android 5.0 (API level 21 - Lollipop) hingga Android 14+
- **Editor**: VS Code / Android Studio dengan ekstensi Flutter & Dart

---

## 🚀 Panduan Instalasi & Menjalankan Aplikasi

### 1. Clone Repository
```bash
git clone https://github.com/ardhikaxx/catat_untung_mobile.git
cd catat_untung_mobile
```

### 2. Unduh Dependensi
```bash
flutter pub get
```

### 3. Generate Kode Database & Launcher Icon
```bash
dart run build_runner build --delete-conflicting-outputs
dart run flutter_launcher_icons
```

> **Catatan CI**: Pada workflow CI/CD, langkah `dart run build_runner build` dijalankan otomatis sebelum membangun APK release untuk memastikan kode generik selalu up‑to‑date.

### 4. Jalankan Aplikasi di Perangkat / Emulator
```bash
flutter run
```

### 5. Build APK Release Siap Pasang
```bash
flutter build apk --release
```
*Gradle menghasilkan `build/app/outputs/flutter-apk/app-release.apk`. Workflow
rilis menamainya menjadi `Catat_Untung_v<versi>.apk` sebelum di-upload ke GitHub
Releases.*

Build release memakai R8 (`minifyEnabled` + `shrinkResources`) dengan aturan di
`android/app/proguard-rules.pro`. R8 berjalan dalam *compatibility mode*
(`android.enableR8.fullMode=false`) supaya member yang dicari plugin lewat
reflection tidak ikut terbuang. Nama class **tidak** di-obfuscate supaya log error
masih terbaca. Karena R8 memangkas kode, selalu lakukan smoke test di perangkat
sebelum rilis ke pengguna.

> **Butuh JDK 17** untuk build Android. Toolchain Kotlin/AGP bawaan Flutter 3.32
> gagal pada JDK 25 (`IllegalArgumentException` saat membaca versi Java). Workflow
> GitHub Actions sudah memakai Java 17.

Butuh AAB untuk Play Store?
```bash
flutter build appbundle --release   # build/app/outputs/bundle/release/app-release.aab
```

> Rilis resmi dibuat otomatis oleh GitHub Actions: buat tag (`git tag v1.2.0`) lalu
> push. Workflow akan memverifikasi versi tag sama dengan `pubspec.yaml`, build APK,
> meng-uploadnya sebagai `Catat_Untung_v<versi>.apk`, dan membuat GitHub Release.

---

## 🧪 Menjalankan Pengujian Otomatis

Proyek ini dilengkapi dengan suite pengujian menyeluruh (*unit tests* & *widget tests*):

```bash
# Menjalankan seluruh unit & widget tests
flutter test

# Alongside laporan coverage (coverage/lcov.info)
flutter test --coverage

# Memeriksa kepatuhan kode dan linting
flutter analyze

# Integration test (butuh perangkat/emulator terpasang)
flutter test integration_test/backup_roundtrip_test.dart
```

---

## 📦 Rilis & Identitas Aplikasi

| Item | Nilai |
| --- | --- |
| Android `applicationId` | `id.ardhikaxx.catat_untueng` |
| iOS bundle identifier | `id.ardhikaxx.catat_untueng` |
| Sumber versi | `pubspec.yaml` (dibaca runtime via `package_info_plus`) |
| Backup | JSON + checksum SHA-256, mode pulihkan *ganti* atau *gabungkan* |
| Sertifikat rilis | SHA-256 `52:9E:11:A1:…:C1:6D:E7:C9` (diverifikasi otomatis tiap rilis) |

### Menlify signing key ke GitHub Actions

APK rilis **wajib** ditandatangani dengan keystore yang sama seperti build lokal,
kalau tidak pengguna tidak bisa memasang APK baru di atas versi lama. Simpan
keystore sebagai secret (Settings → Secrets and variables → Actions):

| Secret | Isi |
| --- | --- |
| `KEYSTORE_BASE64` | `base64 -w0 android/app/upload-keystore.jks` (PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes('android/app/upload-keystore.jks'))`) |
| `KEYSTORE_PASSWORD` | `storePassword` dari `android/key.properties` |
| `KEY_ALIAS` | `keyAlias` dari `android/key.properties` |
| `KEY_PASSWORD` | `keyPassword` dari `android/key.properties` |

Workflow akan berhenti dengan pesan jelas bila secret belum ada, dan menolak
mempublish APK yang sertifikatnya bukan sertifikat rilis di atas.

> iOS memerlukan macOS + Xcode + signing Apple Developer untuk build & rilis.
> Distribusi resmi saat ini berupa APK Android.

---

## 📁 Struktur Direktori Proyek

```
lib/
├── core/                   # Utilitas inti, konstanta, tema, & formatter
│   ├── constants/          # Konstanta aplikasi & path logo
│   ├── theme/              # Warna identitas (Gojek Green palette) & AppTheme
│   └── utils/              # Formatter Rupiah, Tanggal, AppInfo (versi), AppLogger, kalkulasi HPP
├── data/                   # Data repositories (Product, DailyRecord, Settings)
├── database/               # Definisi tabel Drift SQLite & DAO
│   ├── daos/               # Data Access Objects untuk query cepat
│   └── tables/             # Tabel SQLite (Products, DailyRecords, Items)
├── domain/                 # Domain enums & entity rules
├── features/               # Fitur utama berbasis arsitektur modular
│   ├── about/              # Halaman tentang aplikasi & spesifikasi sistem
│   ├── backup/             # Fitur backup & restore data lokal JSON (checksum SHA-256, mode ganti/gabung)
│   ├── calculator/         # Kalkulator HPP & margin modal otomatis
│   ├── daily_rekap/        # Halaman pencatatan rekap harian
│   ├── dashboard/          # Beranda utama, omzet hero card, & grafik laba
│   ├── export/             # Generator ekspor PDF & CSV
│   ├── guide/              # Panduan singkat 4 langkah pembukuan UMKM
│   ├── history/            # Riwayat transaksi & kalender interaktif
│   ├── home/               # Root navigation host dengan floating nav bar
│   ├── products/           # Master katalog produk & form input
│   ├── reports/            # Laporan analisis performa & tren berkala
│   ├── settings/           # Pengaturan toko & status sistem
│   └── splash/             # Splash screen dengan logo brand animasi
├── providers/              # Riverpod state providers
├── routing/                # Konfigurasi GoRouter
└── shared/                 # Reusable UI widgets (nav bar, empty state, indikator)
```

---

## 💖 Dukungan & Donasi

Jika proyek **Catat Untung** ini bermanfaat bagi kelancaran operasional toko Anda atau membantu Anda dalam belajar pengembangan aplikasi Flutter, Anda dapat memberikan apresiasi dan traktiran kopi (donasi) melalui pemindaian kode QRIS di bawah ini:

<p align="center">
  <img src="./qris.png" alt="QRIS Donasi" width="300"/>
</p>

<p align="center">
  <b>NMID: ID1026473928582</b><br/>
  <i>YANUAR ARDHIKA ID, DIGITAL & KREATIF</i>
</p>

---

## 📄 Lisensi

Proyek ini dirilis di bawah lisensi MIT. Lihat file [LICENSE](./LICENSE) untuk informasi lebih lanjut.

Copyright (c) 2026 **Yanuar Ardhika Rahmadhani Ubaidillah**
