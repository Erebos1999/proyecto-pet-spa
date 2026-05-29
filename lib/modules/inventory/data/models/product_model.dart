import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
    debugPrint('================');
debugPrint('FROM MAP PRODUCT');
debugPrint('ID: $id');
debugPrint(map.toString());
debugPrint('================');
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      stock: map['stock'] ?? 0,
      minimumStock: map['minimumStock'] ?? 0,
      purchasePrice: map['purchasePrice'] is num
          ? (map['purchasePrice'] as num).toDouble()
          : (map['purchasePrice'] != null && map['purchasePrice'] is String)
              ? double.tryParse(map['purchasePrice']) ?? 0.0
              : 0.0,
      salePrice: map['salePrice'] is num
          ? (map['salePrice'] as num).toDouble()
          : (map['salePrice'] != null && map['salePrice'] is String)
              ? double.tryParse(map['salePrice']) ?? 0.0
              : 0.0,
      active: map['active'] ?? true,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : (map['createdAt'] is String)
              ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
              : DateTime.now(),
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