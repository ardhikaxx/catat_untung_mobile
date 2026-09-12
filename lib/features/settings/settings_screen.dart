import 'package:flutter/material.dart';
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
        children: [
          const _SectionHeader(title: 'Informasi Aplikasi'),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.info_outline, color: AppColors.primaryGreen),
            ),
            title: const Text(AppConstants.appName),
            subtitle: const Text(AppConstants.appTagline),
          ),
          const Divider(),
          const _SectionHeader(title: 'Data'),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.info.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: AppColors.info),
            ),
            title: const Text('Master Produk'),
            subtitle: const Text('Kelola data produk'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/products'),
          ),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.upload_file, color: AppColors.primaryGreen),
            ),
            title: const Text('Export Laporan'),
            subtitle: const Text('Ekspor data ke PDF atau CSV'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/export'),
          ),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.backup, color: AppColors.warning),
            ),
            title: const Text('Backup & Restore'),
            subtitle: const Text('Cadangkan atau pulihkan data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/backup'),
          ),
          const Divider(),
          const _SectionHeader(title: 'Bahasa'),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Bahasa Indonesia'),
            subtitle: Text('Bahasa utama aplikasi'),
          ),
          const Divider(),
          const _SectionHeader(title: 'Zona Bahaya'),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_forever, color: AppColors.error),
            ),
            title: const Text(
              'Hapus Semua Data',
              style: TextStyle(color: AppColors.error),
            ),
            subtitle: const Text('Menghapus semua data produk dan rekap'),
            onTap: () => _showDeleteAllDialog(context, ref),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Semua Data?',
          style: TextStyle(color: AppColors.error),
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
