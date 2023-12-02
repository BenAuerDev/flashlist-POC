import 'package:flashlist/constants/app_sizes.dart';
import 'package:flutter/material.dart';

final cardTheme = const CardTheme().copyWith(
  margin: const EdgeInsets.all(Sizes.p4),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(Sizes.p4),
    ),
  ),
);
