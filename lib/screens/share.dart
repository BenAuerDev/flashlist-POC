import 'package:flash_list/models/group.dart';
import 'package:flash_list/models/user.dart';
import 'package:flash_list/providers/providers.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:flash_list/widgets/custom_inputs/user_inviter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShareScreen extends HookConsumerWidget {
  const ShareScreen({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    void removeEditor(editor) {
      ref
          .read(firestoreServiceProvider)
          .removeEditorFromGroup(group.uid, editor.uid);

      showSnackbar(
        'User has been removed',
        SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref
                .read(firestoreServiceProvider)
                .addUserToGroup(editor.uid, group.uid);
          },
        ),
      );
    }

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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        'Editors will only appear here once they accepted your invitation.',
                      )),
                    ),
                  );
                }

                final editors = snapshot.data as List<CustomUser>;

                return Expanded(
                  child: ListView.builder(
                    key: Key(editors.length.toString()),
                    shrinkWrap: true,
                    itemCount: editors.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        key: Key(editors[index].uid),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            editors[index].imageUrl ??
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                          ),
                        ),
                        title: Text(editors[index].username),
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            removeEditor(editors[index]);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
