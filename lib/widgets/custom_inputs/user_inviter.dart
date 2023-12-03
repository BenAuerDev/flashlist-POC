import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/group/group_user.dart';
import 'package:flashlist/providers/users.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class UserInviter extends HookConsumerWidget {
  const UserInviter({
    super.key,
    required this.group,
  });

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();

    void inviteUser() async {
      if (emailController.text.isEmpty || !emailController.text.contains('@')) {
        showContextSnackBar(
          context: context,
          message: appLocalizationsOf(context).pleaseEnterValidEmail,
        );
        return;
      }

      if (emailController.text == currentUser!.email) {
        showContextSnackBar(
          context: context,
          message: appLocalizationsOf(context).yourOwnEmail,
        );
        return;
      }

      final user = ref.read(getUserByEmailProvider(emailController.text));

      if (user.value != null &&
          group.permissions.editors.contains(user.value!.uid)) {
        showContextSnackBar(
          context: context,
          message: appLocalizationsOf(context)
              .userAlreadyHasAccess(user.value!.username),
        );
        return;
      }

      // For Security reasons the user doesn't get
      // any direct feedback if a user with this email address exists.
      showContextSnackBar(
        context: context,
        message: appLocalizationsOf(context).ifUserExistsWillBeInvited,
      );

      if (user.value == null) {
        emailController.clear();
        return;
      }

      ref.read(
        inviteUserToGroupProvider(
          {
            'group': group,
            'userUid': user.value!.uid,
          },
        ),
      );

      emailController.clear();
    }

    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: appLocalizationsOf(context).email,
          ),
        ),
        gapH8,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: inviteUser,
              child: Text(appLocalizationsOf(context).inviteUser),
            ),
          ],
        ),
      ],
    );
  }
}
