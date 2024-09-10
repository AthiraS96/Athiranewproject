import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ShowCategoryfoods {
  List<CategoryFoods> categories = [];

  Future<void> getCategoriesFood(String category) async {
    String url = "www.themealdb.com/api/json/v1/1/filter.php?c=$category";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsonData["meals"].forEach((element) {
        if (element["strMealThumb"] != null && element['strMeal'] != null) {
          CategoryFoods categoryModel = CategoryFoods(
            title: element["strMeal"],
            // description: element["strCategoryDescription"],

            urlToImage: element["strMealThumb"],

            id: element["idMeal"],
          );
          categories.add(categoryModel);
        }
      });
    }
  }
}

class CategoryFoods {
  String? id;
  String? title;
  // String? description;

  String? urlToImage;

  CategoryFoods(
      {this.id,

      // this.description,
      this.title,
      this.urlToImage});
}
