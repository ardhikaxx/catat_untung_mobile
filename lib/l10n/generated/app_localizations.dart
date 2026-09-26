import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @navHome.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get navHome;

  /// No description provided for @navRecap.
  ///
  /// In id, this message translates to:
  /// **'Rekap'**
  String get navRecap;

  /// No description provided for @navHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get navHistory;

  /// No description provided for @navReports.
  ///
  /// In id, this message translates to:
  /// **'Laporan'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In id, this message translates to:
  /// **'Setelan'**
  String get navSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsPreferencesSection.
  ///
  /// In id, this message translates to:
  /// **'Preferensi & Bahasa'**
  String get settingsPreferencesSection;

  /// No description provided for @languageTileTitle.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Tampilan'**
  String get languageTileTitle;

  /// No description provided for @languageTileSubtitleSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti sistem'**
  String get languageTileSubtitleSystem;

  /// No description provided for @languageTileSubtitleId.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageTileSubtitleId;

  /// No description provided for @languageTileSubtitleEn.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageTileSubtitleEn;

  /// No description provided for @languageBadgeSystem.
  ///
  /// In id, this message translates to:
  /// **'Sistem'**
  String get languageBadgeSystem;

  /// No description provided for @languageBadgeId.
  ///
  /// In id, this message translates to:
  /// **'ID'**
  String get languageBadgeId;

  /// No description provided for @languageBadgeEn.
  ///
  /// In id, this message translates to:
  /// **'EN'**
  String get languageBadgeEn;

  /// No description provided for @languageDialogTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa'**
  String get languageDialogTitle;

  /// No description provided for @languageOptionSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti Sistem'**
  String get languageOptionSystem;

  /// No description provided for @languageOptionId.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageOptionId;

  /// No description provided for @languageOptionEn.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageOptionEn;

  /// No description provided for @commonCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get commonSave;

  /// No description provided for @commonAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get commonAdd;

  /// No description provided for @commonEdit.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get commonBack;

  /// No description provided for @commonRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get commonRetry;

  /// No description provided for @commonDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get commonDone;

  /// No description provided for @commonYes.
  ///
  /// In id, this message translates to:
  /// **'Ya'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In id, this message translates to:
  /// **'Tidak'**
  String get commonNo;

  /// No description provided for @commonSearch.
  ///
  /// In id, this message translates to:
  /// **'Cari'**
  String get commonSearch;

  /// No description provided for @commonAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get commonAll;

  /// No description provided for @commonLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In id, this message translates to:
  /// **'Terjadi Kesalahan'**
  String get commonError;

  /// No description provided for @commonEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Data'**
  String get commonEmpty;

  /// No description provided for @aboutAppBarTitle.
  ///
  /// In id, this message translates to:
  /// **'Tentang Aplikasi'**
  String get aboutAppBarTitle;

  /// No description provided for @aboutAppBarSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Informasi, visi & spesifikasi aplikasi'**
  String get aboutAppBarSubtitle;

  /// No description provided for @aboutTagline.
  ///
  /// In id, this message translates to:
  /// **'Aplikasi Kasir & Rekap Harian UMKM'**
  String get aboutTagline;

  /// No description provided for @aboutOfflineBadge.
  ///
  /// In id, this message translates to:
  /// **'100% Offline Safe'**
  String get aboutOfflineBadge;

  /// No description provided for @aboutPhilosophyTitle.
  ///
  /// In id, this message translates to:
  /// **'Filosofi & Misi Kami'**
  String get aboutPhilosophyTitle;

  /// No description provided for @aboutPhilosophyBody1.
  ///
  /// In id, this message translates to:
  /// **'Catat Untung diciptakan khusus bagi para pemilik warung, pengusaha kuliner, kedai kopi, dan pelaku UMKM Indonesia yang membutuhkan solusi pembukuan yang praktis, cepat, dan tanpa biaya langganan bulanan.'**
  String get aboutPhilosophyBody1;

  /// No description provided for @aboutPhilosophyBody2.
  ///
  /// In id, this message translates to:
  /// **'Kami percaya bahwa setiap pedagang berhak mengetahui keuntungan bersih usahanya secara jelas dan transparan tanpa harus repot menghitung kalkulator manual setiap malam.'**
  String get aboutPhilosophyBody2;

  /// No description provided for @aboutAdvantagesTitle.
  ///
  /// In id, this message translates to:
  /// **'KEUNGGULAN UTAMA'**
  String get aboutAdvantagesTitle;

  /// No description provided for @aboutPillar1Title.
  ///
  /// In id, this message translates to:
  /// **'Privasi & Bebas Kuota Internet'**
  String get aboutPillar1Title;

  /// No description provided for @aboutPillar1Description.
  ///
  /// In id, this message translates to:
  /// **'100% data bisnis Anda tersimpan eksklusif di dalam perangkat. Tidak ada data yang diunggah ke server luar, menjaga privasi dapur usaha Anda.'**
  String get aboutPillar1Description;

  /// No description provided for @aboutPillar2Title.
  ///
  /// In id, this message translates to:
  /// **'Desain Cepat untuk Jam Sibuk'**
  String get aboutPillar2Title;

  /// No description provided for @aboutPillar2Description.
  ///
  /// In id, this message translates to:
  /// **'Antarmuka modern bergaya Gojek yang ringan dan intuitif memungkinkan Anda mencatat rekap penjualan dalam hitungan 30 detik.'**
  String get aboutPillar2Description;

  /// No description provided for @aboutPillar3Title.
  ///
  /// In id, this message translates to:
  /// **'Kalkulasi HPP & Laba Akurat'**
  String get aboutPillar3Title;

  /// No description provided for @aboutPillar3Description.
  ///
  /// In id, this message translates to:
  /// **'Formula otomatis yang membedakan omzet kotor, modal bahan, kemasan, hingga laba bersih yang siap Anda tabung.'**
  String get aboutPillar3Description;

  /// No description provided for @aboutSpecsTitle.
  ///
  /// In id, this message translates to:
  /// **'Spesifikasi Sistem'**
  String get aboutSpecsTitle;

  /// No description provided for @aboutSpecFrameworkLabel.
  ///
  /// In id, this message translates to:
  /// **'Framework'**
  String get aboutSpecFrameworkLabel;

  /// No description provided for @aboutSpecFrameworkValue.
  ///
  /// In id, this message translates to:
  /// **'Flutter 3.x (Multi-platform)'**
  String get aboutSpecFrameworkValue;

  /// No description provided for @aboutSpecDatabaseLabel.
  ///
  /// In id, this message translates to:
  /// **'Mesin Database'**
  String get aboutSpecDatabaseLabel;

  /// No description provided for @aboutSpecDatabaseValue.
  ///
  /// In id, this message translates to:
  /// **'SQLite Engine via Drift ORM'**
  String get aboutSpecDatabaseValue;

  /// No description provided for @aboutSpecStateLabel.
  ///
  /// In id, this message translates to:
  /// **'Manajemen State'**
  String get aboutSpecStateLabel;

  /// No description provided for @aboutSpecStateValue.
  ///
  /// In id, this message translates to:
  /// **'Riverpod 2.x Architecture'**
  String get aboutSpecStateValue;

  /// No description provided for @aboutSpecExportLabel.
  ///
  /// In id, this message translates to:
  /// **'Format Ekspor'**
  String get aboutSpecExportLabel;

  /// No description provided for @aboutSpecExportValue.
  ///
  /// In id, this message translates to:
  /// **'PDF Document & CSV Spreadsheet'**
  String get aboutSpecExportValue;

  /// No description provided for @aboutSpecStorageLabel.
  ///
  /// In id, this message translates to:
  /// **'Penyimpanan'**
  String get aboutSpecStorageLabel;

  /// No description provided for @aboutSpecStorageValue.
  ///
  /// In id, this message translates to:
  /// **'Offline Local Storage'**
  String get aboutSpecStorageValue;

  /// No description provided for @aboutMadeInIndonesia.
  ///
  /// In id, this message translates to:
  /// **'ðŸ‡®ðŸ‡© Bangga Buatan Indonesia'**
  String get aboutMadeInIndonesia;

  /// No description provided for @aboutDevMotto.
  ///
  /// In id, this message translates to:
  /// **'Dibuat dengan dedikasi untuk mendukung jutaan wirausahawan dan pejuang UMKM di seluruh Nusantara.'**
  String get aboutDevMotto;

  /// No description provided for @aboutCopySuccess.
  ///
  /// In id, this message translates to:
  /// **'Info aplikasi & hak cipta berhasil disalin ke clipboard'**
  String get aboutCopySuccess;

  /// No description provided for @aboutCopyInfo.
  ///
  /// In id, this message translates to:
  /// **'Salin Info'**
  String get aboutCopyInfo;

  /// No description provided for @aboutOpenGuide.
  ///
  /// In id, this message translates to:
  /// **'Buka Panduan'**
  String get aboutOpenGuide;

  /// No description provided for @aboutDonationTitle.
  ///
  /// In id, this message translates to:
  /// **'ðŸ’– Dukungan & Donasi'**
  String get aboutDonationTitle;

  /// No description provided for @aboutDonationBody.
  ///
  /// In id, this message translates to:
  /// **'Catat Untung 100% gratis, bebas kuota, dan tanpa biaya langganan. Jika aplikasi ini bermanfaat untuk operasional usaha Anda, tunjukkan apresiasi dengan mentraktir kopi pengembang melalui QRIS.'**
  String get aboutDonationBody;

  /// No description provided for @aboutDonateButton.
  ///
  /// In id, this message translates to:
  /// **'Traktir Kopi (Scan QRIS)'**
  String get aboutDonateButton;

  /// No description provided for @aboutCopyrightNotice.
  ///
  /// In id, this message translates to:
  /// **'Hak Cipta Dilindungi Undang-Undang.'**
  String get aboutCopyrightNotice;

  /// No description provided for @aboutQrisTitle.
  ///
  /// In id, this message translates to:
  /// **'Dukungan & Donasi QRIS'**
  String get aboutQrisTitle;

  /// No description provided for @aboutQrisInstructions.
  ///
  /// In id, this message translates to:
  /// **'Scan kode QRIS di bawah melalui aplikasi e-wallet atau mobile banking apa saja (BCA, Mandiri, BRI, GoPay, OVO, ShopeePay, Dana, dll).'**
  String get aboutQrisInstructions;

  /// No description provided for @aboutQrisPayee.
  ///
  /// In id, this message translates to:
  /// **'YANUAR ARDHIKA ID, DIGITAL & KREATIF'**
  String get aboutQrisPayee;

  /// No description provided for @aboutQrisNmid.
  ///
  /// In id, this message translates to:
  /// **'NMID: ID1026473928582'**
  String get aboutQrisNmid;

  /// No description provided for @bkpTitle.
  ///
  /// In id, this message translates to:
  /// **'Backup & Restore'**
  String get bkpTitle;

  /// No description provided for @bkpBackupTitle.
  ///
  /// In id, this message translates to:
  /// **'Backup Data'**
  String get bkpBackupTitle;

  /// No description provided for @bkpBackupSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Simpan semua data ke file backup'**
  String get bkpBackupSubtitle;

  /// No description provided for @bkpRestoreTitle.
  ///
  /// In id, this message translates to:
  /// **'Restore Data'**
  String get bkpRestoreTitle;

  /// No description provided for @bkpRestoreSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pulihkan data dari file backup'**
  String get bkpRestoreSubtitle;

  /// No description provided for @bkpProcessing.
  ///
  /// In id, this message translates to:
  /// **'Memproses...'**
  String get bkpProcessing;

  /// No description provided for @bkpBackupSuccess.
  ///
  /// In id, this message translates to:
  /// **'Backup berhasil dibuat'**
  String get bkpBackupSuccess;

  /// No description provided for @bkpRestoreSuccess.
  ///
  /// In id, this message translates to:
  /// **'Restore berhasil'**
  String get bkpRestoreSuccess;

  /// No description provided for @bkpRestoreDialogTitle.
  ///
  /// In id, this message translates to:
  /// **'Restore Data?'**
  String get bkpRestoreDialogTitle;

  /// No description provided for @bkpRestoreDialogContent.
  ///
  /// In id, this message translates to:
  /// **'Semua data saat ini akan diganti dengan data dari backup. Pastikan kamu sudah melakukan backup data terbaru.'**
  String get bkpRestoreDialogContent;

  /// No description provided for @bkpRestoreButton.
  ///
  /// In id, this message translates to:
  /// **'Restore'**
  String get bkpRestoreButton;

  /// No description provided for @bkpFileInaccessible.
  ///
  /// In id, this message translates to:
  /// **'File backup tidak dapat diakses'**
  String get bkpFileInaccessible;

  /// No description provided for @bkpFileInvalid.
  ///
  /// In id, this message translates to:
  /// **'File backup tidak valid'**
  String get bkpFileInvalid;

  /// No description provided for @bkpShareText.
  ///
  /// In id, this message translates to:
  /// **'Backup Catat Untung'**
  String get bkpShareText;

  /// No description provided for @bkpModeReplaceTitle.
  ///
  /// In id, this message translates to:
  /// **'Ganti Semua Data'**
  String get bkpModeReplaceTitle;

  /// No description provided for @bkpModeReplaceSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus data saat ini, lalu isi ulang dari file backup'**
  String get bkpModeReplaceSubtitle;

  /// No description provided for @bkpModeMergeTitle.
  ///
  /// In id, this message translates to:
  /// **'Gabungkan dengan Data Saya'**
  String get bkpModeMergeTitle;

  /// No description provided for @bkpModeMergeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Data lama tetap ada. Rekap pada tanggal yang sudah ada tidak dihitung dua kali.'**
  String get bkpModeMergeSubtitle;

  /// No description provided for @bkpRestoreMergeDetail.
  ///
  /// In id, this message translates to:
  /// **'Ditambahkan {records} rekap & {items} item'**
  String bkpRestoreMergeDetail(Object items, Object records);

  /// No description provided for @bkpRestoreReplaceDetail.
  ///
  /// In id, this message translates to:
  /// **'{products} produk, {records} rekap, {items} item'**
  String bkpRestoreReplaceDetail(Object items, Object products, Object records);

  /// No description provided for @bkpRestoreRejected.
  ///
  /// In id, this message translates to:
  /// **'Restore dibatalkan:'**
  String get bkpRestoreRejected;

  /// No description provided for @bkpRestoreFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal restore. Coba lagi, atau hubungi developer bila tetap gagal.'**
  String get bkpRestoreFailed;

  /// No description provided for @bkpBackupFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat backup. Pastikan penyimpanan perangkat tidak penuh.'**
  String get bkpBackupFailed;

  /// No description provided for @calcEnterCostFirst.
  ///
  /// In id, this message translates to:
  /// **'Masukkan komponen biaya dan jumlah unit terlebih dahulu'**
  String get calcEnterCostFirst;

  /// No description provided for @calcAppBarTitle.
  ///
  /// In id, this message translates to:
  /// **'Kalkulator HPP'**
  String get calcAppBarTitle;

  /// No description provided for @calcAppBarSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hitung modal & simulasi harga jual UMKM'**
  String get calcAppBarSubtitle;

  /// No description provided for @calcReset.
  ///
  /// In id, this message translates to:
  /// **'Reset'**
  String get calcReset;

  /// No description provided for @calcResetTooltip.
  ///
  /// In id, this message translates to:
  /// **'Reset hitungan'**
  String get calcResetTooltip;

  /// No description provided for @calcFormulaTitle.
  ///
  /// In id, this message translates to:
  /// **'Formula HPP UMKM Sehat'**
  String get calcFormulaTitle;

  /// No description provided for @calcFormulaDesc.
  ///
  /// In id, this message translates to:
  /// **'HPP = (Bahan Baku + Kemasan + Operasional) Ã· Jumlah Porsi Jadi. Menghitung kemasan & gas mencegah produk jual rugi.'**
  String get calcFormulaDesc;

  /// No description provided for @calcQuickExamplesHeading.
  ///
  /// In id, this message translates to:
  /// **'CONTOH SIMULASI CEPAT'**
  String get calcQuickExamplesHeading;

  /// No description provided for @calcRecipeAyamGeprek.
  ///
  /// In id, this message translates to:
  /// **'ðŸ— Ayam Geprek (30 Porsi)'**
  String get calcRecipeAyamGeprek;

  /// No description provided for @calcRecipeKopiSusu.
  ///
  /// In id, this message translates to:
  /// **'â˜• Kopi Susu (50 Cup)'**
  String get calcRecipeKopiSusu;

  /// No description provided for @calcRecipeCookies.
  ///
  /// In id, this message translates to:
  /// **'ðŸª Cookies (12 Toples)'**
  String get calcRecipeCookies;

  /// No description provided for @calcCostComponentsTitle.
  ///
  /// In id, this message translates to:
  /// **'Komponen Biaya Produksi'**
  String get calcCostComponentsTitle;

  /// No description provided for @calcCostComponentsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Ketik nominal, hasil HPP terhitung otomatis'**
  String get calcCostComponentsSubtitle;

  /// No description provided for @calcCostBahanLabel.
  ///
  /// In id, this message translates to:
  /// **'Biaya Bahan Baku Utama'**
  String get calcCostBahanLabel;

  /// No description provided for @calcCostBahanSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Daging, beras, bumbu, sayuran, dsb.'**
  String get calcCostBahanSubtitle;

  /// No description provided for @calcCostKemasanLabel.
  ///
  /// In id, this message translates to:
  /// **'Biaya Kemasan & Packaging'**
  String get calcCostKemasanLabel;

  /// No description provided for @calcCostKemasanSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Box, styrofoam, cup, plastik, stiker label'**
  String get calcCostKemasanSubtitle;

  /// No description provided for @calcCostOperasionalLabel.
  ///
  /// In id, this message translates to:
  /// **'Biaya Operasional / Lainnya'**
  String get calcCostOperasionalLabel;

  /// No description provided for @calcCostOperasionalSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Gas LPG, listrik, es batu, minyak goreng'**
  String get calcCostOperasionalSubtitle;

  /// No description provided for @calcTargetYieldTitle.
  ///
  /// In id, this message translates to:
  /// **'Target Jumlah Jadi'**
  String get calcTargetYieldTitle;

  /// No description provided for @calcTargetYieldSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Berapa porsi / unit yang dihasilkan'**
  String get calcTargetYieldSubtitle;

  /// No description provided for @calcUnitCountHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: 50'**
  String get calcUnitCountHint;

  /// No description provided for @calcUnitSuffix.
  ///
  /// In id, this message translates to:
  /// **'Unit / Porsi'**
  String get calcUnitSuffix;

  /// No description provided for @calcQuickAddLabel.
  ///
  /// In id, this message translates to:
  /// **'Tambah cepat: '**
  String get calcQuickAddLabel;

  /// No description provided for @calcCreateProductButton.
  ///
  /// In id, this message translates to:
  /// **'Jadikan Produk Baru'**
  String get calcCreateProductButton;

  /// No description provided for @calcResetAllButton.
  ///
  /// In id, this message translates to:
  /// **'Reset Semua Hitungan'**
  String get calcResetAllButton;

  /// No description provided for @calcAutoHppBadge.
  ///
  /// In id, this message translates to:
  /// **'KALKULASI HPP OTOMATIS'**
  String get calcAutoHppBadge;

  /// No description provided for @calcRealtimeBadge.
  ///
  /// In id, this message translates to:
  /// **'Real-time'**
  String get calcRealtimeBadge;

  /// No description provided for @calcHppHeading.
  ///
  /// In id, this message translates to:
  /// **'HARGA POKOK PRODUKSI (HPP)'**
  String get calcHppHeading;

  /// No description provided for @calcPerUnitLabel.
  ///
  /// In id, this message translates to:
  /// **'/ unit produk'**
  String get calcPerUnitLabel;

  /// No description provided for @calcTotalProductionCost.
  ///
  /// In id, this message translates to:
  /// **'Total Biaya Produksi'**
  String get calcTotalProductionCost;

  /// No description provided for @calcTargetYieldTotal.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Target Jadi'**
  String get calcTargetYieldTotal;

  /// No description provided for @calcCostCompositionHeading.
  ///
  /// In id, this message translates to:
  /// **'Komposisi Beban Biaya Produksi'**
  String get calcCostCompositionHeading;

  /// No description provided for @calcMarginSimulatorTitle.
  ///
  /// In id, this message translates to:
  /// **'Simulator Margin & Harga Jual'**
  String get calcMarginSimulatorTitle;

  /// No description provided for @calcMarginSimulatorSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih target keuntungan dari modal HPP'**
  String get calcMarginSimulatorSubtitle;

  /// No description provided for @calcTargetMarginHeading.
  ///
  /// In id, this message translates to:
  /// **'TARGET MARGIN KEUNTUNGAN'**
  String get calcTargetMarginHeading;

  /// No description provided for @calcIdealBadge.
  ///
  /// In id, this message translates to:
  /// **'Ideal'**
  String get calcIdealBadge;

  /// No description provided for @calcRecommendedPriceLabel.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi Harga Jual'**
  String get calcRecommendedPriceLabel;

  /// No description provided for @calcProfitPerUnitLabel.
  ///
  /// In id, this message translates to:
  /// **'Untung / Unit'**
  String get calcProfitPerUnitLabel;

  /// No description provided for @calcRoundedTo500Note.
  ///
  /// In id, this message translates to:
  /// **'Dibulatkan ke kelipatan Rp 500'**
  String get calcRoundedTo500Note;

  /// No description provided for @rekapLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat rekap tanggal ini. Silakan coba lagi.'**
  String get rekapLoadFailed;

  /// No description provided for @quickEntryTitle.
  ///
  /// In id, this message translates to:
  /// **'Catat Penjualan Cepat'**
  String get quickEntryTitle;

  /// No description provided for @quickEntryQuantity.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get quickEntryQuantity;

  /// No description provided for @quickEntryValidQty.
  ///
  /// In id, this message translates to:
  /// **'Masukkan jumlah yang valid'**
  String get quickEntryValidQty;

  /// No description provided for @quickEntrySave.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get quickEntrySave;

  /// No description provided for @quickEntrySaved.
  ///
  /// In id, this message translates to:
  /// **'Penjualan \"{product}\" ({quantity} {unit}) berhasil dicatat!'**
  String quickEntrySaved(String product, int quantity, String unit);

  /// No description provided for @rekapChangeDateTitle.
  ///
  /// In id, this message translates to:
  /// **'Ganti Tanggal?'**
  String get rekapChangeDateTitle;

  /// No description provided for @rekapChangeDateContent.
  ///
  /// In id, this message translates to:
  /// **'Perubahan rekap yang belum disimpan pada tanggal ini akan hilang jika berpindah tanggal.'**
  String get rekapChangeDateContent;

  /// No description provided for @rekapMoveDate.
  ///
  /// In id, this message translates to:
  /// **'Pindah'**
  String get rekapMoveDate;

  /// No description provided for @rekapAddMinProduct.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan minimal satu produk'**
  String get rekapAddMinProduct;

  /// No description provided for @rekapZeroQuantity.
  ///
  /// In id, this message translates to:
  /// **'Jumlah terjual tidak boleh 0. Sesuaikan terlebih dahulu.'**
  String get rekapZeroQuantity;

  /// No description provided for @rekapUnsavedTitle.
  ///
  /// In id, this message translates to:
  /// **'Perubahan belum disimpan'**
  String get rekapUnsavedTitle;

  /// No description provided for @rekapUnsavedContent.
  ///
  /// In id, this message translates to:
  /// **'Apakah kamu yakin ingin keluar? Perubahan yang belum disimpan akan hilang.'**
  String get rekapUnsavedContent;

  /// No description provided for @rekapExit.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get rekapExit;

  /// No description provided for @rekapTitle.
  ///
  /// In id, this message translates to:
  /// **'Rekap Penjualan'**
  String get rekapTitle;

  /// No description provided for @rekapToday.
  ///
  /// In id, this message translates to:
  /// **'Hari Ini'**
  String get rekapToday;

  /// No description provided for @rekapPickDate.
  ///
  /// In id, this message translates to:
  /// **'Pilih Tanggal'**
  String get rekapPickDate;

  /// No description provided for @rekapSoldItems.
  ///
  /// In id, this message translates to:
  /// **'Item Terjual'**
  String get rekapSoldItems;

  /// No description provided for @rekapEmptyTodayTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Rekap Hari Ini'**
  String get rekapEmptyTodayTitle;

  /// No description provided for @rekapEmptyTodaySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih produk dari katalog Anda dan masukkan jumlah yang terjual hari ini untuk menghitung omzet dan laba bersih otomatis.'**
  String get rekapEmptyTodaySubtitle;

  /// No description provided for @rekapEmptyDateSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada rekap yang tersimpan pada tanggal ini. Pilih produk dari katalog Anda untuk membuat rekap dan menghitung omzet serta laba bersih otomatis.'**
  String get rekapEmptyDateSubtitle;

  /// No description provided for @rekapAddSoldProduct.
  ///
  /// In id, this message translates to:
  /// **'Tambah Produk Terjual'**
  String get rekapAddSoldProduct;

  /// No description provided for @rekapPreviousDay.
  ///
  /// In id, this message translates to:
  /// **'Hari Sebelumnya'**
  String get rekapPreviousDay;

  /// No description provided for @rekapNextDay.
  ///
  /// In id, this message translates to:
  /// **'Hari Berikutnya'**
  String get rekapNextDay;

  /// No description provided for @rekapOmzetLabel.
  ///
  /// In id, this message translates to:
  /// **'Omzet: '**
  String get rekapOmzetLabel;

  /// No description provided for @rekapLabaLabel.
  ///
  /// In id, this message translates to:
  /// **'Laba: '**
  String get rekapLabaLabel;

  /// No description provided for @rekapSaving.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan...'**
  String get rekapSaving;

  /// No description provided for @rekapSaveRecap.
  ///
  /// In id, this message translates to:
  /// **'Simpan Rekap'**
  String get rekapSaveRecap;

  /// No description provided for @rekapRemoveItem.
  ///
  /// In id, this message translates to:
  /// **'Hapus Item'**
  String get rekapRemoveItem;

  /// No description provided for @rekapQuantitySold.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Terjual'**
  String get rekapQuantitySold;

  /// No description provided for @rekapUnitPrice.
  ///
  /// In id, this message translates to:
  /// **'Harga Jual Satuan'**
  String get rekapUnitPrice;

  /// No description provided for @rekapSubtotalLabel.
  ///
  /// In id, this message translates to:
  /// **'Subtotal: '**
  String get rekapSubtotalLabel;

  /// No description provided for @rekapSavedStatus.
  ///
  /// In id, this message translates to:
  /// **'Rekap Sudah Tersimpan'**
  String get rekapSavedStatus;

  /// No description provided for @rekapTotalRevenue.
  ///
  /// In id, this message translates to:
  /// **'Total Omzet'**
  String get rekapTotalRevenue;

  /// No description provided for @rekapTotalCapital.
  ///
  /// In id, this message translates to:
  /// **'Total Modal'**
  String get rekapTotalCapital;

  /// No description provided for @rekapNetProfit.
  ///
  /// In id, this message translates to:
  /// **'Laba Bersih'**
  String get rekapNetProfit;

  /// No description provided for @rekapProductDetails.
  ///
  /// In id, this message translates to:
  /// **'Rincian Produk Terjual'**
  String get rekapProductDetails;

  /// No description provided for @rekapEditAdd.
  ///
  /// In id, this message translates to:
  /// **'Ubah / Tambah Rekap Ini'**
  String get rekapEditAdd;

  /// No description provided for @rekapOpenHistory.
  ///
  /// In id, this message translates to:
  /// **'Buka Riwayat Penjualan'**
  String get rekapOpenHistory;

  /// No description provided for @rekapSelectProduct.
  ///
  /// In id, this message translates to:
  /// **'Pilih Produk Terjual'**
  String get rekapSelectProduct;

  /// No description provided for @rekapLoadingProducts.
  ///
  /// In id, this message translates to:
  /// **'Memuat produk...'**
  String get rekapLoadingProducts;

  /// No description provided for @rekapSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari nama produk...'**
  String get rekapSearchHint;

  /// No description provided for @rekapAlreadyAdded.
  ///
  /// In id, this message translates to:
  /// **'Sudah Ada'**
  String get rekapAlreadyAdded;

  /// No description provided for @rekapEmptyCatalogTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Produk di Katalog'**
  String get rekapEmptyCatalogTitle;

  /// No description provided for @rekapEmptyCatalogSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan produk terlebih dahulu agar bisa memilihnya dalam rekap harian.'**
  String get rekapEmptyCatalogSubtitle;

  /// No description provided for @rekapCreateProduct.
  ///
  /// In id, this message translates to:
  /// **'Buat Produk Sekarang'**
  String get rekapCreateProduct;

  /// No description provided for @rekapProductNotFound.
  ///
  /// In id, this message translates to:
  /// **'Produk Tidak Ditemukan'**
  String get rekapProductNotFound;

  /// No description provided for @rekapEstimateBadge.
  ///
  /// In id, this message translates to:
  /// **'ESTIMASI REKAP'**
  String get rekapEstimateBadge;

  /// No description provided for @rekapTotalEstRevenue.
  ///
  /// In id, this message translates to:
  /// **'Total Estimasi Omzet'**
  String get rekapTotalEstRevenue;

  /// No description provided for @dashLoadOmzetFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data omzet'**
  String get dashLoadOmzetFailed;

  /// No description provided for @dashAllData.
  ///
  /// In id, this message translates to:
  /// **'Semua Data'**
  String get dashAllData;

  /// No description provided for @dashLoadTodayRecapFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat rekap hari ini'**
  String get dashLoadTodayRecapFailed;

  /// No description provided for @dashTodayRecap.
  ///
  /// In id, this message translates to:
  /// **'Rekap Hari Ini'**
  String get dashTodayRecap;

  /// No description provided for @dashNotRecapped.
  ///
  /// In id, this message translates to:
  /// **'Belum Rekap'**
  String get dashNotRecapped;

  /// No description provided for @dashRecordTodayPrompt.
  ///
  /// In id, this message translates to:
  /// **'Yuk, catat penjualan hari ini.'**
  String get dashRecordTodayPrompt;

  /// No description provided for @dashFillNow.
  ///
  /// In id, this message translates to:
  /// **'Isi Sekarang'**
  String get dashFillNow;

  /// No description provided for @dashAlreadyRecapped.
  ///
  /// In id, this message translates to:
  /// **'Sudah Rekap'**
  String get dashAlreadyRecapped;

  /// No description provided for @dashOmzet.
  ///
  /// In id, this message translates to:
  /// **'Omzet'**
  String get dashOmzet;

  /// No description provided for @dashProfit.
  ///
  /// In id, this message translates to:
  /// **'Laba'**
  String get dashProfit;

  /// No description provided for @dashSold.
  ///
  /// In id, this message translates to:
  /// **'Terjual'**
  String get dashSold;

  /// No description provided for @dashRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get dashRetry;

  /// No description provided for @dashLoadProfitTrendFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat tren laba'**
  String get dashLoadProfitTrendFailed;

  /// No description provided for @dashProfitTrendTitle.
  ///
  /// In id, this message translates to:
  /// **'Tren Laba 7 Hari Terakhir'**
  String get dashProfitTrendTitle;

  /// No description provided for @dashQuickMenuTitle.
  ///
  /// In id, this message translates to:
  /// **'Menu Cepat Catat Untung'**
  String get dashQuickMenuTitle;

  /// No description provided for @dashMasterProducts.
  ///
  /// In id, this message translates to:
  /// **'Master Produk'**
  String get dashMasterProducts;

  /// No description provided for @dashMasterProductsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kelola daftar barang dagangan & HPP'**
  String get dashMasterProductsSubtitle;

  /// No description provided for @dashSalesRecap.
  ///
  /// In id, this message translates to:
  /// **'Rekap Penjualan'**
  String get dashSalesRecap;

  /// No description provided for @dashSalesRecapSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Catat penjualan harian toko'**
  String get dashSalesRecapSubtitle;

  /// No description provided for @dashHppCalculator.
  ///
  /// In id, this message translates to:
  /// **'Kalkulator HPP'**
  String get dashHppCalculator;

  /// No description provided for @dashHppCalculatorSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hitung harga pokok & margin untung'**
  String get dashHppCalculatorSubtitle;

  /// No description provided for @dashExportReport.
  ///
  /// In id, this message translates to:
  /// **'Ekspor Laporan'**
  String get dashExportReport;

  /// No description provided for @dashExportReportSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Unduh laporan PDF & CSV'**
  String get dashExportReportSubtitle;

  /// No description provided for @dashSettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get dashSettings;

  /// No description provided for @dashSettingsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Setelan toko & cadangan data'**
  String get dashSettingsSubtitle;

  /// No description provided for @dashRekap.
  ///
  /// In id, this message translates to:
  /// **'Rekap'**
  String get dashRekap;

  /// No description provided for @dashRiwayat.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get dashRiwayat;

  /// No description provided for @dashProduk.
  ///
  /// In id, this message translates to:
  /// **'Produk'**
  String get dashProduk;

  /// No description provided for @dashHpp.
  ///
  /// In id, this message translates to:
  /// **'HPP'**
  String get dashHpp;

  /// No description provided for @dashHeaderTagline.
  ///
  /// In id, this message translates to:
  /// **'Pantau omzet & keuntungan usaha hari ini.'**
  String get dashHeaderTagline;

  /// No description provided for @dashTotalOmzet.
  ///
  /// In id, this message translates to:
  /// **'Total Omzet'**
  String get dashTotalOmzet;

  /// No description provided for @dashNetProfit.
  ///
  /// In id, this message translates to:
  /// **'Laba Bersih'**
  String get dashNetProfit;

  /// No description provided for @dashTotalSold.
  ///
  /// In id, this message translates to:
  /// **'Total Terjual'**
  String get dashTotalSold;

  /// No description provided for @dashNewRecap.
  ///
  /// In id, this message translates to:
  /// **'Rekap Baru'**
  String get dashNewRecap;

  /// No description provided for @expTitle.
  ///
  /// In id, this message translates to:
  /// **'Export Laporan'**
  String get expTitle;

  /// No description provided for @expSelectPeriod.
  ///
  /// In id, this message translates to:
  /// **'Pilih Periode'**
  String get expSelectPeriod;

  /// No description provided for @expExporting.
  ///
  /// In id, this message translates to:
  /// **'Mengekspor data...'**
  String get expExporting;

  /// No description provided for @expExportPdfButton.
  ///
  /// In id, this message translates to:
  /// **'Ekspor PDF'**
  String get expExportPdfButton;

  /// No description provided for @expExportCsvButton.
  ///
  /// In id, this message translates to:
  /// **'Ekspor CSV'**
  String get expExportCsvButton;

  /// No description provided for @expCsvExportSuccess.
  ///
  /// In id, this message translates to:
  /// **'CSV berhasil diekspor'**
  String get expCsvExportSuccess;

  /// No description provided for @expPdfExportSuccess.
  ///
  /// In id, this message translates to:
  /// **'PDF berhasil diekspor'**
  String get expPdfExportSuccess;

  /// No description provided for @expShareText.
  ///
  /// In id, this message translates to:
  /// **'Laporan Catat Untung'**
  String get expShareText;

  /// No description provided for @guideAppBarTitle.
  ///
  /// In id, this message translates to:
  /// **'Panduan Singkat'**
  String get guideAppBarTitle;

  /// No description provided for @guideAppBarSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tips praktis & alur pembukuan UMKM'**
  String get guideAppBarSubtitle;

  /// No description provided for @guideHeroBadge.
  ///
  /// In id, this message translates to:
  /// **'PANDUAN LENGKAP UMKM'**
  String get guideHeroBadge;

  /// No description provided for @guideHeroHeadline.
  ///
  /// In id, this message translates to:
  /// **'Kuasai Pembukuan Toko\nDalam 4 Langkah Mudah'**
  String get guideHeroHeadline;

  /// No description provided for @guideHeroDescription.
  ///
  /// In id, this message translates to:
  /// **'Catat Untung dirancang agar Anda bisa merekap penjualan hanya dalam 1 menit setiap hari tanpa perlu ribet pakai buku kertas.'**
  String get guideHeroDescription;

  /// No description provided for @guideWorkflowTitle.
  ///
  /// In id, this message translates to:
  /// **'ALUR KERJA HARIAN'**
  String get guideWorkflowTitle;

  /// No description provided for @guideStep1Title.
  ///
  /// In id, this message translates to:
  /// **'Daftarkan Katalog & Modal HPP'**
  String get guideStep1Title;

  /// No description provided for @guideStep1Description.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan produk yang Anda jual beserta harga jual dan modal HPP per unitnya. Jika belum tahu HPP, gunakan fitur Kalkulator HPP.'**
  String get guideStep1Description;

  /// No description provided for @guideStep1Action.
  ///
  /// In id, this message translates to:
  /// **'Buka Katalog Produk'**
  String get guideStep1Action;

  /// No description provided for @guideStep2Title.
  ///
  /// In id, this message translates to:
  /// **'Catat Rekap Penjualan Harian'**
  String get guideStep2Title;

  /// No description provided for @guideStep2Description.
  ///
  /// In id, this message translates to:
  /// **'Setiap sore atau saat toko tutup, buka menu Rekap Penjualan. Masukkan jumlah unit produk yang laku terjual hari ini.'**
  String get guideStep2Description;

  /// No description provided for @guideStep2Action.
  ///
  /// In id, this message translates to:
  /// **'Buka Rekap Penjualan'**
  String get guideStep2Action;

  /// No description provided for @guideStep3Title.
  ///
  /// In id, this message translates to:
  /// **'Pantau Omzet & Laba Bersih'**
  String get guideStep3Title;

  /// No description provided for @guideStep3Description.
  ///
  /// In id, this message translates to:
  /// **'Lihat langsung di halaman Beranda berapa total uang masuk (omzet), total modal yang terpakai, dan keuntungan bersih yang Anda bawa pulang.'**
  String get guideStep3Description;

  /// No description provided for @guideStep3Action.
  ///
  /// In id, this message translates to:
  /// **'Lihat Beranda'**
  String get guideStep3Action;

  /// No description provided for @guideStep4Title.
  ///
  /// In id, this message translates to:
  /// **'Analisis Tren & Unduh Laporan'**
  String get guideStep4Title;

  /// No description provided for @guideStep4Description.
  ///
  /// In id, this message translates to:
  /// **'Pelajari produk apa yang paling laris (Best Seller) dan tren omzet mingguan. Anda juga bisa mengekspor laporan bulanan ke format PDF / CSV.'**
  String get guideStep4Description;

  /// No description provided for @guideStep4Action.
  ///
  /// In id, this message translates to:
  /// **'Ekspor Laporan PDF'**
  String get guideStep4Action;

  /// No description provided for @guideTipsTitle.
  ///
  /// In id, this message translates to:
  /// **'TIPS KEUANGAN UMKM'**
  String get guideTipsTitle;

  /// No description provided for @guideTip1Title.
  ///
  /// In id, this message translates to:
  /// **'Pisahkan Dompet Pribadi & Kas Usaha'**
  String get guideTip1Title;

  /// No description provided for @guideTip1Description.
  ///
  /// In id, this message translates to:
  /// **'Hindari memakai uang kas jualan untuk jajan pribadi sebelum menghitung laba bersih bulanan agar modal usaha Anda tidak tergerus.'**
  String get guideTip1Description;

  /// No description provided for @guideTip2Title.
  ///
  /// In id, this message translates to:
  /// **'Perhitungkan Kemasan & Gas LPG'**
  String get guideTip2Title;

  /// No description provided for @guideTip2Description.
  ///
  /// In id, this message translates to:
  /// **'Banyak pedagang lupa menghitung biaya kantong plastik, cup, dan gas LPG dalam HPP sehingga margin keuntungan menjadi lebih kecil dari perkiraan.'**
  String get guideTip2Description;

  /// No description provided for @guideTip3Title.
  ///
  /// In id, this message translates to:
  /// **'Cadangkan Data Secara Berkala'**
  String get guideTip3Title;

  /// No description provided for @guideTip3Description.
  ///
  /// In id, this message translates to:
  /// **'Karena aplikasi ini 100% offline, lakukan backup data di menu Pengaturan > Backup setiap akhir minggu untuk menjaga riwayat transaksi Anda aman.'**
  String get guideTip3Description;

  /// No description provided for @guideFaqTitle.
  ///
  /// In id, this message translates to:
  /// **'PERTANYAAN UMUM (FAQ)'**
  String get guideFaqTitle;

  /// No description provided for @guideFaq1Question.
  ///
  /// In id, this message translates to:
  /// **'Apakah aplikasi membutuhkan internet?'**
  String get guideFaq1Question;

  /// No description provided for @guideFaq1Answer.
  ///
  /// In id, this message translates to:
  /// **'Tidak sama sekali. Catat Untung beroperasi 100% secara offline. Data tersimpan di penyimpanan internal smartphone Anda sehingga Anda dapat mencatat di mana saja tanpa kuota internet.'**
  String get guideFaq1Answer;

  /// No description provided for @guideFaq2Question.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana memindahkan data saat ganti smartphone?'**
  String get guideFaq2Question;

  /// No description provided for @guideFaq2Answer.
  ///
  /// In id, this message translates to:
  /// **'Buka menu Pengaturan > Backup & Pemulihan. Pilih \"Buat Cadangan Baru\", simpan file hasil cadangan ke Google Drive atau kirim ke WhatsApp Anda. Pada smartphone baru, pasang aplikasi dan pilih \"Pulihkan Data\".'**
  String get guideFaq2Answer;

  /// No description provided for @guideFaq3Question.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana jika ada produk yang saya berikan gratis / tester?'**
  String get guideFaq3Question;

  /// No description provided for @guideFaq3Answer.
  ///
  /// In id, this message translates to:
  /// **'Anda tetap dapat mencatat jumlah modalnya di rekap harian atau menambahkan produk dengan harga jual Rp 0 agar modal tetap terhitung dalam pembukuan laba bersih Anda.'**
  String get guideFaq3Answer;

  /// No description provided for @guideFaq4Question.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana cara mencetak laporan untuk pemilik usaha?'**
  String get guideFaq4Question;

  /// No description provided for @guideFaq4Answer.
  ///
  /// In id, this message translates to:
  /// **'Gunakan menu Pengaturan > Ekspor Laporan. Anda dapat memilih rentang tanggal tertentu dan mengunduh laporan berformat PDF rapi siap cetak atau format CSV untuk diolah di Microsoft Excel.'**
  String get guideFaq4Answer;

  /// No description provided for @guideStartButton.
  ///
  /// In id, this message translates to:
  /// **'Mulai Catat Rekap Penjualan'**
  String get guideStartButton;

  /// No description provided for @histRecapHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Rekap'**
  String get histRecapHistory;

  /// No description provided for @histThisMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan Ini'**
  String get histThisMonth;

  /// No description provided for @histLoadHistoryFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat riwayat'**
  String get histLoadHistoryFailed;

  /// No description provided for @histEditRecap.
  ///
  /// In id, this message translates to:
  /// **'Edit Rekap'**
  String get histEditRecap;

  /// No description provided for @histDeleteRecap.
  ///
  /// In id, this message translates to:
  /// **'Hapus Rekap'**
  String get histDeleteRecap;

  /// No description provided for @histRecapDataNotFound.
  ///
  /// In id, this message translates to:
  /// **'Data rekap tidak ditemukan'**
  String get histRecapDataNotFound;

  /// No description provided for @histSalesResultStatus.
  ///
  /// In id, this message translates to:
  /// **'STATUS HASIL PENJUALAN'**
  String get histSalesResultStatus;

  /// No description provided for @histTotalOmzet.
  ///
  /// In id, this message translates to:
  /// **'Total Omzet'**
  String get histTotalOmzet;

  /// No description provided for @histTotalModal.
  ///
  /// In id, this message translates to:
  /// **'Total Modal'**
  String get histTotalModal;

  /// No description provided for @histTotalSold.
  ///
  /// In id, this message translates to:
  /// **'Total Terjual'**
  String get histTotalSold;

  /// No description provided for @histSoldMenuList.
  ///
  /// In id, this message translates to:
  /// **'Daftar Menu Terjual'**
  String get histSoldMenuList;

  /// No description provided for @histNoProductsInRecap.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada produk dalam rekap ini'**
  String get histNoProductsInRecap;

  /// No description provided for @histDeleteRecapTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Rekap Penjualan?'**
  String get histDeleteRecapTitle;

  /// No description provided for @histDeleteRecapMessage.
  ///
  /// In id, this message translates to:
  /// **'Semua data rekapan pada tanggal ini akan dihapus permanen dari riwayat.'**
  String get histDeleteRecapMessage;

  /// No description provided for @histRecapDeleted.
  ///
  /// In id, this message translates to:
  /// **'Rekap berhasil dihapus'**
  String get histRecapDeleted;

  /// No description provided for @histCalendarView.
  ///
  /// In id, this message translates to:
  /// **'Kalender'**
  String get histCalendarView;

  /// No description provided for @histRecapListView.
  ///
  /// In id, this message translates to:
  /// **'Daftar Rekap'**
  String get histRecapListView;

  /// No description provided for @histNoRecap.
  ///
  /// In id, this message translates to:
  /// **'Tidak Ada Rekap'**
  String get histNoRecap;

  /// No description provided for @histEmptyNoSales.
  ///
  /// In id, this message translates to:
  /// **'Belum ada catatan penjualan yang tersimpan.'**
  String get histEmptyNoSales;

  /// No description provided for @histEmptyFiltered.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada catatan rekap pada filter yang dipilih.'**
  String get histEmptyFiltered;

  /// No description provided for @histCreateRecapNow.
  ///
  /// In id, this message translates to:
  /// **'Buat Rekap Sekarang'**
  String get histCreateRecapNow;

  /// No description provided for @histTotalMonthlyProfit.
  ///
  /// In id, this message translates to:
  /// **'TOTAL LABA BULAN INI'**
  String get histTotalMonthlyProfit;

  /// No description provided for @histDaysRecorded.
  ///
  /// In id, this message translates to:
  /// **'Hari Tercatat'**
  String get histDaysRecorded;

  /// No description provided for @histLegendProfitRecap.
  ///
  /// In id, this message translates to:
  /// **'Ada Rekap Untung'**
  String get histLegendProfitRecap;

  /// No description provided for @histLegendLossRecap.
  ///
  /// In id, this message translates to:
  /// **'Ada Rekap Rugi'**
  String get histLegendLossRecap;

  /// No description provided for @histLegendTodaySelected.
  ///
  /// In id, this message translates to:
  /// **'Hari Ini / Terpilih'**
  String get histLegendTodaySelected;

  /// No description provided for @histDateNotYetReached.
  ///
  /// In id, this message translates to:
  /// **'Tanggal belum berjalan'**
  String get histDateNotYetReached;

  /// No description provided for @histNoRecapOnDate.
  ///
  /// In id, this message translates to:
  /// **'Belum ada rekapan penjualan di tanggal ini'**
  String get histNoRecapOnDate;

  /// No description provided for @histCreateRecapToday.
  ///
  /// In id, this message translates to:
  /// **'Buat Rekap Tanggal Ini'**
  String get histCreateRecapToday;

  /// No description provided for @histOmzet.
  ///
  /// In id, this message translates to:
  /// **'Omzet'**
  String get histOmzet;

  /// No description provided for @histModal.
  ///
  /// In id, this message translates to:
  /// **'Modal'**
  String get histModal;

  /// No description provided for @histMargin.
  ///
  /// In id, this message translates to:
  /// **'Margin'**
  String get histMargin;

  /// No description provided for @prodMasterTitle.
  ///
  /// In id, this message translates to:
  /// **'Master Produk'**
  String get prodMasterTitle;

  /// No description provided for @prodMasterSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Katalog harga jual, modal HPP & margin'**
  String get prodMasterSubtitle;

  /// No description provided for @prodAddProduct.
  ///
  /// In id, this message translates to:
  /// **'Tambah Produk'**
  String get prodAddProduct;

  /// No description provided for @prodLoadFailedTitle.
  ///
  /// In id, this message translates to:
  /// **'Gagal Memuat Produk'**
  String get prodLoadFailedTitle;

  /// No description provided for @prodEmptyCatalogTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Produk Terdaftar'**
  String get prodEmptyCatalogTitle;

  /// No description provided for @prodEmptyCatalogDesc.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan produk daganganmu beserta modal HPP dan harga jual agar sistem dapat menghitung keuntungan otomatis setiap hari.'**
  String get prodEmptyCatalogDesc;

  /// No description provided for @prodAddFirstProduct.
  ///
  /// In id, this message translates to:
  /// **'Tambah Produk Pertama'**
  String get prodAddFirstProduct;

  /// No description provided for @prodSearchEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Produk Tidak Ditemukan'**
  String get prodSearchEmptyTitle;

  /// No description provided for @prodSearchEmptyDesc.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada produk yang cocok dengan kata kunci atau filter status yang dipilih.'**
  String get prodSearchEmptyDesc;

  /// No description provided for @prodResetSearchFilter.
  ///
  /// In id, this message translates to:
  /// **'Reset Pencarian & Filter'**
  String get prodResetSearchFilter;

  /// No description provided for @prodUpdateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Produk berhasil diperbarui'**
  String get prodUpdateSuccess;

  /// No description provided for @prodCreateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Produk baru berhasil ditambahkan'**
  String get prodCreateSuccess;

  /// No description provided for @prodSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan: {error}'**
  String prodSaveFailed(Object error);

  /// No description provided for @prodDeleteDialogTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Produk?'**
  String get prodDeleteDialogTitle;

  /// No description provided for @prodDeleteProduct.
  ///
  /// In id, this message translates to:
  /// **'Hapus Produk'**
  String get prodDeleteProduct;

  /// No description provided for @prodDeleteSuccess.
  ///
  /// In id, this message translates to:
  /// **'Produk berhasil dihapus'**
  String get prodDeleteSuccess;

  /// No description provided for @prodDeleteFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus produk: {error}'**
  String prodDeleteFailed(Object error);

  /// No description provided for @prodEditProductTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Data Produk'**
  String get prodEditProductTitle;

  /// No description provided for @prodAddProductTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Produk Baru'**
  String get prodAddProductTitle;

  /// No description provided for @prodIdentityTitle.
  ///
  /// In id, this message translates to:
  /// **'Identitas Barang'**
  String get prodIdentityTitle;

  /// No description provided for @prodIdentitySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Nama dan kemasan penjualan produk'**
  String get prodIdentitySubtitle;

  /// No description provided for @prodNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Produk / Menu *'**
  String get prodNameLabel;

  /// No description provided for @prodNameHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Es Kopi Susu Aren, Nasi Goreng Spesial'**
  String get prodNameHint;

  /// No description provided for @prodNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama produk wajib diisi'**
  String get prodNameRequired;

  /// No description provided for @prodUnitLabel.
  ///
  /// In id, this message translates to:
  /// **'Satuan Penjualan *'**
  String get prodUnitLabel;

  /// No description provided for @prodSelectOtherUnit.
  ///
  /// In id, this message translates to:
  /// **'Pilih Satuan Lainnya'**
  String get prodSelectOtherUnit;

  /// No description provided for @prodUnitFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Satuan Lainnya'**
  String get prodUnitFieldLabel;

  /// No description provided for @prodUnitFieldHint.
  ///
  /// In id, this message translates to:
  /// **'Misal: pcs, lusin, Renteng, Bungkus 250g'**
  String get prodUnitFieldHint;

  /// No description provided for @prodUnitRequired.
  ///
  /// In id, this message translates to:
  /// **'Satuan penjualan wajib diisi'**
  String get prodUnitRequired;

  /// No description provided for @prodUnitTooLong.
  ///
  /// In id, this message translates to:
  /// **'Satuan maksimal 16 karakter'**
  String get prodUnitTooLong;

  /// No description provided for @prodPriceSectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Harga Modal & Penjualan'**
  String get prodPriceSectionTitle;

  /// No description provided for @prodPriceSectionSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Dasar penghitungan laba bersih harian'**
  String get prodPriceSectionSubtitle;

  /// No description provided for @prodHppLabel.
  ///
  /// In id, this message translates to:
  /// **'Harga Modal / HPP per Unit *'**
  String get prodHppLabel;

  /// No description provided for @prodHppHelper.
  ///
  /// In id, this message translates to:
  /// **'Biaya pokok bahan & pembuatan satu unit produk'**
  String get prodHppHelper;

  /// No description provided for @prodHppRequired.
  ///
  /// In id, this message translates to:
  /// **'Harga modal (HPP) wajib diisi'**
  String get prodHppRequired;

  /// No description provided for @prodHppInvalidNumber.
  ///
  /// In id, this message translates to:
  /// **'Harga modal harus berupa angka valid'**
  String get prodHppInvalidNumber;

  /// No description provided for @prodSellingPriceLabel.
  ///
  /// In id, this message translates to:
  /// **'Harga Jual Standar per Unit *'**
  String get prodSellingPriceLabel;

  /// No description provided for @prodSellingPriceHelper.
  ///
  /// In id, this message translates to:
  /// **'Harga normal yang ditawarkan kepada pelanggan'**
  String get prodSellingPriceHelper;

  /// No description provided for @prodSellingPriceRequired.
  ///
  /// In id, this message translates to:
  /// **'Harga jual wajib diisi'**
  String get prodSellingPriceRequired;

  /// No description provided for @prodSellingPriceInvalidNumber.
  ///
  /// In id, this message translates to:
  /// **'Harga jual harus berupa angka valid'**
  String get prodSellingPriceInvalidNumber;

  /// No description provided for @prodActiveStatusTitle.
  ///
  /// In id, this message translates to:
  /// **'Status Produk Aktif'**
  String get prodActiveStatusTitle;

  /// No description provided for @prodActiveStatusOn.
  ///
  /// In id, this message translates to:
  /// **'Produk tampil di daftar saat rekap penjualan harian'**
  String get prodActiveStatusOn;

  /// No description provided for @prodActiveStatusOff.
  ///
  /// In id, this message translates to:
  /// **'Produk disembunyikan dari pilihan rekap harian'**
  String get prodActiveStatusOff;

  /// No description provided for @prodSaveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get prodSaveChanges;

  /// No description provided for @prodAddToCatalog.
  ///
  /// In id, this message translates to:
  /// **'Tambah ke Katalog Produk'**
  String get prodAddToCatalog;

  /// No description provided for @prodStatusActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get prodStatusActive;

  /// No description provided for @prodStatusInactive.
  ///
  /// In id, this message translates to:
  /// **'Nonaktif'**
  String get prodStatusInactive;

  /// No description provided for @prodModalHpp.
  ///
  /// In id, this message translates to:
  /// **'Modal HPP'**
  String get prodModalHpp;

  /// No description provided for @prodSellingPrice.
  ///
  /// In id, this message translates to:
  /// **'Harga Jual'**
  String get prodSellingPrice;

  /// No description provided for @prodCardProfitMargin.
  ///
  /// In id, this message translates to:
  /// **'Laba ({percent}%)'**
  String prodCardProfitMargin(Object percent);

  /// No description provided for @prodEditData.
  ///
  /// In id, this message translates to:
  /// **'Ubah data'**
  String get prodEditData;

  /// No description provided for @prodHeroCatalogBadge.
  ///
  /// In id, this message translates to:
  /// **'KATALOG MASTER PRODUK'**
  String get prodHeroCatalogBadge;

  /// No description provided for @prodHeroTotalLabel.
  ///
  /// In id, this message translates to:
  /// **'TOTAL DAFTAR PRODUK'**
  String get prodHeroTotalLabel;

  /// No description provided for @prodHeroRegisteredLabel.
  ///
  /// In id, this message translates to:
  /// **'Barang Dagangan Terdaftar'**
  String get prodHeroRegisteredLabel;

  /// No description provided for @prodHeroActiveLabel.
  ///
  /// In id, this message translates to:
  /// **'Produk Aktif'**
  String get prodHeroActiveLabel;

  /// No description provided for @prodHeroReadyLabel.
  ///
  /// In id, this message translates to:
  /// **'Siap Jual'**
  String get prodHeroReadyLabel;

  /// No description provided for @prodItemCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Item'**
  String prodItemCount(Object count);

  /// No description provided for @prodSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari produk atau satuan...'**
  String get prodSearchHint;

  /// No description provided for @prodFilterAllCount.
  ///
  /// In id, this message translates to:
  /// **'Semua ({count})'**
  String prodFilterAllCount(Object count);

  /// No description provided for @prodFilterActiveCount.
  ///
  /// In id, this message translates to:
  /// **'Aktif ({count})'**
  String prodFilterActiveCount(Object count);

  /// No description provided for @prodFilterInactiveCount.
  ///
  /// In id, this message translates to:
  /// **'Nonaktif ({count})'**
  String prodFilterInactiveCount(Object count);

  /// No description provided for @prodPreviewNoDataAdvice.
  ///
  /// In id, this message translates to:
  /// **'Simulasi keuntungan akan muncul otomatis saat Anda mengisi modal & harga jual.'**
  String get prodPreviewNoDataAdvice;

  /// No description provided for @prodPreviewLossAdvice.
  ///
  /// In id, this message translates to:
  /// **'Harga jual di bawah modal! Penjualan produk ini akan mengalami rugi.'**
  String get prodPreviewLossAdvice;

  /// No description provided for @prodPreviewHealthyAdvice.
  ///
  /// In id, this message translates to:
  /// **'Margin sangat sehat (â‰¥ 30%). Bagus untuk ketahanan usaha dan promo.'**
  String get prodPreviewHealthyAdvice;

  /// No description provided for @prodPreviewThinAdvice.
  ///
  /// In id, this message translates to:
  /// **'Margin cukup tipis (< 30%). Perhatikan biaya operasional lainnya.'**
  String get prodPreviewThinAdvice;

  /// No description provided for @prodPreviewTitle.
  ///
  /// In id, this message translates to:
  /// **'Simulasi Laba per Unit'**
  String get prodPreviewTitle;

  /// No description provided for @prodPercentMargin.
  ///
  /// In id, this message translates to:
  /// **'{percent}% Margin'**
  String prodPercentMargin(Object percent);

  /// No description provided for @prodPreviewNameEmpty.
  ///
  /// In id, this message translates to:
  /// **'Nama Produk Belum Diisi'**
  String get prodPreviewNameEmpty;

  /// No description provided for @prodNetProfitPerUnit.
  ///
  /// In id, this message translates to:
  /// **'Laba Bersih / {unit}'**
  String prodNetProfitPerUnit(Object unit);

  /// No description provided for @prodPreviewHpp.
  ///
  /// In id, this message translates to:
  /// **'Modal (HPP)'**
  String get prodPreviewHpp;

  /// No description provided for @prodUnit.
  ///
  /// In id, this message translates to:
  /// **'Satuan'**
  String get prodUnit;

  /// No description provided for @repsReportsTitle.
  ///
  /// In id, this message translates to:
  /// **'Laporan & Tren'**
  String get repsReportsTitle;

  /// No description provided for @repsExportTooltip.
  ///
  /// In id, this message translates to:
  /// **'Ekspor Laporan'**
  String get repsExportTooltip;

  /// No description provided for @repsLoadingAnalysis.
  ///
  /// In id, this message translates to:
  /// **'Memuat analisis laporan & tren...'**
  String get repsLoadingAnalysis;

  /// No description provided for @repsLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal Memuat Laporan'**
  String get repsLoadFailed;

  /// No description provided for @repsEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Data Rekap'**
  String get repsEmptyTitle;

  /// No description provided for @repsEmptySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada catatan penjualan pada rentang waktu ini. Silakan pilih rentang waktu lain atau rekap penjualan Anda hari ini.'**
  String get repsEmptySubtitle;

  /// No description provided for @repsRecapNow.
  ///
  /// In id, this message translates to:
  /// **'Rekap Penjualan Sekarang'**
  String get repsRecapNow;

  /// No description provided for @repsPickRange.
  ///
  /// In id, this message translates to:
  /// **'Pilih Rentang'**
  String get repsPickRange;

  /// No description provided for @repsLast7Days.
  ///
  /// In id, this message translates to:
  /// **'7 Hari Terakhir'**
  String get repsLast7Days;

  /// No description provided for @repsThisWeek.
  ///
  /// In id, this message translates to:
  /// **'Minggu Ini'**
  String get repsThisWeek;

  /// No description provided for @repsThisMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan Ini'**
  String get repsThisMonth;

  /// No description provided for @repsLastMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan Lalu'**
  String get repsLastMonth;

  /// No description provided for @repsTrendTitle.
  ///
  /// In id, this message translates to:
  /// **'Tren Laba Harian'**
  String get repsTrendTitle;

  /// No description provided for @repsTrendSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pergerakan laba bersih harian'**
  String get repsTrendSubtitle;

  /// No description provided for @repsProfit.
  ///
  /// In id, this message translates to:
  /// **'Untung'**
  String get repsProfit;

  /// No description provided for @repsLoss.
  ///
  /// In id, this message translates to:
  /// **'Rugi'**
  String get repsLoss;

  /// No description provided for @repsTopProductsTitle.
  ///
  /// In id, this message translates to:
  /// **'Produk Paling Laris'**
  String get repsTopProductsTitle;

  /// No description provided for @repsTopProductsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Peringkat penjualan & kontribusi laba'**
  String get repsTopProductsSubtitle;

  /// No description provided for @repsAvgMargin.
  ///
  /// In id, this message translates to:
  /// **'Margin Rata-rata'**
  String get repsAvgMargin;

  /// No description provided for @repsHealthyMargin.
  ///
  /// In id, this message translates to:
  /// **'Margin Sehat'**
  String get repsHealthyMargin;

  /// No description provided for @repsNeedsImprovement.
  ///
  /// In id, this message translates to:
  /// **'Perlu Ditingkatkan'**
  String get repsNeedsImprovement;

  /// No description provided for @repsTotalSold.
  ///
  /// In id, this message translates to:
  /// **'Total Terjual'**
  String get repsTotalSold;

  /// No description provided for @repsAvgProfit.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata Laba'**
  String get repsAvgProfit;

  /// No description provided for @repsPerDaySales.
  ///
  /// In id, this message translates to:
  /// **'Per hari jualan'**
  String get repsPerDaySales;

  /// No description provided for @repsActiveDays.
  ///
  /// In id, this message translates to:
  /// **'Hari Aktif Rekap'**
  String get repsActiveDays;

  /// No description provided for @repsRecordedInSystem.
  ///
  /// In id, this message translates to:
  /// **'Tercatat di sistem'**
  String get repsRecordedInSystem;

  /// No description provided for @repsTotalNetProfit.
  ///
  /// In id, this message translates to:
  /// **'TOTAL LABA BERSIH'**
  String get repsTotalNetProfit;

  /// No description provided for @repsTotalOmzet.
  ///
  /// In id, this message translates to:
  /// **'Total Omzet'**
  String get repsTotalOmzet;

  /// No description provided for @repsTotalModal.
  ///
  /// In id, this message translates to:
  /// **'Total Modal'**
  String get repsTotalModal;

  /// No description provided for @repsAvgPerDay.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata / Hari'**
  String get repsAvgPerDay;

  /// No description provided for @routeNotFoundTitle.
  ///
  /// In id, this message translates to:
  /// **'Ups, halaman tidak ditemukan'**
  String get routeNotFoundTitle;

  /// No description provided for @routeBackToHome.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Beranda'**
  String get routeBackToHome;

  /// No description provided for @routeInvalidProductId.
  ///
  /// In id, this message translates to:
  /// **'ID produk tidak valid.'**
  String get routeInvalidProductId;

  /// No description provided for @setManageDataSection.
  ///
  /// In id, this message translates to:
  /// **'Kelola Data & Fitur'**
  String get setManageDataSection;

  /// No description provided for @setProductCatalog.
  ///
  /// In id, this message translates to:
  /// **'Katalog Produk'**
  String get setProductCatalog;

  /// No description provided for @setProductCatalogSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kelola daftar harga jual, HPP, & stok produk'**
  String get setProductCatalogSubtitle;

  /// No description provided for @setExportReport.
  ///
  /// In id, this message translates to:
  /// **'Ekspor Laporan'**
  String get setExportReport;

  /// No description provided for @setExportReportSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Unduh laporan rekap penjualan format PDF & CSV'**
  String get setExportReportSubtitle;

  /// No description provided for @setHppCalculator.
  ///
  /// In id, this message translates to:
  /// **'Kalkulator HPP Otomatis'**
  String get setHppCalculator;

  /// No description provided for @setHppCalculatorSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hitung modal bahan baku dan margin profit'**
  String get setHppCalculatorSubtitle;

  /// No description provided for @setBackupRestore.
  ///
  /// In id, this message translates to:
  /// **'Backup & Pemulihan'**
  String get setBackupRestore;

  /// No description provided for @setBackupRestoreSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Cadangkan data aplikasi secara aman'**
  String get setBackupRestoreSubtitle;

  /// No description provided for @setCurrencyFormat.
  ///
  /// In id, this message translates to:
  /// **'Format Mata Uang'**
  String get setCurrencyFormat;

  /// No description provided for @setCurrencyFormatSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Rupiah Indonesia (IDR)'**
  String get setCurrencyFormatSubtitle;

  /// No description provided for @setPrivacySecurity.
  ///
  /// In id, this message translates to:
  /// **'Privasi & Keamanan'**
  String get setPrivacySecurity;

  /// No description provided for @setPrivacySecuritySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Data tersimpan 100% lokal di perangkat Anda'**
  String get setPrivacySecuritySubtitle;

  /// No description provided for @setOfflineSafe.
  ///
  /// In id, this message translates to:
  /// **'Offline Safe'**
  String get setOfflineSafe;

  /// No description provided for @setHelpSection.
  ///
  /// In id, this message translates to:
  /// **'Bantuan & Informasi'**
  String get setHelpSection;

  /// No description provided for @setAbout.
  ///
  /// In id, this message translates to:
  /// **'Tentang Aplikasi'**
  String get setAbout;

  /// No description provided for @setAboutSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Informasi dan filosofi Catat Untung'**
  String get setAboutSubtitle;

  /// No description provided for @setGuide.
  ///
  /// In id, this message translates to:
  /// **'Panduan Singkat'**
  String get setGuide;

  /// No description provided for @setGuideSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tips praktis mencatat rekap penjualan harian'**
  String get setGuideSubtitle;

  /// No description provided for @setErrorReport.
  ///
  /// In id, this message translates to:
  /// **'Laporan Error'**
  String get setErrorReport;

  /// No description provided for @setErrorReportSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Salin atau bagikan log error yang tersimpan di perangkat'**
  String get setErrorReportSubtitle;

  /// No description provided for @setErrorReportHint.
  ///
  /// In id, this message translates to:
  /// **'Log ini tersimpan hanya di perangkat Anda dan tidak dikirim ke mana pun.'**
  String get setErrorReportHint;

  /// No description provided for @setErrorReportCopy.
  ///
  /// In id, this message translates to:
  /// **'Salin'**
  String get setErrorReportCopy;

  /// No description provided for @setErrorReportShare.
  ///
  /// In id, this message translates to:
  /// **'Bagikan'**
  String get setErrorReportShare;

  /// No description provided for @setErrorReportClear.
  ///
  /// In id, this message translates to:
  /// **'Hapus Log'**
  String get setErrorReportClear;

  /// No description provided for @setErrorReportCopied.
  ///
  /// In id, this message translates to:
  /// **'Log error disalin ke clipboard'**
  String get setErrorReportCopied;

  /// No description provided for @setDangerZoneSection.
  ///
  /// In id, this message translates to:
  /// **'Zona Bahaya'**
  String get setDangerZoneSection;

  /// No description provided for @setDeleteAllData.
  ///
  /// In id, this message translates to:
  /// **'Hapus Semua Data'**
  String get setDeleteAllData;

  /// No description provided for @setDeleteAllSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus seluruh data produk, rekap, dan riwayat permanen'**
  String get setDeleteAllSubtitle;

  /// No description provided for @setFootnoteTagline.
  ///
  /// In id, this message translates to:
  /// **'Aplikasi Kasir & Rekap Harian Tanpa Internet'**
  String get setFootnoteTagline;

  /// No description provided for @setDeleteAllTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Semua Data?'**
  String get setDeleteAllTitle;

  /// No description provided for @setDeleteAllContent.
  ///
  /// In id, this message translates to:
  /// **'Seluruh data produk katalog, rekapan penjualan harian, dan riwayat akan dihapus secara permanen dari perangkat ini. Tindakan ini tidak dapat dibatalkan.'**
  String get setDeleteAllContent;

  /// No description provided for @setAllDataCleared.
  ///
  /// In id, this message translates to:
  /// **'Semua data berhasil dibersihkan'**
  String get setAllDataCleared;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
