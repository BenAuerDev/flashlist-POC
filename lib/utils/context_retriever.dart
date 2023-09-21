import 'package:flutter/material.dart';

ThemeData retrieveTheme(context) {
  return Theme.of(context);
}

TextTheme retrieveTextTheme(context) {
  return retrieveTheme(context).textTheme;
}

ColorScheme retrieveColorScheme(context) {
  return retrieveTheme(context).colorScheme;
}
