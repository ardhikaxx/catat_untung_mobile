import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/calculation_utils.dart';
import '../daily_rekap_screen.dart';

class RekapItemTile extends StatefulWidget {
  final RekapItem item;
  final int index;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<int> onPriceChanged;
  final VoidCallback onRemove;

  const RekapItemTile({
    super.key,
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onPriceChanged,
    required this.onRemove,
  });

  @override
  State<RekapItemTile> createState() => _RekapItemTileState();
}

class _RekapItemTileState extends State<RekapItemTile> {
  late TextEditingController _qtyController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: widget.item.quantity.toString());
    _priceController = TextEditingController(text: widget.item.sellingPrice.toString());
  }

  @override
  void didUpdateWidget(covariant RekapItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.quantity != widget.item.quantity &&
        _qtyController.text != widget.item.quantity.toString()) {
      _qtyController.text = widget.item.quantity.toString();
    }
    if (oldWidget.item.sellingPrice != widget.item.sellingPrice &&
        _priceController.text != widget.item.sellingPrice.toString()) {
      _priceController.text = widget.item.sellingPrice.toString();
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _stepQuantity(int delta) {
    final current = widget.item.quantity;
    final next = current + delta;
    if (next >= 0) {
      _qtyController.text = next.toString();
      widget.onQuantityChanged(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final profit = item.subtotalProfit;
    final isProfitPositive = profit > 0;
    final isProfitZero = profit == 0;
    final margin = CalculationUtils.calculateMargin(
      item.subtotalRevenue,
      item.subtotalCost,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Icon + Product Title + Unit + Delete
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 8),
            child: Row(
              children: [
                // Product Icon Box
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Iconsax.box_1,
                    size: 20,
                    color: Color(0xFF6C4AB6),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Unit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.unit.isNotEmpty ? item.unit : 'pcs',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Modal: ${CurrencyFormatter.formatRupiah(item.hpp)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Remove Button
                IconButton(
                  icon: const Icon(Iconsax.trash, size: 18),
                  color: const Color(0xFF94A3B8),
                  hoverColor: const Color(0xFFFEE2E2),
                  splashRadius: 20,
                  tooltip: 'Hapus Item',
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Row 2: Controls (Qty Stepper & Selling Price)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              children: [
                // Qty Stepper
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jumlah Terjual',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            // Minus Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                key: const Key('btn_step_minus'),
                                onTap: () => _stepQuantity(-1),
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                ),
                                child: Container(
                                  width: 36,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Iconsax.minus,
                                    size: 16,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ),

                            // Quantity Text Field
                            Expanded(
                              child: TextFormField(
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (val) {
                                  final qty = int.tryParse(val) ?? 0;
                                  widget.onQuantityChanged(qty);
                                },
                              ),
                            ),

                            // Plus Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                key: const Key('btn_step_plus'),
                                onTap: () => _stepQuantity(1),
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(10),
                                ),
                                child: Container(
                                  width: 36,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Iconsax.add,
                                    size: 16,
                                    color: Color(0xFF6C4AB6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Selling Price
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harga Jual Satuan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Text(
                              'Rp ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (val) {
                                  final price = int.tryParse(val) ?? 0;
                                  widget.onPriceChanged(price);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Row 3: Subtotal Omzet & Profit Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isProfitPositive
                  ? const Color(0xFFF0FDF4)
                  : (isProfitZero ? const Color(0xFFF8FAFC) : const Color(0xFFFEF2F2)),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Subtotal Omzet
                Row(
                  children: [
                    const Text(
                      'Subtotal: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatRupiah(item.subtotalRevenue),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                // Subtotal Profit
                Row(
                  children: [
                    Text(
                      'Laba: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: isProfitPositive
                            ? const Color(0xFF15803D)
                            : (isProfitZero ? const Color(0xFF64748B) : const Color(0xFFB91C1C)),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatRupiah(profit),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isProfitPositive
                            ? const Color(0xFF15803D)
                            : (isProfitZero ? const Color(0xFF64748B) : const Color(0xFFB91C1C)),
                      ),
                    ),
                    if (item.subtotalRevenue > 0) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(${margin >= 0 ? '+' : ''}${margin.toStringAsFixed(0)}%)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isProfitPositive
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
