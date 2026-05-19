import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../auth/data/models/user_model.dart';

class AdminFirestoreDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createEmployee({
    required UserModel employee,
    required String password,
  }) async {
    //final secondaryApp = await FirebaseAuth.instance.app.options;

    final secondaryAuth = FirebaseAuth.instanceFor(
      app: FirebaseAuth.instance.app,
    );

    final credential = await secondaryAuth.createUserWithEmailAndPassword(
      email: employee.email,
      password: password,
    );

    final newUser = UserModel(
      uid: credential.user!.uid,
      email: employee.email,
      nombre: employee.nombre,
      telefono: employee.telefono,
      ci: employee.ci,
      direccion: employee.direccion,
      rol: employee.rol,
      estado: employee.estado,
      failedAttempts: 0,
      lockedUntil: null,
      mfaEnabled: false,
      mfaSecret: '',
    );

    await firestore
        .collection('Usuarios')
        .doc(newUser.uid)
        .set(newUser.toMap());

    await credential.user?.sendEmailVerification();

    await secondaryAuth.signOut();
  }
}
