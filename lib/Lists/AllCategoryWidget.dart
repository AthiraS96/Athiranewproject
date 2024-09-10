import 'package:culinary_snap/Pages/DetailPage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCategoryWidget extends StatefulWidget {
  final String id;
  final String name;
  //final String description;
  final String image;

  const AllCategoryWidget(
      {super.key,
      required this.id,
      required this.name,
      //required this.description,
      required this.image});

  @override
  State<AllCategoryWidget> createState() => _AllCategoryWidgettState();
}

class _AllCategoryWidgettState extends State<AllCategoryWidget> {
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
                print("Widget Clicked....");
                print(widget.name);
                print(DetailPage.rountname);
                Navigator.of(context).pushNamed(DetailPage.rountname,
                    arguments: [widget.name, widget.id]);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.image),
                      backgroundColor: Colors.transparent,
                    ),
                    Text(widget.name,
                        style: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 13, overflow: TextOverflow.fade),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
