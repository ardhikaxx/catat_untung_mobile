import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/database_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/daily_record_provider.dart';
import 'widgets/settings_header_card.dart';
import 'widgets/settings_section_card.dart';
import 'widgets/settings_menu_tile.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = Navigator.canPop(context);
    const bottomSpacing = AppFloatingNavBar.bottomSpacing;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: canPop ? const AppFloatingNavBar(activeIndex: 4) : null,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        leading: canPop
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 0.5,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.maybePop(context),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),

                  ),
                ),
              )
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
        title: const Text(
          'Pengaturan',
          style: TextStyle(
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
            title: 'Kelola Data & Fitur',
            children: [
              SettingsMenuTile(
                icon: LucideIcons.package,
                iconColor: AppColors.primaryGreen,
                iconBg: AppColors.greenTint,
                title: 'Katalog Produk',
                subtitle: 'Kelola daftar harga jual, HPP, & stok produk',
                onTap: () => context.push('/products'),
              ),
              SettingsMenuTile(
                icon: LucideIcons.fileUp,
                iconColor: const Color(0xFF2563EB),
                iconBg: const Color(0xFFDBEAFE),
                title: 'Ekspor Laporan',
                subtitle: 'Unduh laporan rekap penjualan format PDF & CSV',
                onTap: () => context.push('/export'),
              ),
              SettingsMenuTile(
                icon: LucideIcons.calculator,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                title: 'Kalkulator HPP Otomatis',
                subtitle: 'Hitung modal bahan baku dan margin profit',
                onTap: () => context.push('/calculator'),
              ),
              SettingsMenuTile(
                icon: LucideIcons.fileDown,
                iconColor: const Color(0xFF16A34A),
                iconBg: const Color(0xFFDCFCE7),
                title: 'Backup & Pemulihan',
                subtitle: 'Cadangkan data aplikasi secara aman',
                showDivider: false,
                onTap: () => context.push('/backup'),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 3. System Preferences
          SettingsSectionCard(
            title: 'Preferensi & Bahasa',
            children: [
              SettingsMenuTile(
                icon: LucideIcons.coins,
                iconColor: AppColors.primaryGreen,
                iconBg: AppColors.greenTint,
                title: 'Format Mata Uang',
                subtitle: 'Rupiah Indonesia (IDR)',
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
                title: 'Bahasa Tampilan',
                subtitle: 'Bahasa Indonesia (Default)',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ID',
                    style: TextStyle(
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
                title: 'Privasi & Keamanan',
                subtitle: 'Data tersimpan 100% lokal di perangkat Anda',
                showDivider: false,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Offline Safe',
                    style: TextStyle(
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
            title: 'Bantuan & Informasi',
            children: [
              SettingsMenuTile(
                icon: LucideIcons.info,
                iconColor: const Color(0xFF475569),
                iconBg: const Color(0xFFF1F5F9),
                title: 'Tentang Aplikasi',
                subtitle: 'Informasi dan filosofi Catat Untung',
                onTap: () => context.push('/about'),
              ),
              SettingsMenuTile(
                icon: LucideIcons.bookOpen,
                iconColor: const Color(0xFF475569),
                iconBg: const Color(0xFFF1F5F9),
                title: 'Panduan Singkat',
                subtitle: 'Tips praktis mencatat rekap penjualan harian',
                showDivider: false,
                onTap: () => context.push('/guide'),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 5. Danger Zone
          SettingsSectionCard(
            title: 'Zona Bahaya',
            titleColor: const Color(0xFFDC2626),
            children: [
              SettingsMenuTile(
                icon: LucideIcons.trash2,
                iconColor: const Color(0xFFDC2626),
                iconBg: const Color(0xFFFEE2E2),
                title: 'Hapus Semua Data',
                subtitle: 'Hapus seluruh data produk, rekap, dan riwayat permanen',
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
                  '${AppConstants.appName} v${AppConstants.appVersion}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Aplikasi Kasir & Rekap Harian Tanpa Internet',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),
          ),

          // Bottom clearance for floating navbar
          SizedBox(height: bottomSpacing),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(LucideIcons.alertTriangle, color: Color(0xFFDC2626), size: 24),
            SizedBox(width: 10),
            Text(
              'Hapus Semua Data?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ),
        content: const Text(
          'Seluruh data produk katalog, rekapan penjualan harian, dan riwayat akan dihapus secara permanen dari perangkat ini. Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
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
                    content: const Text('Semua data berhasil dibersihkan'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            child: const Text('Hapus Semua Data'),
          ),
        ],
      ),
    );
  }
}
