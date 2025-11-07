import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String shopName;
  final DateTime createdAt;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.shopName,
    required this.createdAt,
    required this.isEmailVerified,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      shopName: data['shopName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isEmailVerified: data['isEmailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'shopName': shopName,
      'createdAt': Timestamp.fromDate(createdAt),
      'isEmailVerified': isEmailVerified,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? shopName,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      shopName: shopName ?? this.shopName,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        shopName,
        createdAt,
        isEmailVerified,
      ];
}