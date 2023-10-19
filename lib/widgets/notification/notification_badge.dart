import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
    required this.notificationCount,
    required this.onOpenModal,
  });

  final int notificationCount;
  final void Function()? onOpenModal;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: onOpenModal,
        ),
        notificationCount > 0
            ? Positioned(
                right: 8,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
