import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/screens/notifications.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationBadge extends ConsumerWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
        StreamBuilder(
          stream: ref
              .watch(firestoreServiceProvider)
              .userUnreadNotificationsCountStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const SizedBox();
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const SizedBox();
            }

            final count = snapshot.data;

            if (count != null && count > 0) {
              return Positioned(
                right: 8,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        )
      ],
    );
  }
}
