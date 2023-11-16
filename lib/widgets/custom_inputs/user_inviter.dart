import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/group.dart';
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

    void showSnackbar(String message, SnackBarAction? action) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: action,
          backgroundColor: retrieveColorScheme(context).primary,
          content: Text(message),
        ),
      );
    }

    void inviteUser() async {
      if (emailController.text.isEmpty || !emailController.text.contains('@')) {
        showSnackbar(
          retrieveAppLocalizations(context).pleaseEnterValidEmail,
          null,
        );
        return;
      }

      if (emailController.text == currentUser!.email) {
        showSnackbar(
          retrieveAppLocalizations(context).yourOwnEmail,
          null,
        );
        return;
      }

      final user = ref.read(getUserByEmailProvider(emailController.text));

      if (user.value != null &&
          group.permissions.editors.contains(user.value!.uid)) {
        showSnackbar(
          retrieveAppLocalizations(context)
              .userAlreadyHasAccess(user.value!.username),
          null,
        );
        return;
      }

      // For Security reasons the user doesn't get
      // any direct feedback if a user with this email address exists.
      showSnackbar(
        retrieveAppLocalizations(context).ifUserExistsWillBeInvited,
        null,
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
            labelText: retrieveAppLocalizations(context).email,
          ),
        ),
        gapH8,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: inviteUser,
              child: Text(retrieveAppLocalizations(context).inviteUser),
            ),
          ],
        ),
      ],
    );
  }
}
