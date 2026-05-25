import 'package:cerberus_pet_spa/core/services/audit_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

import '../datasource/auth_firestore_datasource.dart';
import '../datasource/auth_remote_datasource.dart';

import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthFirestoreDatasource firestoreDatasource;
  final audit = AuditService();

  AuthRepositoryImpl(this.remoteDataSource, this.firestoreDatasource);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    print('A. buscando usuario firestore');
    final snapshot = await firestoreDatasource.firestore
        .collection('Usuarios')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Usuario no encontrado');
    }

    final userData = UserModel.fromMap(snapshot.docs.first.data());

    if (userData.lockedUntil != null &&
        DateTime.now().isBefore(userData.lockedUntil!)) {
      throw Exception('Cuenta bloqueada 15 minutos');
    }

    try {
      print('B. firebase auth login');
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await result.user?.reload();

      final currentUser = FirebaseAuth.instance.currentUser!;
      // VALIDACIÓN DESACTIVADA TEMPORALMENTE

      print('C. email verificado');
      /*if (!currentUser.emailVerified) {
        await remoteDataSource.logout();

        throw Exception('Debes verificar tu correo');
      }*/

      // obtener rol
      final userDoc = await firestoreDatasource.getUser(currentUser.uid);

      print('D. validando 2FA');
      if (userDoc.rol == 'admin' && !userDoc.mfaEnabled) {
        throw Exception('Admin debe registrar 2FA');
      }
      await firestoreDatasource.resetFailedLogin(currentUser.uid);
      await audit.logAction(action: 'login');
      print('E. login terminado');
      return userDoc;
    } on FirebaseAuthException {
      final attempts = userData.failedAttempts + 1;

      await firestoreDatasource.incrementFailedLogin(
        userData.uid,
        userData.failedAttempts,
      );

      if (attempts >= 5) {
        throw Exception('Cuenta bloqueada por 15 minutos');
      }

      final remaining = 5 - attempts;

      throw Exception(
        'Contraseña incorrecta. '
        'Te quedan $remaining intentos.',
      );
    }
  }

  /////////////////////////////////////////
  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String nombre,
    required String telefono,
    required String ci,
    required String direccion,
  }) async {
    final result = await remoteDataSource.register(
      email: email,
      password: password,
    );

    final user = UserModel(
      uid: result.user!.uid,
      email: email,
      nombre: nombre,
      telefono: telefono,
      ci: ci,
      direccion: direccion,
      mfaEnabled: false,
      mfaSecret: '',

      // RBAC
      rol: 'cliente',

      // nunca borrar usuarios
      estado: 'activo',
      failedAttempts: 0,
      lockedUntil: null,
    );

    await firestoreDatasource.saveUser(user);
    await audit.logAction(action: 'register');
    await remoteDataSource.logout();

    return user;
  }

  @override
  Future<UserEntity> getUser(String uid) async {
    return await firestoreDatasource.getUser(uid);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final result = await remoteDataSource.signInWithGoogle();

    final user = result.user!;

    final userModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      nombre: user.displayName ?? '',
      telefono: '',
      ci: '',
      direccion: '',

      rol: 'cliente',
      estado: 'activo',
      failedAttempts: 0,
      lockedUntil: null,
      mfaEnabled: false,
      mfaSecret: '',
    );

    //await firestoreDatasource.saveUser(userModel);
    final doc = await firestoreDatasource.firestore
        .collection('Usuarios')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      await firestoreDatasource.saveUser(userModel);
    }
    await audit.logAction(action: 'google_login');
    return userModel;
  }

  @override
  Future<void> logout() async {
    await audit.logAction(action: 'logout');

    await remoteDataSource.logout();
  }
}
