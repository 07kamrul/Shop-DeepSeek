import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/product/product_bloc.dart';
import '../../../../blocs/sale/sale_bloc.dart';
import '../../../core/injection_container.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/models/user_model.dart';
import '../widgets/quick_actions.dart';
import '../widgets/stats_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(create: (context) => getIt<ProductBloc>()),
        BlocProvider<SaleBloc>(
          create: (context) =>
              getIt<SaleBloc>()..add(LoadTodaySales(userId: user.id)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('${user.shopName} Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<SaleBloc, SaleState>(
          builder: (context, saleState) {
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      _buildWelcomeSection(user),
                      const SizedBox(height: 20),

                      // Stats Grid
                      _buildStatsGrid(context, saleState, productState),
                      const SizedBox(height: 20),

                      // Quick Actions
                      const QuickActions(),
                      const SizedBox(height: 20),

                      // Recent Activity
                      _buildRecentActivity(context),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, ${user.name}!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s your shop overview',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    SaleState saleState,
    ProductState productState,
  ) {
    int totalProducts = 0;
    int lowStockCount = 0;
    double todaySales = 0;
    double todayProfit = 0;

    if (productState is ProductsLoadSuccess) {
      // We'll get actual data from stream in the actual implementation
      totalProducts = 0; // This would be calculated from stream
      lowStockCount = 0; // This would be calculated from stream
    }

    if (saleState is SalesLoadSuccess) {
      // Today's sales and profit would be calculated from stream
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        StatsCard(
          title: 'Today\'s Sales',
          value: '₹${todaySales.toStringAsFixed(2)}',
          icon: Icons.shopping_cart,
          color: Colors.blue,
        ),
        StatsCard(
          title: 'Today\'s Profit',
          value: '₹${todayProfit.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        StatsCard(
          title: 'Total Products',
          value: totalProducts.toString(),
          icon: Icons.inventory_2,
          color: Colors.orange,
        ),
        StatsCard(
          title: 'Low Stock',
          value: lowStockCount.toString(),
          icon: Icons.warning,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Sales',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<SaleBloc, SaleState>(
              builder: (context, state) {
                if (state is SalesLoadInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SalesLoadFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                if (state is SalesLoadSuccess) {
                  return StreamBuilder<List<Sale>>(
                    stream: state.salesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final sales = snapshot.data!.take(5).toList();

                        if (sales.isEmpty) {
                          return const Center(child: Text('No recent sales'));
                        }

                        return ListView.builder(
                          itemCount: sales.length,
                          itemBuilder: (context, index) {
                            final sale = sales[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.receipt),
                                title: Text(
                                  'Sale #${sale.id!.substring(0, 8)}',
                                ),
                                subtitle: Text(
                                  '${sale.items.length} items • ${sale.dateTime.toString().substring(0, 16)}',
                                ),
                                trailing: Text(
                                  '₹${sale.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }

                return const Center(child: Text('Load sales to see activity'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
