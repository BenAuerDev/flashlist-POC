import 'package:flashlist/providers/users.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/async_value_widget.dart';
import 'package:flashlist/widgets/notification/notification_item.dart';
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

    final notificationsValue = ref.watch(userNotificationStreamProvider);

    return AsyncValueWidget(
      value: notificationsValue,
      data: (data) {
        if (data.isEmpty) {
          return Center(
            child: Text(appLocalizationsOf(context).noNotifications),
          );
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
    );
  }
}
