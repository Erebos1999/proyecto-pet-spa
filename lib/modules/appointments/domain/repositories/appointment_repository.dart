import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<void> createAppointment(
    AppointmentEntity appointment,
  );

  Future<List<AppointmentEntity>>
      getAppointmentsByDate(
    DateTime date,
  );

  Future<List<String>>
      getAvailableSlots({
    required DateTime date,
    required String groomerId,
    required int durationMinutes,
  });

  Future<List<AppointmentEntity>>
      getAppointmentsByGroomer({
    required String groomerId,
    required DateTime date,
  });
}