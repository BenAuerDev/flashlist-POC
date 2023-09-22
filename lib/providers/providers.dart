import 'package:brainstorm_array/services/firebase_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final arrayProvider = StreamProvider.autoDispose.family(
  (ref, String uid) {
    return ref
        .watch(firestoreServiceProvider)
        .collectionsCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot['array'])
        .asBroadcastStream();
  },
);
