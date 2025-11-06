import '../datasources/firebase_supplier_datasource.dart';
import '../models/supplier_model.dart';

class SupplierRepository {
  final FirebaseSupplierDataSource _dataSource;

  SupplierRepository(this._dataSource);

  Future<String> addSupplier(Supplier supplier) async {
    return await _dataSource.addSupplier(supplier);
  }

  Stream<List<Supplier>> getSuppliers(String userId) {
    return _dataSource.getSuppliers(userId);
  }

  Future<Supplier?> getSupplier(String supplierId) async {
    return await _dataSource.getSupplier(supplierId);
  }

  Future<void> updateSupplier(Supplier supplier) async {
    return await _dataSource.updateSupplier(supplier);
  }

  Future<void> deleteSupplier(String supplierId) async {
    return await _dataSource.deleteSupplier(supplierId);
  }

  Stream<List<Supplier>> searchSuppliers(String userId, String query) {
    return _dataSource.searchSuppliers(userId, query);
  }

  Future<void> updateSupplierPurchaseStats({
    required String supplierId,
    required double purchaseAmount,
  }) async {
    return await _dataSource.updateSupplierPurchaseStats(
      supplierId: supplierId,
      purchaseAmount: purchaseAmount,
    );
  }

  Stream<List<Supplier>> getTopSuppliers(String userId, {int limit = 10}) {
    return _dataSource.getTopSuppliers(userId, limit: limit);
  }
}
