import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet_model.dart';

class PetFirestoreDatasource {
  final pets =
      FirebaseFirestore.instance.collection(
    'pets',
  );

  Future<void> createPet(
    PetModel pet,
  ) async {
    await pets.add(
      pet.toMap(),
    );
  }

  Future<void> updatePet(
    PetModel pet,
  ) async {
    await pets.doc(pet.id).update(
          pet.toMap(),
        );
  }

  Future<void> deletePet(
    String id,
  ) async {
    await pets.doc(id).delete();
  }

  Future<List<PetModel>>
      getPetsByOwner(
    String ownerId,
  ) async {
    final snapshot =
        await pets
            .where(
              'ownerId',
              isEqualTo: ownerId,
            )
            .get();

    return snapshot.docs
        .map(
          (e) => PetModel.fromMap(
            e.data(),
            e.id,
          ),
        )
        .toList();
  }
}