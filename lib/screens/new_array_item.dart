import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/widgets/collection/collection_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewArrayItemScreen extends ConsumerWidget {
  const NewArrayItemScreen({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arrayItemFormKey = GlobalKey<FormState>();

    var enteredName = '';

    void submit() async {
      final isValid = arrayItemFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      arrayItemFormKey.currentState!.save();

      ref
          .read(firestoreServiceProvider)
          .addItemToArray(collection.uid, enteredName);

      arrayItemFormKey.currentState!.reset();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Container(
        margin: const EdgeInsets.all(4),
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: collection.color!),
          color: collection.color!.withOpacity(0.2),
        ),
        child: Form(
            key: arrayItemFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: collection.uid,
                    child: CollectionWidget(collection: collection),
                  ),
                  TextFormField(
                    onEditingComplete: () {},
                    onFieldSubmitted: (value) => submit(),
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
              ),
            )),
      ),
    );
  }
}
