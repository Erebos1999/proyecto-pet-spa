class AppointmentEntity {
  final String id;
  final String petId;
  final String ownerId;
  final String groomerId;
  final String serviceName;
  final int durationMinutes;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final DateTime createdAt;

  AppointmentEntity({
    required this.id,
    required this.petId,
    required this.ownerId,
    required this.groomerId,
    required this.serviceName,
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
  });
}