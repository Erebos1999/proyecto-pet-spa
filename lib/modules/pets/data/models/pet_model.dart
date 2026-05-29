import '../../domain/entities/pet_entity.dart';

class PetModel extends PetEntity {
  PetModel({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.species,
    required super.breed,
    required super.size,
    required super.sex,
    required super.weight,
    required super.temperament,
    required super.vaccines,
    required super.allergies,
    required super.observations,
    required super.photoUrl,
    required super.birthDate,
    required super.createdAt,
  });

  factory PetModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return PetModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      species: map['species'] ?? '',
      breed: map['breed'] ?? '',
      size: map['size'] ?? '',
      sex: map['sex'] ?? '',
      weight:
          (map['weight'] ?? 0)
              .toDouble(),
      temperament:
          map['temperament'] ?? '',
      vaccines:
          map['vaccines'] ?? '',
      allergies:
          map['allergies'] ?? '',
      observations:
          map['observations'] ?? '',
      photoUrl:
          map['photoUrl'] ?? '',
      birthDate:
          DateTime.parse(
        map['birthDate'],
      ),
      createdAt:
          DateTime.parse(
        map['createdAt'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'species': species,
      'breed': breed,
      'size': size,
      'sex': sex,
      'weight': weight,
      'temperament': temperament,
      'vaccines': vaccines,
      'allergies': allergies,
      'observations':
          observations,
      'photoUrl': photoUrl,
      'birthDate':
          birthDate
              .toIso8601String(),
      'createdAt':
          createdAt
              .toIso8601String(),
    };
  }
}