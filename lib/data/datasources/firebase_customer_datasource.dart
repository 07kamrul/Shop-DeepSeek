import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/customer_model.dart';

class FirebaseCustomerDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _customersCollection =>
      _firestore.collection('customers');

  // Create customer
  Future<String> addCustomer(Customer customer) async {
    final docRef = await _customersCollection.add(customer.toFirestore());
    return docRef.id;
  }

  // Get all customers for a user
  Stream<List<Customer>> getCustomers(String userId) {
    return _customersCollection
        .where('createdBy', isEqualTo: userId)
        .orderBy('lastPurchaseDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Customer.fromFirestore(doc)).toList(),
        );
  }

  // Get customer by ID
  Future<Customer?> getCustomer(String customerId) async {
    final doc = await _customersCollection.doc(customerId).get();
    return doc.exists ? Customer.fromFirestore(doc) : null;
  }

  // Update customer
  Future<void> updateCustomer(Customer customer) async {
    await _customersCollection.doc(customer.id).update(customer.toFirestore());
  }

  // Delete customer
  Future<void> deleteCustomer(String customerId) async {
    await _customersCollection.doc(customerId).delete();
  }

  // Search customers by name or phone
  Stream<List<Customer>> searchCustomers(String userId, String query) {
    return _customersCollection
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Customer.fromFirestore(doc))
              .where(
                (customer) =>
                    customer.name.toLowerCase().contains(query.toLowerCase()) ||
                    (customer.phone?.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ??
                        false),
              )
              .toList(),
        );
  }

  // Update customer purchase statistics
  Future<void> updateCustomerPurchaseStats({
    required String customerId,
    required double purchaseAmount,
  }) async {
    final customerRef = _customersCollection.doc(customerId);
    final customerDoc = await customerRef.get();

    if (customerDoc.exists) {
      final currentData = customerDoc.data() as Map<String, dynamic>;
      final currentTotal = currentData['totalPurchases']?.toDouble() ?? 0.0;
      final currentTransactions = currentData['totalTransactions'] ?? 0;

      await customerRef.update({
        'totalPurchases': currentTotal + purchaseAmount,
        'totalTransactions': currentTransactions + 1,
        'lastPurchaseDate': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  // Get top customers by purchase amount
  Stream<List<Customer>> getTopCustomers(String userId, {int limit = 10}) {
    return _customersCollection
        .where('createdBy', isEqualTo: userId)
        .orderBy('totalPurchases', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Customer.fromFirestore(doc)).toList(),
        );
  }
}
