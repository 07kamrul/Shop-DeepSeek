import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String name;
  final String? barcode;
  final String categoryId;
  final double buyingPrice;
  final double sellingPrice;
  final int currentStock;
  final int minStockLevel;
  final String? supplierId;
  final DateTime createdAt;
  final bool isActive;

  const Product({
    this.id,
    required this.name,
    this.barcode,
    required this.categoryId,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.currentStock,
    this.minStockLevel = 10,
    this.supplierId,
    required this.createdAt,
    this.isActive = true,
  });

  double get profitPerUnit => sellingPrice - buyingPrice;
  double get profitMargin => (profitPerUnit / sellingPrice) * 100;
  bool get isLowStock => currentStock <= minStockLevel;

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      barcode: data['barcode'],
      categoryId: data['categoryId'] ?? '',
      buyingPrice: data['buyingPrice']?.toDouble() ?? 0.0,
      sellingPrice: data['sellingPrice']?.toDouble() ?? 0.0,
      currentStock: data['currentStock'] ?? 0,
      minStockLevel: data['minStockLevel'] ?? 10,
      supplierId: data['supplierId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'barcode': barcode,
      'categoryId': categoryId,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'currentStock': currentStock,
      'minStockLevel': minStockLevel,
      'supplierId': supplierId,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? barcode,
    String? categoryId,
    double? buyingPrice,
    double? sellingPrice,
    int? currentStock,
    int? minStockLevel,
    String? supplierId,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      currentStock: currentStock ?? this.currentStock,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      supplierId: supplierId ?? this.supplierId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        barcode,
        categoryId,
        buyingPrice,
        sellingPrice,
        currentStock,
        minStockLevel,
        supplierId,
        createdAt,
        isActive,
      ];
}