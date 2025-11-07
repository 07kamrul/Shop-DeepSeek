part of 'supplier_bloc.dart';

abstract class SupplierState extends Equatable {
  const SupplierState();

  @override
  List<Object> get props => [];
}

class SupplierInitial extends SupplierState {}

class SuppliersLoadInProgress extends SupplierState {}

class SuppliersLoadSuccess extends SupplierState {
  final Stream<List<Supplier>> suppliersStream;

  const SuppliersLoadSuccess({required this.suppliersStream});

  @override
  List<Object> get props => [suppliersStream];
}

class SupplierOperationSuccess extends SupplierState {}

class SuppliersLoadFailure extends SupplierState {
  final String error;

  const SuppliersLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class SupplierOperationFailure extends SupplierState {
  final String error;

  const SupplierOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
