import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/screens/collection_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionMenu extends ConsumerWidget {
  const CollectionMenu({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AlertDialog deleteDialog = AlertDialog(
      title: const Text('Delete Collection'),
      content: Text('Are you sure you want to delete ${collection.title}?'),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          icon: const Icon(Icons.cancel),
          label: const Text('No'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: const Icon(Icons.delete),
          label: const Text('Yes'),
        ),
      ],
    );

    void removeCollection() async {
      final wantToDelete = await showDialog(
          context: context, builder: (context) => deleteDialog);
      if (wantToDelete) {
        ref.watch(firestoreServiceProvider).removeCollection(collection.uid);
      }
    }

    void onEditCollection() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CollectionFormScreen(collection: collection),
        ),
      );
    }

    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: onEditCollection,
          child: const Text('Edit'),
        ),
        PopupMenuItem(
          onTap: removeCollection,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
