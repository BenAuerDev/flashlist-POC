import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/widgets/group/group_body.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewBodyItemForm extends ConsumerWidget {
  const NewBodyItemForm({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var color = group.color;

    final bodyItemFormKey = GlobalKey<FormState>();

    var enteredName = '';

    void submit() async {
      final isValid = bodyItemFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      bodyItemFormKey.currentState!.save();

      ref
          .read(firestoreServiceProvider)
          .addItemToGroupBody(group.uid, enteredName);

      bodyItemFormKey.currentState!.reset();
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            group.title,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [SizedBox(width: 50)],
      ),
      body: Container(
        margin: const EdgeInsets.all(4),
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: color!),
          color: color.withOpacity(0.2),
        ),
        child: Form(
            key: bodyItemFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: group.uid,
                    child: GroupBody(group: group),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      autofocus: true,
                      onEditingComplete: () {},
                      onFieldSubmitted: (value) {
                        submit();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        enteredName = newValue!;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        onPressed: submit,
                        child: const Text('Add Item'),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
