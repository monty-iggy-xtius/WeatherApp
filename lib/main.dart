import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/pages/searchlocation.dart';
import 'package:weatherapp/pages/startpage.dart';
import 'package:weatherapp/pages/weatherui.dart';
import 'package:weatherapp/provider/theme_provider.dart';

void main() {
  // wrapping the Material App in a ChangeNotifierProvider allows us to access the provider from anywhere in the app
  runApp(ChangeNotifierProvider(
    create: (context) => ToggleThemeProvider(),
    builder: (context, child) {
      final provider = Provider.of<ToggleThemeProvider>(context);
      return MaterialApp(
        theme: provider.theme,
        // remove the debug banner in the app
        debugShowCheckedModeBanner: false,
        // define the default screen shown on load
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/weather': (context) => const WeatherPage(),
          '/search': (context) => const SearchLocation()
        },
      );
    },
  ));
}
