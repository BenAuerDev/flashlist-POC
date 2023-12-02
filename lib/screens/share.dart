import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/group.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/custom_inputs/user_inviter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ShareScreen extends HookConsumerWidget {
  const ShareScreen({super.key, required this.groupUid});

  final String? groupUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Group? group = ref.watch(groupProvider(groupUid!)).value;

    void removeEditor(editor) {
      ref.read(removeGroupEditorProvider({
        'groupUid': group!.uid,
        'editorUid': editor.uid,
      }));

      showContextSnackBar(
        context: context,
        message:
            appLocalizationsOf(context).userHasBeenRemoved(editor.username),
        action: SnackBarAction(
          label: appLocalizationsOf(context).undo,
          onPressed: () {
            ref.read(
              addUserToGroupProvider(
                {
                  'editorUid': editor.uid,
                  'groupUid': group.uid,
                },
              ),
            );
          },
        ),
      );
    }

    if (group == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final groupEditorsValue = ref.watch(groupEditorsProvider(group.uid));

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            group.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: group.color,
              fontSize: Sizes.p24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [SizedBox(width: 50)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            UserInviter(group: group),
            gapH16,
            groupEditorsValue.when(
              data: (editors) {
                if (editors.isEmpty) {
                  return Center(
                    child: Text(
                      appLocalizationsOf(context).noEditorsYet,
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
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
                        contentPadding: EdgeInsets.zero,
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
              loading: () {
                final editors = group.permissions.editors;

                return Shimmer(
                  gradient: LinearGradient(colors: [
                    Colors.grey.withOpacity(0.2),
                    Colors.black12.withOpacity(0.2),
                  ]),
                  child: Column(
                    children: [
                      for (var i = 0; i < editors.length; i++)
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person),
                          ),
                          title: Container(
                            color: Colors.grey,
                            height: Sizes.p4,
                            width: Sizes.p24,
                            child: const SizedBox(),
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          trailing: const Icon(Icons.delete),
                        ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => const Center(
                child: Text('Error loading editors'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
