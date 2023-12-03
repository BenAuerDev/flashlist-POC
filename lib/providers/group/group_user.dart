import 'package:flashlist/providers/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final groupEditorsProvider = StreamProvider.autoDispose.family(
  (ref, String groupUid) async* {
    yield* ref.watch(firestoreServiceProvider).getGroupEditors(groupUid);
  },
);

final groupUsersProvider = StreamProvider.autoDispose.family(
  (ref, String groupUid) async* {
    yield* ref.watch(firestoreServiceProvider).getGroupUsers(groupUid);
  },
);

final removeGroupEditorProvider = Provider.family
    .autoDispose<Future<void>, Map<String, String>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).removeEditorFromGroup(
          data['groupUid']!,
          data['editorUid']!,
        );
  } catch (error) {
    throw StateError("failed to remove group editor: $error");
  }
});

final inviteUserToGroupProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  try {
    return ref
        .watch(firestoreServiceProvider)
        .inviteUserToGroup(data['group'], data['userUid']);
  } catch (error) {
    throw StateError("failed to invite user to group: $error");
  }
});

final addUserToGroupProvider =
    FutureProvider.family<bool, Map<String, String>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).addUserToGroup(
          data['editorUid']!,
          data['groupUid']!,
        );
  } catch (error) {
    throw StateError("failed to add user to group: $error");
  }
});
