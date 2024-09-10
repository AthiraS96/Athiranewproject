import 'package:culinary_snap/Get_started/get_started_screen.dart';
import 'package:culinary_snap/Login/loginPage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              image: AssetImage('assets/background_image.jpg'),
              fit: BoxFit.cover)),
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 100, 50, 250),
        child: SplashScreenView(
            duration: Duration(milliseconds: 4000),
            // backgroundColor: Color.fromARGB(255, 225, 198, 207),
            navigateWhere: isLoaded,
            navigateRoute: const Sliding(),
            text: WavyAnimatedText(
              " Flavor  Finds",
              textStyle: GoogleFonts.acme(
                color: Color.fromARGB(255, 248, 245, 245),
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            imageSrc: "assets/Flavor Finds_With_Title.png"),
      ),
    );
  }
}
