part of 'pet_bloc.dart';

sealed class PetEvent
    extends Equatable {
  const PetEvent();

  @override
  List<Object?> get props => [];
}

class CreatePetEvent
    extends PetEvent {
  final PetEntity pet;

  const CreatePetEvent(
      this.pet);

  @override
  List<Object?> get props => [pet];
}

class LoadPetsEvent
    extends PetEvent {
  final String ownerId;

  const LoadPetsEvent(
      this.ownerId);

  @override
  List<Object?> get props =>
      [ownerId];
}