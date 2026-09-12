import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/products_table.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase> with _$ProductsDaoMixin {
  ProductsDao(super.db);

  Future<List<Product>> getAllProducts() => (select(products)
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .get();

  Stream<List<Product>> watchAllProducts() => (select(products)
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .watch();

  Future<List<Product>> getActiveProducts() => (select(products)
        ..where((t) => t.isActive.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .get();

  Stream<List<Product>> watchActiveProducts() => (select(products)
        ..where((t) => t.isActive.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .watch();

  Future<List<Product>> searchProducts(String query) => (select(products)
        ..where((t) => t.name.like('%$query%'))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .get();

  Future<Product?> getProductById(int id) =>
      (select(products)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertProduct(ProductsCompanion product) =>
      into(products).insert(product);

  Future<bool> updateProduct(ProductsCompanion product) =>
      update(products).replace(product);

  Future<int> deleteProduct(int id) =>
      (delete(products)..where((t) => t.id.equals(id))).go();

  Stream<int> watchProductCount() =>
      (selectOnly(products)..addColumns([products.id.count()]))
          .watch()
          .map((rows) => rows.firstOrNull?.read(products.id.count()) ?? 0);
}
