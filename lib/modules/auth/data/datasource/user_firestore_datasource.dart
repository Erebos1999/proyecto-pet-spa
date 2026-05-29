import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<String?> getUserEmail(String userId) async {
    try {
      final doc = await firestore.collection('Usuarios').doc(userId).get();

      if (!doc.exists) return null;

      final data = doc.data();

      return data?['email'];
    } catch (e) {
      print('ERROR GET USER EMAIL: $e');

      return null;
    }
  }

  Future<List<String>> getAdminEmails() async {
    try {
      final snapshot = await firestore
          .collection('Usuarios')
          .where('role', isEqualTo: 'admin')
          .get();

      return snapshot.docs.map((e) => e.data()['email'] as String).toList();
    } catch (e) {
      print('ERROR GET ADMIN EMAILS: $e');

      return [];
    }
  }
}
