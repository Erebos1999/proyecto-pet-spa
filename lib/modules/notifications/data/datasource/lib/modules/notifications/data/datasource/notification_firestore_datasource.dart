import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFirestoreDatasource {
  final firestore =
      FirebaseFirestore.instance;

  Future<void> createNotification({
    required String type,
    required String title,
    required String message,
    String? userId,
    String? productId,
    String? appointmentId,
    String? groomerId,
  }) async {
    await firestore
        .collection('notifications')
        .add({
      'type': type,
      'title': title,
      'message': message,
      'userId': userId,
      'productId': productId,
      'appointmentId': appointmentId,
      'groomerId': groomerId,
      'read': false,
      'createdAt':
          Timestamp.now(),
    });
  }
}