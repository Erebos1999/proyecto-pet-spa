part of 'pet_bloc.dart';

sealed class PetState
    extends Equatable {
  const PetState();

  @override
  List<Object?> get props => [];
}

final class PetInitial
    extends PetState {}

final class PetLoading
    extends PetState {}

final class PetCreated
    extends PetState {}

final class PetLoaded
    extends PetState {
  final List<PetEntity> pets;

  const PetLoaded(this.pets);

  @override
  List<Object?> get props =>
      [pets];
}

final class PetError
    extends PetState {
  final String message;

  const PetError(
      this.message);

  @override
  List<Object?> get props =>
      [message];
}