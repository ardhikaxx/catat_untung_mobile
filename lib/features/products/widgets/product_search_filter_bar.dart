import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

enum ProductFilterStatus {
  all('Semua'),
  active('Aktif'),
  inactive('Nonaktif');

  final String label;
  const ProductFilterStatus(this.label);
}

enum ProductSortOption {
  nameAsc('Nama A-Z', LucideIcons.arrowUpDown),
  marginDesc('Margin Tertinggi', LucideIcons.trendingUp),
  priceDesc('Harga Jual Tertinggi', LucideIcons.banknote),
  hppDesc('Modal HPP Tertinggi', LucideIcons.wallet);

  final String label;
  final IconData icon;
  const ProductSortOption(this.label, this.icon);
}

class ProductSearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ProductFilterStatus currentFilter;
  final ValueChanged<ProductFilterStatus> onFilterChanged;
  final ProductSortOption currentSort;
  final ValueChanged<ProductSortOption> onSortChanged;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;

  const ProductSearchFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.currentSort,
    required this.onSortChanged,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search & Sort Bar Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Row(
            children: [
              // Search Field
              Expanded(
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.greyBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari produk atau satuan...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textHint,
                      ),
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                LucideIcons.xCircle,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                searchController.clear();
                                onSearchChanged('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Sort Popup Menu
              PopupMenuButton<ProductSortOption>(
                initialValue: currentSort,
                onSelected: onSortChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                itemBuilder: (context) {
                  return ProductSortOption.values.map((opt) {
                    final isSelected = opt == currentSort;
                    return PopupMenuItem<ProductSortOption>(
                      value: opt,
                      child: Row(
                        children: [
                          Icon(
                            opt.icon,
                            size: 16,
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            opt.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.greyBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        LucideIcons.arrowUpDown,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(width: 4),
                      Icon(
                        LucideIcons.chevronDown,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Filter Chips Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: Row(
            children: [
              _buildFilterChip(
                label: 'Semua ($totalCount)',
                status: ProductFilterStatus.all,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Aktif ($activeCount)',
                status: ProductFilterStatus.active,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Nonaktif ($inactiveCount)',
                status: ProductFilterStatus.inactive,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required ProductFilterStatus status,
  }) {
    final isSelected = currentFilter == status;

    return InkWell(
      onTap: () => onFilterChanged(status),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.greyBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.greyBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
