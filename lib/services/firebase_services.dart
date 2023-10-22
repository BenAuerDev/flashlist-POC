import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainstorm_array/models/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:brainstorm_array/models/user.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class FirestoreService {
  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection('groups');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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

  FutureOr<String> addItemToGroupBody(String groupUid, String item) async {
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

  Future<bool> removeItemFromGroupBody(
      String groupUid, Map<String, dynamic> items) async {
    try {
      final group = await getGroup(groupUid);

      final updatedBody =
          group.body.where((element) => element['uid'] != items['uid']);

      groupsCollection.doc(groupUid).update({
        'body': updatedBody.toList(),
      });
      return true;
    } on FirebaseException catch (error) {
      print("Error removing item to body: $error");

      return Future.error("Failed to remove item");
    }
  }

  Future<bool> setGroupBody(String groupUid, List<dynamic> items) async {
    try {
      groupsCollection.doc(groupUid).update({
        'body': items,
      });
      return true;
    } on FirebaseException catch (error) {
      print("Error setting body: $error");

      return Future.error("Failed to set body");
    }
  }

  // User
  Future<CustomUser?> getUserByUid(String userUid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await userCollection.doc(userUid).get();

      if (documentSnapshot.exists) {
        return CustomUser(
          documentSnapshot['email'],
          documentSnapshot['username'],
          documentSnapshot['uid'],
          documentSnapshot['image_url'],
        );
      } else {
        return null;
      }
    } on FirebaseException catch (error) {
      print("Error fetching user: $error");

      return Future.error("Failed to fetch user");
    }
  }

  Future<CustomUser?> getUserByEmail(String userEmail) async {
    try {
      QuerySnapshot querySnapshot =
          await userCollection.where('email', isEqualTo: userEmail).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        return CustomUser(
          documentSnapshot['email'],
          documentSnapshot['username'],
          documentSnapshot['uid'],
          documentSnapshot['image_url'],
        );
      } else {
        return null;
      }
    } on FirebaseException catch (error) {
      print("Error fetching user: $error");

      return Future.error("Failed to fetch user");
    }
  }

  Future<List<CustomUser>> getUsersByUid(List<dynamic> userUids) {
    try {
      return userCollection
          .where('uid', whereIn: userUids)
          .get()
          .then((value) => value.docs.map((doc) {
                return CustomUser(
                  doc['email'],
                  doc['username'],
                  doc['uid'],
                  doc['image_url'],
                );
              }).toList());
    } on FirebaseException catch (error) {
      print("Error fetching users: $error");

      return Future.error("Failed to fetch users");
    }
  }

  Future<void> uploadUserAvatar(File userImage, String userUid) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('$userUid.jpg');

      await storageRef.putFile(userImage);

      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'image_url': imageUrl,
      });
    } catch (error) {
      print(error);
    }
  }
}
