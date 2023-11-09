import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  UserNotification(
    this.title,
    this.body,
    this.uid,
    this.data,
    this.createdAt,
    this.isRead,
  );

  final String title;
  final String body;
  final String uid;
  final Map<String, dynamic>? data;
  final Timestamp createdAt;
  bool isRead;
}
