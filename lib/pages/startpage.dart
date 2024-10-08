import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/weather");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extend body height behind app bar
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.white,
      body: Center(
        child: SpinKitDualRing(
          size: 60,
          color: Colors.teal.shade400,
          duration: const Duration(seconds: 3),
        ),
      ),
    );
  }
}
