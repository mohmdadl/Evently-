import 'package:enevtly/ui/splash/screen/splas_screen.dart';
import 'package:enevtly/ui/welcome/screen/welcome_screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Evently());
}

class Evently extends StatelessWidget {
  const Evently({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: Splash.routName,
      routes: {
        Splash.routName : (context) => Splash(),
        Welcome.routName : (context) => Welcome(),
      },
    );
  }
}
