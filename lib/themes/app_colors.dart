import 'package:flutter/material.dart';

class AppColors {
  static const red = Color(0xFFB00020);

  static const white = Color.fromARGB(255, 255, 255, 255);
  static const black = Color.fromARGB(255, 0, 0, 0);

  static const olive = Color.fromARGB(255, 173, 188, 159);
  static const darkOlive = Color.fromARGB(255, 67, 104, 80);

  static const transparent = Colors.transparent;
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
