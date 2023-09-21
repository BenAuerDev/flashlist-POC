import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/screens/new_collection.dart';
import 'package:brainstorm_array/widgets/collection_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goToNewCollectionScreen() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NewCollectionScreen(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Lists'),
          actions: [
            IconButton(
              onPressed: goToNewCollectionScreen,
              icon: const Icon(Icons.add_card),
            ),
          ],
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('collections').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data as QuerySnapshot;
              final collections = data.docs
                  .map(
                    (doc) => Collection(
                      doc['title'],
                      doc['createdAt'],
                      doc.id,
                      Color(doc['color']),
                      doc['array'],
                    ),
                  )
                  .toList();
              return Center(
                child: ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    return ListTile(
                      key: ValueKey(collection.uid),
                      title: CollectionWidget(collection: collection),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
