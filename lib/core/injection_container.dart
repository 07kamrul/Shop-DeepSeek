import 'package:get_it/get_it.dart';
import '../data/datasources/firebase_category_datasource.dart';
import '../data/datasources/firebase_product_datasource.dart';
import '../data/datasources/firebase_sale_datasource.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/sale_repository.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/sale/sale_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources
  getIt.registerLazySingleton<FirebaseProductDataSource>(
    () => FirebaseProductDataSource(),
  );
  getIt.registerLazySingleton<FirebaseCategoryDataSource>(
    () => FirebaseCategoryDataSource(),
  );
  getIt.registerLazySingleton<FirebaseSaleDataSource>(
    () => FirebaseSaleDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<FirebaseProductDataSource>()),
  );
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepository(getIt<FirebaseCategoryDataSource>()),
  );
  getIt.registerLazySingleton<SaleRepository>(
    () => SaleRepository(getIt<FirebaseSaleDataSource>()),
  );

  // BLoCs
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(productRepository: getIt<ProductRepository>()),
  );
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(categoryRepository: getIt<CategoryRepository>()),
  );
  getIt.registerFactory<SaleBloc>(
    () => SaleBloc(saleRepository: getIt<SaleRepository>()),
  );
}