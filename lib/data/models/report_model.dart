import 'package:equatable/equatable.dart';

class DailySalesReport extends Equatable {
  final DateTime date;
  final double totalSales;
  final double totalProfit;
  final int totalTransactions;
  final List<ProductSales> topProducts;

  const DailySalesReport({
    required this.date,
    required this.totalSales,
    required this.totalProfit,
    required this.totalTransactions,
    required this.topProducts,
  });

  @override
  List<Object?> get props => [
    date,
    totalSales,
    totalProfit,
    totalTransactions,
    topProducts,
  ];
}

class ProductSales extends Equatable {
  final String productId;
  final String productName;
  final int quantitySold;
  final double totalSales;
  final double totalProfit;

  const ProductSales({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.totalSales,
    required this.totalProfit,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    quantitySold,
    totalSales,
    totalProfit,
  ];
}

class CategoryReport extends Equatable {
  final String categoryId;
  final String categoryName;
  final double totalSales;
  final double totalProfit;
  final double profitMargin;

  const CategoryReport({
    required this.categoryId,
    required this.categoryName,
    required this.totalSales,
    required this.totalProfit,
    required this.profitMargin,
  });

  @override
  List<Object?> get props => [
    categoryId,
    categoryName,
    totalSales,
    totalProfit,
    profitMargin,
  ];
}

class ProfitLossReport extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final double totalRevenue;
  final double totalCost;
  final double grossProfit;
  final double grossProfitMargin;
  final List<CategoryReport> categoryBreakdown;

  const ProfitLossReport({
    required this.startDate,
    required this.endDate,
    required this.totalRevenue,
    required this.totalCost,
    required this.grossProfit,
    required this.grossProfitMargin,
    required this.categoryBreakdown,
  });

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    totalRevenue,
    totalCost,
    grossProfit,
    grossProfitMargin,
    categoryBreakdown,
  ];
}
