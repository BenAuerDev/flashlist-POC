import 'package:flash_list/models/group.dart';
import 'package:flash_list/providers/group.dart';
import 'package:flash_list/providers/users.dart';
import 'package:flash_list/utils/context_retriever.dart';
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
        showSnackbar('Please enter an email address', null);
        return;
      }

      if (emailController.text == currentUser!.email) {
        showSnackbar('Dude that\'s your own email address ;-)', null);
        return;
      }

      final user = ref.read(getUserByEmailProvider(emailController.text));

      if (user.value != null &&
          group.permissions['editors'].contains(user.value!.uid)) {
        showSnackbar('User already has access to this list', null);
        return;
      }

      // For Security reasons the user doesn't get
      // any direct feedback if a user with this email address exists.
      showSnackbar(
        'If a user with this email address exists, he received your invitation.',
        null,
      );

      if (user.value == null) {
        emailController.clear();
        return;
      }

      ref.read(inviteUserToGroupProvider({
        'group': group,
        'userUid': user.value!.uid,
      }));

      emailController.clear();
    }

    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: inviteUser,
              child: const Text('Add User'),
            ),
          ],
        ),
      ],
    );
  }
}
