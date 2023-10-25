import 'package:flash_list/models/group.dart';
import 'package:flash_list/providers/providers.dart';
import 'package:flash_list/screens/group_form.dart';
import 'package:flash_list/screens/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class GroupMenu extends ConsumerWidget {
  const GroupMenu({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isCurrentUserOwner =
        group.permissions['owner'] == currentUser!.uid;
    final bool isCurrentUserInEditors =
        group.permissions['editors'].contains(currentUser!.uid);

    AlertDialog deleteDialog = AlertDialog(
      title: const Text('Delete List'),
      content: Text('Are you sure you want to delete ${group.title}?'),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          icon: const Icon(Icons.cancel),
          label: const Text('No'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: const Icon(Icons.delete),
          label: const Text('Yes'),
        ),
      ],
    );

    void removeGroup() async {
      final wantToDelete = await showDialog(
          context: context, builder: (context) => deleteDialog);
      if (wantToDelete) {
        ref.watch(firestoreServiceProvider).removeGroup(group.uid);
      }
    }

    void onEditGroup() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GroupForm(group: group),
        ),
      );
    }

    void onShareGroup() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShareScreen(group: group),
        ),
      );
    }

    void removeCurrentUserFromEditors() {
      FirebaseFirestore.instance.collection('groups').doc(group.uid).update({
        'title': group.title,
        'color': group.color!.value,
        'uid': group.uid,
        'body': group.body,
        'permissions': {
          'owner': group.permissions['owner'],
          'editors': group.permissions['editors']
              .where((editor) => editor != currentUser!.uid)
              .toList(),
        },
      });
    }

    return PopupMenuButton(
      itemBuilder: (context) => [
        // Owner
        if (isCurrentUserOwner)
          PopupMenuItem(
            onTap: onShareGroup,
            child: const Text('Share'),
          ),

        if (isCurrentUserOwner)
          PopupMenuItem(
            onTap: onEditGroup,
            child: const Text('Edit'),
          ),
        if (isCurrentUserOwner)
          PopupMenuItem(
            onTap: removeGroup,
            child: const Text('Delete'),
          ),

        // Editors
        if (isCurrentUserInEditors && !isCurrentUserOwner)
          PopupMenuItem(
            onTap: removeCurrentUserFromEditors,
            child: const Text('Remove'),
          ),
      ],
    );
  }
}
