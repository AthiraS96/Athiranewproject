import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:culinary_snap/Lists/EachFoodProvider.dart';
import 'package:culinary_snap/Lists/errorscreen.dart';
import 'package:culinary_snap/Lists/loadin_screen.dart';
import 'package:culinary_snap/Pages/AddToCartPage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class EachDishPage extends StatefulWidget {
  // static const rountname = 'each_dish_screen';
  final String id;

  static String rountname = 'each_dish_screen';

  const EachDishPage({super.key, required this.id});

  @override
  State<EachDishPage> createState() => _EachDishPageState();
}

class _EachDishPageState extends State<EachDishPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late FoodsById? mealDetails = FoodsById();
  var target_col = Colors.grey;
  var target_icon = Icons.favorite_border;
  bool isFavorite = false;
  bool isInCart = false;
  bool isAddCart = false;
  double targetRating = 0.0;
  int targetPrice = 0;

  Future<void> addPriceRatingDetailsToDB() async {
    final _formKey = GlobalKey<FormState>();
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print('&&&&&&&&&&& PRICE AND RATING ' + mealDetails!.id.toString());

    DocumentSnapshot documentSnapshot =
        await firestore.collection('price_rating').doc(mealDetails!.id).get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>;
      var price = data['price'];
      var rating = data['rating'];

      targetRating = rating;
      targetPrice = price;

      // Use the price and rating as needed
      print('Price: $price, Rating: $rating');
    } else if (null != mealDetails!.id) {
      Random random = Random();
      double min = 2;
      double max = 5;
      double rating = min + random.nextDouble() * (max - min);
      rating = double.parse(rating.toStringAsFixed(1));

      int price = 250 + random.nextInt(1100 - 250 + 1);
      price = int.parse(price.toString());

      if (targetRating == 0.0) {
        targetRating = rating;
      } else {
        targetRating = targetRating;
      }

      if (targetPrice == 0) {
        targetPrice = price;
      } else {
        targetPrice = targetPrice;
      }

      await FirebaseFirestore.instance
          .collection('price_rating')
          .doc(mealDetails!.id)
          .set({
        'id': mealDetails!.id,
        'name': mealDetails!.title,
        'price': targetPrice,
        'rating': targetRating
        // Add other relevant data
      });
      print('Price & Rating added to DB &&&&&&&&&&&&&&&&&&');
    }
  }

  Future<void> toggleFavorite() async {
    final _formKey = GlobalKey<FormState>();
    final _auth = FirebaseAuth.instance;
    print('&&&&&&&&&&&' + isFavorite.toString() + mealDetails!.id.toString());
    if (!isFavorite) {
      // Remove from favorites
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(mealDetails!.id)
          .delete();
    } else {
      // Add to favorites
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(mealDetails!.id)
          .set({
        'id': mealDetails!.id,
        'name': mealDetails!.title,
        'image': mealDetails!.urlToImage,
        // Add other relevant data
      });
    }
  }

  Future<bool> isAvailableInFavorite(id) async {
    final _formKey = GlobalKey<FormState>();
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Try to retrieve the document with the given itemId from a specific collection
    DocumentSnapshot documentSnapshot =
        await firestore.collection('favorites').doc(id).get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // The item exists in the Firestore database
      isFavorite = true;
    } else {
      // The item does not exist in the Firestore database
      isFavorite = false;
    }
    // setState(() {
    //   isFavorite = isFavorite;
    // });

    return isFavorite;
  }

  Future<bool> isFoodPresentInCart(id) async {
    print("IN CART DATABASE CHECK*******************" + id);
    final _formKey = GlobalKey<FormState>();
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Try to retrieve the document with the given itemId from a specific collection
    DocumentSnapshot documentSnapshot =
        await firestore.collection('Cart').doc(id).get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // The item exists in the Firestore database
      isInCart = true;
    } else {
      // The item does not exist in the Firestore database
      isInCart = false;
    }

    return isInCart;
  }

  Future<void> AddToCart() async {
    final _formKey = GlobalKey<FormState>();
    final _auth = FirebaseAuth.instance;

    int foodQuantity = 0;

    isFoodPresentInCart(mealDetails!.id);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print('&&&&&&&&&&& GET FOOD QUANTITY ' + mealDetails!.id.toString());

    DocumentSnapshot documentSnapshot =
        await firestore.collection('Cart').doc(mealDetails!.id).get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>;
      int quantity = data['quantity'];
      foodQuantity = foodQuantity + quantity;

      // Use the price and rating as needed
      print('Food Quantity: $foodQuantity');

      await FirebaseFirestore.instance
          .collection('Cart')
          .doc(mealDetails!.id)
          .update({
        // Assuming you only want to update these two fields
        'quantity': foodQuantity,
      });
    } else {
      foodQuantity = foodQuantity + 1;
      await FirebaseFirestore.instance
          .collection('Cart')
          .doc(mealDetails!.id)
          .set({
        'id': mealDetails!.id,
        'name': mealDetails!.title,
        'image': mealDetails!.urlToImage,
        'price': targetPrice,
        'quantity': foodQuantity,
      });
    }
  }

  Future<FoodsById?> getAllMeals() async {
    print("Inside Details Page....");
    print("Widget ID: " + widget.id);
    String cat_widget_id = widget.id.split(',').last.split(']')[0].trim();
    String cat_widget_name = widget.id.split(',').first.split('[')[1].trim();
    cat_widget_id = cat_widget_id.split('[')[1];
    print(cat_widget_name);
    print(cat_widget_id);

    Future<FoodsById> categoryMealsFutObject =
        Provider.of<ShowFoodById>(context).getFoodById(id: cat_widget_id);

    mealDetails = await categoryMealsFutObject;
    print("full meals");
    print(mealDetails);

    return mealDetails;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FoodsById?>(
      future: getAllMeals(),
      builder: (context, snapshot) {
        return FutureBuilder<bool>(
          future: isAvailableInFavorite(mealDetails!.id), // Await here
          builder: (context, snapshotFavorite) {
            addPriceRatingDetailsToDB();
            if (snapshotFavorite.connectionState == ConnectionState.waiting) {
              return const LoadingScreen(title: 'Loading...');
            } else if (snapshotFavorite.hasError) {
              return ErrorScreen(title: snapshotFavorite.error.toString());
            } else {
              // Use the value of isFavorite here
              isFavorite = snapshotFavorite.data ?? false;
              // Other parts of your UI
              // ...
              if (isFavorite) {
                target_col = Colors.red;
                target_icon = Icons.favorite;
              } else {
                target_col = Colors.grey;
                target_icon = Icons.favorite_border;
              }
              // Rest of your code
              // ...
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen(title: 'Loading...');
            } else if (snapshot.hasError) {
              return ErrorScreen(title: snapshot.error.toString());
            } else if (snapshot.hasData && snapshot.data != null) {
              final mealDetails = snapshot.data!;
              var Size = MediaQuery.of(context).size;

              return Scaffold(
                backgroundColor: Backgroundcolor,
                // bottomNavigationBar: const Bottomappbar(),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Text('Flavor Finds',
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(fontSize: 30, color: logocolour),
                      )),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => CartPage())),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                        )),
                    SizedBox(
                      width: Size.width * 0.05,
                    )
                  ],
                ),
                body: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.network(
                      mealDetails.urlToImage ?? '',
                      width: Size.width,
                      height: Size.width,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: Size.width,
                      height: Size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.black45,
                              Colors.transparent,
                              Colors.black45
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: Size.width - 60,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30))),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 35,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 22),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: 37,
                                                width: 300,
                                                child: Text(
                                                  mealDetails.title!,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: IconButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        targetRating =
                                                            targetRating;
                                                        // Toggle isFavorite value
                                                        isFavorite =
                                                            !isFavorite;
                                                        // Update target_col based on the new isFavorite value
                                                        if (isFavorite) {
                                                          target_col =
                                                              Colors.red;
                                                          target_icon =
                                                              Icons.favorite;
                                                        } else {
                                                          target_col =
                                                              Colors.grey;
                                                          target_icon = Icons
                                                              .favorite_border;
                                                        }
                                                      });
                                                      await toggleFavorite();
                                                      print(
                                                          "IconButton pressed, isFavorite: $isFavorite, Color: $target_col");
                                                    },
                                                    icon: Icon(
                                                      target_icon,
                                                      color: target_col,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IgnorePointer(
                                                    ignoring: true,
                                                    child: RatingBar.builder(
                                                      initialRating:
                                                          targetRating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 20,
                                                      itemPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 1.0),
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (targetRating) {},
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    " $targetRating Star Ratings",
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '₹ ' + targetPrice.toString(),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            isAddCart = !isAddCart;
                                            await AddToCart();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Added to cart successfully'),
                                              duration: Duration(seconds: 2),
                                            ));
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Center(
                                                  child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Text(
                                            "Description",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Text(
                                            mealDetails.description!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 11),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: Divider(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              height: 1,
                                            )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: Text("No Products"));
            }
          },
        );
      },
    );
  }
}
