import 'package:brainstorm_array/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget test = ref.watch(userDataProvider).when(
          data: (data) => Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(data['image_url'] ??
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                ),
                const SizedBox(height: 12),
                Text(data['username'] ?? 'No username'),
                const SizedBox(height: 6),
                Text(data['email'] ?? 'No email'),
              ],
            ),
          ),
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
