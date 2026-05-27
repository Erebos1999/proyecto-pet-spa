class PetEntity {
  final String id;
  final String ownerId;
  final String name;
  final String breed;
  final String size;
  final DateTime birthDate;
  final String temperament;
  final String photoUrl;
  final DateTime createdAt;

  PetEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.breed,
    required this.size,
    required this.birthDate,
    required this.temperament,
    required this.photoUrl,
    required this.createdAt,
  });
}