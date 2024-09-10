import 'package:flutter/material.dart';

class Categories {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;

  Categories({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      idCategory: json['idMeal'],
      strCategory: json['strMeal'],
      strCategoryThumb: json['strMealThumb'],
    );
  }
}
