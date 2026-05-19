import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String email,
    required String password,
    required String nombre,
    required String telefono,
    required String ci,
    required String direccion,
  });
  Future<UserEntity> getUser(String uid);
  Future<UserEntity> signInWithGoogle();
  Future<void> logout();
}
