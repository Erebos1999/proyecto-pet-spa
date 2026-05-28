import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentFirestoreDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<void> createAppointment(AppointmentModel appointment) async {
    await firestore.collection('appointments').add(appointment.toMap());
  }

  Future<List<AppointmentModel>> getAppointmentsByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);

    final end = start.add(const Duration(days: 1));

    final snapshot = await firestore
        .collection('appointments')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startTime', isLessThan: Timestamp.fromDate(end))
        .get();

    return snapshot.docs
        .map((e) => AppointmentModel.fromMap(e.id, e.data()))
        .toList();
  }

  Future<List<String>> getAvailableSlots({
    required DateTime date,
    required String groomerId,
    required int durationMinutes,
  }) async {
    final appointments = await getAppointmentsByDate(date);

    final groomerAppointments = appointments
        .where((e) => e.groomerId == groomerId)
        .toList();

    final List<String> availableSlots = [];

    final startHour = 8;
    final endHour = 18;

    for (int hour = startHour; hour < endHour; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final slotStart = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        final slotEnd = slotStart.add(Duration(minutes: durationMinutes));

        bool overlaps = groomerAppointments.any((appointment) {
          return slotStart.isBefore(appointment.endTime) &&
              slotEnd.isAfter(appointment.startTime);
        });

        if (!overlaps) {
          availableSlots.add(
            '${slotStart.hour.toString().padLeft(2, '0')}:${slotStart.minute.toString().padLeft(2, '0')}',
          );
        }
      }
    }

    return availableSlots;
  }
}
