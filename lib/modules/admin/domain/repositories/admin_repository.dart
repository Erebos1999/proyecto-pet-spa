import '../../../auth/domain/entities/user_entity.dart';

abstract class AdminRepository {
  Future<void> createEmployee({
    required UserEntity employee,
    required String password,
  });
}