import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';

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

  double _totalBiaya = 0;
  double _hppPerUnit = 0;

  @override
  void dispose() {
    _biayaBahanController.dispose();
    _biayaKemasanController.dispose();
    _biayaLainController.dispose();
    _jumlahProdukController.dispose();
    super.dispose();
  }

  void _hitungHpp() {
    final bahan = double.tryParse(_biayaBahanController.text.replaceAll('.', '')) ?? 0;
    final kemasan = double.tryParse(_biayaKemasanController.text.replaceAll('.', '')) ?? 0;
    final lain = double.tryParse(_biayaLainController.text.replaceAll('.', '')) ?? 0;
    final jumlah = int.tryParse(_jumlahProdukController.text.replaceAll('.', '')) ?? 0;

    setState(() {
      _totalBiaya = bahan + kemasan + lain;
      _hppPerUnit = jumlah > 0 ? _totalBiaya / jumlah : 0;
    });
  }

  void _clearAll() {
    _biayaBahanController.clear();
    _biayaKemasanController.clear();
    _biayaLainController.clear();
    _jumlahProdukController.clear();
    setState(() {
      _totalBiaya = 0;
      _hppPerUnit = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator HPP'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            tooltip: 'Reset',
            onPressed: _clearAll,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Penjelasan
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.info.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.info_circle, color: AppColors.info, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'HPP (Harga Pokok Penjualan) adalah total biaya yang dikeluarkan untuk menghasilkan produk.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Input Section
          const Text(
            'Masukkan Biaya',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _biayaBahanController,
            label: 'Biaya Bahan Baku',
            hint: 'Contoh: 500000',
            icon: Iconsax.box,
            iconColor: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _biayaKemasanController,
            label: 'Biaya Kemasan',
            hint: 'Contoh: 100000',
            icon: Iconsax.document,
            iconColor: AppColors.warning,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _biayaLainController,
            label: 'Biaya Lainnya',
            hint: 'Contoh: 50000 (opsional)',
            icon: Iconsax.add_circle,
            iconColor: AppColors.info,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _jumlahProdukController,
            label: 'Jumlah Produk (unit)',
            hint: 'Contoh: 100',
            icon: Iconsax.box,
            iconColor: AppColors.textSecondary,
            isNumber: true,
          ),
          const SizedBox(height: 20),

          // Tombol Hitung
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _hitungHpp,
              icon: const Icon(Iconsax.calculator),
              label: const Text(
                'Hitung HPP',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Hasil
          if (_totalBiaya > 0) ...[
            const Text(
              'Hasil Perhitungan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildResultCard(
              title: 'Total Biaya',
              value: 'Rp ${_numberFormat.format(_totalBiaya)}',
              icon: Iconsax.wallet_3,
              color: AppColors.warning,
            ),
            const SizedBox(height: 8),

            if (_hppPerUnit > 0) ...[
              _buildResultCard(
                title: 'HPP Per Unit',
                value: 'Rp ${_numberFormat.format(_hppPerUnit.round())}',
                icon: Iconsax.box,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(height: 16),

              // Info tambahan
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.tick_circle, color: AppColors.primaryGreen, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'HPP per unit adalah Rp ${_numberFormat.format(_hppPerUnit.round())}. Gunakan harga ini sebagai modal saat input rekap.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    bool isNumber = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
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
                  color: iconColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => _hitungHpp(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
