import 'dart:ui';

import 'package:flutter/material.dart';

class Themes {
  static const Color green = Color.fromARGB(255, 0, 255, 0);
  static const Color darkgreen = Color.fromARGB(255, 4, 56, 4);

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
    useMaterial3: true,
    primaryColor: Colors.white,
    primaryColorDark: const Color.fromARGB(255, 4, 56, 4),
    primaryColorLight: const Color.fromARGB(255, 0, 255, 0),
    //bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
    //appBarTheme: const AppBarTheme(color: Colors.black),

    colorScheme: const ColorScheme.dark().copyWith(
      background: Colors.black,
      primary: Colors.white,
      secondary: const Color.fromARGB(255, 4, 56, 4),
      tertiary: Colors.grey[800],
      onTertiary: Colors.white,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.white,
        ),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black,
    primaryColorDark: const Color.fromARGB(255, 4, 56, 4),
    primaryColorLight: const Color.fromARGB(255, 0, 255, 0),
    useMaterial3: true,
    colorScheme: const ColorScheme.light().copyWith(
      background: Colors.white,
      primary: Colors.black,
      secondary: const Color.fromARGB(255, 21, 145, 21),
      tertiary: Colors.grey[300],
      onTertiary: Colors.white,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.black,
        ),
  );
}
