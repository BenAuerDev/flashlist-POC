import 'dart:async';

import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final groupBodyProvider = StreamProvider.autoDispose.family(
  (ref, String groupUid) async* {
    yield* ref.watch(firestoreServiceProvider).groupBodyStream(groupUid);
  },
);

final addItemToGroupBodyProvider = FutureProvider.family
    .autoDispose<Future<void>, Map<String, String>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).addItemToGroupBody(
          data['groupUid']!,
          data['name']!,
        );
  } catch (error) {
    throw StateError("failed to add item to group body: $error");
  }
});

final removeItemFromGroupBodyProvider = FutureProvider.family
    .autoDispose<FutureOr<void>, Map<String, String>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).removeItemFromGroupBody(
          data['groupUid']!,
          data['itemUid']!,
        );
  } catch (error) {
    throw StateError("failed to remove item from group body: $error");
  }
});

final setGroupBodyProvider = FutureProvider.family
    .autoDispose<Future<void>, Map<String, Object>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).setGroupBody(
          data['groupUid'] as String,
          data['body'] as List<GroupBodyItem>,
        );
  } catch (error) {
    throw StateError("failed to set group body: $error");
  }
});

final groupBodyCountProvider = StreamProvider.autoDispose.family(
  (ref, String groupUid) {
    return ref.watch(firestoreServiceProvider).groupBodyCountStream(groupUid);
  },
);
