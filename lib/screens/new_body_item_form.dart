import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/group.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/group/group_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewBodyItemForm extends HookConsumerWidget {
  const NewBodyItemForm({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScrollController scrollController = useScrollController();

    var color = group.color;

    final bodyItemFormKey = GlobalKey<FormState>();

    var enteredName = '';

    void scrollToEnd() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    void submit() async {
      final isValid = bodyItemFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      bodyItemFormKey.currentState!.save();
      ref.read(
        addItemToGroupBodyProvider({
          'groupUid': group.uid,
          'name': enteredName,
        }),
      );

      bodyItemFormKey.currentState!.reset();

      scrollToEnd();
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
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color!),
          color: color.withOpacity(0.2),
        ),
        child: Form(
            key: bodyItemFormKey,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Hero(
                    tag: group.uid,
                    child: GroupBody(group: group),
                  ),
                  ref.watch(groupBodyCountProvider(group.uid)).when(
                        data: (count) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              autofocus: true,
                              onEditingComplete: () {},
                              maxLength: 40,
                              decoration:
                                  InputDecoration(labelText: '#${count + 1}'),
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
                          );
                        },
                        loading: () => const SizedBox(),
                        error: (error, stackTrace) => const SizedBox(),
                      ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(retrieveAppLocalizations(context).goBack),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        onPressed: submit,
                        child: Text(retrieveAppLocalizations(context).add),
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
