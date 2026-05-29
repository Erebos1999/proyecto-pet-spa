class PetEntity {
  final String id;

  final String ownerId;

  final String name;

  final String species;

  final String breed;

  final String size;

  final String sex;

  final double weight;

  final String temperament;

  final String vaccines;

  final String allergies;

  final String observations;

  final String photoUrl;

  final DateTime birthDate;

  final DateTime createdAt;

  PetEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    required this.breed,
    required this.size,
    required this.sex,
    required this.weight,
    required this.temperament,
    required this.vaccines,
    required this.allergies,
    required this.observations,
    required this.photoUrl,
    required this.birthDate,
    required this.createdAt,
  });
}