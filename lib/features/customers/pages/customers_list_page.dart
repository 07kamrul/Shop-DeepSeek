import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/injection_container.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/customer/customer_bloc.dart';
import '../../../../data/models/customer_model.dart';
import '../widgets/customer_card.dart';
import 'add_customer_page.dart';

class CustomersListPage extends StatefulWidget {
  const CustomersListPage({super.key});

  @override
  State<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      _loadAllCustomers();
    } else {
      _searchCustomers(_searchController.text);
    }
  }

  void _loadAllCustomers() {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    context.read<CustomerBloc>().add(LoadCustomers(userId: user.id));
  }

  void _searchCustomers(String query) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    context.read<CustomerBloc>().add(
      SearchCustomers(userId: user.id, query: query),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return BlocProvider(
      create: (context) =>
          getIt<CustomerBloc>()..add(LoadCustomers(userId: user.id)),
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching ? _buildSearchField() : const Text('Customers'),
          actions: _buildAppBarActions(),
        ),
        body: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomersLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CustomersLoadFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }

            if (state is CustomersLoadSuccess) {
              return StreamBuilder<List<Customer>>(
                stream: state.customersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final customers = snapshot.data!;
                    return customers.isEmpty
                        ? _buildEmptyState()
                        : _buildCustomersList(customers);
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }

            return const Center(child: Text('Load customers to get started'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCustomerPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search customers...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
            _loadAllCustomers();
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCustomerPage()),
            );
          },
        ),
      ];
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Customers Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first customer to track purchases',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCustomerPage(),
                ),
              );
            },
            child: const Text('Add First Customer'),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersList(List<Customer> customers) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${customers.length} customer${customers.length == 1 ? '' : 's'} found',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return CustomerCard(customer: customer);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
