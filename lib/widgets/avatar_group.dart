import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class AvatarGroup extends HookConsumerWidget {
  const AvatarGroup({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isExpanded = useState(false);

    List<dynamic> usersWithoutCurrent = [
      ...group.permissions['editors'],
      group.permissions['owner']
    ].where((userUid) => userUid != currentUser!.uid).toList();

    AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: 0.3,
      lowerBound: 0.3,
      upperBound: 0.8,
    );

    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    void expandTemporarily() {
      if (!isExpanded.value) {
        isExpanded.value = true;
        animationController.forward();
        Future.delayed(
          const Duration(seconds: 2),
          () {
            isExpanded.value = false;
            animationController.reverse();
          },
        );
      } else {
        isExpanded.value = false;
        animationController.reverse();
      }
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FutureBuilder(
          future: ref
              .read(firestoreServiceProvider)
              .getUsersByUid(usersWithoutCurrent),
          builder: (context, snapshots) {
            if (snapshots.hasError) {
              return const Text('Error fetching users');
            }

            return GestureDetector(
              onTap: usersWithoutCurrent.length > 1 ? expandTemporarily : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 8),
                  for (var user in snapshots.data ?? [])
                    Align(
                      alignment: isExpanded.value
                          ? Alignment.bottomRight
                          : Alignment.bottomRight,
                      widthFactor: user == snapshots.data!.first
                          ? 0.9
                          : animationController.value,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                          user.imageUrl ??
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
