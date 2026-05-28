import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasource/appointment_firestore_datasource.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentFirestoreDatasource datasource;

  AppointmentRepositoryImpl(this.datasource);

  static const int maxPerGroomer = 4;

  @override
  Future<void> createAppointment(AppointmentEntity appointment) async {
    final existing = await datasource.getAppointmentsByDate(
      appointment.startTime,
    );

    final overlapping = existing.where(
      (e) =>
          e.groomerId == appointment.groomerId &&
          appointment.startTime.isBefore(e.endTime) &&
          appointment.endTime.isAfter(e.startTime),
    );

    if (overlapping.isNotEmpty) {
      throw Exception('El groomer ya tiene una cita en ese horario');
    }

    final sameGroomer = existing
        .where((e) => e.groomerId == appointment.groomerId)
        .length;

    if (sameGroomer >= maxPerGroomer) {
      throw Exception('Capacidad máxima del groomer alcanzada');
    }

    await datasource.createAppointment(
      AppointmentModel(
        id: appointment.id,

        petId: appointment.petId,
        petName: appointment.petName,

        ownerId: appointment.ownerId,
        ownerName: appointment.ownerName,

        groomerId: appointment.groomerId,
        groomerName: appointment.groomerName,

        services: appointment.services,

        total: appointment.total,

        durationMinutes: appointment.durationMinutes,

        startTime: appointment.startTime,

        endTime: appointment.endTime,

        status: appointment.status,

        notes: appointment.notes,

        completedChecklist: appointment.completedChecklist,

        paymentCompleted: appointment.paymentCompleted,

        paymentMethod: appointment.paymentMethod,

        createdAt: appointment.createdAt,
      ),
    );
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByDate(DateTime date) async {
    return await datasource.getAppointmentsByDate(date);
  }

  @override
  Future<List<String>> getAvailableSlots({
    required DateTime date,
    required String groomerId,
    required int durationMinutes,
  }) async {
    return datasource.getAvailableSlots(
      date: date,
      groomerId: groomerId,
      durationMinutes: durationMinutes,
    );
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByGroomer({
    required String groomerId,
    required DateTime date,
  }) async {
    return datasource.getAppointmentsByGroomer(
      groomerId: groomerId,
      date: date,
    );
  }
}
