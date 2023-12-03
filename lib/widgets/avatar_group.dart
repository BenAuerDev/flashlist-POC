import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/models/group.dart';
import 'package:flashlist/models/user.dart';
import 'package:flashlist/providers/group/group_user.dart';
import 'package:flashlist/widgets/slide_fade_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class AvatarGroup extends HookConsumerWidget {
  const AvatarGroup({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isExpanded = useState(false);

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

    final groupUsersValue = ref.watch(groupUsersProvider(group.uid));

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return groupUsersValue.when(
          data: (groupUsers) {
            final List<CustomUser> usersWithoutCurrent = groupUsers
                .where((user) => user.uid != currentUser!.uid)
                .toList();

            if (usersWithoutCurrent.isEmpty) {
              return const SizedBox();
            }

            return GestureDetector(
              onTap: group.permissions.editors.length > 1
                  ? expandTemporarily
                  : null,
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var user in usersWithoutCurrent.reversed)
                    Align(
                      alignment: isExpanded.value
                          ? Alignment.bottomRight
                          : Alignment.bottomRight,
                      widthFactor: user == usersWithoutCurrent.first
                          ? 0.9
                          : animationController.value,
                      child: SlideFadeTransition(
                        index: usersWithoutCurrent.indexOf(user),
                        position: animationController.value,
                        animationController: animationController,
                        direction: isExpanded.value ? 1 : -1,
                        child: CircleAvatar(
                          radius: Sizes.p16,
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
          loading: () {
            // TODO: think about how to make this file smaller
            final editors = group.permissions.editors;

            return Shimmer(
              gradient: LinearGradient(colors: [
                Colors.grey.withOpacity(0.2),
                Colors.black12.withOpacity(0.2),
              ]),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < editors.length; i++)
                    Align(
                      alignment: Alignment.bottomRight,
                      widthFactor: i == editors.length - 1 ? 1 : 0.3,
                      child: Container(
                        width: Sizes.p32,
                        height: Sizes.p32,
                        decoration: BoxDecoration(
                          color: group.color,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const SizedBox(),
                      ),
                    )
                ],
              ),
            );
          },
          error: (error, stackTrace) => const SizedBox(),
        );
      },
    );
  }
}
