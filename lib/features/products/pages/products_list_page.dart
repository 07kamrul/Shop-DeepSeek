import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../data/models/product_model.dart';
import 'add_product_page.dart';

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductsLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state is ProductsLoadSuccess) {
            return StreamBuilder<List<Product>>(
              stream: state.productsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final products = snapshot.data!;
                  return products.isEmpty
                      ? const Center(child: Text('No products found'))
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(product: products[index]);
                          },
                        );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }

          return const Center(child: Text('Load products to get started'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}