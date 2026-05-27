import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasource/pet_firestore_datasource.dart';
import '../../data/repositories/pet_repository_impl.dart';
import '../../domain/entities/pet_entity.dart';

part 'pet_event.dart';
part 'pet_state.dart';

class PetBloc
    extends Bloc<PetEvent, PetState> {
  final repository =
      PetRepositoryImpl(
    PetFirestoreDatasource(),
  );

  PetBloc() : super(PetInitial()) {
    on<CreatePetEvent>(
        _createPet);
    on<LoadPetsEvent>(
        _loadPets);
  }

  Future<void> _createPet(
    CreatePetEvent event,
    Emitter<PetState> emit,
  ) async {
    try {
      emit(PetLoading());

      await repository
          .createPet(event.pet);

      emit(PetCreated());
    } catch (e) {
      emit(
        PetError(
            e.toString()),
      );
    }
  }

  Future<void> _loadPets(
    LoadPetsEvent event,
    Emitter<PetState> emit,
  ) async {
    try {
      emit(PetLoading());

      final pets =
          await repository
              .getPetsByOwner(
        event.ownerId,
      );

      emit(PetLoaded(pets));
    } catch (e) {
      emit(
        PetError(
            e.toString()),
      );
    }
  }
}