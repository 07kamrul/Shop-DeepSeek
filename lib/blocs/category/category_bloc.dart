import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  void _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) {
    emit(CategoriesLoadInProgress());
    try {
      final categoriesStream = categoryRepository.getCategories(event.userId);
      emit(CategoriesLoadSuccess(categoriesStream: categoriesStream));
    } catch (e) {
      emit(CategoriesLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await categoryRepository.addCategory(event.category);
    } catch (e) {
      emit(CategoryOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await categoryRepository.updateCategory(event.category);
    } catch (e) {
      emit(CategoryOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await categoryRepository.deleteCategory(event.categoryId);
    } catch (e) {
      emit(CategoryOperationFailure(error: e.toString()));
    }
  }
}
