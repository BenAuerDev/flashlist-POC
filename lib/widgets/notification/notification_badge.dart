import 'package:flashlist/constants/app_sizes.dart';
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
      width: Sizes.p40,
      height: Sizes.p40,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: colorSchemeOf(context).onBackground,
          ),
          if (count.value != 0 && count.value != null)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: Sizes.p12,
                  minHeight: Sizes.p12,
                ),
                child: Text(
                  count.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.p8,
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
