import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final userDataProvider = StreamProvider((ref) {
  final userData = ref.watch(userProvider).value;

  if (userData != null) {
    var docRef =
        FirebaseFirestore.instance.collection('users').doc(userData.uid);
    return docRef.snapshots().map((snapshot) => snapshot.data());
  } else {
    return const Stream.empty();
  }
});
