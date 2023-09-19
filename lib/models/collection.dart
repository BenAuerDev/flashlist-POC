import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  final String title;
  final Timestamp createdAt;
  final String uid;
  final List<dynamic> array;

  Collection(this.title, this.createdAt, this.uid, this.array);
}
