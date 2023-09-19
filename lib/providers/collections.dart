import 'package:brainstorm_array/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:brainstorm_array/models/collection.dart';
import 'package:brainstorm_array/services/firebase_services.dart';

final collectionsProvider =
    StateNotifierProvider<CollectionsNotifier, List<Collection>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return CollectionsNotifier(firestoreService);
});

class CollectionsNotifier extends StateNotifier<List<Collection>> {
  final FirestoreService _firestoreService;

  CollectionsNotifier(this._firestoreService) : super([]);

  Future<void> getCollections() async {
    final collections = await _firestoreService.getCollections();
    state = collections;
  }

  Future<void> addCollection(Map<String, dynamic> newCollection) async {
    final newItem = await _firestoreService.addCollection(newCollection);
    state = [...state, newItem];
  }
}
