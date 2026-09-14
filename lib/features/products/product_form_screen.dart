import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/database_provider.dart';
import '../../providers/product_provider.dart';
import '../../database/app_database.dart';
import 'widgets/product_live_preview_card.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final int? productId;
  final double? initialHpp;
  final double? initialSellingPrice;

  const ProductFormScreen({
    super.key,
    this.productId,
    this.initialHpp,
    this.initialSellingPrice,
  });

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hppController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  String _selectedUnit = 'pcs';
  bool _isActive = true;
  bool _isLoading = false;
  bool _isEdit = false;

  // Preset quick unit options for instant selection
  static const List<String> _quickUnits = [
    'pcs',
    'porsi',
    'cup',
    'botol',
    'box',
    'paket',
    'kg',
    'unit',
  ];

  @override
  void initState() {
    super.initState();
    _isEdit = widget.productId != null;
    if (_isEdit) {
      _loadProduct();
    } else {
      if (widget.initialHpp != null && widget.initialHpp! > 0) {
        _hppController.text = widget.initialHpp!.round().toString();
      }
      if (widget.initialSellingPrice != null && widget.initialSellingPrice! > 0) {
        _sellingPriceController.text = widget.initialSellingPrice!.round().toString();
      }
    }
  }

  Future<void> _loadProduct() async {
    final db = ref.read(databaseProvider);
    final product = await (db.select(db.products)
          ..where((t) => t.id.equals(widget.productId!)))
        .getSingleOrNull();
    if (product != null && mounted) {
      setState(() {
        _nameController.text = product.name;
        _hppController.text = product.hpp.toString();
        _sellingPriceController.text = product.sellingPrice.toString();
        _selectedUnit = product.unit;
        _isActive = product.isActive;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hppController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      final name = _nameController.text.trim();
      final hpp = int.tryParse(_hppController.text) ?? 0;
      final sellingPrice = int.tryParse(_sellingPriceController.text) ?? 0;

      if (_isEdit) {
        await (db.update(db.products)
              ..where((t) => t.id.equals(widget.productId!)))
            .write(
          ProductsCompanion(
            name: drift.Value(name),
            hpp: drift.Value(hpp),
            sellingPrice: drift.Value(sellingPrice),
            unit: drift.Value(_selectedUnit),
            isActive: drift.Value(_isActive),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
      } else {
        await db.into(db.products).insert(
          ProductsCompanion.insert(
            name: name,
            hpp: drift.Value(hpp),
            sellingPrice: drift.Value(sellingPrice),
            unit: drift.Value(_selectedUnit),
          ),
        );
      }

      ref.invalidate(productCountProvider);
      ref.invalidate(allProductsProvider);
      ref.invalidate(activeProductsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(_isEdit
                    ? 'Produk berhasil diperbarui'
                    : 'Produk baru berhasil ditambahkan'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(LucideIcons.trash2, color: AppColors.loss, size: 22),
            SizedBox(width: 10),
            Text(
              'Hapus Produk?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.loss,
              ),
            ),
          ],
        ),
        content: Text(
          'Produk "${_nameController.text.trim()}" akan dihapus permanen dari daftar katalog produk.',
          style: const TextStyle(fontSize: 13, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.loss,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Hapus Produk'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.productId != null) {
      setState(() => _isLoading = true);
      try {
        final repo = ref.read(productRepositoryProvider);
        await repo.deleteProduct(widget.productId!);

        ref.invalidate(productCountProvider);
        ref.invalidate(allProductsProvider);
        ref.invalidate(activeProductsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Produk berhasil dihapus'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus produk: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHpp = int.tryParse(_hppController.text) ?? 0;
    final currentSellingPrice =
        int.tryParse(_sellingPriceController.text) ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: const AppFloatingNavBar(activeIndex: 0),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.greyBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyBorder),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),

              ),
            ),
          ),
        ),
        title: Text(
          _isEdit ? 'Edit Data Produk' : 'Tambah Produk Baru',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          if (_isEdit)
            IconButton(
              tooltip: 'Hapus Produk',
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.trash2,
                  size: 18,
                  color: AppColors.loss,
                ),
              ),
              onPressed: _confirmDelete,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
          children: [
            // 1. Dynamic Live Profit Margin Preview Card
            ProductLivePreviewCard(
              productName: _nameController.text,
              hpp: currentHpp,
              sellingPrice: currentSellingPrice,
              unit: _selectedUnit,
            ),

            const SizedBox(height: 18),

            // 2. Section: Product Identity
            _buildSectionContainer(
              title: 'Identitas Barang',
              subtitle: 'Nama dan kemasan penjualan produk',
              icon: LucideIcons.package,
              children: [
                // Nama Produk
                TextFormField(
                  controller: _nameController,
                  onChanged: (val) => setState(() {}),
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nama Produk / Menu *',
                    hintText: 'Contoh: Es Kopi Susu Aren, Nasi Goreng Spesial',
                    prefixIcon: const Icon(LucideIcons.tag, size: 20),
                    filled: true,
                    fillColor: AppColors.greyBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.greyBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primaryGreen,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nama produk wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Satuan Selection with Chips & Dropdown
                const Text(
                  'Satuan Penjualan *',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),

                // Quick preset chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _quickUnits.map((unit) {
                    final isSelected = _selectedUnit == unit;
                    return InkWell(
                      onTap: () => setState(() => _selectedUnit = unit),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.greyBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.greyBorder,
                          ),
                        ),
                        child: Text(
                          unit,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // Dropdown fallback for all units
                DropdownButtonFormField<String>(
                  value: AppConstants.unitOptions.contains(_selectedUnit)
                      ? _selectedUnit
                      : AppConstants.unitOptions.first,
                  decoration: InputDecoration(
                    labelText: 'Pilih Satuan Lainnya',
                    prefixIcon: const Icon(LucideIcons.ruler, size: 20),
                    filled: true,
                    fillColor: AppColors.greyBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.greyBorder),
                    ),
                  ),
                  items: AppConstants.unitOptions
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedUnit = val);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 3. Section: Financials (HPP & Selling Price)
            _buildSectionContainer(
              title: 'Harga Modal & Penjualan',
              subtitle: 'Dasar penghitungan laba bersih harian',
              icon: LucideIcons.wallet,
              children: [
                // Modal HPP
                TextFormField(
                  controller: _hppController,
                  onChanged: (val) => setState(() {}),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Harga Modal / HPP per Unit *',
                    hintText: '0',
                    prefixText: 'Rp ',
                    prefixStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    helperText: 'Biaya pokok bahan & pembuatan satu unit produk',
                    prefixIcon: const Icon(LucideIcons.shoppingBag, size: 20),
                    filled: true,
                    fillColor: AppColors.greyBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.greyBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primaryGreen,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Harga modal (HPP) wajib diisi';
                    }
                    final num = int.tryParse(val);
                    if (num == null || num < 0) {
                      return 'Harga modal harus berupa angka valid';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Harga Jual
                TextFormField(
                  controller: _sellingPriceController,
                  onChanged: (val) => setState(() {}),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Harga Jual Standar per Unit *',
                    hintText: '0',
                    prefixText: 'Rp ',
                    prefixStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    helperText: 'Harga normal yang ditawarkan kepada pelanggan',
                    prefixIcon: const Icon(LucideIcons.coins, size: 20),
                    filled: true,
                    fillColor: AppColors.greyBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.greyBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primaryGreen,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Harga jual wajib diisi';
                    }
                    final num = int.tryParse(val);
                    if (num == null || num < 0) {
                      return 'Harga jual harus berupa angka valid';
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 4. Section: Product Active Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.greyBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Status Produk Aktif',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  _isActive
                      ? 'Produk tampil di daftar saat rekap penjualan harian'
                      : 'Produk disembunyikan dari pilihan rekap harian',
                  style: TextStyle(
                    fontSize: 11,
                    color: _isActive
                        ? AppColors.profit
                        : AppColors.textSecondary,
                  ),
                ),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
                activeColor: AppColors.primaryGreen,
              ),
            ),

            const SizedBox(height: 28),

            // 5. Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(LucideIcons.checkCircle2, size: 20),
                label: Text(
                  _isEdit ? 'Simpan Perubahan' : 'Tambah ke Katalog Produk',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppFloatingNavBar.bottomSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.greenTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
