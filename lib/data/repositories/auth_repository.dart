import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<User> signUp({
    required String email,
    required String password,
    required String name,
    required String shopName,
    String? phone,
  }) async {
    return await _dataSource.signUp(
      email: email,
      password: password,
      name: name,
      shopName: shopName,
      phone: phone,
    );
  }

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    return await _dataSource.signIn(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return await _dataSource.signOut();
  }

  Stream<User?> get currentUser {
    return _dataSource.currentUser;
  }

  Future<void> updateProfile(User user) async {
    return await _dataSource.updateProfile(user);
  }

  Future<void> changePassword(String newPassword) async {
    return await _dataSource.changePassword(newPassword);
  }
}