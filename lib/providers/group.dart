import 'dart:async';

import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userGroupsProvider = StreamProvider<List<Group>>((ref) async* {
  try {
    yield* ref.watch(firestoreServiceProvider).groupsForUserStream();
  } catch (e) {
    print(e);

    throw StateError("failed to get user's groups");
  }
});

final groupProvider =
    FutureProvider.family<Group, String>((ref, groupUid) async {
  try {
    return ref.watch(firestoreServiceProvider).getGroup(groupUid);
  } catch (e) {
    print(e);

    throw StateError("failed to get group");
  }
});

final addGroupProvider = FutureProvider.family
    .autoDispose<Future<Group>, GroupDTO>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).addGroup(data);
  } catch (e) {
    print(e);

    throw StateError("failed to add group");
  }
});

final editGroupProvider = FutureProvider.family
    .autoDispose<Future<Group>, GroupDTO>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).editGroup(data);
  } catch (e) {
    print(e);

    throw StateError("failed to edit group");
  }
});

final removeGroupProvider =
    FutureProvider.family.autoDispose<void, String>((ref, groupUid) async {
  try {
    return ref.watch(firestoreServiceProvider).removeGroup(groupUid);
  } catch (e) {
    print(e);

    throw StateError("failed to remove group");
  }
});

final groupBodyProvider = StreamProvider.autoDispose.family(
  (ref, String groupUid) async* {
    yield* ref.watch(firestoreServiceProvider).groupBodyStream(groupUid);
  },
);

final addItemToGroupBodyProvider = FutureProvider.family
    .autoDispose<Future<void>, Map<String, dynamic>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).addItemToGroupBody(
          data['groupUid'],
          data['name'],
        );
  } catch (e) {
    print(e);

    throw StateError("failed to add item to group body");
  }
});

final removeItemFromGroupBodyProvider = FutureProvider.family
    .autoDispose<FutureOr<void>, Map<String, dynamic>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).removeItemFromGroupBody(
          data['groupUid'],
          data['itemUid'],
        );
  } catch (e) {
    print(e);

    throw StateError("failed to remove item from group body");
  }
});

final setGroupBodyProvider = FutureProvider.family
    .autoDispose<Future<void>, Map<String, dynamic>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).setGroupBody(
          data['groupUid'],
          data['body'],
        );
  } catch (e) {
    print(e);

    throw StateError("failed to set group body");
  }
});

final groupEditorsProvider = StreamProvider.autoDispose.family(
  (ref, String groupUid) async* {
    yield* ref.watch(firestoreServiceProvider).getGroupEditors(groupUid);
  },
);

final groupBodyCountProvider = StreamProvider.autoDispose.family(
  (ref, String groupUid) {
    return ref.watch(firestoreServiceProvider).groupBodyCountStream(groupUid);
  },
);

final removeGroupEditorProvider = Provider.family
    .autoDispose<Future<void>, Map<String, dynamic>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).removeEditorFromGroup(
          data['groupUid'],
          data['editorUid'],
        );
  } catch (e) {
    print(e);

    throw StateError("failed to remove group editor");
  }
});

final inviteUserToGroupProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  try {
    return ref
        .watch(firestoreServiceProvider)
        .inviteUserToGroup(data['group'], data['userUid']);
  } catch (e) {
    print(e);

    throw StateError("failed to invite user to group");
  }
});

final addUserToGroupProvider =
    FutureProvider.family<bool, Map<String, dynamic>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).addUserToGroup(
          data['editorUid'],
          data['groupUid'],
        );
  } catch (e) {
    print(e);

    throw StateError("failed to add user to group");
  }
});

final removeNotificationProvider =
    FutureProvider.family<void, Map<String, dynamic>>(
  (ref, data) async {
    try {
      return ref
          .watch(firestoreServiceProvider)
          .removeNotification(data['userUid'], data['notificationUid']);
    } catch (e) {
      print(e);

      throw StateError("failed to remove notification");
    }
  },
);

final markNotificationAsReadProvider =
    FutureProvider.family<void, Map<String, dynamic>>(
  (ref, data) async {
    try {
      return ref
          .watch(firestoreServiceProvider)
          .markInvitationAsRead(data['userUid'], data['notificationUid']);
    } catch (e) {
      print(e);

      throw StateError("failed to mark notification as read");
    }
  },
);

final acceptGroupInvitationProvider =
    FutureProvider.family<void, Map<String, dynamic>>(
  (ref, data) async {
    try {
      return ref.watch(firestoreServiceProvider).acceptGroupInvitation(
            data['userUid'],
            data['groupUid'],
            data['notificationUid'],
          );
    } catch (e) {
      print(e);

      throw StateError("failed to accept group invitation");
    }
  },
);
