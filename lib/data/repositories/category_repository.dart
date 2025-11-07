import '../datasources/firebase_category_datasource.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final FirebaseCategoryDataSource _dataSource;

  CategoryRepository(this._dataSource);

  Future<String> addCategory(Category category) async {
    return await _dataSource.addCategory(category);
  }

  Stream<List<Category>> getCategories(String userId) {
    return _dataSource.getCategories(userId);
  }

  Future<void> updateCategory(Category category) async {
    return await _dataSource.updateCategory(category);
  }

  Future<void> deleteCategory(String categoryId) async {
    return await _dataSource.deleteCategory(categoryId);
  }

  Future<Category?> getCategory(String categoryId) async {
    return await _dataSource.getCategory(categoryId);
  }
}