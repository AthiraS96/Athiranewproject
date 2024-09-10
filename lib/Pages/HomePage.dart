import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culinary_snap/Lists/AllCategoryWidget.dart';
import 'package:culinary_snap/Lists/BottomNavigation.dart';

import 'package:culinary_snap/Lists/CustomAlert.dart';
import 'package:culinary_snap/Lists/IndianFoodWidget.dart';
import 'package:culinary_snap/Lists/Indianprovider.dart';
import 'package:culinary_snap/Lists/allMealsProvider.dart';
import 'package:culinary_snap/Lists/loadin_screen.dart';
import 'package:culinary_snap/Lists/maincategoryprovider.dart';
import 'package:culinary_snap/Lists/searchProvider.dart';
import 'package:culinary_snap/Pages/AddToCartPage.dart';
import 'package:culinary_snap/Pages/CategoryPage.dart';
import 'package:culinary_snap/Pages/EachDishDetailPage.dart';
import 'package:culinary_snap/Pages/FavoritePage.dart';
import 'package:culinary_snap/Pages/ProfilePage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  final dynamic image, categoryName;
  Home({this.categoryName, this.image});

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {
  int activeIndex = 0;
  TextEditingController searchController = TextEditingController();
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadUserData();
        _loadProviderData();
      }
    });
    searchController.addListener(_onSearchChanged);
  }

  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userName = userSnapshot.get('name');
        _userEmail = userSnapshot.get('email');
      });
    }
  }

  void _loadProviderData() {
    Provider.of<MainCategoryProvider>(context, listen: false)
        .getAllMainCategoryData(context: context);

    Provider.of<IndianCategoryProvider>(context, listen: false)
        .getAllMainCategoryData(context: context);

    Provider.of<AllMealsProvider>(context, listen: false)
        .getAllCategoryMeals(context: context);
  }

  void _onSearchChanged() {
    if (searchController.text.trim().isEmpty) {
      Provider.of<SearchProvider>(context, listen: false).clearSearchResults();
      // Optionally handle empty search query case.
      return;
    }
    Provider.of<SearchProvider>(context, listen: false).getAllSearchData(
      context,
      searchQuery: searchController.text.trim(),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  // Test Firestore connection by reading a document

  List<String> slider = [
    "assets/slider1.jpg",
    "assets/slider2.jpg",
    "assets/slider3.jpg",
    "assets/slider4.jpg",
    "assets/slider5.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final category = Provider.of<MainCategoryProvider>(context);
    final indian = Provider.of<IndianCategoryProvider>(context);
    final Size screensize = MediaQuery.of(context).size;
    MyCustomAlertDialog alertDialog = MyCustomAlertDialog();

    return SafeArea(
        child: Scaffold(
      backgroundColor: Backgroundcolor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Backgroundcolor,
        elevation: 0,
        title: Center(
          child: Text('Flavor Finds',
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
            width: screensize.width * 0.05,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 40, right: 40, top: 10, bottom: 12),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "Search here...",
                          isDense: true,
                          contentPadding: const EdgeInsets.all(12.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(
                              Radius.circular(99),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(99),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              // Clear the search field
                              searchController.clear();
                              // Clear the search results by calling the method in your SearchProvider
                              Provider.of<SearchProvider>(context,
                                      listen: false)
                                  .clearSearchResults();
                            },
                          ),
                          prefixIcon: IconButton(
                              onPressed: () {
                                print(SearchController().text);
                                // showSearch(
                                //     context: context,
                                //     delegate: FoodSearchDelegate(),
                                //     query: SearchController().text);
                              },
                              icon: const Icon(Icons.search))),
                      onSubmitted: (value) {
                        // Optionally trigger search on submit instead of real time
                        _onSearchChanged;
                      },
                    ),
                  )
                ])),
            Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                if (searchProvider.islOading) {
                  return CircularProgressIndicator();
                }
                if (searchProvider.SearchItem.isEmpty) {
                  // Provider.of<SearchProvider>(context, listen: false)
                  //     .clearSearchResults();
                  // return Text("No results found");
                }
                return ListView.builder(
                  shrinkWrap: true, // Important to avoid infinite height
                  physics:
                      NeverScrollableScrollPhysics(), // Avoid scrolling within scrolling
                  itemCount: searchProvider.SearchItem.length,
                  itemBuilder: (context, index) {
                    final item = searchProvider.SearchItem[index];
                    return GestureDetector(
                      onTap: () {
                        print("IDDDDDDDDDDDDDDD" + item.idCategory);
                        Navigator.of(context).pushNamed(EachDishPage.rountname,
                            arguments: [item.idCategory]);
                      },
                      child: ListTile(
                        title: Text(item.strCategory),
                        leading: Image.network(item.strCategoryThumb),
                        // Add more item properties as needed
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: screensize.height * 0.02),
            category.loadingSpinner
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingScreen(title: 'Loading'),
                      CircularProgressIndicator(
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                : category.AllMaincategories.isEmpty
                    ? const Center(
                        child: Text(
                        'No main category Packages...',
                        style: TextStyle(color: Colors.green),
                      ))
                    : SizedBox(
                        height: screensize.height * 0.08,
                        child: ListView.builder(
                          itemCount: category.categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return AllCategoryWidget(
                              id: category.categories[index].idCategory,
                              name: category.categories[index].strCategory,
                              image:
                                  category.categories[index].strCategoryThumb,
                            );
                          },
                        ),
                      ),
            SizedBox(
              height: screensize.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Todays  deals!',
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(fontSize: 20, color: logocolour),
                      )),
                ),
              ],
            ),
            CarouselSlider.builder(
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  return Image.asset(slider[index]);
                },
                options: CarouselOptions(
                    height: size.height * 0.25,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    })),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(child: buildIndicator()),
            SizedBox(
              height: size.height * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Popular Indian dishes!',
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(fontSize: 20, color: logocolour),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.18,
              child: ListView.builder(
                itemCount: indian.Indiancategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return IndianFoodWidget(
                    id: indian.Indiancategories[index].idCategory,
                    name: indian.Indiancategories[index].strCategory,
                    image: indian.Indiancategories[index].strCategoryThumb,
                  );
                },
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //Drawer header for Heading part of drawer
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/Flavor Finds_With_Title.png',
                    ),
                    fit: BoxFit.cover),
              ),

              //Title of header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/ProfileImage.jpg'),
                  ),
                  Text(
                    _userName,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    _userEmail,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            ),
            //Child tile of drawer with specified title
            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
              },
            ),

            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text('Categories'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryPage(),
                    ));
              },
            ),

            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.share),
              title: const Text('Share With Friends'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.rate_review),
              title: const Text('Rate and Review'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.flag),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ));
              },
            ),
            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                alertDialog.showCustomAlertdialog(
                    context: context,
                    title: 'Confirm',
                    subtitle: 'Do you want to log out and exit.',
                    onTapOkButt: () {},
                    button: true,
                    onTapCancelButt: () {
                      Navigator.of(context).pop();
                    });
              },
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 5,
        effect: SlideEffect(
            dotWidth: MediaQuery.of(context).size.width * 0.02,
            dotHeight: MediaQuery.of(context).size.height * 0.01,
            activeDotColor: Colors.black),
      );
}

class CategoryModel {
  String? categoryName;
  int? selectedIndex;
  String? image;
}
