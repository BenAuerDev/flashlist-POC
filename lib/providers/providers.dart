import 'package:brainstorm_array/services/firebase_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});
