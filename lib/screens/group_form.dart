import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:brainstorm_array/widgets/custom_inputs/color_input.dart';
import 'package:brainstorm_array/widgets/custom_inputs/user_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupForm extends ConsumerWidget {
  const GroupForm({super.key, this.group});

  final Group? group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupFormKey = GlobalKey<FormState>();

    var enteredTitle = group?.title ?? '';
    Color? enteredColor = group?.color ?? retrieveColorScheme(context).primary;
    List enteredEditors = group?.permissions['editors'] ?? [];

    Future createGroup() async {
      final res = await ref.read(firestoreServiceProvider).addGroup({
        'title': enteredTitle,
        'color': enteredColor ?? retrieveColorScheme(context).primary,
        'editors': enteredEditors,
      });
      return res;
    }

    Future editGroup() async {
      final res =
          await ref.read(firestoreServiceProvider).editGroup(group!.uid, {
        'title': enteredTitle,
        'color': enteredColor ?? retrieveColorScheme(context).primary,
        'editors': enteredEditors,
      });
      return res;
    }

    void onSelectEditor(String uid) {
      enteredEditors.add(uid);
    }

    void onRemoveEditor(String uid) {
      enteredEditors.remove(uid);
    }

    void submit() {
      final isValid = groupFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      groupFormKey.currentState!.save();

      if (group == null) {
        createGroup();
      } else {
        editGroup();
      }
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(group == null ? 'Add new List' : 'Edit your List'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: groupFormKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: enteredTitle,
                  maxLength: 20,
                  keyboardType: TextInputType.emailAddress,
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
                  initialColor: group != null ? group!.color : null,
                  onSelectColor: (Color color) {
                    enteredColor = color;
                  },
                ),
                const SizedBox(height: 12),
                UserPicker(
                  group: group,
                  onSelectEditor: onSelectEditor,
                  onRemoveEditor: onRemoveEditor,
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
                      child: Text(group == null ? 'Add List' : 'Update List'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
