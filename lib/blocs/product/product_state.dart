part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductsLoadInProgress extends ProductState {}

class ProductsLoadSuccess extends ProductState {
  final Stream<List<Product>> productsStream;

  const ProductsLoadSuccess({required this.productsStream});

  @override
  List<Object> get props => [productsStream];
}

class ProductOperationSuccess extends ProductState {}

class ProductsLoadFailure extends ProductState {
  final String error;

  const ProductsLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class ProductOperationFailure extends ProductState {
  final String error;

  const ProductOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}