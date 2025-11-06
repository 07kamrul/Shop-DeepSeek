import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../data/models/report_model.dart';

class ProfitChart extends StatelessWidget {
  final List<DailySalesReport> reports;

  const ProfitChart({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Profit Trend'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeAxis(title: AxisTitle(text: 'Date')),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Amount (₹)'),
        numberFormat: NumberFormat.currency(symbol: '₹', decimalDigits: 0),
      ),
      series: <ChartSeries>[
        LineSeries<DailySalesReport, DateTime>(
          name: 'Sales',
          dataSource: reports,
          xValueMapper: (DailySalesReport report, _) => report.date,
          yValueMapper: (DailySalesReport report, _) => report.totalSales,
          markerSettings: const MarkerSettings(isVisible: true),
          color: Colors.blue,
        ),
        LineSeries<DailySalesReport, DateTime>(
          name: 'Profit',
          dataSource: reports,
          xValueMapper: (DailySalesReport report, _) => report.date,
          yValueMapper: (DailySalesReport report, _) => report.totalProfit,
          markerSettings: const MarkerSettings(isVisible: true),
          color: Colors.green,
        ),
      ],
    );
  }
}
