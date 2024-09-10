import 'package:flutter/material.dart';

class IndianCategories {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;

  IndianCategories({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
  });

  factory IndianCategories.fromJson(Map<String, dynamic> json) {
    return IndianCategories(
      idCategory: json['idMeal'],
      strCategory: json['strMeal'],
      strCategoryThumb: json['strMealThumb'],
    );
  }
}
