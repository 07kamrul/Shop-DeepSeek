import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/supplier/supplier_bloc.dart';
import '../../../../data/models/supplier_model.dart';
import '../../../core/injection_container.dart';
import '../widgets/supplier_card.dart';
import 'add_supplier_page.dart';

class SuppliersListPage extends StatefulWidget {
  const SuppliersListPage({super.key});

  @override
  State<SuppliersListPage> createState() => _SuppliersListPageState();
}

class _SuppliersListPageState extends State<SuppliersListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      _loadAllSuppliers();
    } else {
      _searchSuppliers(_searchController.text);
    }
  }

  void _loadAllSuppliers() {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    context.read<SupplierBloc>().add(LoadSuppliers(userId: user.id));
  }

  void _searchSuppliers(String query) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    context.read<SupplierBloc>().add(
      SearchSuppliers(userId: user.id, query: query),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return BlocProvider(
      create: (context) =>
          getIt<SupplierBloc>()..add(LoadSuppliers(userId: user.id)),
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching ? _buildSearchField() : const Text('Suppliers'),
          actions: _buildAppBarActions(),
        ),
        body: BlocBuilder<SupplierBloc, SupplierState>(
          builder: (context, state) {
            if (state is SuppliersLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SuppliersLoadFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }

            if (state is SuppliersLoadSuccess) {
              return StreamBuilder<List<Supplier>>(
                stream: state.suppliersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final suppliers = snapshot.data!;
                    return suppliers.isEmpty
                        ? _buildEmptyState()
                        : _buildSuppliersList(suppliers);
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }

            return const Center(child: Text('Load suppliers to get started'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddSupplierPage()),
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
        hintText: 'Search suppliers...',
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
            _loadAllSuppliers();
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
              MaterialPageRoute(builder: (context) => const AddSupplierPage()),
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
          Icon(Icons.business, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Suppliers Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first supplier to manage inventory',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSupplierPage(),
                ),
              );
            },
            child: const Text('Add First Supplier'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuppliersList(List<Supplier> suppliers) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${suppliers.length} supplier${suppliers.length == 1 ? '' : 's'} found',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final supplier = suppliers[index];
              return SupplierCard(supplier: supplier);
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
