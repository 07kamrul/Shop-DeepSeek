part of 'sale_bloc.dart';

abstract class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

class SaleInitial extends SaleState {}

class SalesLoadInProgress extends SaleState {}

class SaleOperationInProgress extends SaleState {}

class SalesLoadSuccess extends SaleState {
  final Stream<List<Sale>> salesStream;

  const SalesLoadSuccess({required this.salesStream});

  @override
  List<Object> get props => [salesStream];
}

class SaleOperationSuccess extends SaleState {}

class SalesLoadFailure extends SaleState {
  final String error;

  const SalesLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class SaleOperationFailure extends SaleState {
  final String error;

  const SaleOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
