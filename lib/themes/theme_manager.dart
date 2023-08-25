import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _theme = ThemeData.light();
  ThemeData get theme => _theme;

  void toggleTheme(String themeName) {
    switch (themeName) {
      case "greenTheme":
        _theme = ThemeData(
          primaryColor: Colors.green,
          secondaryHeaderColor:
              const Color.fromARGB(255, 0, 128, 0), // Darker green shade
          cardColor: const Color.fromARGB(255, 144, 238, 144),
          //colorScheme: ColorScheme(background: Colors.white),
        );
        break;
      case "blueTheme":
        _theme = ThemeData(
          primaryColor: Colors.blue,
          secondaryHeaderColor:
              const Color.fromARGB(255, 0, 0, 128), // Darker blue shade
          cardColor: const Color.fromARGB(255, 173, 216, 230),
          //colorScheme: ColorScheme(background: Colors.white),
        );
        break;
      case "redTheme":
        _theme = ThemeData(
          primaryColor: Colors.red,
          secondaryHeaderColor:
              const Color.fromARGB(255, 128, 0, 0), // Darker red shade
          cardColor: const Color.fromARGB(255, 255, 182, 193),
          //colorScheme: ColorScheme(background: Colors.white),
        );
        break;
      case "blackTheme":
        _theme = ThemeData(
          primaryColor: Colors.black,
          secondaryHeaderColor: Colors.white,
          cardColor: Colors.black,
          //colorScheme: ColorScheme(background: Colors.black),
        );
        break;
      // Add more cases for other themes
      default:
        _theme = ThemeData.light();
        break;
    }
    notifyListeners();
  }
}
