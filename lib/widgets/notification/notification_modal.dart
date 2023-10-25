import 'package:brainstorm_array/models/notification.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:brainstorm_array/widgets/notification/notification_badge.dart';
import 'package:brainstorm_array/widgets/notification/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationModal extends ConsumerWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<UserNotification>>(
        stream: ref.watch(firestoreServiceProvider).userNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return NotificationBadge(
            notificationCount: snapshot.data!
                .where((notification) => !notification.isRead)
                .length,
            onOpenModal: () {
              showGeneralDialog(
                context: context,
                barrierColor: Colors.black12.withOpacity(0.6),
                barrierDismissible: false,
                barrierLabel: 'Dialog',
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (BuildContext _, Animation<double> __,
                    Animation<double> ___) {
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
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final notification = snapshot.data![index];

                                return NotificationItem(
                                    notification: notification);
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
        });
  }
}
