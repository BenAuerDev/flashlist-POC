import 'package:brainstorm_array/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArrayWidget extends HookConsumerWidget {
  const ArrayWidget({
    super.key,
    required this.collectionUid,
    required this.array,
  });

  final String collectionUid;
  final List<dynamic> array;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (array.isNotEmpty)
          for (final item in array)
            Dismissible(
              key: ValueKey(item['uid']),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                ref
                    .read(firestoreServiceProvider)
                    .removeItemFromArray(collectionUid, item);
              },
              child: Card(
                shape: const ContinuousRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
