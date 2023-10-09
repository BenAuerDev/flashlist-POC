import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:brainstorm_array/widgets/custom_inputs/color_input.dart';
import 'package:brainstorm_array/widgets/custom_inputs/user_email_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionFormScreen extends ConsumerWidget {
  const CollectionFormScreen({super.key, this.collection});

  final Collection? collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionFormKey = GlobalKey<FormState>();

    var enteredTitle = collection?.title ?? '';
    Color? enteredColor =
        collection?.color ?? retrieveColorScheme(context).primary;
    List<String> enteredEditors = [FirebaseAuth.instance.currentUser!.uid];

    void createCollection() {
      ref.read(firestoreServiceProvider).addCollection({
        'title': enteredTitle,
        'color': enteredColor ?? retrieveColorScheme(context).primary,
        'editors': enteredEditors,
      });
    }

    Future editCollection() async {
      final res = await ref
          .read(firestoreServiceProvider)
          .editCollection(collection!.uid, {
        'title': enteredTitle,
        'color': enteredColor ?? retrieveColorScheme(context).primary,
        'editors': enteredEditors.length > 1
            ? enteredEditors
            : collection!.permissions['editors'],
      });
      return res;
    }

    void submit() {
      final isValid = collectionFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      collectionFormKey.currentState!.save();

      if (collection == null) {
        createCollection();
      } else {
        editCollection();
      }
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(collection == null ? 'Add new List' : 'Edit your List'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: collectionFormKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: enteredTitle,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'List Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a list name';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  enteredTitle = newValue!;
                },
              ),
              const SizedBox(height: 12),
              ColorInput(
                initialColor: collection != null ? collection!.color : null,
                onSelectColor: (Color color) {
                  enteredColor = color;
                },
              ),
              const SizedBox(height: 12),
              UserEmailInput(
                collection: collection!,
                onSelectEditors: (List<dynamic> editors) {
                  print('inside on select editors: $editors');

                  final passedEditorUids =
                      editors.map((editor) => editor['uid']).toList();
                  enteredEditors = [...enteredEditors, ...passedEditorUids];
                },
                onRemoveEditor: (String uid) {
                  enteredEditors.remove(uid);
                  print('inside onremove editor $enteredEditors');
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: submit,
                    child:
                        Text(collection == null ? 'Add List' : 'Update List'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
