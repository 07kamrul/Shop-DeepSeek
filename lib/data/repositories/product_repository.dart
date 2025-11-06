import '../datasources/firebase_product_datasource.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseProductDataSource _dataSource;

  ProductRepository(this._dataSource);

  Future<String> addProduct(Product product) async {
    return await _dataSource.addProduct(product);
  }

  Stream<List<Product>> getProducts() {
    return _dataSource.getProducts();
  }

  Stream<Product> getProduct(String productId) {
    return _dataSource.getProduct(productId);
  }

  Future<void> updateProduct(Product product) async {
    return await _dataSource.updateProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    return await _dataSource.deleteProduct(productId);
  }

  Future<void> updateStock(String productId, int newStock) async {
    return await _dataSource.updateStock(productId, newStock);
  }

  Stream<List<Product>> getLowStockProducts() {
    return _dataSource.getLowStockProducts();
  }
}