import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/screens/collection_form_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUser = FirebaseAuth.instance.currentUser;

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

    void onRemoveEditor() {
      FirebaseFirestore.instance
          .collection('collections')
          .doc(collection.uid)
          .update({
        'title': collection.title,
        'color': collection.color!.value,
        'uid': collection.uid,
        'array': collection.array,
        'permissions': {
          'owner': collection.permissions['owner'],
          'editors': collection.permissions['editors']
              .where((editor) => editor != currentUser!.uid)
              .toList(),
        },
      });
    }

    return PopupMenuButton(
      itemBuilder: (context) => [
        // Owner
        if (collection.permissions['owner'] == currentUser!.uid)
          PopupMenuItem(
            onTap: onEditCollection,
            child: const Text('Edit'),
          ),
        if (collection.permissions['owner'] == currentUser!.uid)
          PopupMenuItem(
            onTap: removeCollection,
            child: const Text('Delete'),
          ),

        // Editors
        if (collection.permissions['editors'].contains(currentUser!.uid) &&
            collection.permissions['owner'] != currentUser!.uid)
          PopupMenuItem(
            onTap: onRemoveEditor,
            child: const Text('Remove'),
          ),
      ],
    );
  }
}
