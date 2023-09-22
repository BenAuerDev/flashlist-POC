import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/widgets/array_widget.dart';
import 'package:brainstorm_array/widgets/collection/collection_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CollectionWidget extends HookWidget {
  const CollectionWidget({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                Text(
                  collection.title,
                  style: TextStyle(
                    color: collection.color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CollectionMenu(collection: collection),
              ],
            ),
            const SizedBox(height: 12),
            ArrayWidget(collectionUid: collection.uid),
          ],
        ),
      ),
    );
  }
}
