import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/database_provider.dart';
import '../../database/app_database.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';
import 'widgets/product_hero_card.dart';
import 'widgets/product_search_filter_bar.dart';
import 'widgets/product_card.dart';

// State providers for search, filter status, and sorting
final productSearchTextProvider = StateProvider<String>((ref) => '');
final productStatusFilterProvider =
    StateProvider<ProductFilterStatus>((ref) => ProductFilterStatus.all);
final productSortOptionProvider =
    StateProvider<ProductSortOption>((ref) => ProductSortOption.nameAsc);

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetSearchAndFilter() {
    _searchController.clear();
    ref.read(productSearchTextProvider.notifier).state = '';
    ref.read(productStatusFilterProvider.notifier).state =
        ProductFilterStatus.all;
    ref.read(productSortOptionProvider.notifier).state =
        ProductSortOption.nameAsc;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(productRepositoryProvider);
    final allProductsStream = repo.watchAllProducts();

    final searchQuery = ref.watch(productSearchTextProvider);
    final statusFilter = ref.watch(productStatusFilterProvider);
    final sortOption = ref.watch(productSortOptionProvider);

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Master Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Katalog harga jual, modal HPP & margin',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Tambah Produk',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.greenTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Iconsax.add,
                size: 18,
                color: AppColors.primaryGreen,
              ),
            ),
            onPressed: () => context.push('/products/add'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: allProductsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.warning_2,
                      size: 40,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal Memuat Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final allProducts = snapshot.data ?? [];
          final activeCount = allProducts.where((p) => p.isActive).length;
          final inactiveCount = allProducts.length - activeCount;

          // 1. Filter by Status
          List<Product> filtered = allProducts.where((p) {
            if (statusFilter == ProductFilterStatus.active) return p.isActive;
            if (statusFilter == ProductFilterStatus.inactive) return !p.isActive;
            return true;
          }).toList();

          // 2. Filter by Search Query
          if (searchQuery.trim().isNotEmpty) {
            final query = searchQuery.trim().toLowerCase();
            filtered = filtered.where((p) {
              final nameMatch = p.name.toLowerCase().contains(query);
              final unitMatch = p.unit.toLowerCase().contains(query);
              return nameMatch || unitMatch;
            }).toList();
          }

          // 3. Sort
          filtered.sort((a, b) {
            switch (sortOption) {
              case ProductSortOption.nameAsc:
                return a.name.toLowerCase().compareTo(b.name.toLowerCase());
              case ProductSortOption.marginDesc:
                final marginA = a.sellingPrice > 0
                    ? (a.sellingPrice - a.hpp) / a.sellingPrice
                    : 0.0;
                final marginB = b.sellingPrice > 0
                    ? (b.sellingPrice - b.hpp) / b.sellingPrice
                    : 0.0;
                return marginB.compareTo(marginA);
              case ProductSortOption.priceDesc:
                return b.sellingPrice.compareTo(a.sellingPrice);
              case ProductSortOption.hppDesc:
                return b.hpp.compareTo(a.hpp);
            }
          });

          return CustomScrollView(
            slivers: [
              // A. Hero Overview Card
              if (allProducts.isNotEmpty)
                SliverToBoxAdapter(
                  child: ProductHeroCard(allProducts: allProducts),
                ),

              // B. Search, Filter Chips, & Sort Bar
              if (allProducts.isNotEmpty)
                SliverToBoxAdapter(
                  child: ProductSearchFilterBar(
                    searchController: _searchController,
                    onSearchChanged: (val) {
                      ref.read(productSearchTextProvider.notifier).state = val;
                      setState(() {});
                    },
                    currentFilter: statusFilter,
                    onFilterChanged: (status) {
                      ref.read(productStatusFilterProvider.notifier).state =
                          status;
                    },
                    currentSort: sortOption,
                    onSortChanged: (sort) {
                      ref.read(productSortOptionProvider.notifier).state = sort;
                    },
                    totalCount: allProducts.length,
                    activeCount: activeCount,
                    inactiveCount: inactiveCount,
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),

              // C. Product List or Empty States
              if (allProducts.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyKatalogState(context),
                )
              else if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptySearchResultState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 130),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = filtered[index];
                        return ProductCard(
                          product: product,
                          onTap: () =>
                              context.push('/products/edit/${product.id}'),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/products/add'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Iconsax.add, size: 20),
        label: const Text(
          'Tambah Produk',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyKatalogState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.greenTint,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.box_add,
                  size: 44,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Produk Terdaftar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tambahkan produk daganganmu beserta modal HPP dan harga jual agar sistem dapat menghitung keuntungan otomatis setiap hari.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/products/add'),
              icon: const Icon(Iconsax.add_circle, size: 18),
              label: const Text(
                'Tambah Produk Pertama',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchResultState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.greyBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.search_status,
                size: 34,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Produk Tidak Ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tidak ada produk yang cocok dengan kata kunci atau filter status yang dipilih.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: _resetSearchAndFilter,
              icon: const Icon(Iconsax.refresh, size: 16),
              label: const Text(
                'Reset Pencarian & Filter',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
                side: const BorderSide(color: AppColors.primaryGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
