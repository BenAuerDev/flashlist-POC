import 'package:flashlist/providers/users.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationBadge extends ConsumerWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var count = ref.watch(userUnreadNotificationsCountProvider);

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
          if (count.value != 0)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Text(
                  count.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
