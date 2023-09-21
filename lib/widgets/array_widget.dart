import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArrayWidget extends HookConsumerWidget {
  const ArrayWidget({super.key, required this.array});

  final List<dynamic> array;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (array.isNotEmpty)
          for (final item in array)
            Card(
              shape: const ContinuousRectangleBorder(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
