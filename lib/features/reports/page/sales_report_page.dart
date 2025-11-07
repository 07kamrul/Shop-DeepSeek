import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/report/report_bloc.dart';
import '../../../../data/models/report_model.dart';
import '../../../../core/utils/calculations.dart';
import '../../../core/injection_container.dart';

class SalesReportPage extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SalesReportPage({
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
          LoadDailySalesReport(
            userId: user.id,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sales Report')),
        body: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DailySalesReportLoaded) {
              final reports = state.reports;
              return _buildSalesReportContent(reports);
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

  Widget _buildSalesReportContent(List<DailySalesReport> reports) {
    final totalSales = reports.fold(
      0.0,
      (sum, report) => sum + report.totalSales,
    );
    final totalProfit = reports.fold(
      0.0,
      (sum, report) => sum + report.totalProfit,
    );
    final totalTransactions = reports.fold(
      0,
      (sum, report) => sum + report.totalTransactions,
    );

    // Fix: Ensure averageSale is explicitly cast to double
    final double averageSale = totalTransactions > 0
        ? (totalSales / totalTransactions).toDouble()
        : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(
            totalSales,
            totalProfit,
            totalTransactions,
            averageSale,
          ),
          const SizedBox(height: 20),

          // Sales Chart
          Expanded(child: _buildSalesChart(reports)),

          // Daily Breakdown
          const SizedBox(height: 20),
          _buildDailyBreakdown(reports),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    double totalSales,
    double totalProfit,
    int totalTransactions,
    double averageSale,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildSummaryCard(
          'Total Sales',
          Calculations.formatCurrency(totalSales),
          Colors.blue,
          Icons.shopping_cart,
        ),
        _buildSummaryCard(
          'Total Profit',
          Calculations.formatCurrency(totalProfit),
          Colors.green,
          Icons.attach_money,
        ),
        _buildSummaryCard(
          'Transactions',
          totalTransactions.toString(),
          Colors.orange,
          Icons.receipt,
        ),
        _buildSummaryCard(
          'Avg Sale',
          Calculations.formatCurrency(averageSale),
          Colors.purple,
          Icons.trending_up,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart(List<DailySalesReport> reports) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Sales Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(title: AxisTitle(text: 'Date')),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Amount (₹)'),
                  // Fix: Use NumberFormat instead of String
                  numberFormat: NumberFormat.currency(
                    symbol: '₹',
                    decimalDigits: 0,
                  ),
                ),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  LineSeries<DailySalesReport, DateTime>(
                    name: 'Sales',
                    dataSource: reports,
                    xValueMapper: (DailySalesReport report, _) => report.date,
                    yValueMapper: (DailySalesReport report, _) =>
                        report.totalSales,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.blue,
                  ),
                  LineSeries<DailySalesReport, DateTime>(
                    name: 'Profit',
                    dataSource: reports,
                    xValueMapper: (DailySalesReport report, _) => report.date,
                    yValueMapper: (DailySalesReport report, _) =>
                        report.totalProfit,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyBreakdown(List<DailySalesReport> reports) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return _buildDailyReportItem(report);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyReportItem(DailySalesReport report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(report.date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${report.totalTransactions} transactions',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Calculations.formatCurrency(report.totalSales),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Calculations.formatCurrency(report.totalProfit),
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
