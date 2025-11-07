part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoadInProgress extends ReportState {}

class ProfitLossReportLoaded extends ReportState {
  final ProfitLossReport report;

  const ProfitLossReportLoaded({required this.report});

  @override
  List<Object> get props => [report];
}

class DailySalesReportLoaded extends ReportState {
  final List<DailySalesReport> reports;

  const DailySalesReportLoaded({required this.reports});

  @override
  List<Object> get props => [reports];
}

class TopSellingProductsLoaded extends ReportState {
  final List<ProductSales> products;

  const TopSellingProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ReportLoadFailure extends ReportState {
  final String error;

  const ReportLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
