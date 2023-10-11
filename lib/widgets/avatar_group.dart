import 'package:brainstorm_array/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AvatarGroup extends HookConsumerWidget {
  const AvatarGroup({super.key, required this.users});

  final List<dynamic> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isExpanded = useState(false);

    return FutureBuilder(
      future: ref.read(firestoreServiceProvider).getUsersByUid(users),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshots.hasError) {
          return const Text('Error fetching users');
        }

        return TextButton(
          onPressed: () => isExpanded.value = !isExpanded.value,
          child: Row(
            children: [
              for (var user in snapshots.data ?? [])
                Align(
                  widthFactor: isExpanded.value ? 1.0 : 0.3,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                      user.imageUrl ??
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
