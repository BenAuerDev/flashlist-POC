import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/models/user.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/widgets/custom_inputs/user_inviter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// create hook consumer widget share-screen receiving the group as a parameter
class ShareScreen extends HookConsumerWidget {
  const ShareScreen({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            group.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: group.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [SizedBox(width: 50)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            UserInviter(group: group),
            StreamBuilder(
              stream: ref
                  .watch(firestoreServiceProvider)
                  .getGroupEditors(group.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No editors'));
                }

                final editors = snapshot.data as List<CustomUser>;

                return ListView(
                  key: Key(editors.length.toString()),
                  shrinkWrap: true,
                  children: [
                    if (editors.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Editors',
                        ),
                      ),
                    for (final editor in editors)
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(editor.imageUrl ??
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                        ),
                        title: Text(editor.username),
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref
                                .read(firestoreServiceProvider)
                                .removeEditorFromGroup(
                                  group.uid,
                                  editor.uid,
                                );
                          },
                        ),
                      ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
