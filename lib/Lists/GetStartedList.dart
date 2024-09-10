import 'package:flutter/material.dart';

class AllContent {
  String image;
  String title;
  String discription;

  AllContent({
    required this.image,
    required this.title,
    required this.discription,
  });
}

List<AllContent> contents = [
  AllContent(
    title: 'Hello',
    image: "getstarted1.jpg",
    discription:
        'Embark on a culinary journey with our exquisite selection of dishes from around the world.',
  ),
  AllContent(
    title: 'Welcome',
    image: "getstarted2.jpg",
    discription:
        'Satisfy your cravings and  elevate your dining experience with every scroll.',
  ),
  AllContent(
    title: 'Welcome',
    image: "getstarted3.jpg",
    discription:
        'Welcome to a world where food is not just a meal,but a celebration of flavor. Let your culinary adventure begin!.',
  ),
];
