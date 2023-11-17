import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

ThemeData retrieveTheme(context) {
  return Theme.of(context);
}

TextTheme retrieveTextTheme(context) {
  return retrieveTheme(context).textTheme;
}

ColorScheme retrieveColorScheme(context) {
  return retrieveTheme(context).colorScheme;
}

AppLocalizations retrieveAppLocalizations(context) {
  return AppLocalizations.of(context)!;
}

Brightness retrieveBrightness(context) {
  return retrieveTheme(context).brightness;
}

bool retrieveIsDarkTheme(context) {
  return retrieveBrightness(context) == Brightness.dark;
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
      backgroundColor: retrieveColorScheme(context).primary,
      content: Text(message),
    ),
  );
}
