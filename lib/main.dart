import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/pages/searchlocation.dart';
import 'package:weatherapp/pages/startpage.dart';
import 'package:weatherapp/pages/weatherui.dart';
import 'package:weatherapp/provider/theme_provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // force the app layout to always be in potrait mode 
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  // wrapping the Material App in a ChangeNotifierProvider allows us to access the provider from anywhere in the app
  runApp(ChangeNotifierProvider(
    create: (context) => CustomThemeProvider(),
    builder: (context, child) {
      return MaterialApp(
        // use the getter to reurn current theme
        theme: Provider.of<CustomThemeProvider>(context).themeData,
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
