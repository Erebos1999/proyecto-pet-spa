import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    required super.id,
    required super.petId,
    required super.ownerId,
    required super.groomerId,
    required super.serviceName,
    required super.durationMinutes,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.createdAt,
  });

  factory AppointmentModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return AppointmentModel(
      id: id,
      petId: map['petId'],
      ownerId: map['ownerId'],
      groomerId: map['groomerId'],
      serviceName: map['serviceName'],
      durationMinutes: map['durationMinutes'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'ownerId': ownerId,
      'groomerId': groomerId,
      'serviceName': serviceName,
      'durationMinutes': durationMinutes,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}