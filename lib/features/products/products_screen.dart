import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/database_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../database/app_database.dart';

final showInactiveProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsListProvider = StreamProvider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider);
  
  final repo = ref.watch(productRepositoryProvider);
  
  if (query.isNotEmpty) {
    return repo.searchProducts(query).asStream();
  }
  
  return repo.watchAllProducts();
});

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

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(filteredProductsListProvider);
    final showInactive = ref.watch(showInactiveProvider);
    final hasProducts = productsAsync.valueOrNull?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Produk'),
        actions: [
          if (hasProducts)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nonaktif',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                Switch(
                  value: showInactive,
                  onChanged: (val) {
                    ref.read(showInactiveProvider.notifier).state = val;
                  },
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).state = val;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => const Center(child: Text('Gagal memuat data')),
              data: (products) {
                final filtered = showInactive
                    ? products
                    : products.where((p) => p.isActive).toList();
                
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'Belum Ada Produk',
                    subtitle: 'Tambahkan produk yang biasa kamu jual',
                    actionLabel: 'Tambah Produk',
                    onAction: () => context.push('/products/add'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return _ProductTile(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/products/add'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),
    );
  }
}

class _ProductTile extends ConsumerWidget {
  final Product product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final margin = product.sellingPrice - product.hpp;
    final marginPercent = product.sellingPrice > 0
        ? ((margin / product.sellingPrice) * 100).toStringAsFixed(0)
        : '0';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: product.isActive
                ? AppColors.primaryGreen.withAlpha(25)
                : AppColors.textHint.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            color: product.isActive ? AppColors.primaryGreen : AppColors.textHint,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: product.isActive
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
            if (!product.isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Nonaktif',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'HPP: ${CurrencyFormatter.formatRupiah(product.hpp)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Jual: ${CurrencyFormatter.formatRupiah(product.sellingPrice)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Margin: $marginPercent%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: margin > 0
                      ? AppColors.profit
                      : margin < 0
                          ? AppColors.loss
                          : AppColors.breakEven,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/products/edit/${product.id}'),
      ),
    );
  }
}
