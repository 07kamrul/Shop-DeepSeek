import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sale_model.dart';

class FirebaseSaleDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _salesCollection => _firestore.collection('sales');
  CollectionReference get _productsCollection =>
      _firestore.collection('products');

  // Create sale and update product stock
  Future<String> addSale(Sale sale) async {
    final batch = _firestore.batch();

    // Add sale document
    final saleRef = _salesCollection.doc();
    batch.set(saleRef, sale.toFirestore());

    // Update product stock for each item
    for (final item in sale.items) {
      final productRef = _productsCollection.doc(item.productId);
      batch.update(productRef, {
        'currentStock': FieldValue.increment(-item.quantity),
      });
    }

    await batch.commit();
    return saleRef.id;
  }

  // Get sales for a user
  Stream<List<Sale>> getSales(String userId) {
    return _salesCollection
        .where('createdBy', isEqualTo: userId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Sale.fromFirestore(doc)).toList(),
        );
  }

  // Get sales by date range
  Stream<List<Sale>> getSalesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _salesCollection
        .where('createdBy', isEqualTo: userId)
        .where('dateTime', isGreaterThanOrEqualTo: startDate)
        .where('dateTime', isLessThanOrEqualTo: endDate)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Sale.fromFirestore(doc)).toList(),
        );
  }

  // Get today's sales
  Stream<List<Sale>> getTodaySales(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return getSalesByDateRange(userId, startOfDay, endOfDay);
  }

  // Get sale by ID
  Future<Sale?> getSale(String saleId) async {
    final doc = await _salesCollection.doc(saleId).get();
    return doc.exists ? Sale.fromFirestore(doc) : null;
  }

  // Delete sale and restore stock
  Future<void> deleteSale(Sale sale) async {
    final batch = _firestore.batch();

    // Delete sale
    batch.delete(_salesCollection.doc(sale.id!));

    // Restore product stock
    for (final item in sale.items) {
      final productRef = _productsCollection.doc(item.productId);
      batch.update(productRef, {
        'currentStock': FieldValue.increment(item.quantity),
      });
    }

    await batch.commit();
  }
}
