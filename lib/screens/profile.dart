import 'dart:io';

import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/providers/users.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/async_value_widget.dart';
import 'package:flashlist/widgets/custom_inputs/avatar_picker.dart';
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

    final currentUserValue = ref.watch(currentUserDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            appLocalizationsOf(context).profile,
            textAlign: TextAlign.center,
          ),
        ),
        actions: const [SizedBox(width: 50)],
      ),
      body: AsyncValueWidget(
        value: currentUserValue,
        data: (user) {
          if (user != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
              child: Column(
                children: [
                  Center(
                    child: AvatarPicker(
                      initialImage: user['image_url'],
                      onPickImage: (pickedImage) {
                        uploadNewImage(pickedImage, user['uid']);
                      },
                    ),
                  ),
                  gapH12,
                  Row(
                    children: [
                      Text(
                        '${appLocalizationsOf(context).username}: ',
                      ),
                      gapW12,
                      Text(user['username'] ??
                          appLocalizationsOf(context).noUsername),
                    ],
                  ),
                  gapH12,
                  Row(
                    children: [
                      Text(
                        '${appLocalizationsOf(context).email}: ',
                      ),
                      const SizedBox(width: 42),
                      Text(
                          user['email'] ?? appLocalizationsOf(context).noEmail),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No user data'),
            );
          }
        },
      ),
    );
  }
}
