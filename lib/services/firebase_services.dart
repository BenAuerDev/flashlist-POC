import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainstorm_array/models/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class FirestoreService {
  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection('groups');

  Stream<List<Group>> groupsForUserStream() {
    try {
      return groupsCollection.snapshots().map((snapshot) {
        return snapshot.docs.where((doc) {
          final permissions = doc['permissions'];
          final owner = permissions['owner'];
          final editors = permissions['editors'] ?? [];

          return owner == currentUser!.uid ||
              editors.contains(currentUser!.uid);
        }).map((doc) {
          return Group(
            doc['title'],
            doc['createdAt'],
            doc.id,
            Color(doc['color']),
            doc['body'],
            doc['permissions'],
          );
        }).toList();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<Group> getGroup(String groupUid) async {
    try {
      final snapshot = await groupsCollection.doc(groupUid).get();
      return Group(
        snapshot['title'],
        snapshot['createdAt'],
        snapshot.id,
        Color(snapshot['color']),
        snapshot['body'],
        snapshot['permissions'],
      );
    } on FirebaseException catch (error) {
      print("Error fetching group: $error");

      return Future.error("Failed to fetch group");
    }
  }

  Future<Group> addGroup(Map<String, dynamic> newGroup) async {
    final newPermissions = {
      'owner': FirebaseAuth.instance.currentUser!.uid,
      'editors': newGroup['editors'],
    };

    try {
      final groupReference = await groupsCollection.add({
        'title': newGroup['title'],
        'createdAt': Timestamp.now(),
        'color': newGroup['color'].value,
        'body': [],
        'permissions': newPermissions,
      });

      return Group(
        newGroup['title'],
        Timestamp.now(),
        groupReference.id,
        newGroup['color'],
        [],
        newPermissions,
      );
    } on FirebaseException catch (error) {
      print("Error creating group: $error");

      return Future.error("Failed to create group");
    }
  }

  Future<Group> editGroup(
      String groupUid, Map<String, dynamic> updatedGroup) async {
    final updatedPermissions = {
      'owner': FirebaseAuth.instance.currentUser!.uid,
      'editors': updatedGroup['editors'],
    };
    try {
      await groupsCollection.doc(groupUid).update({
        'title': updatedGroup['title'],
        'color': updatedGroup['color'].value,
        'permissions': updatedPermissions,
      });

      return Group(
        updatedGroup['title'],
        Timestamp.now(),
        groupUid,
        updatedGroup['color'],
        [],
        updatedPermissions,
      );
    } on FirebaseException catch (error) {
      print("Error editing group: $error");

      return Future.error("Failed to edit group");
    }
  }

  Future<void> removeGroup(String groupUid) async {
    try {
      await groupsCollection.doc(groupUid).delete();
    } on FirebaseException catch (error) {
      print("Error deleting group: $error");

      return Future.error("Failed to delete group");
    }
  }

  Future<List<dynamic>> getBody(String groupUid) async {
    try {
      final group = await getGroup(groupUid);

      return group.body;
    } on FirebaseException catch (error) {
      print("Error fetching body: $error");

      return Future.error("Failed to fetch body");
    }
  }

  FutureOr<String> addItemToBody(String groupUid, String item) async {
    try {
      final group = await getGroup(groupUid);

      var uuid = const Uuid().v4();

      groupsCollection.doc(groupUid).update({
        'body': [
          ...group.body,
          {
            'name': item,
            'uid': uuid,
          }
        ],
      });

      return uuid;
    } on FirebaseException catch (error) {
      print("Error add item to body: $error");

      return Future.error("Failed to add item");
    }
  }

  Future<void> removeItemFromBody(
      String groupUid, Map<String, dynamic> item) async {
    try {
      final group = await getGroup(groupUid);

      final updatedBody =
          group.body.where((element) => element['uid'] != item['uid']);

      groupsCollection.doc(groupUid).update({
        'body': updatedBody.toList(),
      });
    } on FirebaseException catch (error) {
      print("Error removing item to body: $error");

      return Future.error("Failed to remove item");
    }
  }
}
