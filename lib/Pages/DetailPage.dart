import 'package:culinary_snap/Lists/allMealsProvider.dart';
import 'package:culinary_snap/Lists/categoryclass.dart';
import 'package:culinary_snap/Lists/errorscreen.dart';
import 'package:culinary_snap/Lists/loadin_screen.dart';
import 'package:culinary_snap/Lists/maincategoryprovider.dart';
import 'package:culinary_snap/Pages/AddToCartPage.dart';
import 'package:culinary_snap/Pages/EachDishDetailPage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  static const rountname = 'category_details_screen';
  final String id;
  final String name;
  const DetailPage({super.key, required this.id, required this.name});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Categories> categoryMeals = [];

  Future<void> getAllMeals() async {
    print("Inside Details Page....");
    print("Widget ID: " + widget.id);
    String cat_widget_id = widget.id.split(',').last.split(']')[0].trim();
    String cat_widget_name = widget.id.split(',').first.split('[')[1].trim();
    print(cat_widget_name);

    Future<List<Categories>> categoryMealsFutObject =
        Provider.of<AllMealsProvider>(context)
            .getMealsForCategory(categoryName: cat_widget_name);

    categoryMeals = await categoryMealsFutObject;
    print("cat meals");
    print(categoryMeals);
  }

  @override
  Widget build(BuildContext context) {
    if (categoryMeals.length == 0) {
      getAllMeals();
    }

    final meals = Provider.of<AllMealsProvider>(context);
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
            backgroundColor: Backgroundcolor,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Backgroundcolor,
              elevation: 0,
              title: Center(
                child: Text(widget.name.split(',').first.split('[')[1].trim(),
                    style: GoogleFonts.acme(
                      textStyle: TextStyle(fontSize: 30, color: logocolour),
                    )),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: ((context) => CartPage())),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    )),
                SizedBox(
                  width: size.width * 0.05,
                )
              ],
            ),
            body: meals.islOading
                ? const LoadingScreen(
                    title: 'Loading...',
                  )
                : categoryMeals.isEmpty
                    ? ErrorScreen(title: meals.isError.toString())
                    : categoryMeals.isEmpty
                        ? const Text(
                            'No Products ',
                          )
                        : categoryMeals.isEmpty
                            ? const Center(child: Text("No Products"))
                            : GridView.builder(
                                itemCount: categoryMeals.length,
                                itemBuilder: (ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          EachDishPage.rountname,
                                          arguments: [
                                            categoryMeals[index].idCategory
                                          ]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 10, right: 10),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 160,
                                                  width: 160,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  tileMode:
                                                                      TileMode
                                                                          .decal,
                                                                  colors: [
                                                                    Colors
                                                                        .transparent,
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.99999),
                                                                  ],
                                                                  stops: const [
                                                                    0.7,
                                                                    6
                                                                  ],
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                        image:
                                                                            NetworkImage(
                                                                  categoryMeals[
                                                                          index]
                                                                      .strCategoryThumb,
                                                                )),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .black12),
                                                            child: Text(
                                                                categoryMeals[
                                                                        index]
                                                                    .strCategory,
                                                                style:
                                                                    GoogleFonts
                                                                        .acme(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                              )));
  }
}
