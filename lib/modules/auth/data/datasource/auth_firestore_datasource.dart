import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class AuthFirestoreDatasource {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await firestore
        .collection('Usuarios')
        .doc(user.uid)
        .set(user.toMap());
  }
  Future<UserModel> getUser(String uid) async {

  final doc = await firestore
      .collection('Usuarios')
      .doc(uid)
      .get();

  return UserModel.fromMap(doc.data()!);
}
Future<void> incrementFailedLogin(
  String uid,
  int currentAttempts,
) async {

  final attempts =
      currentAttempts + 1;

  DateTime? lockTime;

  if (attempts >= 5) {
    lockTime =
        DateTime.now().add(
      const Duration(
        minutes: 15,
      ),
    );
  }

  await firestore
      .collection('Usuarios')
      .doc(uid)
      .update({
    'failedAttempts': attempts,
    'lockedUntil':
        lockTime?.toIso8601String(),
  });
}
Future<void> resetFailedLogin(
  String uid,
) async {
  await firestore
      .collection('Usuarios')
      .doc(uid)
      .update({
    'failedAttempts': 0,
    'lockedUntil': null,
  });
}
}