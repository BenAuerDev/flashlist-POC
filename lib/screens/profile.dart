import 'dart:io';

import 'package:brainstorm_array/providers/users.dart';
import 'package:brainstorm_array/widgets/custom_inputs/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget test = ref.watch(userDataProvider).when(
          data: (user) {
            void uploadNewImage(File pickedImage) async {
              try {
                final storageRef = FirebaseStorage.instance
                    .ref()
                    .child('user_images')
                    .child('${user['uid']}.jpg');

                await storageRef.putFile(pickedImage);

                final imageUrl = await storageRef.getDownloadURL();

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user['uid'])
                    .update({
                  'image_url': imageUrl,
                });
              } catch (error) {
                print(error);
              }
            }

            return Center(
              child: Column(
                children: [
                  UserImagePicker(
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
