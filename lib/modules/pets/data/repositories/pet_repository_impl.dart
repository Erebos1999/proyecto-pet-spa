import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pet_repository.dart';
import '../datasource/pet_firestore_datasource.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl
    implements PetRepository {
  final PetFirestoreDatasource
      datasource;

  PetRepositoryImpl(
    this.datasource,
  );

  @override
  Future<void> createPet(
    PetEntity pet,
  ) async {
    final model = PetModel(
      id: pet.id,
      ownerId: pet.ownerId,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      size: pet.size,
      sex: pet.sex,
      weight: pet.weight,
      temperament:
          pet.temperament,
      vaccines: pet.vaccines,
      allergies: pet.allergies,
      observations:
          pet.observations,
      photoUrl: pet.photoUrl,
      birthDate: pet.birthDate,
      createdAt: pet.createdAt,
    );

    await datasource.createPet(
      model,
    );
  }

  @override
  Future<void> updatePet(
    PetEntity pet,
  ) async {
    final model = PetModel(
      id: pet.id,
      ownerId: pet.ownerId,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      size: pet.size,
      sex: pet.sex,
      weight: pet.weight,
      temperament:
          pet.temperament,
      vaccines: pet.vaccines,
      allergies: pet.allergies,
      observations:
          pet.observations,
      photoUrl: pet.photoUrl,
      birthDate: pet.birthDate,
      createdAt: pet.createdAt,
    );

    await datasource.updatePet(
      model,
    );
  }

  @override
  Future<void> deletePet(
    String id,
  ) async {
    await datasource.deletePet(
      id,
    );
  }

  @override
  Future<List<PetEntity>>
      getPetsByOwner(
    String ownerId,
  ) async {
    return await datasource
        .getPetsByOwner(
      ownerId,
    );
  }
}