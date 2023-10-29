import 'dart:io';

import 'package:flash_list/providers/users.dart';
import 'package:flash_list/widgets/custom_inputs/avatar_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void uploadNewImage(File pickedImage, String userUid) {
      ref.read(uploadUserAvatarProvider({
        'pickedImage': pickedImage,
        'userUid': userUid,
      }));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Profile',
            textAlign: TextAlign.center,
          ),
        ),
        actions: const [SizedBox(width: 50)],
      ),
      body: ref.watch(userDataProvider).when(
            data: (user) {
              return Center(
                child: Column(
                  children: [
                    AvatarPicker(
                        initialImage: user['image_url'],
                        onPickImage: (pickedImage) {
                          uploadNewImage(pickedImage, user['uid']);
                        }),
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
          ),
    );
  }
}
