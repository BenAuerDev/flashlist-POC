import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isThemeLight = retrieveTheme(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isThemeLight)
                      const Icon(Icons.light_mode)
                    else
                      const Icon(Icons.dark_mode),
                    const SizedBox(width: 10),
                    if (isThemeLight)
                      const Text('Dark Mode')
                    else
                      const Text('Light Mode'),
                  ],
                ),
                Switch(
                  value: isThemeLight,
                  onChanged: (value) {
                    if (value) {
                      AdaptiveTheme.of(context).setLight();
                    } else {
                      AdaptiveTheme.of(context).setDark();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
