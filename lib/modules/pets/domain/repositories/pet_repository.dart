import '../entities/pet_entity.dart';

abstract class PetRepository {
  Future<void> createPet(PetEntity pet);

  Future<List<PetEntity>> getPetsByOwner(String ownerId);
  Future<void> updatePet(PetEntity pet);

  Future<void> deletePet(String id);
}
