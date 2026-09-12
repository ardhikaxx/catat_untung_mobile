import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/database_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen,
                  AppColors.primaryGreen.withAlpha(180),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Iconsax.money_recive,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppConstants.appTagline,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Data Management Card
          _buildCard(
            title: 'Kelola Data',
            children: [
              _buildMenuItem(
                icon: Iconsax.box,
                iconColor: AppColors.info,
                title: 'Master Produk',
                subtitle: 'Kelola data produk',
                onTap: () => context.push('/products'),
              ),
              const Divider(height: 1, indent: 56),
              _buildMenuItem(
                icon: Iconsax.document_upload,
                iconColor: AppColors.primaryGreen,
                title: 'Export Laporan',
                subtitle: 'Ekspor data ke PDF atau CSV',
                onTap: () => context.push('/export'),
              ),
              const Divider(height: 1, indent: 56),
              _buildMenuItem(
                icon: Iconsax.document_download,
                iconColor: AppColors.warning,
                title: 'Backup & Restore',
                subtitle: 'Cadangkan atau pulihkan data',
                onTap: () => context.push('/backup'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Language Card
          _buildCard(
            title: 'Bahasa',
            children: [
              _buildMenuItem(
                icon: Iconsax.global,
                iconColor: AppColors.primaryGreen,
                title: 'Bahasa Indonesia',
                subtitle: 'Bahasa utama aplikasi',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Danger Zone Card
          _buildCard(
            title: 'Zona Bahaya',
            titleColor: AppColors.error,
            children: [
              _buildMenuItem(
                icon: Iconsax.trash,
                iconColor: AppColors.error,
                title: 'Hapus Semua Data',
                subtitle: 'Menghapus semua data produk dan rekap',
                titleColor: AppColors.error,
                onTap: () => _showDeleteAllDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Version
          Center(
            child: Text(
              'v${AppConstants.appVersion}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    Color? titleColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: titleColor ?? AppColors.textSecondary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Iconsax.arrow_right_3,
                size: 18,
                color: AppColors.textHint,
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Iconsax.warning_2, color: AppColors.error, size: 24),
            SizedBox(width: 10),
            Text(
              'Hapus Semua Data?',
              style: TextStyle(color: AppColors.error),
            ),
          ],
        ),
        content: const Text(
          'Semua data produk, rekap penjualan, dan riwayat akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final db = ref.read(databaseProvider);
              await db.delete(db.dailyRecordItems).go();
              await db.delete(db.dailyRecords).go();
              await db.delete(db.products).go();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua data berhasil dihapus')),
                );
              }
            },
            child: const Text(
              'Hapus Semua',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
