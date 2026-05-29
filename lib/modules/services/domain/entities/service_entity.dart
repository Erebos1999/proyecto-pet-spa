class ServiceEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;
  final bool active;
  final DateTime createdAt;

  ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.active,
    required this.createdAt,
  });
}
