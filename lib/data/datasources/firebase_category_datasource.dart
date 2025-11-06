import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/data/models/category_model.dart';

class FirebaseCategoryDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _categoriesCollection => _firestore.collection('categories');

  Future<String> addCategory(Category category) async {
    final docRef = await _categoriesCollection.add(category.toFirestore());
    return docRef.id;
  }

  Stream<List<Category>> getCategories(String userId) {
    return _categoriesCollection
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Category.fromFirestore(doc))
            .toList());
  }

  Future<void> updateCategory(Category category) async {
    await _categoriesCollection
        .doc(category.id)
        .update(category.toFirestore());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoriesCollection.doc(categoryId).delete();
  }

  Future<Category?> getCategory(String categoryId) async {
    final doc = await _categoriesCollection.doc(categoryId).get();
    return doc.exists ? Category.fromFirestore(doc) : null;
  }
}