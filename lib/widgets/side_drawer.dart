import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/screens/profile.dart';
import 'package:flashlist/screens/settings.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateTo(Widget screen) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
    }

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
            onTap: () => navigateTo(const ProfileScreen()),
          ),
          ListTile(
            title: Row(children: [
              const Icon(Icons.settings),
              gapW12,
              Text(retrieveAppLocalizations(context).settings),
            ]),
            onTap: () => navigateTo(const SettingsScreen()),
          ),
          ListTile(
            title: Row(children: [
              const Icon(Icons.logout),
              gapW12,
              Text(retrieveAppLocalizations(context).signOut),
            ]),
            onTap: () {
              Navigator.of(context).pop();
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
