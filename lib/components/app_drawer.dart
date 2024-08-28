import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/provider/theme_provider.dart';

// will have an app logo, a settings icon and a home icon
class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // app icon
          DrawerHeader(
              child: Icon(
            Icons.window_rounded,
            color: Theme.of(context).colorScheme.inversePrimary,
            size: 45,
          )),

          // back to home tile
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 25, right: 15),
            child: ListTile(
              leading: Text(
                "Home",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                 fontFamily: "Rale",
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),

              title: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.home_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 30,
                ),
              ),
              // pop the drawer and return to home page
              onTap: () => Navigator.pop(context),
            ),
          ),

          // settings tile
          // try to change the theme from here
          // use a switch widget
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 25, right: 15),
            child: ListTile(
              leading: Text(
                "Dark Theme",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: "Rale",
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              title: Align(
                alignment: Alignment.centerRight,
                child: CupertinoSwitch(
                    activeColor: Colors.teal.shade400,
                    // the value is the getter to check if theme is dark mode
                    value: Provider.of<CustomThemeProvider>(context, listen: false).isDarkTheme,
                    onChanged: (value) {
                        // the toggling of themes happens here
                        Provider.of<CustomThemeProvider>(context, listen: false).toggleCurrentTheme();
                        },
                            
                            ),
              ),

            onTap: () {},
          )
      )],
      ),
    );
  }
}
