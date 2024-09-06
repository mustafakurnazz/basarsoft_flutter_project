import 'package:basarsoft/View/logIn/login_view.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash:
    Column(
      children: [
        Center(
          child: LottieBuilder.asset("assets/images/Lottie/Animation - 1724342160651.json"),
        )
      ],
    ), nextScreen: const LoginPage(),
    splashIconSize: 400,
    backgroundColor: Colors.blueAccent,);
  }
}