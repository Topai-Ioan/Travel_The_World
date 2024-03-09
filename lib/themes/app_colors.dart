import 'package:flutter/material.dart';

class AppColors {
  static const purple = Color(0xFF6200EE);
  static const darkPurple = Color(0xFF3700B3);
  static const lightPurple = Color(0xFFBB86FC);
  static const green = Color(0xFF03DAC6);
  static const lightGreen = Color(0xFF03DAC6);
  static const red = Color(0xFFB00020);
  static const darkRed = Color(0xFF870000);

  static const white = Color.fromARGB(255, 255, 255, 255);
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const darkGreen = Color.fromARGB(255, 40, 92, 42);

  static const lightGrey = Color.fromARGB(255, 194, 192, 192);
  static const grey = Color.fromARGB(255, 200, 200, 200);
  static const darkGrey = Color.fromARGB(255, 70, 70, 70);

  static const olive = Color.fromARGB(255, 173, 188, 159);
  static const darkOlive = Color.fromARGB(255, 67, 104, 80);
}

Color getTextColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? AppColors.black
      : AppColors.white;
}

Color getBackgroundColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Colors.white
      : Colors.black;
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
