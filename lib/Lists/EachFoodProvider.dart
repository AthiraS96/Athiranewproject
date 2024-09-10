import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ShowFoodById with ChangeNotifier {
  bool _isLoading = false;
  bool get islOading {
    return _isLoading;
  }

  final bool _loadingSpinner = false;
  bool get loadingSpinner {
    return _loadingSpinner;
  }

  bool _isSelect = false;

  bool get isSelect {
    return _isSelect;
  }

  final bool _isError = false;

  bool get isError {
    return _isError;
  }

  late FoodsById foodItem = FoodsById();

  Future<FoodsById> getFoodById({required String id}) async {
    String url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var meal = jsonData['meals'][0];
      print(meal);
      if (meal["strMealThumb"] != null && meal['strMeal'] != null) {
        FoodsById categoryModel = FoodsById(
            title: meal["strMeal"],
            description: meal["strInstructions"],
            urlToImage: meal["strMealThumb"],
            id: meal["idMeal"],
            youtube: meal["strYoutube"]);
        foodItem = categoryModel;
      }
    }
    return foodItem;
  }
}

class FoodsById {
  String? id;
  String? title;
  String? description;

  String? urlToImage;
  String? youtube;

  FoodsById(
      {this.id, this.description, this.title, this.urlToImage, this.youtube});
}
