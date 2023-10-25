import 'package:flash_list/models/notification.dart';
import 'package:flash_list/providers/providers.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationItem extends ConsumerWidget {
  const NotificationItem({super.key, required this.notification});

  final UserNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final groupUid = notification.data!['groupUid'];

    AlertDialog invitationDialog = AlertDialog(
      title: Text(notification.title),
      content: const Text('Would you like to join as an editor?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            ref
                .read(firestoreServiceProvider)
                .removeNotification(currentUserUid, notification.uid);
            Navigator.of(context).pop('no');
          },
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () {
            ref
                .read(firestoreServiceProvider)
                .markInvitationAsRead(currentUserUid, notification.uid);
            Navigator.of(context).pop('notnow');
          },
          child: const Text('Not now'),
        ),
        ElevatedButton(
          onPressed: () async {
            ref.read(firestoreServiceProvider).acceptGroupInvitation(
                  currentUserUid,
                  groupUid,
                  notification.uid,
                );
            Navigator.of(context).pop('yes');
          },
          child: const Text('Yes'),
        ),
      ],
    );

    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (context) => invitationDialog);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        color: notification.isRead
            ? Colors.transparent
            : retrieveColorScheme(context).primaryContainer.withOpacity(0.2),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Row(
          children: [
            const Icon(Icons.groups, size: 35),
            const SizedBox(width: 16),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title),
                Text(notification.body),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
