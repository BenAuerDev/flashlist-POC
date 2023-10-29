import 'package:flash_list/models/group.dart';
import 'package:flash_list/providers/group.dart';
import 'package:flash_list/screens/group_form.dart';
import 'package:flash_list/screens/share.dart';
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

    AlertDialog showConfirmDialog(String title, String content) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
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
    }

    void removeGroup() async {
      final wantToDelete = await showDialog(
        context: context,
        builder: (context) => showConfirmDialog(
          'Delete Group',
          'Are you sure you want to delete ${group.title}?',
        ),
      );
      if (wantToDelete) {
        ref.watch(removeGroupProvider(group.uid));
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

    void removeCurrentUserFromEditors() async {
      final wantToDelete = await showDialog(
        context: context,
        builder: (context) => showConfirmDialog(
          'Remove list for you',
          'Are you sure you want to remove yourself from ${group.title}?',
        ),
      );
      if (wantToDelete) {
        ref.read(removeGroupEditorProvider({
          'groupUid': group.uid,
          'editorUid': currentUser!.uid,
        }));
      }
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
