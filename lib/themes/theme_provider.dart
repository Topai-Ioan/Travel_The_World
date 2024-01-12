import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_the_world/themes/themes.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeData _themeData;

  ThemeProvider(this._themeData) {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadThemeFromPrefs();
    });
  }

  @override
  void didChangePlatformBrightness() {
    getThemeName().then((theme) {
      if (theme == 'system') {
        Brightness platformBrightness =
            PlatformDispatcher.instance.platformBrightness;
        var isDarkMode = platformBrightness == Brightness.dark;
        setThemeAsync(isDarkMode ? 'dark' : 'light');
      }
    });

    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ThemeData get themeData => _themeData;

  Future<String?> getThemeName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme');
  }

  loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('theme');
    switch (themeName) {
      case 'dark':
        _themeData = Themes.darkTheme;
        break;
      case 'light':
        _themeData = Themes.lightTheme;
        break;
      case 'system':
        _themeData = Themes.systemTheme;
        break;
      default:
        _themeData = Themes.systemTheme;
        break;
    }
    notifyListeners();
  }

  setThemeAsync(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeName);
    switch (themeName) {
      case 'dark':
        _themeData = Themes.darkTheme;
        break;
      case 'light':
        _themeData = Themes.lightTheme;
        break;
      case 'system':
        _themeData = Themes.systemTheme;
        break;
      default:
        _themeData = Themes.systemTheme;
        break;
    }
    notifyListeners();
  }

  setWhiteThemeAsync() async {
    await setThemeAsync('light');
  }

  setDarkThemeAsync() async {
    await setThemeAsync('dark');
  }

  setSystemThemeAsync() async {
    await setThemeAsync('system');
  }
}