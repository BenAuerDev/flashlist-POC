import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlist/providers/users.dart';
import 'package:flashlist/screens/auth.dart';
import 'package:flashlist/screens/group_form.dart';
import 'package:flashlist/screens/home.dart';
import 'package:flashlist/screens/new_body_item_form.dart';
import 'package:flashlist/screens/profile.dart';
import 'package:flashlist/screens/settings.dart';
import 'package:flashlist/screens/share.dart';
import 'package:flashlist/widgets/async_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum AppRoute {
  home,
  auth,
  settings,
  profile,
  addItemToBody,
  addGroup,
  editGroup,
  shareGroup,
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) {
        return Consumer(
          builder: (context, ref, child) {
            // TODO: think about using ref.watch(authProvider).value
            // and if it's null, show the auth screen
            // as the splash screen is shown until the auth state is loaded
            final authValue = ref.watch(authProvider);

            return DefaultTabController(
              length: 2,
              child: AsyncValueWidget<User?>(
                value: authValue,
                data: (user) {
                  FlutterNativeSplash.remove();
                  if (user != null) {
                    return const HomeScreen();
                  }
                  return const AuthScreen();
                },
              ),
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: 'add-group',
          name: AppRoute.addGroup.name,
          builder: (context, state) => const GroupForm(),
        ),
        GoRoute(
          path: 'edit-group/:id',
          name: AppRoute.editGroup.name,
          pageBuilder: (context, state) {
            final groupUid = state.pathParameters['id']!;
            return MaterialPage(
              child: GroupForm(groupUid: groupUid),
            );
          },
        ),
        GoRoute(
          path: 'share-group/:id',
          name: AppRoute.shareGroup.name,
          pageBuilder: (context, state) {
            final groupUid = state.pathParameters['id']!;
            return MaterialPage(
              child: ShareScreen(groupUid: groupUid),
            );
          },
        ),
        GoRoute(
          path: 'add-item-to-group/:id',
          name: AppRoute.addItemToBody.name,
          pageBuilder: (context, state) {
            final groupUid = state.pathParameters['id']!;
            return MaterialPage(
              child: NewBodyItemForm(groupUid: groupUid),
            );
          },
        ),
        GoRoute(
          path: 'settings',
          name: AppRoute.settings.name,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: 'profile',
          name: AppRoute.profile.name,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
