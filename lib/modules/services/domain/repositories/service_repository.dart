import '../entities/service_entity.dart';

abstract class ServiceRepository {
  Future<void> createService(
    ServiceEntity service,
  );

  Future<List<ServiceEntity>>
      getServices();
}