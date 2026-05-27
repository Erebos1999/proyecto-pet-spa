import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pet_repository.dart';
import '../datasource/pet_firestore_datasource.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl
    implements PetRepository {
  final PetFirestoreDatasource
      datasource;

  PetRepositoryImpl(
      this.datasource);

  @override
  Future<void> createPet(
      PetEntity pet) async {
    await datasource.createPet(
      PetModel(
        id: pet.id,
        ownerId: pet.ownerId,
        name: pet.name,
        breed: pet.breed,
        size: pet.size,
        birthDate:
            pet.birthDate,
        temperament:
            pet.temperament,
        photoUrl:
            pet.photoUrl,
        createdAt:
            pet.createdAt,
      ),
    );
  }

  @override
  Future<List<PetEntity>>
      getPetsByOwner(
    String ownerId,
  ) async {
    return await datasource
        .getPetsByOwner(
            ownerId);
  }
}