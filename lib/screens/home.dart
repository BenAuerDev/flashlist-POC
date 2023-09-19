import 'package:brainstorm_array/screens/new_collection.dart';
import 'package:brainstorm_array/widgets/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:brainstorm_array/providers/collections.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);

    void addCollection() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NewCollectionScreen(),
        ),
      );
    }

    useEffect(() {
      ref.read(collectionsProvider.notifier).getCollections();
      return null;
    }, []);

    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (collections.isNotEmpty) {
      content = Center(
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Lists'),
        actions: [
          IconButton(
            onPressed: addCollection,
            icon: const Icon(Icons.add_card),
          ),
        ],
      ),
      body: content,
    );
  }
}
