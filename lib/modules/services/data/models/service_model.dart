import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.duration,
    required super.active,
    required super.createdAt,
  });

  factory ServiceModel.fromMap(String id, Map<String, dynamic> map) {
    return ServiceModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      duration: map['duration'] ?? 30,
      active: map['active'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'active': active,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
