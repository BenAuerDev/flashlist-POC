import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

ThemeData themeOf(context) {
  return Theme.of(context);
}

TextTheme textThemeOf(context) {
  return themeOf(context).textTheme;
}

ColorScheme colorSchemeOf(context) {
  return themeOf(context).colorScheme;
}

AppLocalizations appLocalizationsOf(context) {
  return AppLocalizations.of(context)!;
}

Brightness brightnessOf(context) {
  return themeOf(context).brightness;
}

bool isDarkThemeOf(context) {
  return brightnessOf(context) == Brightness.dark;
}

void showContextSnackBar({
  context,
  required String message,
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: action,
      backgroundColor: colorSchemeOf(context).primary,
      content: Text(message),
    ),
  );
}
