import 'package:flash_list/models/group.dart';
import 'package:flash_list/providers/group.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:flash_list/widgets/custom_inputs/color_input.dart';
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

    Future createGroup() async {
      final res = ref.read(addGroupProvider({
        'title': enteredTitle,
        'color': enteredColor ?? retrieveColorScheme(context).primary,
      }));

      return res;
    }

    Future editGroup() async {
      final res = ref.read(editGroupProvider({
        'uid': group!.uid,
        'title': enteredTitle,
        'color': enteredColor ?? retrieveColorScheme(context).primary,
      }));
      return res;
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
        title: Center(
          child: Text(
            group == null ? '' : group!.title,
            style: TextStyle(
              color: group == null
                  ? retrieveColorScheme(context).onBackground
                  : group!.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [SizedBox(width: 50)],
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
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return retrieveAppLocalizations(context)
                          .pleaseEnterValidListTitle;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(retrieveAppLocalizations(context).goBack),
                    ),
                    ElevatedButton(
                      onPressed: submit,
                      child: Text(
                        group == null
                            ? retrieveAppLocalizations(context).add
                            : retrieveAppLocalizations(context).edit,
                      ),
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
