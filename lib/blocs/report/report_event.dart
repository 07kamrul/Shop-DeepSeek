part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class LoadProfitLossReport extends ReportEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  const LoadProfitLossReport({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [userId, startDate, endDate];
}

class LoadDailySalesReport extends ReportEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  const LoadDailySalesReport({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [userId, startDate, endDate];
}

class LoadTopSellingProducts extends ReportEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final int limit;

  const LoadTopSellingProducts({
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.limit = 10,
  });

  @override
  List<Object> get props => [userId, startDate, endDate, limit];
}
