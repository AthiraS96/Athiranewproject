import 'package:culinary_snap/Lists/EachFoodProvider.dart';
import 'package:culinary_snap/Lists/Indianclass.dart';
import 'package:culinary_snap/Lists/Indianprovider.dart';

import 'package:culinary_snap/Lists/allMealsProvider.dart';

import 'package:culinary_snap/Lists/maincategoryprovider.dart';
import 'package:culinary_snap/Lists/searchProvider.dart';
import 'package:culinary_snap/Pages/CategoryPage.dart';
import 'package:culinary_snap/Pages/DetailPage.dart';
import 'package:culinary_snap/Pages/EachDishDetailPage.dart';
import 'package:culinary_snap/Pages/HomePage.dart';

import 'package:culinary_snap/SplashScreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainCategoryProvider(),
          child: MaterialApp(
            home: Home(), // Or wherever you're including Bottomappbar
          ),
        ),
        ChangeNotifierProvider(create: (context) => IndianCategoryProvider()),
        ChangeNotifierProvider(create: (context) => AllMealsProvider()),
        ChangeNotifierProvider(create: (context) => ShowFoodById()),
        ChangeNotifierProvider(create: (context) => SearchProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: SplashScreen(),
        routes: {
          'all_category_screen': (context) => CategoryPage(),
          'category_details_screen': (context) {
            String id = ModalRoute.of(context)!.settings.arguments.toString();
            String name = ModalRoute.of(context)!.settings.arguments.toString();
            return DetailPage(
              id: id,
              name: name,
            );
          },
          'each_dish_screen': (context) {
            String id = ModalRoute.of(context)!.settings.arguments.toString();

            return EachDishPage(
              id: id,
            );
          },
          //'each_dish_screen': (context) => EachDishPage()
        },
      ),
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
