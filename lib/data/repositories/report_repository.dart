import '../datasources/firebase_report_datasource.dart';
import '../models/report_model.dart';

class ReportRepository {
  final FirebaseReportDataSource _dataSource;

  ReportRepository(this._dataSource);

  Future<ProfitLossReport> getProfitLossReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _dataSource.getProfitLossReport(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<DailySalesReport>> getDailySalesReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _dataSource.getDailySalesReport(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<ProductSales>> getTopSellingProducts({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    return await _dataSource.getTopSellingProducts(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }
}
