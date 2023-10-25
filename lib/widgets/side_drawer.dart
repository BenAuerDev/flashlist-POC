import 'package:flash_list/screens/profile.dart';
import 'package:flash_list/screens/settings.dart';
import 'package:flash_list/utils/context_retriever.dart';
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
            title: const Row(children: [
              Icon(Icons.person),
              SizedBox(width: 10),
              Text('Profile'),
            ]),
            onTap: () => navigateTo(const ProfileScreen()),
          ),
          ListTile(
            title: const Row(children: [
              Icon(Icons.settings),
              SizedBox(width: 10),
              Text('Settings'),
            ]),
            onTap: () => navigateTo(const SettingsScreen()),
          ),
          ListTile(
            title: const Row(children: [
              Icon(Icons.logout),
              SizedBox(width: 10),
              Text('Sign out'),
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
