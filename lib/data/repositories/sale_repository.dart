import '../datasources/firebase_sale_datasource.dart';
import '../models/sale_model.dart';

class SaleRepository {
  final FirebaseSaleDataSource _dataSource;

  SaleRepository(this._dataSource);

  Future<String> addSale(Sale sale) async {
    return await _dataSource.addSale(sale);
  }

  Stream<List<Sale>> getSales(String userId) {
    return _dataSource.getSales(userId);
  }

  Stream<List<Sale>> getSalesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _dataSource.getSalesByDateRange(userId, startDate, endDate);
  }

  Stream<List<Sale>> getTodaySales(String userId) {
    return _dataSource.getTodaySales(userId);
  }

  Future<Sale?> getSale(String saleId) async {
    return await _dataSource.getSale(saleId);
  }

  Future<void> deleteSale(Sale sale) async {
    return await _dataSource.deleteSale(sale);
  }
}
