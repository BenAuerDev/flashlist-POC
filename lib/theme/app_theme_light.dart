import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/theme/card_theme.dart';
import 'package:flashlist/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  textTheme: GoogleFonts.latoTextTheme(
    textTheme.apply(bodyColor: Colors.black),
  ),
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  brightness: Brightness.light,
  cardTheme: cardTheme.copyWith(
    margin: const EdgeInsets.all(Sizes.p4),
  ),
);
