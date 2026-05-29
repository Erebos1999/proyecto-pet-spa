import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/entities/appointment_entity.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepositoryImpl repository;

  AppointmentBloc(this.repository) : super(AppointmentInitial()) {
    on<CreateAppointmentEvent>(_createAppointment);

    on<LoadAppointmentsByDateEvent>(_loadAppointments);
    on<LoadAvailableSlotsEvent>(_loadAvailableSlots);
  }

  Future<void> _createAppointment(
    CreateAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoading());

      await repository.createAppointment(event.appointment);

      emit(AppointmentCreated());
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _loadAppointments(
    LoadAppointmentsByDateEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoading());

      final data = await repository.getAppointmentsByDate(event.date);

      emit(AppointmentLoaded(data));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _loadAvailableSlots(
    LoadAvailableSlotsEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoading());

      final slots = await repository.getAvailableSlots(
        date: event.date,
        groomerId: event.groomerId,
        durationMinutes: event.durationMinutes,
      );

      emit(AvailableSlotsLoaded(slots));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
