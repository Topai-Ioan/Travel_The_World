import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:travel_the_world/themes/app_colors.dart';

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

  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
    ),
  );
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.black,
      surfaceTintColor: AppColors.black,
    ),
  );
}
