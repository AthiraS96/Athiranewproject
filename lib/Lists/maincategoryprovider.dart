import 'dart:convert';
import 'dart:io';
import 'package:culinary_snap/Lists/categoryclass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class MainCategoryProvider with ChangeNotifier {
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

  List<Categories> AllMaincategories = [];
  List<Categories> get categories {
    return [...AllMaincategories];
  }

  Future getAllMainCategoryData({required BuildContext context}) async {
    try {
      _isLoading = true;

      var response = await https.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php"),
      );

      print("https://www.themealdb.com/api/json/v1/1/categories.php");

      print(response.body);
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;

        AllMaincategories = [];
        var extractedData = json.decode(response.body);
        //  print(json.decode(response.body) + 'printed extrated data');
        final List<dynamic> MainCategoryDetails = extractedData['categories'];
        for (var i = 0; i < MainCategoryDetails.length; i++) {
          if (i != 4) {
            AllMaincategories.add(Categories(
              idCategory: MainCategoryDetails[i]['idCategory'].toString(),
              strCategory: MainCategoryDetails[i]['strCategory'].toString(),
              strCategoryThumb:
                  MainCategoryDetails[i]['strCategoryThumb'].toString(),
            ));
          }
        }
        ;

        print('All main category details' + AllMaincategories.toString());
        _isLoading = false;
        print('main category loading completed --->' + 'loading data');
        notifyListeners();
      } else {
        _isLoading = true;
        notifyListeners();
      }
    } on HttpException catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      print('error in main category prod -->>' + e.toString());
      print(
          'Main category Data is one by one loaded the product' + e.toString());
      _isLoading = false;

      _isSelect = false;
      notifyListeners();
    }
  }
}
