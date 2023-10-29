import 'package:flash_list/providers/users.dart';
import 'package:flash_list/widgets/notification/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsTab extends HookConsumerWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fcmToken = useState<dynamic>('');

    setupPushNotifications() async {
      final fcm = FirebaseMessaging.instance;
      await fcm.requestPermission();
      final token = await fcm.getToken();
      return token;
    }

    useEffect(() {
      fcmToken.value = setupPushNotifications();
      return;
    }, []);

    return ref.watch(userNotificationStreamProvider).when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('No notifications'));
            }

            return SizedBox.expand(
              child: ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final notification = data[index];

                  return NotificationItem(notification: notification);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text(error.toString()),
        );
  }
}
