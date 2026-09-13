import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/database_provider.dart';
import '../../providers/product_provider.dart';
import '../../database/app_database.dart';
import '../../data/repositories/daily_record_repository.dart';
import 'widgets/rekap_date_selector.dart';
import 'widgets/rekap_live_summary_card.dart';
import 'widgets/rekap_item_tile.dart';
import 'widgets/rekap_product_selector_modal.dart';
import 'widgets/rekap_bottom_action_panel.dart';
import 'widgets/rekap_saved_view.dart';

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
  bool _isEditing = false;
  DailyRecord? _existingRecord;
  List<DailyRecordItem> _existingItems = [];

  @override
  void initState() {
    super.initState();
    _loadExistingRecord();
  }

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  Future<void> _loadExistingRecord() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final record = await repo.getRecordByDate(_selectedDate);
      if (record != null) {
        final items = await repo.getItemsByRecordId(record.id);
        if (mounted) {
          setState(() {
            _existingRecord = record;
            _existingItems = items;
            _isEditing = false;
            _isLoading = false;
          });
          ref.read(rekapItemsProvider.notifier).state = [];
        }
      } else {
        if (mounted) {
          setState(() {
            _existingRecord = null;
            _existingItems = [];
            _isEditing = true;
            _isLoading = false;
          });
          ref.read(rekapItemsProvider.notifier).state = [];
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _enterEditMode() {
    // Populate form with existing saved items for quick editing
    if (_existingItems.isNotEmpty) {
      final rekapItems = _existingItems.map((item) {
        return RekapItem(
          productId: item.productId,
          productName: item.productNameSnapshot,
          unit: item.unitSnapshot,
          hpp: item.hppSnapshot,
          sellingPrice: item.sellingPriceSnapshot,
          quantity: item.quantity,
        );
      }).toList();
      ref.read(rekapItemsProvider.notifier).state = rekapItems;
    }
    setState(() => _isEditing = true);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.gojekGreen,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      await _handleDateChange(picked);
    }
  }

  Future<void> _handleDateChange(DateTime newDate) async {
    final items = ref.read(rekapItemsProvider);
    if (items.isNotEmpty && _isEditing) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Ganti Tanggal?'),
          content: const Text(
            'Perubahan rekap yang belum disimpan pada tanggal ini akan hilang jika berpindah tanggal.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Pindah', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    setState(() => _selectedDate = newDate);
    await _loadExistingRecord();
  }

  void _showProductSelector() {
    final items = ref.read(rekapItemsProvider);
    final selectedIds = items.map((i) => i.productId).toSet();

    RekapProductSelectorModal.show(
      context: context,
      products: ref.read(activeProductsProvider).valueOrNull,
      selectedProductIds: selectedIds,
      onProductSelected: _addProductItem,
    );
  }

  void _addProductItem(Product product) {
    final items = ref.read(rekapItemsProvider);
    final existingIndex = items.indexWhere((i) => i.productId == product.id);
    if (existingIndex >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} sudah ada dalam rekap'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    if (quantity < 0) return;
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
        SnackBar(
          content: const Text('Tambahkan minimal satu produk'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final hasZeroQty = items.any((item) => item.quantity == 0);
    if (hasZeroQty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Jumlah terjual tidak boleh 0. Sesuaikan terlebih dahulu.'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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
          SnackBar(
            content: Row(
              children: [
                const Icon(Iconsax.tick_circle, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Rekap ${DateFormat('d MMM yyyy', 'id_ID').format(_selectedDate)} berhasil disimpan!',
                ),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        ref.read(rekapItemsProvider.notifier).state = [];
        await _loadExistingRecord();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan rekap: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _totalRevenue => ref.watch(rekapItemsProvider).fold<int>(
        0,
        (sum, item) => sum + item.subtotalRevenue,
      );

  int get _totalCost => ref.watch(rekapItemsProvider).fold<int>(
        0,
        (sum, item) => sum + item.subtotalCost,
      );

  int get _totalProfit => _totalRevenue - _totalCost;

  int get _totalQuantity => ref.watch(rekapItemsProvider).fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

  @override
  Widget build(BuildContext context) {
    // Keep active products stream warm
    ref.watch(activeProductsProvider);
    final items = ref.watch(rekapItemsProvider);
    final canPop = Navigator.canPop(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (items.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text('Perubahan belum disimpan'),
              content: const Text(
                'Apakah kamu yakin ingin keluar? Perubahan yang belum disimpan akan hilang.',
              ),
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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
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
                      color: const Color(0xFFE8F8EA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Iconsax.note_1,
                      size: 20,
                      color: Color(0xFF00AA13),
                    ),
                  ),
                ),
          title: const Text(
            'Rekap Penjualan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          actions: [
            if (!_isToday)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: TextButton.icon(
                  onPressed: () => _handleDateChange(DateTime.now()),
                  icon: const Icon(Iconsax.calendar_tick, size: 16),
                  label: const Text(
                    'Hari Ini',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF00AA13),
                    backgroundColor: const Color(0xFFE8F8EA),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Iconsax.calendar, size: 20),
              color: AppColors.textPrimary,
              tooltip: 'Pilih Tanggal',
              onPressed: _selectDate,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Date Selector Bar
            RekapDateSelector(
              selectedDate: _selectedDate,
              onSelectDate: _selectDate,
              onDateChanged: _handleDateChange,
            ),

            // Main Body Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00AA13),
                      ),
                    )
                  : (!_isEditing && _existingRecord != null)
                      ? RekapSavedView(
                          record: _existingRecord!,
                          items: _existingItems,
                          selectedDate: _selectedDate,
                          onEditRekap: _enterEditMode,
                          onViewHistory: () => context.push('/history'),
                          bottomSpacing: canPop ? 24.0 : 104.0,
                        )
                      : _buildFormView(items, canPop),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView(List<RekapItem> items, bool canPop) {
    final bottomSpacing = canPop ? 20.0 : 100.0;

    if (items.isEmpty) {
      return _buildEmptyState(bottomSpacing);
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              // Real-time Summary Hero Card
              RekapLiveSummaryCard(
                totalRevenue: _totalRevenue,
                totalCost: _totalCost,
                totalProfit: _totalProfit,
                itemCount: items.length,
                totalQuantity: _totalQuantity,
              ),

              // Section Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Item Terjual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${items.length} Menu',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // List of Item Tiles
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return RekapItemTile(
                  key: ValueKey('item_${item.productId}_$index'),
                  item: item,
                  index: index,
                  onQuantityChanged: (qty) => _updateQuantity(index, qty),
                  onPriceChanged: (price) => _updateSellingPrice(index, price),
                  onRemove: () => _removeItem(index),
                );
              }),
            ],
          ),
        ),

        // Bottom Sticky Action Panel
        RekapBottomActionPanel(
          totalRevenue: _totalRevenue,
          totalCost: _totalCost,
          totalProfit: _totalProfit,
          itemCount: items.length,
          totalQuantity: _totalQuantity,
          isLoading: _isLoading,
          onSave: _saveRekap,
          onAddProduct: _showProductSelector,
          bottomPadding: bottomSpacing,
        ),
      ],
    );
  }

  Widget _buildEmptyState(double bottomSpacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Modern Card for Empty Recap
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(6),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F8EA),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00AA13).withAlpha(25),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Iconsax.bag_2,
                              size: 36,
                              color: Color(0xFF00AA13),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Belum Ada Rekap Hari Ini',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Pilih produk dari katalog Anda dan masukkan jumlah yang terjual hari ini untuk menghitung omzet dan laba bersih otomatis.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _showProductSelector,
                              icon: const Icon(Iconsax.add_circle, size: 20),
                              label: const Text(
                                'Tambah Produk Terjual',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00AA13),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: const Color(0xFF00AA13).withAlpha(100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Visual spacing above floating navbottom
                    SizedBox(height: bottomSpacing),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
