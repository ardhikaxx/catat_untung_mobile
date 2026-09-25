import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../data/services/backup_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/database_provider.dart';
import '../../shared/widgets/app_back_button.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';
import '../../shared/widgets/loading_state.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _isProcessing = false;

  Future<void> _backupData() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isProcessing = true);
    try {
      final db = ref.read(databaseProvider);
      final data = await BackupService(db).exportData();
      final json = jsonEncode(data);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = p.join(directory.path, 'catat_untung_backup_$timestamp.json');
      final file = File(filePath);
      await file.writeAsString(json);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: l10n?.bkpShareText ?? 'Backup Catat Untung',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.bkpBackupSuccess ?? 'Backup berhasil dibuat')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat backup: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _restoreData() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.bkpRestoreDialogTitle ?? 'Restore Data?'),
        content: Text(
          l10n?.bkpRestoreDialogContent ??
              'Semua data saat ini akan diganti dengan data dari backup. Pastikan kamu sudah melakukan backup data terbaru.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n?.commonCancel ?? 'Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n?.bkpRestoreButton ?? 'Restore', style: const TextStyle(color: AppColors.warning)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) return;

    setState(() => _isProcessing = true);
    try {
      final path = result.files.first.path;
      if (path == null) {
        throw BackupFormatException(l10n?.bkpFileInaccessible ?? 'File backup tidak dapat diakses');
      }
      final file = File(path);
      final json = await file.readAsString();
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
          throw BackupFormatException(l10n?.bkpFileInvalid ?? 'File backup tidak valid');
      }

      final db = ref.read(databaseProvider);
      await BackupService(db).restoreData(decoded);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.bkpRestoreSuccess ?? 'Restore berhasil')),
        );
        Navigator.pop(context);
      }
    } on BackupFormatException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore dibatalkan: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal restore: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: const AppFloatingNavBar(activeIndex: 4),
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(l10n?.bkpTitle ?? 'Backup & Restore'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isProcessing)
            LoadingState(message: l10n?.bkpProcessing ?? 'Memproses...')
          else ...[
            Card(
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.fileDown, color: AppColors.primaryGreen),
                ),
                title: Text(l10n?.bkpBackupTitle ?? 'Backup Data'),
                subtitle: Text(l10n?.bkpBackupSubtitle ?? 'Simpan semua data ke file backup'),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: _backupData,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.fileUp, color: AppColors.warning),
                ),
                title: Text(l10n?.bkpRestoreTitle ?? 'Restore Data'),
                subtitle: Text(l10n?.bkpRestoreSubtitle ?? 'Pulihkan data dari file backup'),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: _restoreData,
              ),
            ),
            const SizedBox(height: AppFloatingNavBar.bottomSpacing),
          ],
        ],
      ),
    );
  }
}
