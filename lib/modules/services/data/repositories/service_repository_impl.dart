import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasource/service_firestore_datasource.dart';
import '../models/service_model.dart';

class ServiceRepositoryImpl
    implements ServiceRepository {
  final ServiceFirestoreDatasource
      datasource;

  ServiceRepositoryImpl(
    this.datasource,
  );

  @override
  Future<void> createService(
    ServiceEntity service,
  ) async {
    await datasource.createService(
      ServiceModel(
        id: service.id,

        name: service.name,

        description:
            service.description,

        price: service.price,

        duration:
            service.duration,

        active:
            service.active,

        createdAt:
            service.createdAt,
      ),
    );
  }

  @override
  Future<List<ServiceEntity>>
      getServices() async {
    return await datasource
        .getServices();
  }
}