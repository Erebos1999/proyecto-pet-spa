import '../../domain/repositories/admin_repository.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../datasource/admin_firestore_datasource.dart';

class AdminRepositoryImpl
    implements AdminRepository {

  final AdminFirestoreDatasource datasource;

  AdminRepositoryImpl(this.datasource);

  @override
  Future<void> createEmployee({
    required UserEntity employee,
    required String password,
  }) async {
    await datasource.createEmployee(
      employee: employee as UserModel,
      password: password,
    );
  }
}