import 'package:shop/data/models/sale_model.dart';

class Calculations {
  // Calculate profit for a single product
  static double calculateProfit({
    required double sellingPrice,
    required double buyingPrice,
    required int quantity,
  }) {
    return (sellingPrice - buyingPrice) * quantity;
  }

  // Calculate profit margin percentage
  static double calculateProfitMargin({
    required double sellingPrice,
    required double buyingPrice,
  }) {
    if (sellingPrice == 0) return 0;
    return ((sellingPrice - buyingPrice) / sellingPrice) * 100;
  }

  // Calculate total from list of sales
  static double calculateTotalSales(List<Sale> sales) {
    return sales.fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  // Calculate total profit from list of sales
  static double calculateTotalProfit(List<Sale> sales) {
    return sales.fold(0.0, (sum, sale) => sum + sale.totalProfit);
  }

  // Format currency
  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  // Format percentage
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  // Ensure double type
  static double ensureDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
