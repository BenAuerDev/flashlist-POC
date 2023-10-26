import 'package:flash_list/providers/providers.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationBadge extends ConsumerWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: retrieveColorScheme(context).onBackground,
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
                  right: 0,
                  bottom: 6,
                  child: Container(
                    alignment: Alignment.center,
                    width: 15,
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      count.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
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
      ),
    );
  }
}
