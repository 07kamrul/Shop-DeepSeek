import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/data/models/product_model.dart';

class FirebaseProductDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _productsCollection => _firestore.collection('products');

  // Create
  Future<String> addProduct(Product product) async {
    final docRef = await _productsCollection.add(product.toFirestore());
    return docRef.id;
  }

  // Read
  Stream<List<Product>> getProducts() {
    return _productsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }

  Stream<Product> getProduct(String productId) {
    return _productsCollection
        .doc(productId)
        .snapshots()
        .map((doc) => Product.fromFirestore(doc));
  }

  // Update
  Future<void> updateProduct(Product product) async {
    await _productsCollection
        .doc(product.id)
        .update(product.toFirestore());
  }

  // Delete (soft delete)
  Future<void> deleteProduct(String productId) async {
    await _productsCollection
        .doc(productId)
        .update({'isActive': false});
  }

  // Update stock
  Future<void> updateStock(String productId, int newStock) async {
    await _productsCollection
        .doc(productId)
        .update({'currentStock': newStock});
  }

  // Get low stock products
  Stream<List<Product>> getLowStockProducts() {
    return _productsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .where((product) => product.isLowStock)
            .toList());
  }
}