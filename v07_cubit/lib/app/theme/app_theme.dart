import 'package:flutter/material.dart';

class AppThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: Colors.amber,
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
  );
}
