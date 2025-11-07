import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final String? id;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final double totalPurchases;
  final int totalProducts;
  final DateTime lastPurchaseDate;
  final DateTime createdAt;
  final String createdBy;

  const Supplier({
    this.id,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.totalPurchases = 0.0,
    this.totalProducts = 0,
    required this.lastPurchaseDate,
    required this.createdAt,
    required this.createdBy,
  });

  factory Supplier.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Supplier(
      id: doc.id,
      name: data['name'] ?? '',
      contactPerson: data['contactPerson'],
      phone: data['phone'],
      email: data['email'],
      address: data['address'],
      totalPurchases: data['totalPurchases']?.toDouble() ?? 0.0,
      totalProducts: data['totalProducts'] ?? 0,
      lastPurchaseDate: (data['lastPurchaseDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'address': address,
      'totalPurchases': totalPurchases,
      'totalProducts': totalProducts,
      'lastPurchaseDate': Timestamp.fromDate(lastPurchaseDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  Supplier copyWith({
    String? id,
    String? name,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    double? totalPurchases,
    int? totalProducts,
    DateTime? lastPurchaseDate,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalProducts: totalProducts ?? this.totalProducts,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    contactPerson,
    phone,
    email,
    address,
    totalPurchases,
    totalProducts,
    lastPurchaseDate,
    createdAt,
    createdBy,
  ];
}
