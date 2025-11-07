part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomersLoadInProgress extends CustomerState {}

class CustomersLoadSuccess extends CustomerState {
  final Stream<List<Customer>> customersStream;

  const CustomersLoadSuccess({required this.customersStream});

  @override
  List<Object> get props => [customersStream];
}

class CustomerOperationSuccess extends CustomerState {}

class CustomersLoadFailure extends CustomerState {
  final String error;

  const CustomersLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class CustomerOperationFailure extends CustomerState {
  final String error;

  const CustomerOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
