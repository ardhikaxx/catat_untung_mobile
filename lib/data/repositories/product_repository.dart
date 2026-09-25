import '../../database/app_database.dart';
import '../../database/daos/products_dao.dart';

class ProductRepository {
  final AppDatabase _db;
  late final ProductsDao _productsDao;

  ProductRepository(this._db) {
    _productsDao = ProductsDao(_db);
  }

  Stream<List<Product>> watchAllProducts() => _productsDao.watchAllProducts();

  Stream<List<Product>> watchActiveProducts() => _productsDao.watchActiveProducts();

  Future<int> deleteProduct(int id) => _productsDao.deleteProduct(id);

  Stream<int> watchProductCount() => _productsDao.watchProductCount();
}
