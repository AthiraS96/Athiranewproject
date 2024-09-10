import 'dart:convert';
import 'dart:io';
import 'package:culinary_snap/Lists/Indianclass.dart';
import 'package:culinary_snap/Lists/categoryclass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class IndianCategoryProvider with ChangeNotifier {
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

  List<IndianCategories> AllIndiancategories = [];
  List<IndianCategories> get Indiancategories {
    return [...AllIndiancategories];
  }

  Future getAllMainCategoryData({required BuildContext context}) async {
    try {
      _isLoading = true;

      var response = await https.get(
        Uri.parse(
            "https://www.themealdb.com/api/json/v1/1/filter.php?a=indian"),
      );

      print("https://www.themealdb.com/api/json/v1/1/filter.php?a=indian");

      print(response.body);
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;

        AllIndiancategories = [];
        var extractedData = json.decode(response.body);
        //  print(json.decode(response.body) + 'printed extrated data');
        final List<dynamic> MainCategoryDetails = extractedData['meals'];
        print("######### ");
        print(MainCategoryDetails);
        for (var i = 0; i < MainCategoryDetails.length; i++) {
          if (i != 4) {
            AllIndiancategories.add(IndianCategories(
              idCategory: MainCategoryDetails[i]['idMeal'].toString(),
              strCategory: MainCategoryDetails[i]['strMeal'].toString(),
              strCategoryThumb:
                  MainCategoryDetails[i]['strMealThumb'].toString(),
            ));
          }
        }
        ;

        print('All Indian Food details' + AllIndiancategories.toString());
        _isLoading = false;
        print('Indian food loading completed --->' + 'loading data');
        notifyListeners();
      } else {
        _isLoading = true;
        notifyListeners();
      }
    } on HttpException catch (e) {
      print('error in indian food prod -->>' + e.toString());
      print('Indian food Data is one by one loaded the product' + e.toString());
      _isLoading = false;

      _isSelect = false;
      notifyListeners();
    }
  }
}
