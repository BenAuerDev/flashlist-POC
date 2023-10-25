import 'package:flash_list/models/group.dart';
import 'package:flash_list/providers/providers.dart';
import 'package:flash_list/screens/group_form.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:flash_list/widgets/group/group_wrapper.dart';
import 'package:flash_list/widgets/notification/notification_badge.dart';
import 'package:flash_list/widgets/side_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fcmToken = useState<dynamic>('');

    void goToGroupForm() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const GroupForm(),
        ),
      );
    }

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

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Your Lists')),
          actions: const [
            NotificationBadge(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: retrieveColorScheme(context).background,
          onPressed: goToGroupForm,
          child: const Icon(Icons.add_card),
        ),
        drawer: const SideDrawer(),
        body: StreamBuilder(
          stream: ref.read(firestoreServiceProvider).groupsForUserStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data as List<Group>;
              final groups = data
                  .map(
                    (doc) => Group(
                      doc.title,
                      doc.createdAt,
                      doc.uid,
                      Color(doc.color!.value),
                      doc.body,
                      doc.permissions,
                    ),
                  )
                  .toList();

              if (groups.isEmpty) {
                return const Center(child: Text('No lists yet...'));
              }

              return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return GroupWrapper(group: group);
                },
              );
            }
          },
        ));
  }
}
