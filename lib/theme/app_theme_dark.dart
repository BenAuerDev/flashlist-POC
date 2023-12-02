import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/theme/card_theme.dart';
import 'package:flashlist/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkTheme = ThemeData(
  textTheme: GoogleFonts.latoTextTheme(
    textTheme.apply(bodyColor: Colors.white),
  ),
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  brightness: Brightness.dark,
  cardTheme: cardTheme.copyWith(
    margin: const EdgeInsets.all(Sizes.p4),
    color: Colors.black38,
  ),
);
