import 'package:flash_list/models/notification.dart';
import 'package:flash_list/providers/providers.dart';
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

    return StreamBuilder<List<UserNotification>>(
        stream: ref.watch(firestoreServiceProvider).userNotificationsStream(),
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
        });
  }
}
