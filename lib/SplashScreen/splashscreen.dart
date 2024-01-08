import 'package:culinary_snap/Login/loginPage.dart';
import 'package:culinary_snap/main.dart';
import 'package:flutter/material.dart';
import 'package:tbib_splash_screen/splash_screen.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  get isLoaded => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/splashscreen.png'), fit: BoxFit.cover)),
      child: SplashScreenView(
          duration: Duration(milliseconds: 10000),
          // backgroundColor: Color.fromARGB(255, 225, 198, 207),
          navigateWhere: isLoaded,
          navigateRoute: const Login(),
          text: WavyAnimatedText(
            "Culinary Snap",
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 144, 12, 12),
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          imageSrc: "assets/logo_circle.png"),
    );
  }
}
