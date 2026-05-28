part of 'service_bloc.dart';

sealed class ServiceEvent
    extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class CreateServiceEvent
    extends ServiceEvent {
  final ServiceEntity service;

  const CreateServiceEvent(
    this.service,
  );

  @override
  List<Object?> get props =>
      [service];
}

class LoadServicesEvent
    extends ServiceEvent {}