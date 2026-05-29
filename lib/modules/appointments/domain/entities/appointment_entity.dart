class AppointmentEntity {
  final String id;

  final String petId;
  final String petName;

  final String ownerId;
  final String ownerName;

  final String groomerId;
  final String groomerName;

  final List<Map<String, dynamic>> services;

  final double total;

  final int durationMinutes;

  final DateTime startTime;
  final DateTime endTime;

  final String status;

  final String notes;

  final List<String> completedChecklist;

  final List<Map<String, dynamic>> usedProducts;

  final bool paymentCompleted;

  final String paymentMethod;

  final DateTime createdAt;

  AppointmentEntity({
    required this.id,
    required this.petId,
    required this.petName,
    required this.ownerId,
    required this.ownerName,
    required this.groomerId,
    required this.groomerName,
    required this.services,
    required this.total,
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.notes,
    required this.completedChecklist,
    required this.usedProducts,
    required this.paymentCompleted,
    required this.paymentMethod,
    required this.createdAt,
  });
}