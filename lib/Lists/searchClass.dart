import 'package:flutter/material.dart';

class Search {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;

  Search({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      idCategory: json['idMeal'],
      strCategory: json['strMeal'],
      strCategoryThumb: json['strMealThumb'],
    );
  }
}
