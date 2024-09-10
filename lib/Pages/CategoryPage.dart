import 'package:culinary_snap/Lists/allMealsProvider.dart';
import 'package:culinary_snap/Lists/categoryclass.dart';

import 'package:culinary_snap/Lists/maincategoryprovider.dart';
import 'package:culinary_snap/Pages/AddToCartPage.dart';
import 'package:culinary_snap/Pages/DetailPage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  final String? image;
  final String? categoryName;
  const CategoryPage({super.key, this.categoryName, this.image});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Categories> categories = [];
  @override
  void initState() {
    Provider.of<AllMealsProvider>(context, listen: false)
        .getAllCategoryMeals(context: context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final category = Provider.of<MainCategoryProvider>(context);
    var Size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Backgroundcolor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Backgroundcolor,
        elevation: 0,
        title: Center(
          child: Text('Categories    ',
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
          // SizedBox(
          //   width: Size.width * 0.005,
          // )
        ],
      ),
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: Size.width * 0.40,
            height: Size.height * 2.5,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 107, 18, 12),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35)),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: category.categories.length,
                      itemBuilder: ((context, index) {
                        return AllCategoryPageWidget(
                            id: category.categories[index].idCategory,
                            name: category.categories[index].strCategory,
                            image: category.categories[index].strCategoryThumb);
                      }))
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class AllCategoryPageWidget extends StatefulWidget {
  final String id;
  final String name;
  //final String description;
  final String image;

  const AllCategoryPageWidget(
      {super.key,
      required this.id,
      required this.name,
      //required this.description,
      required this.image});

  @override
  State<AllCategoryPageWidget> createState() => _AllCategoryPageWidgettState();
}

class _AllCategoryPageWidgettState extends State<AllCategoryPageWidget> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //  final pet = Provider.of<PetModel>(context);

    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(DetailPage.rountname,
              arguments: [widget.name, widget.id]);
        },
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(alignment: Alignment.centerRight, children: [
              Container(
                margin: const EdgeInsets.only(top: 9, bottom: 8, right: 20),
                width: size.width - 120,
                height: 90,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 208, 208),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 7,
                          offset: Offset(0, 4))
                    ]),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(widget.image,
                        // widget.image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain
                        //fit: BoxFit.cover,
                        ),
                    const SizedBox(
                      width: 45,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name,
                                //widget.categoryName!,
                                style: GoogleFonts.acme(
                                  textStyle: const TextStyle(
                                      fontSize: 22,
                                      overflow: TextOverflow.fade),
                                )),
                          ]),
                    )
                  ])
            ])));
  }
}
