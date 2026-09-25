import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_info.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/app_locale_provider.dart';
import '../../providers/daily_record_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/product_provider.dart';
import '../../shared/widgets/app_back_button.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';
import 'widgets/settings_header_card.dart';
import 'widgets/settings_menu_tile.dart';
import 'widgets/settings_section_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = Navigator.canPop(context);
    const bottomSpacing = AppFloatingNavBar.bottomSpacing;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: canPop ? const AppFloatingNavBar(activeIndex: 4) : null,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        leading: canPop
            ? const AppCircleBackButton()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.greenTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.settings,
                    size: 20,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
        title: Text(
          l10n?.settingsTitle ?? 'Pengaturan',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. App Brand & Storage Status Hero Card
          const SettingsHeaderCard(),

          const SizedBox(height: 6),

          // 2. Data Management Section
          SettingsSectionCard(
            title: l10n?.setManageDataSection ?? 'Kelola Data & Fitur',
            children: [
              SettingsMenuTile(
                icon: LucideIcons.package,
                iconColor: AppColors.primaryGreen,
                iconBg: AppColors.greenTint,
                title: l10n?.setProductCatalog ?? 'Katalog Produk',
                subtitle: l10n?.setProductCatalogSubtitle ??
                    'Kelola daftar harga jual, HPP, & stok produk',
                onTap: () => context.push('/products'),
              ),
              SettingsMenuTile(
                icon: LucideIcons.fileUp,
                iconColor: const Color(0xFF2563EB),
                iconBg: const Color(0xFFDBEAFE),
                title: l10n?.setExportReport ?? 'Ekspor Laporan',
                subtitle: l10n?.setExportReportSubtitle ??
                    'Unduh laporan rekap penjualan format PDF & CSV',
                onTap: () => context.push('/export'),
              ),
              SettingsMenuTile(
                icon: LucideIcons.calculator,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                title: l10n?.setHppCalculator ?? 'Kalkulator HPP Otomatis',
                subtitle: l10n?.setHppCalculatorSubtitle ??
                    'Hitung modal bahan baku dan margin profit',
                onTap: () => context.push('/calculator'),
              ),
              SettingsMenuTile(
                icon: LucideIcons.fileDown,
                iconColor: const Color(0xFF16A34A),
                iconBg: const Color(0xFFDCFCE7),
                title: l10n?.setBackupRestore ?? 'Backup & Pemulihan',
                subtitle: l10n?.setBackupRestoreSubtitle ??
                    'Cadangkan data aplikasi secara aman',
                showDivider: false,
                onTap: () => context.push('/backup'),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 3. System Preferences
          SettingsSectionCard(
            title: l10n?.settingsPreferencesSection ?? 'Preferensi & Bahasa',
            children: [
              SettingsMenuTile(
                icon: LucideIcons.coins,
                iconColor: AppColors.primaryGreen,
                iconBg: AppColors.greenTint,
                title: l10n?.setCurrencyFormat ?? 'Format Mata Uang',
                subtitle: l10n?.setCurrencyFormatSubtitle ??
                    'Rupiah Indonesia (IDR)',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Rp (IDR)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ),
              SettingsMenuTile(
                icon: LucideIcons.globe,
                iconColor: const Color(0xFF2563EB),
                iconBg: const Color(0xFFDBEAFE),
                title: l10n?.languageTileTitle ?? 'Bahasa Tampilan',
                subtitle: switch (ref.watch(appLocaleProvider)) {
                  null => l10n?.languageTileSubtitleSystem ?? 'Ikuti sistem',
                  final locale when locale.languageCode == 'en' =>
                    l10n?.languageTileSubtitleEn ?? 'English',
                  _ => l10n?.languageTileSubtitleId ?? 'Bahasa Indonesia',
                },
                onTap: () => _showLanguageDialog(context, ref, l10n),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    switch (ref.watch(appLocaleProvider)) {
                      null => l10n?.languageBadgeSystem ?? 'Sistem',
                      final locale when locale.languageCode == 'en' =>
                        l10n?.languageBadgeEn ?? 'EN',
                      _ => l10n?.languageBadgeId ?? 'ID',
                    },
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ),
              SettingsMenuTile(
                icon: LucideIcons.shieldCheck,
                iconColor: const Color(0xFF16A34A),
                iconBg: const Color(0xFFDCFCE7),
                title: l10n?.setPrivacySecurity ?? 'Privasi & Keamanan',
                subtitle: l10n?.setPrivacySecuritySubtitle ??
                    'Data tersimpan 100% lokal di perangkat Anda',
                showDivider: false,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n?.setOfflineSafe ?? 'Offline Safe',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 4. Help & About Section
          SettingsSectionCard(
            title: l10n?.setHelpSection ?? 'Bantuan & Informasi',
            children: [
              SettingsMenuTile(
                icon: LucideIcons.info,
                iconColor: const Color(0xFF475569),
                iconBg: const Color(0xFFF1F5F9),
                title: l10n?.setAbout ?? 'Tentang Aplikasi',
                subtitle: l10n?.setAboutSubtitle ??
                    'Informasi dan filosofi Catat Untung',
                onTap: () => context.push('/about'),
              ),
              SettingsMenuTile(
                icon: LucideIcons.bug,
                iconColor: const Color(0xFF475569),
                iconBg: const Color(0xFFF1F5F9),
                title: l10n?.setErrorReport ?? 'Laporan Error',
                subtitle: l10n?.setErrorReportSubtitle ??
                    'Salin atau bagikan log error yang tersimpan di perangkat',
                onTap: () => _showErrorReport(context),
              ),
              SettingsMenuTile(
                icon: LucideIcons.bookOpen,
                iconColor: const Color(0xFF475569),
                iconBg: const Color(0xFFF1F5F9),
                title: l10n?.setGuide ?? 'Panduan Singkat',
                subtitle: l10n?.setGuideSubtitle ??
                    'Tips praktis mencatat rekap penjualan harian',
                showDivider: false,
                onTap: () => context.push('/guide'),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 5. Danger Zone
          SettingsSectionCard(
            title: l10n?.setDangerZoneSection ?? 'Zona Bahaya',
            titleColor: const Color(0xFFDC2626),
            children: [
              SettingsMenuTile(
                icon: LucideIcons.trash2,
                iconColor: const Color(0xFFDC2626),
                iconBg: const Color(0xFFFEE2E2),
                title: l10n?.setDeleteAllData ?? 'Hapus Semua Data',
                subtitle: l10n?.setDeleteAllSubtitle ??
                    'Hapus seluruh data produk, rekap, dan riwayat permanen',
                titleColor: const Color(0xFFDC2626),
                showDivider: false,
                onTap: () => _showDeleteAllDialog(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Version Footnote
          Center(
            child: Column(
              children: [
                Text(
                  '${AppConstants.appName} v${AppInfo.version}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n?.setFootnoteTagline ??
                      'Aplikasi Kasir & Rekap Harian Tanpa Internet',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  AppConstants.copyright,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          // Bottom clearance for floating navbar
          const SizedBox(height: bottomSpacing),
        ],
      ),
    );
  }

  /// Shows the locally buffered error log and lets the user share it.
  /// Nothing is uploaded automatically: the app has no network permission.
  void _showErrorReport(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final report = AppLogger.buildReport(appVersion: AppInfo.versionWithBuild);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(LucideIcons.bug, color: Color(0xFF475569), size: 22),
            const SizedBox(width: 10),
            Text(
              l10n?.setErrorReport ?? 'Laporan Error',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n?.setErrorReportHint ??
                    'Log ini tersimpan hanya di perangkat Anda dan tidak dikirim ke mana pun.',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: SelectableText(
                    report,
                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (AppLogger.hasEntries)
            TextButton(
              onPressed: () {
                AppLogger.clear();
                Navigator.pop(dialogContext);
              },
              child: Text(l10n?.setErrorReportClear ?? 'Hapus Log'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Clipboard.setData(ClipboardData(text: report));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n?.setErrorReportCopied ?? 'Log error disalin'),
                ),
              );
            },
            child: Text(l10n?.setErrorReportCopy ?? 'Salin'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Share.shareXFiles(
                [
                  XFile.fromData(
                    const Utf8Encoder().convert(report),
                    mimeType: 'text/plain',
                  ),
                ],
                text: l10n?.setErrorReport ?? 'Laporan Error',
              );
            },
            child: Text(l10n?.setErrorReportShare ?? 'Bagikan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(
              LucideIcons.alertTriangle,
              color: Color(0xFFDC2626),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              l10n?.setDeleteAllTitle ?? 'Hapus Semua Data?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ),
        content: Text(
          l10n?.setDeleteAllContent ??
              'Seluruh data produk katalog, rekapan penjualan harian, dan riwayat akan dihapus secara permanen dari perangkat ini. Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.commonCancel ?? 'Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final db = ref.read(databaseProvider);
              await db.delete(db.dailyRecordItems).go();
              await db.delete(db.dailyRecords).go();
              await db.delete(db.products).go();
              ref.invalidate(productCountProvider);
              ref.invalidate(allProductsProvider);
              ref.invalidate(activeProductsProvider);
              ref.invalidate(allRecordsProvider);
              ref.invalidate(todayRecordProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n?.setAllDataCleared ??
                          'Semua data berhasil dibersihkan',
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            child: Text(l10n?.setDeleteAllData ?? 'Hapus Semua Data'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppLocalizations? l10n) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final current = ref.read(appLocaleProvider);
        final groupValue = current?.languageCode ?? 'system';
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n?.languageDialogTitle ?? 'Pilih Bahasa',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption(
                dialogContext: dialogContext,
                ref: ref,
                value: 'system',
                groupValue: groupValue,
                label: l10n?.languageOptionSystem ?? 'Ikuti Sistem',
              ),
              _languageOption(
                dialogContext: dialogContext,
                ref: ref,
                value: 'id',
                groupValue: groupValue,
                label: l10n?.languageOptionId ?? 'Bahasa Indonesia',
              ),
              _languageOption(
                dialogContext: dialogContext,
                ref: ref,
                value: 'en',
                groupValue: groupValue,
                label: l10n?.languageOptionEn ?? 'English',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption({
    required BuildContext dialogContext,
    required WidgetRef ref,
    required String value,
    required String groupValue,
    required String label,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      onChanged: (selected) async {
        Navigator.pop(dialogContext);
        if (selected == null) return;
        await saveAppLocale(ref.read(appLocaleProvider.notifier), selected);
      },
    );
  }
}
