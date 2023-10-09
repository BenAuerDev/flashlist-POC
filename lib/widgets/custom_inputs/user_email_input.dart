import 'package:brainstorm_array/models/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class UserEmailInput extends HookConsumerWidget {
  const UserEmailInput({
    super.key,
    required this.collection,
    required this.onSelectEditors,
    required this.onRemoveEditor,
  });

  final Collection collection;
  final Function(List<dynamic>) onSelectEditors;
  final Function(String uid) onRemoveEditor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final editors = useState([]);

    getEditorUserObjects() async {
      return await FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: collection.permissions['editors'])
          .get();
    }

    useEffect(() {
      if (collection.permissions['editors'].isNotEmpty) {
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
      onSelectEditors(editors.value);

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
              if (editor['uid'] != collection.permissions['owner'])
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
