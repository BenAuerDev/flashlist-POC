import 'package:flash_list/widgets/settings/brightness_radio.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Settings',
          textAlign: TextAlign.center,
        )),
        actions: const [
          SizedBox(width: 60),
        ],
      ),
      body: ListView(
        children: const [
          BrightnessRadio(),
        ],
      ),
    );
  }
}
