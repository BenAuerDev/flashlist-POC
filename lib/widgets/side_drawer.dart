import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/routing/app_router.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          DrawerHeader(
            decoration:
                BoxDecoration(color: retrieveColorScheme(context).background),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  retrieveIsDarkTheme(context)
                      ? 'assets/favicon/logo_white_no_background.png'
                      : 'assets/favicon/logo_black_no_background.png',
                  width: 120,
                  height: 100,
                ),
                Text(
                  'Flashlist',
                  style: TextStyle(
                    fontSize: Sizes.p16,
                    color: retrieveColorScheme(context).onBackground,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(children: [
              const Icon(Icons.person),
              gapW12,
              Text(retrieveAppLocalizations(context).profile),
            ]),
            onTap: () => context.goNamed(AppRoute.profile.name),
          ),
          ListTile(
            title: Row(children: [
              const Icon(Icons.settings),
              gapW12,
              Text(retrieveAppLocalizations(context).settings),
            ]),
            onTap: () => context.goNamed(AppRoute.settings.name),
          ),
          ListTile(
            title: Row(children: [
              const Icon(Icons.logout),
              gapW12,
              Text(retrieveAppLocalizations(context).signOut),
            ]),
            onTap: () {
              context.pop();
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
