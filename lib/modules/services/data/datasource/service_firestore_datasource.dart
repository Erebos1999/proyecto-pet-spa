import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/service_model.dart';

class ServiceFirestoreDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<void> createService(ServiceModel service) async {
    await firestore.collection('services').add(service.toMap());
  }

  Future<List<ServiceModel>> getServices() async {
    final snapshot = await firestore
        .collection('services')
        .where('active', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((e) => ServiceModel.fromMap(e.id, e.data()))
        .toList();
  }
}
