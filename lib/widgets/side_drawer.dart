import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/routing/app_router.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlist/widgets/notification/notification_badge.dart';
import 'package:flashlist/widgets/svg/logo_branding_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: ListView(
        children: [
          const DrawerHeader(
            child: LogoBrandingHorizontal(),
          ),
          Container(
            margin: const EdgeInsets.only(top: Sizes.p12, left: Sizes.p20),
            child: Column(
              children: [
                ListTile(
                  title: Row(children: [
                    const Icon(Icons.person),
                    gapW12,
                    Text(appLocalizationsOf(context).profile),
                  ]),
                  onTap: () => context.goNamed(AppRoute.profile.name),
                ),
                ListTile(
                  title: const Row(children: [
                    NotificationBadge(),
                    gapW12,
                    Text('Notifications'),
                  ]),
                  onTap: () {
                    context.pop();
                    context.goNamed(AppRoute.notifications.name);
                  },
                ),
                ListTile(
                  title: Row(children: [
                    const Icon(Icons.settings),
                    gapW12,
                    Text(appLocalizationsOf(context).settings),
                  ]),
                  onTap: () => context.goNamed(AppRoute.settings.name),
                ),
                ListTile(
                  title: Row(children: [
                    const Icon(Icons.logout),
                    gapW12,
                    Text(appLocalizationsOf(context).signOut),
                  ]),
                  onTap: () {
                    context.pop();
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
