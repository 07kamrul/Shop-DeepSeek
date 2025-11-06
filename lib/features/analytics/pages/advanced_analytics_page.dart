import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/injection_container.dart';
import 'package:shop/features/reports/widgets/profit_chart.dart';
import 'package:shop/features/reports/widgets/sales_pie_chart.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/report/report_bloc.dart';

class AdvancedAnalyticsPage extends StatefulWidget {
  const AdvancedAnalyticsPage({super.key});

  @override
  State<AdvancedAnalyticsPage> createState() => _AdvancedAnalyticsPageState();
}

class _AdvancedAnalyticsPageState extends State<AdvancedAnalyticsPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Show export dialog
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<ReportBloc>()
          ..add(
            LoadDailySalesReport(
              userId: user.id,
              startDate: _startDate,
              endDate: _endDate,
            ),
          )
          ..add(
            LoadTopSellingProducts(
              userId: user.id,
              startDate: _startDate,
              endDate: _endDate,
            ),
          ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDateRangeSelector(),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    if (state is ReportLoadInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is DailySalesReportLoaded &&
                        state is TopSellingProductsLoaded) {
                      final dailyReports =
                          (state as DailySalesReportLoaded).reports;
                      final topProducts =
                          (state as TopSellingProductsLoaded).products;

                      return ListView(
                        children: [
                          SizedBox(
                            height: 300,
                            child: ProfitChart(reports: dailyReports),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 300,
                            child: SalesPieChart(topProducts: topProducts),
                          ),
                        ],
                      );
                    }

                    if (state is ReportLoadFailure) {
                      return Center(child: Text('Error: ${state.error}'));
                    }

                    return const Center(child: Text('Load analytics data'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('From Date'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(
                      '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('To Date'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(
                      '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
      _refreshData();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      _refreshData();
    }
  }

  void _refreshData() {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    context.read<ReportBloc>()
      ..add(
        LoadDailySalesReport(
          userId: user.id,
          startDate: _startDate,
          endDate: _endDate,
        ),
      )
      ..add(
        LoadTopSellingProducts(
          userId: user.id,
          startDate: _startDate,
          endDate: _endDate,
        ),
      );
  }
}
