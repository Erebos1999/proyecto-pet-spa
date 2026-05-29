import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/service_repository_impl.dart';
import '../../domain/entities/service_entity.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepositoryImpl repository;

  ServiceBloc(this.repository) : super(ServiceInitial()) {
    on<CreateServiceEvent>(_createService);

    on<LoadServicesEvent>(_loadServices);
  }

  Future<void> _createService(
    CreateServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());

      await repository.createService(event.service);

      emit(ServiceCreated());
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> _loadServices(
    LoadServicesEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());

      final services = await repository.getServices();

      emit(ServiceLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }
}
