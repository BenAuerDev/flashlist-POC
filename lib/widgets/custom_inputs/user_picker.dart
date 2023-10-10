import 'package:brainstorm_array/models/group.dart';
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
      return await FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: group?.permissions['editors'])
          .get();
    }

    useEffect(() {
      if (group != null && group?.permissions['editors'].isNotEmpty) {
        // TODO: There must be a better way than this
        getEditorUserObjects().then((value) {
          editors.value = value.docs.map((doc) => doc.data()).toList();
        });
      }
      return null;
    }, []);

    void addUser() async {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .snapshots()
          .first
          .then((value) => value.docs.first.data());

      editors.value = [...editors.value, user];
      onSelectEditor(user['uid']);

      emailController.clear();
    }

    void removeUser(editor) async {
      editors.value = editors.value.where((item) => item != editor).toList();
      onRemoveEditor(editor['uid']);
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: emailController,
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
            for (final editor in editors.value)
              if (editor['uid'] != group?.permissions['editors'])
                ListTile(
                  title: Text(editor['username'] ?? 'No username'),
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
