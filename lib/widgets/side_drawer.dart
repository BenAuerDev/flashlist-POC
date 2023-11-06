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
            decoration: BoxDecoration(
                color: retrieveColorScheme(context).primaryContainer),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Image.asset(
                      'assets/favicon/logo.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flashlist',
                    style: TextStyle(
                      fontSize: 18,
                      color: retrieveColorScheme(context).onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Row(children: [
              const Icon(Icons.person),
              const SizedBox(width: 10),
              Text(retrieveAppLocalizations(context).profile),
            ]),
            onTap: () => navigateTo(const ProfileScreen()),
          ),
          ListTile(
            title: Row(children: [
              const Icon(Icons.settings),
              const SizedBox(width: 10),
              Text(retrieveAppLocalizations(context).settings),
            ]),
            onTap: () => navigateTo(const SettingsScreen()),
          ),
          ListTile(
            title: Row(children: [
              const Icon(Icons.logout),
              const SizedBox(width: 10),
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
