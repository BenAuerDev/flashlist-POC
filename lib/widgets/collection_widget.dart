import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/screens/new_array_item.dart';
import 'package:brainstorm_array/widgets/array_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CollectionWidget extends HookWidget {
  const CollectionWidget({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    void addItemToArray() async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NewArrayItemScreen(collection: collection),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: collection.color!),
        color: collection.color!.withOpacity(0.2),
      ),
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
          ArrayWidget(array: collection.array),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: addItemToArray,
                icon: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}
