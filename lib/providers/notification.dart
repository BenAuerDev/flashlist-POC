import 'package:flashlist/providers/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
