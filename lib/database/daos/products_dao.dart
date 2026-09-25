import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/products_table.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase> with _$ProductsDaoMixin {
  ProductsDao(super.db);

  Stream<List<Product>> watchAllProducts() => (select(products)
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .watch();

  Stream<List<Product>> watchActiveProducts() => (select(products)
        ..where((t) => t.isActive.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .watch();

  Future<int> deleteProduct(int id) =>
      (delete(products)..where((t) => t.id.equals(id))).go();

  Stream<int> watchProductCount() =>
      (selectOnly(products)..addColumns([products.id.count()]))
          .watch()
          .map((rows) => rows.firstOrNull?.read(products.id.count()) ?? 0);
}
