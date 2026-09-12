import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/database_provider.dart';
import '../../database/app_database.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final int? productId;

  const ProductFormScreen({super.key, this.productId});

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

  @override
  void initState() {
    super.initState();
    _isEdit = widget.productId != null;
    if (_isEdit) {
      _loadProduct();
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
        await (db.update(db.products)..where((t) => t.id.equals(widget.productId!))).write(
          ProductsCompanion(
            name: Value(name),
            hpp: Value(hpp),
            sellingPrice: Value(sellingPrice),
            unit: Value(_selectedUnit),
            isActive: Value(_isActive),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } else {
        await db.into(db.products).insert(
          ProductsCompanion.insert(
            name: name,
            hpp: Value(hpp),
            sellingPrice: Value(sellingPrice),
            unit: Value(_selectedUnit),
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEdit ? 'Produk diperbarui' : 'Produk ditambahkan'),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                hintText: 'Contoh: Kopi Susu',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Nama produk wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hppController,
              decoration: const InputDecoration(
                labelText: 'Harga Modal / HPP per Unit',
                hintText: '0',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Harga modal wajib diisi';
                final num = int.tryParse(val);
                if (num == null || num < 0) return 'Harga modal harus angka valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sellingPriceController,
              decoration: const InputDecoration(
                labelText: 'Harga Jual Standar per Unit',
                hintText: '0',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Harga jual wajib diisi';
                final num = int.tryParse(val);
                if (num == null || num < 0) return 'Harga jual harus angka valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: const InputDecoration(
                labelText: 'Satuan',
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
            if (_isEdit) ...[
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Status Aktif'),
                subtitle: Text(
                  _isActive ? 'Produk aktif' : 'Produk nonaktif',
                  style: TextStyle(
                    color: _isActive ? AppColors.profit : AppColors.textSecondary,
                  ),
                ),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
                activeColor: AppColors.primaryGreen,
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isEdit ? 'Simpan Perubahan' : 'Tambah Produk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
