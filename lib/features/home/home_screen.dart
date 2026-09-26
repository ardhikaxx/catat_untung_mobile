import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/daily_record_repository.dart';
import '../../database/app_database.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/database_provider.dart';
import '../../providers/product_provider.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';
import '../daily_rekap/daily_rekap_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../history/history_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _screens = [
    DashboardScreen(),
    DailyRekapScreen(),
    HistoryScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabProvider);
    final products = ref.watch(activeProductsProvider).value ?? [];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      extendBody: true,
      bottomNavigationBar: const AppFloatingNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickEntry(context, ref, products),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        child: const Icon(LucideIcons.plusCircle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showQuickEntry(
      BuildContext context, WidgetRef ref, List<Product> products) async {
    final l10n = AppLocalizations.of(context);

    // Find the first active product (most recent/frequently used)
    final firstProduct = products.isNotEmpty ? products.first : null;

    if (firstProduct == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.rekapEmptyCatalogTitle ??
                'Belum ada produk di katalog. Tambah produk terlebih dahulu.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show quick entry dialog
    final quantityController = TextEditingController(text: '1');

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(l10n?.quickEntryTitle ?? 'Catat Penjualan Cepat'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product info - show the first active product
              Row(
                children: [
                  const Icon(LucideIcons.shoppingBag, size: 24, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      firstProduct.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Quantity input
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n?.quickEntryQuantity ?? 'Jumlah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return l10n?.quickEntryValidQty ??
                        'Masukkan jumlah yang valid';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),

              // Unit hint
              Text(
                '${l10n?.prodUnit ?? 'Satuan'}: ${firstProduct.unit}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(quantityController.text);
              if (qty != null && qty > 0) {
                // Save quick entry using the first product
                _saveQuickEntry(ref, firstProduct, qty, context);
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n?.quickEntrySave ?? 'Simpan'),
          ),
        ],
      ),
    );

    quantityController.dispose();
  }

  Future<void> _saveQuickEntry(
      WidgetRef ref, Product product, int quantity, BuildContext context) async {
    final repository = ref.read(dailyRecordRepositoryProvider);
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    final subtotalRevenue = product.sellingPrice * quantity;
    final subtotalCost = product.hpp * quantity;
    final totalProfit = subtotalRevenue - subtotalCost;

    final newItem = DailyRecordItemData(
      productId: product.id,
      productName: product.name,
      unit: product.unit,
      hpp: product.hpp,
      sellingPrice: product.sellingPrice,
      quantity: quantity,
      subtotalRevenue: subtotalRevenue,
      subtotalCost: subtotalCost,
      subtotalProfit: totalProfit,
    );

    // saveDailyRecord mengganti seluruh item pada tanggal tersebut, jadi
    // quick entry harus menambahkan ke item rekap hari ini agar tidak hilang.
    final existingRecord = await repository.getRecordByDate(dateOnly);
    final existingItems = existingRecord == null
        ? <DailyRecordItemData>[]
        : (await repository.getItemsByRecordId(existingRecord.id))
            .map(
              (item) => DailyRecordItemData(
                productId: item.productId,
                productName: item.productNameSnapshot,
                unit: item.unitSnapshot,
                hpp: item.hppSnapshot,
                sellingPrice: item.sellingPriceSnapshot,
                quantity: item.quantity,
                subtotalRevenue: item.subtotalRevenue,
                subtotalCost: item.subtotalCost,
                subtotalProfit: item.subtotalProfit,
              ),
            )
            .toList();

    // Save using the repository
    await repository.saveDailyRecord(
      date: dateOnly,
      items: [...existingItems, newItem],
    );

    // Refresh and show success
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n?.quickEntrySaved(product.name, quantity, product.unit) ??
              'Penjualan ${product.name} ($quantity ${product.unit}) berhasil dicatat!',
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    // Navigate to daily rekap for today
    context.go('/daily-rekap');
  }
}