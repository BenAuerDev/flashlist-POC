import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainstorm_array/models/collection.dart';

class FirestoreService {
  final CollectionReference collectionsCollection =
      FirebaseFirestore.instance.collection('collections');

  Future<List<Collection>> getCollections() async {
    final snapshot = await collectionsCollection.get();
    return snapshot.docs.map((doc) {
      return Collection(
        doc['title'],
        doc['createdAt'],
        doc.id,
        doc['array'],
      );
    }).toList();
  }

  Future<Collection> addCollection(dynamic newCollection) async {
    final res = await collectionsCollection.add({
      'title': newCollection,
      'createdAt': Timestamp.now(),
      'array': [],
    });

    return Collection(
      newCollection,
      Timestamp.now(),
      res.id,
      [],
    );
  }
}
