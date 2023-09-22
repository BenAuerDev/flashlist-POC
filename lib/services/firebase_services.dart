import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainstorm_array/models/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final CollectionReference collectionsCollection =
      FirebaseFirestore.instance.collection('collections');

  Future<List<Collection>> getCollections() async {
    try {
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
    } on FirebaseException catch (error) {
      print("Error fetching collections: $error");

      return Future.error("Failed to fetch collections");
    }
  }

  Future<Collection> getCollection(String collectionUid) async {
    try {
      final snapshot = await collectionsCollection.doc(collectionUid).get();
      return Collection(
        snapshot['title'],
        snapshot['createdAt'],
        snapshot.id,
        Color(snapshot['color']),
        snapshot['array'],
      );
    } on FirebaseException catch (error) {
      print("Error fetching collection: $error");

      return Future.error("Failed to fetch collection");
    }
  }

  Future<Collection> addCollection(Map<String, dynamic> newCollection) async {
    try {
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
    } on FirebaseException catch (error) {
      print("Error creating collection: $error");

      return Future.error("Failed to create collection");
    }
  }

  Future<Collection> editCollection(
      String collectionUid, Map<String, dynamic> updatedCollection) async {
    try {
      await collectionsCollection.doc(collectionUid).update({
        'title': updatedCollection['title'],
        'color': updatedCollection['color'].value,
      });

      return Collection(
        updatedCollection['title'],
        Timestamp.now(),
        collectionUid,
        updatedCollection['color'],
        [],
      );
    } on FirebaseException catch (error) {
      print("Error editing collection: $error");

      return Future.error("Failed to edit collection");
    }
  }

  Future<void> removeCollection(String collectionUid) async {
    try {
      await collectionsCollection.doc(collectionUid).delete();
    } on FirebaseException catch (error) {
      print("Error deleting collection: $error");

      return Future.error("Failed to delete collection");
    }
  }

  Future<List<dynamic>> getArray(String collectionUid) async {
    try {
      final collection = await getCollection(collectionUid);

      return collection.array;
    } on FirebaseException catch (error) {
      print("Error fetching array: $error");

      return Future.error("Failed to fetch array");
    }
  }

  FutureOr<String> addItemToArray(String collectionUid, String item) async {
    try {
      final collection = await getCollection(collectionUid);

      var uuid = const Uuid().v4();

      collectionsCollection.doc(collectionUid).update({
        'array': [
          ...collection.array,
          {
            'name': item,
            'uid': uuid,
          }
        ],
      });

      return uuid;
    } on FirebaseException catch (error) {
      print("Error add item to array: $error");

      return Future.error("Failed to add item");
    }
  }

  Future<void> removeItemFromArray(
      String collectionUid, Map<String, dynamic> item) async {
    try {
      final collection = await getCollection(collectionUid);

      final updatedArray =
          collection.array.where((element) => element['uid'] != item['uid']);

      collectionsCollection.doc(collectionUid).update({
        'array': updatedArray.toList(),
      });
    } on FirebaseException catch (error) {
      print("Error removing item to array: $error");

      return Future.error("Failed to remove item");
    }
  }
}
