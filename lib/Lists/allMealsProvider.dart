import 'dart:convert';
import 'dart:io';
import 'package:culinary_snap/Lists/categoryclass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class AllMealsProvider with ChangeNotifier {
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

  List<Categories> AllMeals = [];
  List<Categories> CategoryMeals = [];
  List<Categories> get categories {
    return AllMeals;
  }

  List<Categories> get categoryMeals {
    return CategoryMeals;
  }

  Future<List<Categories>> getMealsForCategory(
      {required String categoryName}) async {
    final categoryMealsFutureObject =
        getAllMealsForCategory(category: categoryName);
    List<Categories> categoryMeals = await categoryMealsFutureObject;
    CategoryMeals = categoryMeals;
    print(categoryMeals);
    return categoryMeals;
  }

  Future getAllCategoryMeals({required BuildContext context}) async {
    Future<List<String>> categoryNames = getAllCategoryNames();
    List<Categories> allMeals = [];
    List<String> catNames = await categoryNames;
    for (String name in catNames) {
      Future<List<Categories>> allMealsForCatObj =
          getAllMealsForCategory(category: name);
      List<Categories> allMealsForCategory = await allMealsForCatObj;

      for (Categories mealCat in allMealsForCategory) {
        allMeals.add(mealCat);
      }
    }

    AllMeals = allMeals;
  }

  /// Gets all category names available
  Future<List<String>> getAllCategoryNames() async {
    var response = await https.get(
      Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php/"),
    );

    Map extractedData = json.decode(response.body);

    final List<dynamic> categoryDetails = extractedData['categories'];
    List<String> categoryNames = [];
    for (Map category in categoryDetails) {
      categoryNames.add(category['strCategory']);
    }

    return categoryNames;
  }

  Future<List<Categories>> getAllMealsForCategory(
      {required String category}) async {
    List<Categories> Allcategories = [];

    try {
      _isLoading = true;

      var response = await https.get(
        Uri.parse(
            "https://www.themealdb.com/api/json/v1/1/filter.php?c=$category"),
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        var extractedData = json.decode(response.body);

        final List<dynamic> gardenDetails = extractedData['meals'];
        for (var i = 0; i < gardenDetails.length; i++) {
          Allcategories.add(Categories(
            idCategory: gardenDetails[i]['idMeal'].toString(),
            strCategory: gardenDetails[i]['strMeal'].toString(),
            strCategoryThumb: gardenDetails[i]['strMealThumb'].toString(),
          ));
        }
        _isLoading = false;
        print('category loading completed --->' + 'loading data');
        notifyListeners();
      } else {
        _isLoading = true;
        notifyListeners();
      }
    } on HttpException catch (e) {
      print('error in each category prod -->>' + e.toString());
      print(
          'Each category Data is one by one loaded the product' + e.toString());
      _isLoading = false;

      _isSelect = false;
      notifyListeners();
    }

    return Allcategories;
  }
}
