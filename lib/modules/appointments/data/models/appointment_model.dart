import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    required super.id,
    required super.petId,
    required super.petName,
    required super.ownerId,
    required super.ownerName,
    required super.groomerId,
    required super.groomerName,
    required super.services,
    required super.total,
    required super.durationMinutes,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.notes,
    required super.completedChecklist,
    required super.paymentCompleted,
    required super.paymentMethod,
    required super.createdAt,
    required super.usedProducts,
  });

  factory AppointmentModel.fromMap(String id, Map<String, dynamic> map) {
    return AppointmentModel(
      id: id,
      petId: map['petId'],
      petName: map['petName'] ?? '',
      ownerId: map['ownerId'],
      ownerName: map['ownerName'] ?? '',
      groomerId: map['groomerId'],
      groomerName: map['groomerName'] ?? '',
      services: List<Map<String, dynamic>>.from(map['services']),
      total: (map['total'] as num).toDouble(),
      durationMinutes: map['durationMinutes'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      status: map['status'],
      notes: map['notes'] ?? '',
      completedChecklist: List<String>.from(map['completedChecklist'] ?? []),
      paymentCompleted: map['paymentCompleted'] ?? false,
      paymentMethod: map['paymentMethod'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      usedProducts: List<Map<String, dynamic>>.from(map['usedProducts'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'petName': petName,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'groomerId': groomerId,
      'groomerName': groomerName,
      'services': services,
      'total': total,
      'durationMinutes': durationMinutes,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': status,
      'notes': notes,
      'completedChecklist': completedChecklist,
      'paymentCompleted': paymentCompleted,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'usedProducts': usedProducts,
    };
  }
}
