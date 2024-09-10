import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culinary_snap/Lists/allMealsProvider.dart';
import 'package:culinary_snap/Lists/categoryclass.dart';
import 'package:culinary_snap/Pages/DetailPage.dart';
import 'package:culinary_snap/Pages/EachDishDetailPage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class IndianFoodWidget extends StatefulWidget {
  final String id;
  final String name;
  //final String description;
  final String image;

  const IndianFoodWidget(
      {super.key,
      required this.id,
      required this.name,
      //required this.description,
      required this.image});

  @override
  State<IndianFoodWidget> createState() => _IndianFoodWidgettState();
}

class _IndianFoodWidgettState extends State<IndianFoodWidget> {
  List<Categories> categoryMeals = [];

  Future<void> getAllMeals() async {
    //String cat_widget_id = widget.id.split(',').last.split(']')[0].trim();
    String cat_widget_name = widget.id.split(',').first.split('[')[1].trim();
    // print(cat_widget_name);

    Future<List<Categories>> categoryMealsFutObject =
        Provider.of<AllMealsProvider>(context)
            .getMealsForCategory(categoryName: cat_widget_name);

    categoryMeals = await categoryMealsFutObject;
  }

  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //  final pet = Provider.of<PetModel>(context);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 1),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(EachDishPage.rountname, arguments: [widget.id]);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 100,
                          width: 110,
                          child: Image.network(
                            width: 105,
                            height: 20,
                            widget.image,
                            fit: BoxFit.fitWidth,
                          )),
                      SizedBox(
                        child: Text(widget.name,
                            style: GoogleFonts.acme(
                              textStyle: TextStyle(
                                  fontSize: 12, overflow: TextOverflow.fade),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
