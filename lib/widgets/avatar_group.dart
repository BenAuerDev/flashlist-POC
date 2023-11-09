import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/group.dart';
import 'package:flashlist/widgets/slide_fade_transition.dart';
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
      ...group.permissions.editors,
      group.permissions.owner,
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

    if (usersWithoutCurrent.isEmpty) {
      return const SizedBox(width: 20);
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return ref.watch(groupEditorsProvider(group.uid)).when(
              data: (editors) {
                return GestureDetector(
                  onTap:
                      usersWithoutCurrent.length > 1 ? expandTemporarily : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      for (var user in editors)
                        Align(
                          alignment: isExpanded.value
                              ? Alignment.bottomRight
                              : Alignment.bottomRight,
                          widthFactor: user == editors.first
                              ? 0.9
                              : animationController.value,
                          child: SlideFadeTransition(
                            index: editors.indexOf(user),
                            position: animationController.value,
                            animationController: animationController,
                            direction: isExpanded.value ? 1 : -1,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                user.imageUrl ??
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (error, stackTrace) => const SizedBox(),
            );
      },
    );
  }
}
