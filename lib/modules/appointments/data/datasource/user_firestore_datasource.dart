import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getGroomers() async {
    final snapshot = await firestore
        .collection('Usuarios')
        .where('rol', isEqualTo: 'groomer')
        .where('estado', isEqualTo: 'activo')
        .get();

    return snapshot.docs.map((e) => {'id': e.id, ...e.data()}).toList();
  }
}
