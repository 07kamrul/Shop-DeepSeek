import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/injection_container.dart';
import 'features/products/pages/products_list_page.dart';
import 'blocs/product/product_bloc.dart';
import 'blocs/category/category_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => getIt<ProductBloc>()..add(LoadProducts()),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => getIt<CategoryBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ProductsListPage(),
      ),
    );
  }
}