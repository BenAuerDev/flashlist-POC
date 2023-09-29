import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArrayWidget extends HookConsumerWidget {
  const ArrayWidget({
    super.key,
    required this.collectionUid,
  });

  final String collectionUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final array = ref.watch(arrayProvider(collectionUid)).value;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (array != null && array.isNotEmpty)
          for (final item in array)
            Dismissible(
              key: ValueKey(item['uid']),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                ref
                    .read(firestoreServiceProvider)
                    .removeItemFromArray(collectionUid, item);
              },
              background: Container(
                color: retrieveColorScheme(context).error.withOpacity(0.5),
                margin: EdgeInsets.symmetric(
                  vertical:
                      retrieveTheme(context).cardTheme.margin!.vertical / 2,
                ),
              ),
              child: Card(
                shape: const ContinuousRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      item['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
        else
          const Text(
            'No items yet',
            style: TextStyle(fontSize: 18),
          ),
      ],
    );
  }
}
