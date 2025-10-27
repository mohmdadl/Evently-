import 'package:enevtly/core/resourses/assets_manager.dart';
import 'package:enevtly/core/resourses/colors_manager.dart';
import 'package:enevtly/ui/welcome/screen/welcome_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Splash extends StatelessWidget {
  static const String routName = "spalsh";
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorsManager.lightBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsManager.logo)
                .animate(
                  onComplete: (controller) => {
                    Navigator.pushReplacementNamed(context, Welcome.routName),
                  },
                )
                .slideX(duration: 600.ms)
                .then(delay: 500.ms)
                .rotate(duration: 3000.ms)
                .then()
                .fadeOut(duration: 1.seconds),
            SizedBox(height: 10),
            Image.asset(
              AssetsManager.evently,
            ).animate(delay: 4.seconds).fadeOut(duration: 1.seconds),
          ],
        ),
      ),
    );
  }
}
