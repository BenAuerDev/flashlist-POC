import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewArrayItemScreen extends ConsumerWidget {
  const NewArrayItemScreen({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arrayItemFormKey = GlobalKey<FormState>();

    var enteredName = '';

    void submit() {
      final isValid = arrayItemFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      arrayItemFormKey.currentState!.save();
      ref
          .read(firestoreServiceProvider)
          .addItemToArray(collection.uid, enteredName);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            key: arrayItemFormKey,
            child: Column(
              children: [
                TextFormField(
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
            )),
      ),
    );
  }
}
