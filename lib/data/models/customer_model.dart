import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String? id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double totalPurchases;
  final int totalTransactions;
  final DateTime lastPurchaseDate;
  final DateTime createdAt;
  final String createdBy;

  const Customer({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.totalPurchases = 0.0,
    this.totalTransactions = 0,
    required this.lastPurchaseDate,
    required this.createdAt,
    required this.createdBy,
  });

  factory Customer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Customer(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'],
      email: data['email'],
      address: data['address'],
      totalPurchases: data['totalPurchases']?.toDouble() ?? 0.0,
      totalTransactions: data['totalTransactions'] ?? 0,
      lastPurchaseDate: (data['lastPurchaseDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'totalPurchases': totalPurchases,
      'totalTransactions': totalTransactions,
      'lastPurchaseDate': Timestamp.fromDate(lastPurchaseDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? totalPurchases,
    int? totalTransactions,
    DateTime? lastPurchaseDate,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    email,
    address,
    totalPurchases,
    totalTransactions,
    lastPurchaseDate,
    createdAt,
    createdBy,
  ];
}
