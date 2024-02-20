import 'package:flutter/material.dart';

class AppColors {
  static const purple = Color(0xFF6200EE);
  static const darkPurple = Color(0xFF3700B3);
  static const lightPurple = Color(0xFFBB86FC);
  static const green = Color(0xFF03DAC6);
  static const darkGreen = Color(0xFF018786);
  static const lightGreen = Color(0xFF03DAC6);
  static const red = Color(0xFFB00020);
  static const darkRed = Color(0xFF870000);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const black = Color.fromARGB(255, 0, 0, 0);
}

Color getThemeColor(
    BuildContext? context, Color? lightThemeColor, Color? darkThemeColor) {
  if (context == null || lightThemeColor == null || darkThemeColor == null) {
    return Colors.transparent;
  }
  return Theme.of(context).brightness == Brightness.light
      ? lightThemeColor
      : darkThemeColor;
}
