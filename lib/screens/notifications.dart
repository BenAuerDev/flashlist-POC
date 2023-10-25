import 'package:flash_list/models/notification.dart';
import 'package:flash_list/providers/providers.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:flash_list/widgets/notification/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationsScreen extends HookConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: StreamBuilder<List<UserNotification>>(
            stream:
                ref.watch(firestoreServiceProvider).userNotificationsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No notifications'));
              }

              return SizedBox.expand(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final notification = snapshot.data![index];

                    return NotificationItem(notification: notification);
                  },
                ),
              );
            }));
  }
}
