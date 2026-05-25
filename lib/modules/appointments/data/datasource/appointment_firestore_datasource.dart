import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentFirestoreDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<void> createAppointment(
    AppointmentModel appointment,
  ) async {
    await firestore
        .collection('appointments')
        .add(appointment.toMap());
  }

  Future<List<AppointmentModel>> getAppointmentsByDate(
    DateTime date,
  ) async {
    final start =
        DateTime(date.year, date.month, date.day);

    final end =
        start.add(const Duration(days: 1));

    final snapshot = await firestore
        .collection('appointments')
        .where(
          'startTime',
          isGreaterThanOrEqualTo:
              Timestamp.fromDate(start),
        )
        .where(
          'startTime',
          isLessThan:
              Timestamp.fromDate(end),
        )
        .get();

    return snapshot.docs
        .map((e) => AppointmentModel.fromMap(
              e.id,
              e.data(),
            ))
        .toList();
  }
}