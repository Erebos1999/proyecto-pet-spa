import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<void> createAppointment(AppointmentEntity appointment);

  Future<List<AppointmentEntity>> getAppointmentsByDate(
    DateTime date,
  );
}