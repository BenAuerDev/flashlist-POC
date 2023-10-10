import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/screens/collection_form_screen.dart';
import 'package:brainstorm_array/widgets/collection/collection_widget_wrapper.dart';
import 'package:brainstorm_array/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goToNewCollectionScreen() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CollectionFormScreen(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Your Lists')),
          actions: [
            IconButton(
              onPressed: goToNewCollectionScreen,
              icon: const Icon(Icons.add_card),
            ),
          ],
        ),
        drawer: const SideDrawer(),
        body: StreamBuilder(
          stream: ref.read(firestoreServiceProvider).userCollectionsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data as List<Collection>;
              final collections = data
                  .map(
                    (doc) => Collection(
                      doc.title,
                      doc.createdAt,
                      doc.uid,
                      Color(doc.color!.value),
                      doc.array,
                      doc.permissions,
                    ),
                  )
                  .toList();

              if (collections.isEmpty) {
                return const Center(child: Text('No lists yet...'));
              }
              return Center(
                child: ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    return CollectionWidgetWrapper(collection: collection);
                  },
                ),
              );
            }
          },
        ));
  }
}
