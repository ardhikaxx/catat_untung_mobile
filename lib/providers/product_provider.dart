import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'database_provider.dart';

final allProductsProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).watchAllProducts();
});

final activeProductsProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).watchActiveProducts();
});

final productCountProvider = StreamProvider<int>((ref) {
  return ref.watch(productRepositoryProvider).watchProductCount();
});
