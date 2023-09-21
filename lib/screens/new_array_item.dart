import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/widgets/array_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewArrayItemScreen extends HookConsumerWidget {
  const NewArrayItemScreen({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arrayItemFormKey = GlobalKey<FormState>();

    var collectionArray = useState(collection.array);

    var enteredName = '';

    void submit() async {
      final isValid = arrayItemFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      arrayItemFormKey.currentState!.save();

      final itemUid = await ref
          .read(firestoreServiceProvider)
          .addItemToArray(collection.uid, enteredName);

      collectionArray.value = [
        ...collectionArray.value,
        {
          'name': enteredName,
          'uid': itemUid,
        }
      ];

      arrayItemFormKey.currentState!.reset();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Container(
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
                      child: Material(
                        type: MaterialType.transparency,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                collection.title,
                                style: TextStyle(
                                  color: collection.color,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ArrayWidget(
                                collectionUid: collection.uid,
                                array: collectionArray.value,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                ),
              )),
        ),
      ),
    );
  }
}
