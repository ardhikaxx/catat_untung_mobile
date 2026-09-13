import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = Navigator.canPop(context);
    final bottomSpacing = canPop ? 24.0 : 110.0;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                        Iconsax.arrow_left_2,
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
                    Iconsax.setting_2,
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
                icon: Iconsax.box,
                iconColor: AppColors.primaryGreen,
                iconBg: AppColors.greenTint,
                title: 'Katalog Produk',
                subtitle: 'Kelola daftar harga jual, HPP, & stok produk',
                onTap: () => context.push('/products'),
              ),
              SettingsMenuTile(
                icon: Iconsax.document_upload,
                iconColor: const Color(0xFF2563EB),
                iconBg: const Color(0xFFDBEAFE),
                title: 'Ekspor Laporan',
                subtitle: 'Unduh laporan rekap penjualan format PDF & CSV',
                onTap: () => context.push('/export'),
              ),
              SettingsMenuTile(
                icon: Iconsax.calculator,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                title: 'Kalkulator HPP Otomatis',
                subtitle: 'Hitung modal bahan baku dan margin profit',
                onTap: () => context.push('/calculator'),
              ),
              SettingsMenuTile(
                icon: Iconsax.document_download,
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
                icon: Iconsax.coin,
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
                icon: Iconsax.global,
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
                icon: Iconsax.security_safe,
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
                icon: Iconsax.info_circle,
                iconColor: const Color(0xFF475569),
                iconBg: const Color(0xFFF1F5F9),
                title: 'Tentang Aplikasi',
                subtitle: 'Informasi dan filosofi Catat Untung',
                onTap: () => _showAboutModal(context),
              ),
              SettingsMenuTile(
                icon: Iconsax.book_1,
                iconColor: const Color(0xFF475569),
                iconBg: const Color(0xFFF1F5F9),
                title: 'Panduan Singkat',
                subtitle: 'Tips praktis mencatat rekap penjualan harian',
                showDivider: false,
                onTap: () => _showGuideModal(context),
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
                icon: Iconsax.trash,
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

  void _showAboutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.greenTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.wallet_money,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Catat Untung',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Versi 1.0.0 • 100% Offline First',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Catat Untung dirancang khusus untuk pelaku UMKM, pedagang warung, dan pengusaha kuliner agar dapat mengetahui omzet, modal, dan laba bersih harian secara akurat tanpa memerlukan koneksi internet.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGuideModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cara Mudah Rekap Penjualan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildGuideStep('1', 'Tambah produk dan tentukan HPP (modal) serta harga jual pada menu Katalog Produk.'),
            const SizedBox(height: 10),
            _buildGuideStep('2', 'Buka menu Rekap setiap hari, pilih produk yang terjual dan masukkan jumlah unitnya.'),
            const SizedBox(height: 10),
            _buildGuideStep('3', 'Simpan rekap dan pantau laba bersih secara real-time di Beranda serta Laporan & Tren.'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Mengerti'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.greenTint,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF334155),
              height: 1.4,
            ),
          ),
        ),
      ],
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
            Icon(Iconsax.warning_2, color: Color(0xFFDC2626), size: 24),
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
