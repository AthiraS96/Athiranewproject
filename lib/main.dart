import 'package:culinary_snap/Login/loginPage.dart';
import 'package:culinary_snap/SplashScreen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: foodApp(),
    );
  }
}

class foodApp extends StatefulWidget {
  const foodApp({super.key});

  @override
  State<foodApp> createState() => _foodAppState();
}

class _foodAppState extends State<foodApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
