import 'package:brainstorm_array/models/notification.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:brainstorm_array/widgets/notification/notification_badge.dart';
import 'package:brainstorm_array/widgets/notification/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NotificationModal extends HookWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context) {
    var notifications = <UserNotification>[
      UserNotification(
        'Marcus Antonius Aurelius invited you to the list: Conquest of Germania',
        '23423423',
        false,
      ),
      UserNotification(
        'John Snow invited you to the list: Black Castle Supplies',
        '23423423',
        false,
      ),
      UserNotification(
        'Gaius Julius Caesar invited you to the list: Conquest of Gaul',
        '23423423',
        false,
      ),
      UserNotification(
        'Kratos invited you to the list: Revenge on the Gods',
        '23423423',
        true,
      ),
    ];

    return NotificationBadge(
      notificationCount:
          notifications.where((notification) => !notification.isRead).length,
      onOpenModal: () {
        showGeneralDialog(
          context: context,
          barrierColor: Colors.black12.withOpacity(0.6),
          barrierDismissible: false,
          barrierLabel: 'Dialog',
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder:
              (BuildContext _, Animation<double> __, Animation<double> ___) {
            return Scaffold(
              appBar: AppBar(
                title: const Center(child: Text('Notifications')),
                leading: const SizedBox(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              backgroundColor: retrieveColorScheme(context).background,
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: SizedBox.expand(
                      child: ListView.builder(
                        itemCount: notifications.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          return NotificationItem(notification: notification);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
