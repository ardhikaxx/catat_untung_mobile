import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import 'widgets/hpp_hero_result_card.dart';
import 'widgets/hpp_target_margin_card.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';

class HppCalculatorScreen extends StatefulWidget {
  const HppCalculatorScreen({super.key});

  @override
  State<HppCalculatorScreen> createState() => _HppCalculatorScreenState();
}

class _HppCalculatorScreenState extends State<HppCalculatorScreen> {
  final _biayaBahanController = TextEditingController();
  final _biayaKemasanController = TextEditingController();
  final _biayaLainController = TextEditingController();
  final _jumlahProdukController = TextEditingController();

  final _numberFormat = NumberFormat('#,##0', 'id_ID');

  double _biayaBahan = 0;
  double _biayaKemasan = 0;
  double _biayaLain = 0;
  int _jumlahProduk = 0;

  double _totalBiaya = 0;
  double _hppPerUnit = 0;
  double _selectedMargin = 0.30; // 30% default recommendation

  @override
  void initState() {
    super.initState();
    _biayaBahanController.addListener(_onCostChanged);
    _biayaKemasanController.addListener(_onCostChanged);
    _biayaLainController.addListener(_onCostChanged);
    _jumlahProdukController.addListener(_onCostChanged);
  }

  @override
  void dispose() {
    _biayaBahanController.removeListener(_onCostChanged);
    _biayaKemasanController.removeListener(_onCostChanged);
    _biayaLainController.removeListener(_onCostChanged);
    _jumlahProdukController.removeListener(_onCostChanged);

    _biayaBahanController.dispose();
    _biayaKemasanController.dispose();
    _biayaLainController.dispose();
    _jumlahProdukController.dispose();
    super.dispose();
  }

  void _onCostChanged() {
    final bahan = _parseCurrency(_biayaBahanController.text);
    final kemasan = _parseCurrency(_biayaKemasanController.text);
    final lain = _parseCurrency(_biayaLainController.text);
    final jumlah = int.tryParse(_jumlahProdukController.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;

    setState(() {
      _biayaBahan = bahan;
      _biayaKemasan = kemasan;
      _biayaLain = lain;
      _jumlahProduk = jumlah;

      _totalBiaya = _biayaBahan + _biayaKemasan + _biayaLain;
      _hppPerUnit = _jumlahProduk > 0 ? _totalBiaya / _jumlahProduk : 0;
    });
  }

  double _parseCurrency(String text) {
    if (text.isEmpty) return 0;
    final cleaned = text.replaceAll('.', '').replaceAll(',', '').trim();
    return double.tryParse(cleaned) ?? 0;
  }

  void _clearAll() {
    _biayaBahanController.clear();
    _biayaKemasanController.clear();
    _biayaLainController.clear();
    _jumlahProdukController.clear();
    setState(() {
      _biayaBahan = 0;
      _biayaKemasan = 0;
      _biayaLain = 0;
      _jumlahProduk = 0;
      _totalBiaya = 0;
      _hppPerUnit = 0;
    });
  }

  void _applyQuickRecipe(String title, int bahan, int kemasan, int lain, int unit) {
    _biayaBahanController.text = _numberFormat.format(bahan);
    _biayaKemasanController.text = _numberFormat.format(kemasan);
    _biayaLainController.text = _numberFormat.format(lain);
    _jumlahProdukController.text = unit.toString();
  }

  void _addUnit(int amount) {
    final current = int.tryParse(_jumlahProdukController.text.replaceAll('.', '')) ?? 0;
    final updated = current + amount;
    _jumlahProdukController.text = updated.toString();
  }

  double get _recommendedSellingPrice {
    if (_hppPerUnit <= 0 || _selectedMargin >= 1.0) return 0.0;
    final rawPrice = _hppPerUnit / (1.0 - _selectedMargin);
    // Rounded to nearest 500
    return ((rawPrice / 500).ceil() * 500).toDouble();
  }

  void _navigateToCreateProduct() {
    if (_hppPerUnit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan komponen biaya dan jumlah unit terlebih dahulu'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    context.push(
      '/products/add',
      extra: {
        'initialHpp': _hppPerUnit,
        'initialSellingPrice': _recommendedSellingPrice,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _totalBiaya > 0 && _jumlahProduk > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        bottomNavigationBar: const AppFloatingNavBar(activeIndex: 0),
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kalkulator HPP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Hitung modal & simulasi harga jual UMKM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            if (_totalBiaya > 0 || _jumlahProduk > 0)
              TextButton.icon(
                onPressed: _clearAll,
                icon: const Icon(
                  Iconsax.refresh,
                  size: 16,
                  color: AppColors.error,
                ),
                label: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(
                  Iconsax.refresh,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                tooltip: 'Reset hitungan',
                onPressed: _clearAll,
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // Education Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.greenTint,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGreen.withAlpha(40)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Iconsax.lamp_on,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Formula HPP UMKM Sehat',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreenDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'HPP = (Bahan Baku + Kemasan + Operasional) ÷ Jumlah Porsi Jadi. Menghitung kemasan & gas mencegah produk jual rugi.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: AppColors.textPrimary.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Hero Live Result Card
            HppHeroResultCard(
              hppPerUnit: _hppPerUnit,
              totalBiaya: _totalBiaya,
              jumlahProduk: _jumlahProduk,
              biayaBahan: _biayaBahan,
              biayaKemasan: _biayaKemasan,
              biayaLain: _biayaLain,
            ),

            // Target Margin & Selling Price Simulator Card
            HppTargetMarginCard(
              hppPerUnit: _hppPerUnit,
              selectedMargin: _selectedMargin,
              onMarginChanged: (margin) {
                setState(() => _selectedMargin = margin);
              },
            ),

            // Quick Example Templates
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.magicpen,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'CONTOH SIMULASI CEPAT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Row(
                children: [
                  _buildQuickRecipeChip(
                    label: '🍗 Ayam Geprek (30 Porsi)',
                    onTap: () => _applyQuickRecipe('Ayam Geprek', 210000, 35000, 25000, 30),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickRecipeChip(
                    label: '☕ Kopi Susu (50 Cup)',
                    onTap: () => _applyQuickRecipe('Kopi Susu', 175000, 65000, 20000, 50),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickRecipeChip(
                    label: '🍪 Cookies (12 Toples)',
                    onTap: () => _applyQuickRecipe('Cookies', 140000, 36000, 15000, 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Cost Input Form Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(6),
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
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.greenTint,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Iconsax.edit_2,
                          size: 18,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Komponen Biaya Produksi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Ketik nominal, hasil HPP terhitung otomatis',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 1. Biaya Bahan Baku
                  _buildCostField(
                    controller: _biayaBahanController,
                    label: 'Biaya Bahan Baku Utama',
                    subtitle: 'Daging, beras, bumbu, sayuran, dsb.',
                    hint: '0',
                    icon: Iconsax.box_1,
                    iconColor: AppColors.primaryGreen,
                    bgColor: AppColors.greenTint,
                  ),

                  const SizedBox(height: 16),

                  // 2. Biaya Kemasan & Label
                  _buildCostField(
                    controller: _biayaKemasanController,
                    label: 'Biaya Kemasan & Packaging',
                    subtitle: 'Box, styrofoam, cup, plastik, stiker label',
                    hint: '0',
                    icon: Iconsax.box,
                    iconColor: AppColors.warning,
                    bgColor: AppColors.warning.withAlpha(20),
                  ),

                  const SizedBox(height: 16),

                  // 3. Biaya Operasional / Lainnya
                  _buildCostField(
                    controller: _biayaLainController,
                    label: 'Biaya Operasional / Lainnya',
                    subtitle: 'Gas LPG, listrik, es batu, minyak goreng',
                    hint: '0',
                    icon: Iconsax.flash_1,
                    iconColor: AppColors.info,
                    bgColor: AppColors.info.withAlpha(20),
                  ),

                  const SizedBox(height: 20),
                  Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 18),

                  // 4. Target Hasil Jadi (Porsi/Unit)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Iconsax.chart_21,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Target Jumlah Jadi',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Berapa porsi / unit yang dihasilkan',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _jumlahProdukController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Contoh: 50',
                      hintStyle: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
                      ),
                      suffixText: 'Unit / Porsi',
                      suffixStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryGreen,
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Quick Increment Chips
                  Row(
                    children: [
                      Text(
                        'Tambah cepat: ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      _buildAddUnitChip('+10', () => _addUnit(10)),
                      const SizedBox(width: 6),
                      _buildAddUnitChip('+25', () => _addUnit(25)),
                      const SizedBox(width: 6),
                      _buildAddUnitChip('+50', () => _addUnit(50)),
                      const SizedBox(width: 6),
                      _buildAddUnitChip('+100', () => _addUnit(100)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: hasData ? _navigateToCreateProduct : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.divider,
                        disabledForegroundColor: AppColors.textSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: hasData ? 3 : 0,
                      ),
                      icon: const Icon(Iconsax.add_square, size: 20),
                      label: Text(
                        hasData
                            ? 'Jadikan Produk Baru (${CurrencyFormatter.formatRupiah(_recommendedSellingPrice.round())})'
                            : 'Jadikan Produk Baru',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_totalBiaya > 0 || _jumlahProduk > 0)
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: _clearAll,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: BorderSide(color: AppColors.divider),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Iconsax.refresh, size: 16),
                        label: const Text(
                          'Reset Semua Hitungan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppFloatingNavBar.bottomSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildCostField({
    required TextEditingController controller,
    required String label,
    required String subtitle,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _RupiahInputFormatter(),
          ],
          decoration: InputDecoration(
            prefixText: 'Rp ',
            prefixStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textHint,
              fontSize: 15,
            ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickRecipeChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildAddUnitChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.greenTint,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryGreen.withAlpha(50)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreenDark,
          ),
        ),
      ),
    );
  }
}

/// Custom TextInputFormatter to format input text with Indonesian thousands separator (e.g. 500.000)
class _RupiahInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0', 'id_ID');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    final number = int.tryParse(digitsOnly);
    if (number == null) {
      return oldValue;
    }

    final formatted = _formatter.format(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
