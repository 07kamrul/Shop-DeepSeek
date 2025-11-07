part of 'sale_bloc.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object> get props => [];
}

class LoadSales extends SaleEvent {
  final String userId;

  const LoadSales({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadSalesByDateRange extends SaleEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  const LoadSalesByDateRange({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [userId, startDate, endDate];
}

class LoadTodaySales extends SaleEvent {
  final String userId;

  const LoadTodaySales({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddSale extends SaleEvent {
  final Sale sale;

  const AddSale({required this.sale});

  @override
  List<Object> get props => [sale];
}

class DeleteSale extends SaleEvent {
  final Sale sale;

  const DeleteSale({required this.sale});

  @override
  List<Object> get props => [sale];
}
