import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.stock,
    required super.minimumStock,
    required super.purchasePrice,
    required super.salePrice,
    required super.active,
    required super.createdAt,
  });

  factory ProductModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      stock: map['stock'] ?? 0,
      minimumStock: map['minimumStock'] ?? 0,
      purchasePrice: (map['purchasePrice'] as num).toDouble(),
      salePrice: (map['salePrice'] as num).toDouble(),
      active: map['active'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'stock': stock,
      'minimumStock': minimumStock,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'active': active,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}