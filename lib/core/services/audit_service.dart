import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuditService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logAction({
    required String action,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    String platform;

    if (kIsWeb) {
      platform = 'web';
    } else {
      platform = defaultTargetPlatform.name;
    }

    await _firestore.collection('Logs').add({
      'uid': user?.uid ?? 'anonimo',
      'email': user?.email ?? '',
      'action': action,
      'platform': platform,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}