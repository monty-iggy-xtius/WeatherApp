// this class will be responsible for toggling the app's theme setting

import 'package:flutter/material.dart';

class ToggleThemeProvider extends ChangeNotifier {
  // private only accesible in the class
  ThemeData _theme = ThemeData.light();

  ThemeData get theme => _theme;

  void toggleCurrentTheme() {
    final isDarkTheme = _theme == ThemeData.dark();

    if (isDarkTheme) {
      _theme = ThemeData.light();
    } else {
      _theme = ThemeData.dark();
    }

    notifyListeners();
  }
}
