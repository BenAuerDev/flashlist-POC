import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainstorm_array/models/collection.dart';
import 'package:flutter/material.dart';

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
        Color(doc['color']),
        doc['array'],
      );
    }).toList();
  }

  Future<Collection> getCollection(String collectionUid) async {
    final snapshot = await collectionsCollection.doc(collectionUid).get();
    return Collection(
      snapshot['title'],
      snapshot['createdAt'],
      snapshot.id,
      Color(snapshot['color']),
      snapshot['array'],
    );
  }

  Future<Collection> addCollection(Map<String, dynamic> newCollection) async {
    final collectionReference = await collectionsCollection.add({
      'title': newCollection['title'],
      'createdAt': Timestamp.now(),
      'color': newCollection['color'].value,
      'array': [],
    });

    return Collection(
      newCollection['title'],
      Timestamp.now(),
      collectionReference.id,
      newCollection['color'],
      [],
    );
  }

  Future<String> addItemToArray(String collectionUid, String item) async {
    final collection = await getCollection(collectionUid);

    collectionsCollection.doc(collectionUid).update({
      'array': [...collection.array, item],
    });

    return item;
  }
}
