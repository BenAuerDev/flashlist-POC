import 'package:brainstorm_array/models/notification.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:brainstorm_array/widgets/notification/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NotificationModal extends HookWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context) {
    var notifications = <UserNotification>[
      UserNotification(
        '##User invited you to the list ##listname',
        '23423423',
        false,
      ),
      UserNotification(
        '##User invited you to the list ##listname',
        '23423423',
        false,
      ),
      UserNotification(
        '##User invited you to the list ##listname',
        '23423423',
        false,
      ),
      UserNotification(
        '##User invited you to the list ##listname',
        '23423423',
        false,
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
                    flex: 5,
                    child: SizedBox.expand(
                      child: ListView(
                        children: [
                          for (var notification in notifications)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              key: Key(notification.uid),
                              title: GestureDetector(
                                onTap: () {
                                  print('tapped');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    children: [
                                      Text(notification.message),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
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
