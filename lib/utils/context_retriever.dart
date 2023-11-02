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
