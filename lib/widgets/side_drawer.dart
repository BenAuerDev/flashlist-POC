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
                  Icon(
                    Icons.list_alt,
                    size: 50,
                    color: retrieveColorScheme(context).primary,
                  ),
                  Text(
                    'Flash List',
                    style: TextStyle(
                      fontSize: 24,
                      color: retrieveColorScheme(context).primary,
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
