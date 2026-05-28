part of 'appointment_bloc.dart';

sealed class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class CreateAppointmentEvent extends AppointmentEvent {
  final AppointmentEntity appointment;

  const CreateAppointmentEvent(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class LoadAppointmentsByDateEvent extends AppointmentEvent {
  final DateTime date;

  const LoadAppointmentsByDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class LoadAvailableSlotsEvent extends AppointmentEvent {
  final DateTime date;

  final String groomerId;

  final int durationMinutes;

  const LoadAvailableSlotsEvent({
    required this.date,
    required this.groomerId,
    required this.durationMinutes,
  });

  @override
  List<Object> get props => [date, groomerId, durationMinutes];
}
