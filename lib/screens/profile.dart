import 'dart:io';

import 'package:flash_list/providers/providers.dart';
import 'package:flash_list/providers/users.dart';
import 'package:flash_list/widgets/custom_inputs/avatar_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget test = ref.watch(userDataProvider).when(
          data: (user) {
            void uploadNewImage(File pickedImage) {
              ref
                  .read(firestoreServiceProvider)
                  .uploadUserAvatar(pickedImage, user['uid']);
            }

            return Center(
              child: Column(
                children: [
                  AvatarPicker(
                    initialImage: user['image_url'],
                    onPickImage: uploadNewImage,
                  ),
                  const SizedBox(height: 12),
                  Text(user['username'] ?? 'No username'),
                  const SizedBox(height: 6),
                  Text(user['email'] ?? 'No email'),
                ],
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text(error.toString()),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: test,
    );
  }
}
