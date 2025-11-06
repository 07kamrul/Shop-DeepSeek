import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/data/models/report_model.dart';
import 'package:shop/data/models/sale_model.dart';
import 'package:shop/data/repositories/report_repository.dart';

class FirebaseReportDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _salesCollection => _firestore.collection('sales');

  // Get sales report for date range
  Future<ProfitLossReport> getProfitLossReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final salesQuery = await _salesCollection
        .where('createdBy', isEqualTo: userId)
        .where('dateTime', isGreaterThanOrEqualTo: startDate)
        .where('dateTime', isLessThanOrEqualTo: endDate)
        .get();

    final sales = salesQuery.docs
        .map((doc) => Sale.fromFirestore(doc))
        .toList();

    double totalRevenue = 0;
    double totalCost = 0;

    final categoryMap = <String, CategoryReport>{};

    for (final sale in sales) {
      totalRevenue += sale.totalAmount;
      totalCost += sale.totalCost;

      for (final item in sale.items) {
        // Here you would need to get category info from products
        // This is a simplified version
      }
    }

    final grossProfit = totalRevenue - totalCost;
    final grossProfitMargin = totalRevenue > 0
        ? (grossProfit / totalRevenue) * 100
        : 0.0;

    return ProfitLossReport(
      startDate: startDate,
      endDate: endDate,
      totalRevenue: totalRevenue,
      totalCost: totalCost,
      grossProfit: grossProfit,
      grossProfitMargin: grossProfitMargin.toDouble(),
      categoryBreakdown: categoryMap.values.toList(),
    );
  }

  // Get daily sales report
  Future<List<DailySalesReport>> getDailySalesReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final salesQuery = await _salesCollection
        .where('createdBy', isEqualTo: userId)
        .where('dateTime', isGreaterThanOrEqualTo: startDate)
        .where('dateTime', isLessThanOrEqualTo: endDate)
        .get();

    final sales = salesQuery.docs
        .map((doc) => Sale.fromFirestore(doc))
        .toList();

    // Group sales by date
    final salesByDate = <DateTime, List<Sale>>{};
    for (final sale in sales) {
      final date = DateTime(
        sale.dateTime.year,
        sale.dateTime.month,
        sale.dateTime.day,
      );
      salesByDate[date] = [...salesByDate[date] ?? [], sale];
    }

    final reports = <DailySalesReport>[];

    for (final entry in salesByDate.entries) {
      final date = entry.key;
      final dailySales = entry.value;

      double dailyTotalSales = 0;
      double dailyTotalProfit = 0;
      final productSalesMap = <String, ProductSales>{};

      for (final sale in dailySales) {
        dailyTotalSales += sale.totalAmount;
        dailyTotalProfit += sale.totalProfit;

        for (final item in sale.items) {
          final existing = productSalesMap[item.productId];
          if (existing != null) {
            productSalesMap[item.productId] = ProductSales(
              productId: item.productId,
              productName: item.productName,
              quantitySold: existing.quantitySold + item.quantity,
              totalSales: existing.totalSales + item.totalAmount,
              totalProfit: existing.totalProfit + item.totalProfit,
            );
          } else {
            productSalesMap[item.productId] = ProductSales(
              productId: item.productId,
              productName: item.productName,
              quantitySold: item.quantity,
              totalSales: item.totalAmount,
              totalProfit: item.totalProfit,
            );
          }
        }
      }

      final topProducts = productSalesMap.values.toList()
        ..sort((a, b) => b.totalSales.compareTo(a.totalSales))
        ..take(5);

      reports.add(
        DailySalesReport(
          date: date,
          totalSales: dailyTotalSales,
          totalProfit: dailyTotalProfit,
          totalTransactions: dailySales.length,
          topProducts: topProducts,
        ),
      );
    }

    reports.sort((a, b) => b.date.compareTo(a.date));
    return reports;
  }

  // Get top selling products
  Future<List<ProductSales>> getTopSellingProducts({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    final salesQuery = await _salesCollection
        .where('createdBy', isEqualTo: userId)
        .where('dateTime', isGreaterThanOrEqualTo: startDate)
        .where('dateTime', isLessThanOrEqualTo: endDate)
        .get();

    final sales = salesQuery.docs
        .map((doc) => Sale.fromFirestore(doc))
        .toList();

    final productSalesMap = <String, ProductSales>{};

    for (final sale in sales) {
      for (final item in sale.items) {
        final existing = productSalesMap[item.productId];
        if (existing != null) {
          productSalesMap[item.productId] = ProductSales(
            productId: item.productId,
            productName: item.productName,
            quantitySold: existing.quantitySold + item.quantity,
            totalSales: existing.totalSales + item.totalAmount,
            totalProfit: existing.totalProfit + item.totalProfit,
          );
        } else {
          productSalesMap[item.productId] = ProductSales(
            productId: item.productId,
            productName: item.productName,
            quantitySold: item.quantity,
            totalSales: item.totalAmount,
            totalProfit: item.totalProfit,
          );
        }
      }
    }

    return productSalesMap.values.toList()
      ..sort((a, b) => b.totalSales.compareTo(a.totalSales))
      ..take(limit);
  }
}
