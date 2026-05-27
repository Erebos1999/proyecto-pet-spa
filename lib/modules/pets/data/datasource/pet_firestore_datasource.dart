import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class PetFirestoreDatasource {
  final firestore =
      FirebaseFirestore.instance;

  Future<void> createPet(
      PetModel pet) async {
    await firestore
        .collection('pets')
        .add(pet.toMap());
  }

  Future<List<PetModel>>
      getPetsByOwner(
    String ownerId,
  ) async {
    final snapshot =
        await firestore
            .collection('pets')
            .where(
              'ownerId',
              isEqualTo:
                  ownerId,
            )
            .get();

    return snapshot.docs
        .map(
          (e) =>
              PetModel.fromMap(
            e.id,
            e.data(),
          ),
        )
        .toList();
  }
}