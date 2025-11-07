part of 'supplier_bloc.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object> get props => [];
}

class LoadSuppliers extends SupplierEvent {
  final String userId;

  const LoadSuppliers({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SearchSuppliers extends SupplierEvent {
  final String userId;
  final String query;

  const SearchSuppliers({required this.userId, required this.query});

  @override
  List<Object> get props => [userId, query];
}

class AddSupplier extends SupplierEvent {
  final Supplier supplier;

  const AddSupplier({required this.supplier});

  @override
  List<Object> get props => [supplier];
}

class UpdateSupplier extends SupplierEvent {
  final Supplier supplier;

  const UpdateSupplier({required this.supplier});

  @override
  List<Object> get props => [supplier];
}

class DeleteSupplier extends SupplierEvent {
  final String supplierId;

  const DeleteSupplier({required this.supplierId});

  @override
  List<Object> get props => [supplierId];
}

class LoadTopSuppliers extends SupplierEvent {
  final String userId;
  final int limit;

  const LoadTopSuppliers({required this.userId, this.limit = 10});

  @override
  List<Object> get props => [userId, limit];
}
