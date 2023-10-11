import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserPicker extends HookConsumerWidget {
  const UserPicker({
    super.key,
    this.group,
    required this.onSelectEditor,
    required this.onRemoveEditor,
  });

  final Group? group;
  final Function(String uid) onSelectEditor;
  final Function(String uid) onRemoveEditor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final editors = useState([]);

    getEditorUserObjects() async {
      final uidList = group!.permissions['editors'];
      final userObjects =
          await ref.read(firestoreServiceProvider).getUsersByUid(uidList);

      editors.value = userObjects;
    }

    useEffect(() {
      if (group != null && group?.permissions['editors'].isNotEmpty) {
        getEditorUserObjects();
      }
      return null;
    }, []);

    void showSnackbar(String message, SnackBarAction? action) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: action,
          content: Text(message),
        ),
      );
    }

    void addUser() async {
      if (emailController.text.isEmpty || !emailController.text.contains('@')) {
        showSnackbar('Please enter an email address', null);
        return;
      }

      final user = await ref
          .read(firestoreServiceProvider)
          .getUserByEmail(emailController.text);

      if (user != null) {
        editors.value = [...editors.value, user];
        onSelectEditor(user.uid);
        emailController.clear();
      } else {
        showSnackbar(
          'No user found with that email address, maybe check the spelling?',
          null,
        );
      }
    }

    void removeUser(editor) async {
      final oldState = editors.value;

      editors.value = editors.value.where((item) => item != editor).toList();
      onRemoveEditor(editor.uid);

      showSnackbar(
        'User has been removed',
        SnackBarAction(
          label: 'undo',
          onPressed: () {
            editors.value = oldState;
            onSelectEditor(editor.uid);
          },
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ),
              ),
            ),
            ElevatedButton(onPressed: addUser, child: const Text('Add User')),
          ],
        ),
        const SizedBox(height: 8),
        ListView(
          key: Key(editors.value.length.toString()),
          shrinkWrap: true,
          children: [
            if (editors.value.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Editors',
                ),
              ),
            for (final editor in editors.value)
              if (editor.uid != group?.permissions['editors'])
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(editor.imageUrl ??
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                  ),
                  title: Text(editor.username ?? 'No username'),
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      removeUser(editor);
                    },
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
