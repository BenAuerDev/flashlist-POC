import 'dart:async';
import 'dart:io';

import 'package:flashlist/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashlist/models/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flashlist/models/user.dart';

class FirestoreService {
  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection('groups');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  GroupPermissions buildGroupPermission(doc) {
    return GroupPermissions(
      doc['permissions']['owner'] as String,
      List<String>.from(doc['permissions']['editors']),
    );
  }

  List<GroupBodyItem> buildGroupBody(doc) {
    return List<GroupBodyItem>.from(
      doc['body'].map(
        (item) => GroupBodyItem(
          name: item['name'],
          uid: item['uid'],
        ),
      ),
    );
  }

  List<Map<String, String>> destructureGroupBody(List<GroupBodyItem> body) {
    return body.map((item) {
      return {
        'name': item.name,
        'uid': item.uid,
      };
    }).toList();
  }

  Stream<List<Group>> groupsForUserStream() {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      return groupsCollection.orderBy('createdAt').snapshots().map((snapshot) {
        return snapshot.docs.where((doc) {
          final permissions = doc['permissions'];
          final owner = permissions['owner'];
          final editors = permissions['editors'] ?? [];

          return owner == currentUser!.uid || editors.contains(currentUser.uid);
        }).map((doc) {
          return Group(
            doc['title'],
            doc['createdAt'],
            doc.id,
            Color(doc['color']),
            buildGroupBody(doc),
            buildGroupPermission(doc),
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
        buildGroupBody(snapshot),
        buildGroupPermission(snapshot),
      );
    } on FirebaseException catch (error) {
      print("Error fetching group: $error");

      return Future.error("Failed to fetch group");
    }
  }

  Future<Group> addGroup(GroupDTO newGroup) async {
    final newPermissions = {
      'owner': FirebaseAuth.instance.currentUser!.uid,
      'editors': [],
    };

    try {
      final groupReference = await groupsCollection.add({
        'title': newGroup.title,
        'createdAt': Timestamp.now(),
        'color': newGroup.color!.value,
        'body': [],
        'permissions': newPermissions,
      });

      return Group(
        newGroup.title,
        Timestamp.now(),
        groupReference.id,
        newGroup.color,
        [],
        GroupPermissions(
          newPermissions['owner'] as String,
          newPermissions['editors'] as List<String>,
        ),
      );
    } on FirebaseException catch (error) {
      print("Error creating group: $error");

      return Future.error("Failed to create group");
    }
  }

  Future<Group> editGroup(GroupDTO updatedGroup) async {
    try {
      final group = await getGroup(updatedGroup.uid!);

      await groupsCollection.doc(updatedGroup.uid).update({
        'title': updatedGroup.title,
        'color': updatedGroup.color!.value,
      });

      return Group(
        updatedGroup.title,
        Timestamp.now(),
        updatedGroup.uid!,
        updatedGroup.color,
        [],
        group.permissions,
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

  Stream<List<GroupBodyItem>> groupBodyStream(String groupUid) {
    try {
      return groupsCollection
          .doc(groupUid)
          .snapshots()
          .map((snapshot) => buildGroupBody(snapshot));
    } on FirebaseException catch (error) {
      print("Error fetching group body: $error");

      return Stream.error("Failed to fetch group body");
    }
  }

  Future<String> addItemToGroupBody(String groupUid, String item) async {
    try {
      final group = await getGroup(groupUid);

      var uuid = const Uuid().v4();

      groupsCollection.doc(groupUid).update({
        'body': [
          ...group.body.map((GroupBodyItem item) => {
                'name': item.name,
                'uid': item.uid,
              }),
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

  Future<void> removeItemFromGroupBody(String groupUid, String itemUid) async {
    try {
      final group = await getGroup(groupUid);

      final updatedBody =
          group.body.where((element) => element.uid != itemUid).toList();

      groupsCollection.doc(groupUid).update({
        'body': destructureGroupBody(updatedBody),
      });
    } on FirebaseException catch (error) {
      print("Error removing item to body: $error");

      return Future.error("Failed to remove item");
    }
  }

  Future<bool> setGroupBody(String groupUid, List<GroupBodyItem> items) async {
    try {
      groupsCollection.doc(groupUid).update({
        'body': destructureGroupBody(items),
      });
      return true;
    } on FirebaseException catch (error) {
      print("Error setting body: $error");

      return Future.error("Failed to set body");
    }
  }

  Stream<List<CustomUser>> getGroupEditors(String groupUid) {
    try {
      return groupsCollection
          .doc(groupUid)
          .snapshots()
          .map((snapshot) => snapshot['permissions']['editors'])
          .asyncMap((userUids) {
        if (userUids == null || userUids.isEmpty) {
          return [];
        }
        return getUsersByUid(userUids);
      });
    } on FirebaseException catch (error) {
      print("Error fetching group editors: $error");

      return Stream.error("Failed to fetch group editors");
    }
  }

  Future<void> removeEditorFromGroup(String groupUid, String editorUid) async {
    try {
      final group = await getGroup(groupUid);

      final updatedEditors =
          group.permissions.editors.where((uid) => uid != editorUid);

      groupsCollection.doc(groupUid).update({
        'permissions': {
          'owner': group.permissions.owner,
          'editors': updatedEditors.toList(),
        }
      });
    } on FirebaseException catch (error) {
      print("Error removing editor from group: $error");

      return Future.error("Failed to remove editor from group");
    }
  }

  // User
  FutureOr<CustomUser> getUserByUid(String userUid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await userCollection.doc(userUid).get();

      if (documentSnapshot.exists) {
        return CustomUser(
          documentSnapshot['email'],
          documentSnapshot['username'],
          documentSnapshot['uid'],
          documentSnapshot['image_url'],
          documentSnapshot['notifications'],
        );
      } else {
        return Future.error("User does not exist");
      }
    } on FirebaseException catch (error) {
      print("Error fetching user: $error");

      return Future.error("Failed to fetch user");
    }
  }

  FutureOr<CustomUser> getUserByEmail(String userEmail) async {
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
          documentSnapshot['notifications'],
        );
      } else {
        return Future.error("User does not exist");
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
                  doc['notifications'],
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

  Future<void> inviteUserToGroup(Group group, String userUid) async {
    try {
      final inviter =
          await getUserByUid(FirebaseAuth.instance.currentUser!.uid);

      final invitee = await getUserByUid(userUid);
      var uuid = const Uuid().v4();

      userCollection.doc(userUid).update({
        'notifications': {
          ...invitee.notifications,
          {
            'title': 'Group Invitation',
            'body': '${inviter.username} invited you to ${group.title}',
            'uid': uuid,
            'data': {
              'groupUid': group.uid,
            },
            'createdAt': Timestamp.now(),
            'isRead': false,
          }
        }
      });
    } on FirebaseException catch (error) {
      print("Error inviting user to group: $error");

      return Future.error("Failed to invite user to group");
    }
  }

  FutureOr<bool> addUserToGroup(String userUid, String groupUid) async {
    try {
      final invitee = await getUserByUid(userUid);
      final group = await getGroup(groupUid);

      final updatedEditors = [
        ...group.permissions.editors,
        invitee.uid,
      ];

      groupsCollection.doc(groupUid).update({
        'permissions': {
          'owner': group.permissions.owner,
          'editors': updatedEditors,
        }
      });

      return true;
    } on FirebaseException catch (error) {
      print("Error adding user to group: $error");

      return Future.error("Failed to add user to group");
    }
  }

  Future<void> removeNotification(
      String userUid, String notificationUid) async {
    try {
      final invitee = await getUserByUid(userUid);

      final updatedNotifications = invitee.notifications
          .where((notification) => notification['uid'] != notificationUid)
          .toList();

      userCollection.doc(userUid).update({
        'notifications': updatedNotifications,
      });
    } on FirebaseException catch (error) {
      print("Error removing notification: $error");

      return Future.error("Failed to remove notification");
    }
  }

  Future<void> markInvitationAsRead(
      String userUid, String notificationUid) async {
    try {
      final invitee = await getUserByUid(userUid);

      final updatedNotifications = invitee.notifications
          .map((notification) => {
                ...notification,
                'isRead': notification['uid'] == notificationUid
                    ? true
                    : notification['isRead'],
              })
          .toList();

      userCollection.doc(userUid).update({
        'notifications': updatedNotifications,
      });
    } on FirebaseException catch (error) {
      print("Error marking invitation as read: $error");

      return Future.error("Failed to mark invitation as read");
    }
  }

  Future<void> acceptGroupInvitation(
      String userUid, String groupUid, String notificationUid) async {
    try {
      final wasAdded = await addUserToGroup(userUid, groupUid);

      if (wasAdded == true) {
        removeNotification(userUid, notificationUid);
      }
    } on FirebaseException catch (error) {
      print("Error accepting group invitation: $error");

      return Future.error("Failed to accept group invitation");
    }
  }

  Stream<List<UserNotification>> userNotificationsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists &&
            snapshot['notifications'] != null &&
            snapshot['notifications'].isNotEmpty) {
          return snapshot['notifications']
              .map<UserNotification>((notification) {
            return UserNotification(
              notification['title'],
              notification['body'],
              notification['uid'],
              notification['data'],
              notification['createdAt'],
              notification['isRead'],
            );
          }).toList();
        } else {
          return [];
        }
      });
    } catch (error) {
      throw error;
    }
  }

  Stream<dynamic> userUnreadNotificationsCountStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .snapshots();

      final count = userRef.map((snapshot) {
        if (snapshot.exists &&
            snapshot['notifications'] != null &&
            snapshot['notifications'].isNotEmpty) {
          return snapshot['notifications']
              .where((notification) => notification['isRead'] == false)
              .length;
        } else {
          return 0;
        }
      });

      return count;
    } catch (error) {
      throw error;
    }
  }

  Stream<dynamic> groupBodyCountStream(String groupUid) {
    try {
      final groupRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupUid)
          .snapshots();

      final count = groupRef.map((snapshot) {
        return snapshot['body'].length;
      });

      return count;
    } catch (error) {
      throw error;
    }
  }
}
