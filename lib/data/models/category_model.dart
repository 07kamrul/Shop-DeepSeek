import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? id;
  final String name;
  final String? parentCategoryId;
  final String? description;
  final double? profitMarginTarget;
  final DateTime createdAt;
  final String createdBy;

  const Category({
    this.id,
    required this.name,
    this.parentCategoryId,
    this.description,
    this.profitMarginTarget,
    required this.createdAt,
    required this.createdBy,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      parentCategoryId: data['parentCategoryId'],
      description: data['description'],
      profitMarginTarget: data['profitMarginTarget']?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'parentCategoryId': parentCategoryId,
      'description': description,
      'profitMarginTarget': profitMarginTarget,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? parentCategoryId,
    String? description,
    double? profitMarginTarget,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      description: description ?? this.description,
      profitMarginTarget: profitMarginTarget ?? this.profitMarginTarget,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        parentCategoryId,
        description,
        profitMarginTarget,
        createdAt,
        createdBy,
      ];
}