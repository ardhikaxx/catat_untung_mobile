import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/database_provider.dart';
import '../../providers/product_provider.dart';
import '../../database/app_database.dart';
import '../../shared/widgets/empty_state.dart';
import '../../data/repositories/daily_record_repository.dart';

class RekapItem {
  int? productId;
  String productName;
  String unit;
  int hpp;
  int sellingPrice;
  int quantity;
  int get subtotalRevenue => quantity * sellingPrice;
  int get subtotalCost => quantity * hpp;
  int get subtotalProfit => subtotalRevenue - subtotalCost;

  RekapItem({
    this.productId,
    required this.productName,
    required this.unit,
    required this.hpp,
    required this.sellingPrice,
    required this.quantity,
  });
}

final rekapItemsProvider = StateProvider<List<RekapItem>>((ref) => []);

class DailyRekapScreen extends ConsumerStatefulWidget {
  const DailyRekapScreen({super.key});

  @override
  ConsumerState<DailyRekapScreen> createState() => _DailyRekapScreenState();
}

class _DailyRekapScreenState extends ConsumerState<DailyRekapScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingRecord();
  }

  Future<void> _loadExistingRecord() async {
    final repo = ref.read(dailyRecordRepositoryProvider);
    final record = await repo.getRecordByDate(_selectedDate);
    if (record != null && mounted) {
      final items = await repo.getItemsByRecordId(record.id);
      setState(() {
        ref.read(rekapItemsProvider.notifier).state = items.map((item) {
          return RekapItem(
            productId: item.productId,
            productName: item.productNameSnapshot,
            unit: item.unitSnapshot,
            hpp: item.hppSnapshot,
            sellingPrice: item.sellingPriceSnapshot,
            quantity: item.quantity,
          );
        }).toList();
      });
    } else if (mounted) {
      ref.read(rekapItemsProvider.notifier).state = [];
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      await _loadExistingRecord();
    }
  }

  void _showProductSelector() async {
    final productsAsync = ref.read(activeProductsProvider);
    final products = productsAsync.valueOrNull ?? [];

    if (products.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Belum ada produk. Tambahkan produk terlebih dahulu.'),
          ),
        );
      }
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Pilih Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'HPP: ${CurrencyFormatter.formatRupiah(product.hpp)} • Jual: ${CurrencyFormatter.formatRupiah(product.sellingPrice)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _addProductItem(product);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addProductItem(Product product) {
    final items = ref.read(rekapItemsProvider);
    
    final existingIndex = items.indexWhere((i) => i.productId == product.id);
    if (existingIndex >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} sudah ditambahkan'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
      return;
    }

    final newItem = RekapItem(
      productId: product.id,
      productName: product.name,
      unit: product.unit,
      hpp: product.hpp,
      sellingPrice: product.sellingPrice,
      quantity: 1,
    );
    ref.read(rekapItemsProvider.notifier).state = [...items, newItem];
  }

  void _removeItem(int index) {
    final items = ref.read(rekapItemsProvider);
    ref.read(rekapItemsProvider.notifier).state = [
      ...items.sublist(0, index),
      ...items.sublist(index + 1),
    ];
  }

  void _updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _removeItem(index);
      return;
    }
    final items = List<RekapItem>.from(ref.read(rekapItemsProvider));
    items[index].quantity = quantity;
    ref.read(rekapItemsProvider.notifier).state = items;
  }

  void _updateSellingPrice(int index, int price) {
    final items = List<RekapItem>.from(ref.read(rekapItemsProvider));
    items[index].sellingPrice = price;
    ref.read(rekapItemsProvider.notifier).state = items;
  }

  Future<void> _saveRekap() async {
    final items = ref.read(rekapItemsProvider);
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan minimal satu produk')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final recordItems = items.map((item) {
        return DailyRecordItemData(
          productId: item.productId,
          productName: item.productName,
          unit: item.unit,
          hpp: item.hpp,
          sellingPrice: item.sellingPrice,
          quantity: item.quantity,
          subtotalRevenue: item.subtotalRevenue,
          subtotalCost: item.subtotalCost,
          subtotalProfit: item.subtotalProfit,
        );
      }).toList();

      await repo.saveDailyRecord(
        date: _selectedDate,
        items: recordItems,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rekap tersimpan')),
        );
        ref.read(rekapItemsProvider.notifier).state = [];
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _totalRevenue => ref.read(rekapItemsProvider).fold<int>(
      0, (sum, item) => sum + item.subtotalRevenue);

  int get _totalCost => ref.read(rekapItemsProvider).fold<int>(
      0, (sum, item) => sum + item.subtotalCost);

  int get _totalProfit => _totalRevenue - _totalCost;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(rekapItemsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (items.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Perubahan belum disimpan'),
              content: const Text('Apakah kamu yakin ingin keluar? Perubahan yang belum disimpan akan hilang.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(rekapItemsProvider.notifier).state = [];
                    context.pop();
                  },
                  child: const Text('Keluar', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          );
        } else {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rekap Penjualan'),
          actions: [
            TextButton(
              onPressed: _selectDate,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('d MMM yyyy', 'id_ID').format(_selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: items.isEmpty
                  ? EmptyState(
                      icon: Icons.edit_note,
                      title: 'Belum Ada Item',
                      subtitle: 'Tambahkan produk yang terjual hari ini',
                      actionLabel: 'Tambah Produk',
                      onAction: _showProductSelector,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 200),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _RekapItemCard(
                          item: item,
                          index: index,
                          onQuantityChanged: (qty) => _updateQuantity(index, qty),
                          onPriceChanged: (price) => _updateSellingPrice(index, price),
                          onRemove: () => _removeItem(index),
                        );
                      },
                    ),
            ),
            _BottomPanel(
              totalRevenue: _totalRevenue,
              totalCost: _totalCost,
              totalProfit: _totalProfit,
              itemCount: items.length,
              isLoading: _isLoading,
              onSave: _saveRekap,
              onAddProduct: _showProductSelector,
            ),
          ],
        ),
      ),
    );
  }
}

class _RekapItemCard extends StatelessWidget {
  final RekapItem item;
  final int index;
  final Function(int) onQuantityChanged;
  final Function(int) onPriceChanged;
  final VoidCallback onRemove;

  const _RekapItemCard({
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onPriceChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'HPP: ${CurrencyFormatter.formatRupiah(item.hpp)}/${item.unit}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: AppColors.textHint,
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Qty',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      TextFormField(
                        initialValue: item.quantity.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onChanged: (val) {
                          final qty = int.tryParse(val) ?? 0;
                          onQuantityChanged(qty);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harga Jual',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      TextFormField(
                        initialValue: item.sellingPrice.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          prefixText: 'Rp ',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onChanged: (val) {
                          final price = int.tryParse(val) ?? 0;
                          onPriceChanged(price);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: item.subtotalProfit >= 0
                    ? AppColors.profit.withAlpha(25)
                    : AppColors.loss.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Omzet: ${CurrencyFormatter.formatRupiah(item.subtotalRevenue)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Laba: ${CurrencyFormatter.formatRupiah(item.subtotalProfit)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: item.subtotalProfit >= 0
                          ? AppColors.profit
                          : AppColors.loss,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  final int totalRevenue;
  final int totalCost;
  final int totalProfit;
  final int itemCount;
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onAddProduct;

  const _BottomPanel({
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.itemCount,
    required this.isLoading,
    required this.onSave,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Omzet', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text(
                        CurrencyFormatter.formatRupiah(totalRevenue),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Modal', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text(
                        CurrencyFormatter.formatRupiah(totalCost),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Laba/Rugi', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text(
                        CurrencyFormatter.formatRupiah(totalProfit),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: totalProfit > 0
                              ? AppColors.profit
                              : totalProfit < 0
                                  ? AppColors.loss
                                  : AppColors.breakEven,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAddProduct,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (itemCount == 0 || isLoading) ? null : onSave,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan Rekap'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}