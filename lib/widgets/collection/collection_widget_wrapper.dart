import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/screens/new_array_item.dart';
import 'package:brainstorm_array/widgets/collection/collection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CollectionWidgetWrapper extends HookWidget {
  const CollectionWidgetWrapper({super.key, required this.collection});

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
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: collection.color!),
        color: collection.color!.withOpacity(0.2),
      ),
      child: Column(
        children: [
          Hero(
            tag: collection.uid,
            child: CollectionWidget(
              collection: collection,
            ),
          ),
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
