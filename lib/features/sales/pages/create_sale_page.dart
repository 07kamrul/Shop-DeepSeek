import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/product/product_bloc.dart';
import '../../../../blocs/sale/sale_bloc.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/sale_model.dart';

class CreateSalePage extends StatefulWidget {
  const CreateSalePage({super.key});

  @override
  State<CreateSalePage> createState() => _CreateSalePageState();
}

class _CreateSalePageState extends State<CreateSalePage> {
  final List<SaleItem> _saleItems = [];
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  String _paymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saleItems.isNotEmpty
                ? () => _completeSale(user.id)
                : null,
          ),
        ],
      ),
      body: Column(
        children: [
          // Customer Info
          _buildCustomerInfo(),

          // Products List
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductsLoadSuccess) {
                  return StreamBuilder<List<Product>>(
                    stream: state.productsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final products = snapshot.data!
                            .where((product) => product.currentStock > 0)
                            .toList();
                        return _buildProductsGrid(products);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),

          // Sale Summary
          _buildSaleSummary(),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _customerPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                DropdownMenuItem(value: 'card', child: Text('Card')),
                DropdownMenuItem(value: 'upi', child: Text('UPI')),
                DropdownMenuItem(value: 'online', child: Text('Online')),
              ],
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final saleItem = _saleItems.firstWhere(
          (item) => item.productId == product.id,
          orElse: () => const SaleItem(
            productId: '',
            productName: '',
            quantity: 0,
            unitBuyingPrice: 0,
            unitSellingPrice: 0,
          ),
        );

        return _buildProductCard(product, saleItem);
      },
    );
  }

  Widget _buildProductCard(Product product, SaleItem saleItem) {
    final isInCart = saleItem.quantity > 0;

    return Card(
      elevation: isInCart ? 4 : 1,
      color: isInCart ? Colors.blue[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Stock: ${product.currentStock}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '₹${product.sellingPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Spacer(),
            if (isInCart)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () =>
                        _updateQuantity(product, saleItem.quantity - 1),
                  ),
                  Text(
                    saleItem.quantity.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () =>
                        _updateQuantity(product, saleItem.quantity + 1),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _updateQuantity(product, 1),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Add to Sale'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleSummary() {
    final totalAmount = _saleItems.fold(
      0.0,
      (sum, item) => sum + item.totalAmount,
    );
    final totalProfit = _saleItems.fold(
      0.0,
      (sum, item) => sum + item.totalProfit,
    );

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Items:'),
                Text(_saleItems.length.toString()),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:'),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Profit:'),
                Text(
                  '₹${totalProfit.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saleItems.isNotEmpty
                    ? () {
                        final user =
                            (context.read<AuthBloc>().state
                                    as AuthAuthenticated)
                                .user;
                        _completeSale(user.id);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Complete Sale',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(Product product, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _saleItems.removeWhere((item) => item.productId == product.id);
      } else {
        if (newQuantity > product.currentStock) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not enough stock available'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final existingIndex = _saleItems.indexWhere(
          (item) => item.productId == product.id,
        );

        if (existingIndex >= 0) {
          _saleItems[existingIndex] = SaleItem(
            productId: product.id!,
            productName: product.name,
            quantity: newQuantity,
            unitBuyingPrice: product.buyingPrice,
            unitSellingPrice: product.sellingPrice,
          );
        } else {
          _saleItems.add(
            SaleItem(
              productId: product.id!,
              productName: product.name,
              quantity: newQuantity,
              unitBuyingPrice: product.buyingPrice,
              unitSellingPrice: product.sellingPrice,
            ),
          );
        }
      }
    });
  }

  void _completeSale(String userId) {
    if (_saleItems.isEmpty) return;

    final totalAmount = _saleItems.fold(
      0.0,
      (sum, item) => sum + item.totalAmount,
    );
    final totalProfit = _saleItems.fold(
      0.0,
      (sum, item) => sum + item.totalProfit,
    );

    final sale = Sale(
      dateTime: DateTime.now(),
      items: _saleItems,
      customerName: _customerNameController.text.isEmpty
          ? null
          : _customerNameController.text,
      customerPhone: _customerPhoneController.text.isEmpty
          ? null
          : _customerPhoneController.text,
      paymentMethod: _paymentMethod,
      totalAmount: totalAmount,
      totalCost: totalAmount - totalProfit,
      totalProfit: totalProfit,
      createdBy: userId,
    );

    context.read<SaleBloc>().add(AddSale(sale: sale));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sale completed successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }
}
