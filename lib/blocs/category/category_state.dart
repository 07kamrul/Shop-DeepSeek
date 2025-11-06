part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoriesLoadInProgress extends CategoryState {}

class CategoriesLoadSuccess extends CategoryState {
  final Stream<List<Category>> categoriesStream;

  const CategoriesLoadSuccess({required this.categoriesStream});

  @override
  List<Object> get props => [categoriesStream];
}

class CategoryOperationSuccess extends CategoryState {}

class CategoriesLoadFailure extends CategoryState {
  final String error;

  const CategoriesLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class CategoryOperationFailure extends CategoryState {
  final String error;

  const CategoryOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
