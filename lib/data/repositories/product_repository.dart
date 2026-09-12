import 'package:drift/drift.dart';
import '../../database/app_database.dart';
import '../../database/daos/products_dao.dart';

class ProductRepository {
  final AppDatabase _db;
  late final ProductsDao _productsDao;

  ProductRepository(this._db) {
    _productsDao = ProductsDao(_db);
  }

  Future<List<Product>> getAllProducts() => _productsDao.getAllProducts();

  Stream<List<Product>> watchAllProducts() => _productsDao.watchAllProducts();

  Future<List<Product>> getActiveProducts() => _productsDao.getActiveProducts();

  Stream<List<Product>> watchActiveProducts() => _productsDao.watchActiveProducts();

  Future<List<Product>> searchProducts(String query) => _productsDao.searchProducts(query);

  Future<Product?> getProductById(int id) => _productsDao.getProductById(id);

  Future<int> insertProduct({
    required String name,
    required int hpp,
    required int sellingPrice,
    String unit = 'pcs',
  }) {
    return _db.into(_db.products).insert(
          ProductsCompanion.insert(
            name: name,
            hpp: Value(hpp),
            sellingPrice: Value(sellingPrice),
            unit: Value(unit),
          ),
        );
  }

  Future<bool> updateProduct({
    required int id,
    required String name,
    required int hpp,
    required int sellingPrice,
    required String unit,
    required bool isActive,
  }) {
    return _db.update(_db.products).replace(
          ProductsCompanion(
            id: Value(id),
            name: Value(name),
            hpp: Value(hpp),
            sellingPrice: Value(sellingPrice),
            unit: Value(unit),
            isActive: Value(isActive),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<int> deleteProduct(int id) => _productsDao.deleteProduct(id);

  Stream<int> watchProductCount() => _productsDao.watchProductCount();
}
