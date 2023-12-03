import 'dart:async';

import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userGroupsProvider = StreamProvider<List<Group>>((ref) async* {
  try {
    yield* ref.watch(firestoreServiceProvider).groupsForUserStream();
  } catch (error) {
    throw StateError("failed to get user's groups: $error");
  }
});

final groupProvider =
    FutureProvider.autoDispose.family<Group, String>((ref, groupUid) async {
  try {
    return ref.watch(firestoreServiceProvider).getGroup(groupUid);
  } catch (error) {
    throw StateError("failed to get group: $error");
  }
});

final addGroupProvider = FutureProvider.family
    .autoDispose<Future<Group>, GroupDTO>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).addGroup(data);
  } catch (error) {
    throw StateError("failed to add group: $error");
  }
});

final editGroupProvider = FutureProvider.family
    .autoDispose<Future<Group>, GroupDTO>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).editGroup(data);
  } catch (error) {
    throw StateError("failed to edit group: $error");
  }
});

final removeGroupProvider =
    FutureProvider.family.autoDispose<void, String>((ref, groupUid) async {
  try {
    return ref.watch(firestoreServiceProvider).removeGroup(groupUid);
  } catch (error) {
    throw StateError("failed to remove group: $error");
  }
});
