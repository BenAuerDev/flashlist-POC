import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/group.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/custom_inputs/color_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupForm extends ConsumerWidget {
  const GroupForm({super.key, this.groupUid});

  final String? groupUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupFormKey = GlobalKey<FormState>();

    final Group? group =
        groupUid != null ? ref.watch(groupProvider(groupUid!)).value : null;

    var enteredTitle = group?.title ?? '';
    Color? enteredColor = group?.color ?? retrieveColorScheme(context).primary;

    Future createGroup() async {
      final res = ref.read(
        addGroupProvider(
          GroupDTO(
            enteredTitle,
            enteredColor ?? retrieveColorScheme(context).primary,
          ),
        ),
      );

      return res;
    }

    Future editGroup() async {
      final res = ref.read(
        editGroupProvider(
          GroupDTO(enteredTitle, enteredColor, group!.uid),
        ),
      );
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
      context.pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            group == null ? '' : group.title,
            style: TextStyle(
              color: group == null
                  ? retrieveColorScheme(context).onBackground
                  : group.color,
              fontSize: Sizes.p24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [SizedBox(width: 50)],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
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
                gapH12,
                ColorInput(
                  initialColor: group?.color,
                  onSelectColor: (Color color) {
                    enteredColor = color;
                  },
                ),
                gapH12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
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
