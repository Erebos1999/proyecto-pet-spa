part of 'appointment_bloc.dart';

sealed class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentCreated extends AppointmentState {}

final class AppointmentLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;

  const AppointmentLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

final class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class AvailableSlotsLoaded extends AppointmentState {
  final List<String> slots;

  const AvailableSlotsLoaded(this.slots);

  @override
  List<Object> get props => [slots];
}
