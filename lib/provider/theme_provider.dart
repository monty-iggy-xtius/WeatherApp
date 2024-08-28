// this class will be responsible for toggling the app's theme setting

import 'package:flutter/material.dart';
import 'package:weatherapp/provider/dark_theme.dart';
import 'package:weatherapp/provider/light_theme.dart';

class CustomThemeProvider extends ChangeNotifier {
  // private only accesible in the class
  // initially the theme is set to light mode 
  ThemeData _currentTheme = lightTheme;

  // getter to return current theme
  ThemeData get themeData => _currentTheme;

  // check if the theme is set to dark
  bool get isDarkTheme => _currentTheme == darkTheme;

  // this setter function sets the theme to the given theme 
  set newTheme(ThemeData themeData) {
    _currentTheme = themeData;

    // use the listeners to notify and update UI 
    notifyListeners();
  }

  void toggleCurrentTheme() {
    if (_currentTheme == lightTheme) {
      // use the setter to update themes
      newTheme = darkTheme;
    }
    else{
      newTheme = lightTheme;
    }
  }
}
