import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/database_provider.dart';
import '../../database/app_database.dart';
import '../../shared/widgets/loading_state.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _isProcessing = false;

  Future<void> _backupData() async {
    setState(() => _isProcessing = true);
    try {
      final db = ref.read(databaseProvider);
      final products = await db.select(db.products).get();
      final records = await db.select(db.dailyRecords).get();
      final items = await db.select(db.dailyRecordItems).get();

      final backup = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'appName': 'Catat Untung',
        'products': products.map((p) => {
          'id': p.id,
          'name': p.name,
          'hpp': p.hpp,
          'sellingPrice': p.sellingPrice,
          'unit': p.unit,
          'isActive': p.isActive,
          'createdAt': p.createdAt.toIso8601String(),
          'updatedAt': p.updatedAt.toIso8601String(),
        }).toList(),
        'dailyRecords': records.map((r) => {
          'id': r.id,
          'date': r.date.toIso8601String(),
          'totalRevenue': r.totalRevenue,
          'totalCost': r.totalCost,
          'totalProfit': r.totalProfit,
          'totalQuantity': r.totalQuantity,
          'createdAt': r.createdAt.toIso8601String(),
          'updatedAt': r.updatedAt.toIso8601String(),
        }).toList(),
        'dailyRecordItems': items.map((i) => {
          'id': i.id,
          'dailyRecordId': i.dailyRecordId,
          'productId': i.productId,
          'productNameSnapshot': i.productNameSnapshot,
          'unitSnapshot': i.unitSnapshot,
          'hppSnapshot': i.hppSnapshot,
          'sellingPriceSnapshot': i.sellingPriceSnapshot,
          'quantity': i.quantity,
          'subtotalRevenue': i.subtotalRevenue,
          'subtotalCost': i.subtotalCost,
          'subtotalProfit': i.subtotalProfit,
          'createdAt': i.createdAt.toIso8601String(),
        }).toList(),
      };

      final json = jsonEncode(backup);
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = p.join(directory.path, 'catat_untung_backup_$timestamp.json');
      final file = File(filePath);
      await file.writeAsString(json);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Backup Catat Untung',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup berhasil dibuat')),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Data?'),
        content: const Text(
          'Semua data saat ini akan diganti dengan data dari backup. Pastikan kamu sudah melakukan backup data terbaru.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restore', style: TextStyle(color: AppColors.warning)),
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
      final file = File(result.files.first.path!);
      final json = await file.readAsString();
      final backup = jsonDecode(json) as Map<String, dynamic>;

      if (backup['appName'] != 'Catat Untung') {
        throw Exception('File backup tidak valid');
      }

      final db = ref.read(databaseProvider);

      await db.transaction(() async {
        await db.delete(db.dailyRecordItems).go();
        await db.delete(db.dailyRecords).go();
        await db.delete(db.products).go();

        for (final p in backup['products'] as List) {
          await db.into(db.products).insert(
            ProductsCompanion.insert(
              name: p['name'] as String,
              hpp: Value(p['hpp'] as int),
              sellingPrice: Value(p['sellingPrice'] as int),
              unit: Value(p['unit'] as String),
              isActive: Value(p['isActive'] as bool),
            ),
          );
        }

        for (final r in backup['dailyRecords'] as List) {
          await db.into(db.dailyRecords).insert(
            DailyRecordsCompanion.insert(
              date: DateTime.parse(r['date'] as String),
              totalRevenue: Value(r['totalRevenue'] as int),
              totalCost: Value(r['totalCost'] as int),
              totalProfit: Value(r['totalProfit'] as int),
              totalQuantity: Value(r['totalQuantity'] as int),
            ),
          );
        }

        for (final i in backup['dailyRecordItems'] as List) {
          await db.into(db.dailyRecordItems).insert(
            DailyRecordItemsCompanion.insert(
              dailyRecordId: i['dailyRecordId'] as int,
              productId: Value(i['productId'] as int?),
              productNameSnapshot: i['productNameSnapshot'] as String,
              unitSnapshot: Value(i['unitSnapshot'] as String),
              hppSnapshot: Value(i['hppSnapshot'] as int),
              sellingPriceSnapshot: Value(i['sellingPriceSnapshot'] as int),
              quantity: Value(i['quantity'] as int),
              subtotalRevenue: Value(i['subtotalRevenue'] as int),
              subtotalCost: Value(i['subtotalCost'] as int),
              subtotalProfit: Value(i['subtotalProfit'] as int),
            ),
          );
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore berhasil')),
        );
        Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: const AppFloatingNavBar(activeIndex: 4),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Backup & Restore'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isProcessing)
            const LoadingState(message: 'Memproses...')
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
                title: const Text('Backup Data'),
                subtitle: const Text('Simpan semua data ke file backup'),
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
                title: const Text('Restore Data'),
                subtitle: const Text('Pulihkan data dari file backup'),
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
