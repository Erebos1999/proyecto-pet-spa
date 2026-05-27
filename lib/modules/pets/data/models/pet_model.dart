import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/pet_entity.dart';

class PetModel extends PetEntity {
  PetModel({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.breed,
    required super.size,
    required super.birthDate,
    required super.temperament,
    required super.photoUrl,
    required super.createdAt,
  });

  factory PetModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return PetModel(
      id: id,
      ownerId: map['ownerId'],
      name: map['name'],
      breed: map['breed'],
      size: map['size'],
      birthDate:
          (map['birthDate'] as Timestamp)
              .toDate(),
      temperament:
          map['temperament'],
      photoUrl: map['photoUrl'],
      createdAt:
          (map['createdAt'] as Timestamp)
              .toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'breed': breed,
      'size': size,
      'birthDate':
          Timestamp.fromDate(
              birthDate),
      'temperament':
          temperament,
      'photoUrl': photoUrl,
      'createdAt':
          Timestamp.fromDate(
              createdAt),
    };
  }
}