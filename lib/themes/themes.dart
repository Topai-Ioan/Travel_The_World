import 'dart:ui';

import 'package:flutter/material.dart';

class Themes {
  static ThemeData get systemTheme {
    Brightness platformBrightness =
        PlatformDispatcher.instance.platformBrightness;

    if (platformBrightness == Brightness.dark) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  static ThemeData lightTheme = ThemeData();

  static ThemeData darkTheme = ThemeData();
}
