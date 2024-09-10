import 'package:culinary_snap/Pages/DetailPage.dart';
import 'package:culinary_snap/Pages/EachDishDetailPage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesPage extends StatefulWidget {
  // Ensure the user is authenticated

  FavoritesPage({super.key});

  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    // Check for authentication
    if (user == null) {
      return Center(child: Text('Please log in to view favorites.'));
    }

    return Scaffold(
      backgroundColor: Backgroundcolor,
      //  bottomNavigationBar: Bottomappbar(),
      appBar: AppBar(
        title: Text('Favorites',
            style: GoogleFonts.acme(
              textStyle: TextStyle(fontSize: 30, color: logocolour),
            )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.75,
            ),
            itemCount: data.size,
            itemBuilder: (context, index) {
              bool isFavorite =
                  true; // Add a variable to track if the item is a favorite

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(EachDishPage.rountname,
                      arguments: [data.docs[index]['id']]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  data.docs[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data.docs[index]['name'],
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorite =
                                    !isFavorite; // Toggle the favorite status
                              });

                              if (!isFavorite) {
                                // Add logic to remove the item from favorites
                                FirebaseFirestore.instance
                                    .collection('favorites')
                                    .doc(data.docs[index]['id']!)
                                    .delete();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
