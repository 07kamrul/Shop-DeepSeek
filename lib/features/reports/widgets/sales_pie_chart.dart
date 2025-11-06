import 'package:flutter/material.dart';
import 'package:shop/data/models/report_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../data/models/product_model.dart';

class SalesPieChart extends StatelessWidget {
  final List<ProductSales> topProducts;

  const SalesPieChart({super.key, required this.topProducts});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: 'Top Selling Products'),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries>[
        DoughnutSeries<ProductSales, String>(
          dataSource: topProducts,
          xValueMapper: (ProductSales sales, _) => sales.productName,
          yValueMapper: (ProductSales sales, _) => sales.totalSales,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),
          enableTooltip: true,
        ),
      ],
    );
  }
}
