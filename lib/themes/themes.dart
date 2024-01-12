import 'dart:ui';

import 'package:flutter/material.dart';

class Themes {
  final Color lightPrimaryColor;
  final Color lightSecondaryColor;
  final Color darkPrimaryColor;
  final Color darkSecondaryColor;

  Themes({
    this.lightPrimaryColor = Colors.purple,
    this.lightSecondaryColor = Colors.green,
    this.darkPrimaryColor = Colors.black,
    this.darkSecondaryColor = Colors.white,
  });

  static final Themes _themes = Themes();

  static ThemeData get systemTheme {
    Brightness platformBrightness =
        PlatformDispatcher.instance.platformBrightness;

    if (platformBrightness == Brightness.dark) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themes.darkPrimaryColor,
      secondary: _themes.darkSecondaryColor,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: _themes.darkSecondaryColor,
          displayColor: _themes.darkSecondaryColor,
        ),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themes.lightPrimaryColor,
      secondary: _themes.lightSecondaryColor,
    ),
  );
}
