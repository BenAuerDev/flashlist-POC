import 'package:brainstorm_array/models/notification.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.notification});

  final UserNotification notification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        notification.isRead = false;
        Navigator.of(context).pop();
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
