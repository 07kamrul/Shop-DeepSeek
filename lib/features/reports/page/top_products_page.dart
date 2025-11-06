import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/injection_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/report/report_bloc.dart';
import '../../../../data/models/report_model.dart';
import '../../../../core/utils/calculations.dart';

class TopProductsPage extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TopProductsPage({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return BlocProvider(
      create: (context) => getIt<ReportBloc>()
        ..add(
          LoadTopSellingProducts(
            userId: user.id,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Top Products')),
        body: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TopSellingProductsLoaded) {
              final products = state.products;
              return _buildTopProductsContent(products);
            }

            if (state is ReportLoadFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }

            return const Center(child: Text('Load report to see data'));
          },
        ),
      ),
    );
  }

  Widget _buildTopProductsContent(List<ProductSales> products) {
    final totalSales = products.fold(
      0.0,
      (sum, product) => sum + product.totalSales,
    );
    final totalProfit = products.fold(
      0.0,
      (sum, product) => sum + product.totalProfit,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Summary
          _buildSummary(totalSales, totalProfit, products.length),
          const SizedBox(height: 20),

          // Products Chart
          Expanded(flex: 2, child: _buildProductsChart(products)),

          // Products List
          const SizedBox(height: 20),
          Expanded(flex: 3, child: _buildProductsList(products)),
        ],
      ),
    );
  }

  Widget _buildSummary(
    double totalSales,
    double totalProfit,
    int productCount,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              'Total Sales',
              Calculations.formatCurrency(totalSales),
            ),
            _buildSummaryItem(
              'Total Profit',
              Calculations.formatCurrency(totalProfit),
            ),
            _buildSummaryItem('Products', productCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildProductsChart(List<ProductSales> products) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Top Products by Sales',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries>[
                  DoughnutSeries<ProductSales, String>(
                    dataSource: products.take(5).toList(),
                    xValueMapper: (ProductSales sales, _) => sales.productName,
                    yValueMapper: (ProductSales sales, _) => sales.totalSales,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                    enableTooltip: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(List<ProductSales> products) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Performance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductItem(product, index + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(ProductSales product, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.quantitySold} units sold',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Calculations.formatCurrency(product.totalSales),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Calculations.formatCurrency(product.totalProfit),
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }
}
