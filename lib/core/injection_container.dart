import 'package:get_it/get_it.dart';
import '../data/datasources/firebase_auth_datasource.dart';
import '../data/datasources/firebase_product_datasource.dart';
import '../data/datasources/firebase_category_datasource.dart';
import '../data/datasources/firebase_sale_datasource.dart';
import '../data/datasources/firebase_report_datasource.dart';
import '../data/datasources/firebase_customer_datasource.dart';
import '../data/datasources/firebase_supplier_datasource.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/sale_repository.dart';
import '../data/repositories/report_repository.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/supplier_repository.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/sale/sale_bloc.dart';
import '../blocs/report/report_bloc.dart';
import '../blocs/customer/customer_bloc.dart';
import '../blocs/supplier/supplier_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(),
  );
  getIt.registerLazySingleton<FirebaseProductDataSource>(
    () => FirebaseProductDataSource(),
  );
  getIt.registerLazySingleton<FirebaseCategoryDataSource>(
    () => FirebaseCategoryDataSource(),
  );
  getIt.registerLazySingleton<FirebaseSaleDataSource>(
    () => FirebaseSaleDataSource(),
  );
  getIt.registerLazySingleton<FirebaseReportDataSource>(
    () => FirebaseReportDataSource(),
  );
  getIt.registerLazySingleton<FirebaseCustomerDataSource>(
    () => FirebaseCustomerDataSource(),
  );
  getIt.registerLazySingleton<FirebaseSupplierDataSource>(
    () => FirebaseSupplierDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<FirebaseAuthDataSource>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<FirebaseProductDataSource>()),
  );
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepository(getIt<FirebaseCategoryDataSource>()),
  );
  getIt.registerLazySingleton<SaleRepository>(
    () => SaleRepository(getIt<FirebaseSaleDataSource>()),
  );
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepository(getIt<FirebaseReportDataSource>()),
  );
  getIt.registerLazySingleton<CustomerRepository>(
    () => CustomerRepository(getIt<FirebaseCustomerDataSource>()),
  );
  getIt.registerLazySingleton<SupplierRepository>(
    () => SupplierRepository(getIt<FirebaseSupplierDataSource>()),
  );

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(productRepository: getIt<ProductRepository>()),
  );
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(categoryRepository: getIt<CategoryRepository>()),
  );
  getIt.registerFactory<SaleBloc>(
    () => SaleBloc(saleRepository: getIt<SaleRepository>()),
  );
  getIt.registerFactory<ReportBloc>(
    () => ReportBloc(reportRepository: getIt<ReportRepository>()),
  );
  getIt.registerFactory<CustomerBloc>(
    () => CustomerBloc(customerRepository: getIt<CustomerRepository>()),
  );
  getIt.registerFactory<SupplierBloc>(
    () => SupplierBloc(supplierRepository: getIt<SupplierRepository>()),
  );
}
