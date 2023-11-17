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

final groupBodyCountProvider = StreamProvider.autoDispose.family(
  (ref, String groupUid) {
    return ref.watch(firestoreServiceProvider).groupBodyCountStream(groupUid);
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

final removeNotificationProvider =
    FutureProvider.family<void, Map<String, String>>(
  (ref, data) async {
    try {
      return ref.watch(firestoreServiceProvider).removeNotification(
            data['userUid']!,
            data['notificationUid']!,
          );
    } catch (error) {
      throw StateError("failed to remove notification: $error");
    }
  },
);

final markNotificationAsReadProvider =
    FutureProvider.family<void, Map<String, String>>(
  (ref, data) async {
    try {
      return ref
          .watch(firestoreServiceProvider)
          .markInvitationAsRead(data['userUid']!, data['notificationUid']!);
    } catch (error) {
      throw StateError("failed to mark notification as read: $error");
    }
  },
);

final acceptGroupInvitationProvider =
    FutureProvider.family<void, Map<String, String>>(
  (ref, data) async {
    try {
      return ref.watch(firestoreServiceProvider).acceptGroupInvitation(
            data['userUid']!,
            data['groupUid']!,
            data['notificationUid']!,
          );
    } catch (error) {
      throw StateError("failed to accept group invitation: $error");
    }
  },
);
