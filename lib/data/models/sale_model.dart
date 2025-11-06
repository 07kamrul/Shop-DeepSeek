import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SaleItem extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double unitBuyingPrice;
  final double unitSellingPrice;

  const SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitBuyingPrice,
    required this.unitSellingPrice,
  });

  double get totalAmount => quantity * unitSellingPrice;
  double get totalProfit => quantity * (unitSellingPrice - unitBuyingPrice);

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitBuyingPrice': unitBuyingPrice,
      'unitSellingPrice': unitSellingPrice,
      'totalAmount': totalAmount,
      'totalProfit': totalProfit,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitBuyingPrice: map['unitBuyingPrice']?.toDouble() ?? 0.0,
      unitSellingPrice: map['unitSellingPrice']?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        productName,
        quantity,
        unitBuyingPrice,
        unitSellingPrice,
      ];
}

class Sale extends Equatable {
  final String? id;
  final DateTime dateTime;
  final List<SaleItem> items;
  final String? customerId;
  final String paymentMethod;
  final double totalAmount;
  final double totalProfit;

  const Sale({
    this.id,
    required this.dateTime,
    required this.items,
    this.customerId,
    required this.paymentMethod,
    required this.totalAmount,
    required this.totalProfit,
  });

  factory Sale.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>)
        .map((item) => SaleItem.fromMap(item as Map<String, dynamic>))
        .toList();

    return Sale(
      id: doc.id,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      items: items,
      customerId: data['customerId'],
      paymentMethod: data['paymentMethod'] ?? 'cash',
      totalAmount: data['totalAmount']?.toDouble() ?? 0.0,
      totalProfit: data['totalProfit']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'dateTime': Timestamp.fromDate(dateTime),
      'items': items.map((item) => item.toMap()).toList(),
      'customerId': customerId,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'totalProfit': totalProfit,
    };
  }

  @override
  List<Object?> get props => [
        id,
        dateTime,
        items,
        customerId,
        paymentMethod,
        totalAmount,
        totalProfit,
      ];
}