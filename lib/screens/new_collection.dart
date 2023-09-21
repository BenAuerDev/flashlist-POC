import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:brainstorm_array/widgets/color_input.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewCollectionScreen extends ConsumerWidget {
  const NewCollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionFormKey = GlobalKey<FormState>();

    var enteredTitle = '';
    Color? enteredColor;

    void submit() async {
      final isValid = collectionFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      collectionFormKey.currentState!.save();

      ref.read(firestoreServiceProvider).addCollection({
        'title': enteredTitle,
        'color': enteredColor ?? retrieveColorScheme(context).primary,
      });

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new List'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: collectionFormKey,
          child: Column(
            children: [
              TextFormField(
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
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: submit,
                    child: const Text('Add List'),
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
