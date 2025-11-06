import '../datasources/firebase_customer_datasource.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final FirebaseCustomerDataSource _dataSource;

  CustomerRepository(this._dataSource);

  Future<String> addCustomer(Customer customer) async {
    return await _dataSource.addCustomer(customer);
  }

  Stream<List<Customer>> getCustomers(String userId) {
    return _dataSource.getCustomers(userId);
  }

  Future<Customer?> getCustomer(String customerId) async {
    return await _dataSource.getCustomer(customerId);
  }

  Future<void> updateCustomer(Customer customer) async {
    return await _dataSource.updateCustomer(customer);
  }

  Future<void> deleteCustomer(String customerId) async {
    return await _dataSource.deleteCustomer(customerId);
  }

  Stream<List<Customer>> searchCustomers(String userId, String query) {
    return _dataSource.searchCustomers(userId, query);
  }

  Future<void> updateCustomerPurchaseStats({
    required String customerId,
    required double purchaseAmount,
  }) async {
    return await _dataSource.updateCustomerPurchaseStats(
      customerId: customerId,
      purchaseAmount: purchaseAmount,
    );
  }

  Stream<List<Customer>> getTopCustomers(String userId, {int limit = 10}) {
    return _dataSource.getTopCustomers(userId, limit: limit);
  }
}
