import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/supplier_model.dart';

class FirebaseSupplierDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _suppliersCollection =>
      _firestore.collection('suppliers');

  // Create supplier
  Future<String> addSupplier(Supplier supplier) async {
    final docRef = await _suppliersCollection.add(supplier.toFirestore());
    return docRef.id;
  }

  // Get all suppliers for a user
  Stream<List<Supplier>> getSuppliers(String userId) {
    return _suppliersCollection
        .where('createdBy', isEqualTo: userId)
        .orderBy('lastPurchaseDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Supplier.fromFirestore(doc)).toList(),
        );
  }

  // Get supplier by ID
  Future<Supplier?> getSupplier(String supplierId) async {
    final doc = await _suppliersCollection.doc(supplierId).get();
    return doc.exists ? Supplier.fromFirestore(doc) : null;
  }

  // Update supplier
  Future<void> updateSupplier(Supplier supplier) async {
    await _suppliersCollection.doc(supplier.id).update(supplier.toFirestore());
  }

  // Delete supplier
  Future<void> deleteSupplier(String supplierId) async {
    await _suppliersCollection.doc(supplierId).delete();
  }

  // Search suppliers by name or contact
  Stream<List<Supplier>> searchSuppliers(String userId, String query) {
    return _suppliersCollection
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Supplier.fromFirestore(doc))
              .where(
                (supplier) =>
                    supplier.name.toLowerCase().contains(query.toLowerCase()) ||
                    (supplier.contactPerson?.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ??
                        false) ||
                    (supplier.phone?.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ??
                        false),
              )
              .toList(),
        );
  }

  // Update supplier purchase statistics
  Future<void> updateSupplierPurchaseStats({
    required String supplierId,
    required double purchaseAmount,
  }) async {
    final supplierRef = _suppliersCollection.doc(supplierId);
    final supplierDoc = await supplierRef.get();

    if (supplierDoc.exists) {
      final currentData = supplierDoc.data() as Map<String, dynamic>;
      final currentTotal = currentData['totalPurchases']?.toDouble() ?? 0.0;
      final currentProducts = currentData['totalProducts'] ?? 0;

      await supplierRef.update({
        'totalPurchases': currentTotal + purchaseAmount,
        'totalProducts': currentProducts + 1,
        'lastPurchaseDate': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  // Get top suppliers by purchase amount
  Stream<List<Supplier>> getTopSuppliers(String userId, {int limit = 10}) {
    return _suppliersCollection
        .where('createdBy', isEqualTo: userId)
        .orderBy('totalPurchases', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Supplier.fromFirestore(doc)).toList(),
        );
  }
}
