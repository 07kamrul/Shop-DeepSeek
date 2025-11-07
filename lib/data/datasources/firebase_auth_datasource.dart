
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

import '../models/user_model.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');

  // Sign Up
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
    required String shopName,
    String? phone,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user!;
      final user = User(
        id: firebaseUser.uid,
        email: email,
        name: name,
        phone: phone,
        shopName: shopName,
        createdAt: DateTime.now(),
        isEmailVerified: false,
      );

      await _usersCollection.doc(firebaseUser.uid).set(user.toFirestore());
      return user;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Sign In
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user!;
      final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
      
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      return User.fromFirestore(userDoc);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get Current User
  Stream<User?> get currentUser {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
      if (!userDoc.exists) return null;
      
      return User.fromFirestore(userDoc);
    });
  }

  // Update Profile
  Future<void> updateProfile(User user) async {
    await _usersCollection.doc(user.id).update(user.toFirestore());
  }

  // Change Password
  Future<void> changePassword(String newPassword) async {
    await _auth.currentUser!.updatePassword(newPassword);
  }
}