import 'package:flash_list/models/notification.dart';
import 'package:flash_list/providers/group.dart';
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
      content: Text(retrieveAppLocalizations(context).wantToJoin),
      actions: [
        ElevatedButton(
          onPressed: () {
            ref.read(removeNotificationProvider(
              {
                'userUid': currentUserUid,
                'notificationUid': notification.uid,
              },
            ));
            Navigator.of(context).pop('no');
          },
          child: Text(retrieveAppLocalizations(context).no),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(markNotificationAsReadProvider({
              'userUid': currentUserUid,
              'notificationUid': notification.uid
            }));
            Navigator.of(context).pop('notnow');
          },
          child: Text(retrieveAppLocalizations(context).notNow),
        ),
        ElevatedButton(
          onPressed: () async {
            ref.read(acceptGroupInvitationProvider(
              {
                'userUid': currentUserUid,
                'groupUid': groupUid,
                'notificationUid': notification.uid,
              },
            ));
            Navigator.of(context).pop('yes');
          },
          child: Text(retrieveAppLocalizations(context).yes),
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
