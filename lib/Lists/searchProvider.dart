import 'dart:convert';
import 'dart:io';
import 'package:culinary_snap/Lists/Indianclass.dart';
import 'package:culinary_snap/Lists/categoryclass.dart';
import 'package:culinary_snap/Lists/searchClass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class SearchProvider with ChangeNotifier {
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

  List<Search> AllSearchItems = [];
  List<Search> get SearchItem {
    return [...AllSearchItems];
  }

  Future getAllSearchData(BuildContext context,
      {required String searchQuery}) async {
    try {
      _isLoading = true;

      var response = await https.get(
        Uri.parse(
            "https://www.themealdb.com/api/json/v1/1/search.php?s=$searchQuery"),
      );

      print(
          "https://www.themealdb.com/api/json/v1/1/search.php?s=$searchQuery");

      print(response.body);
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;

        AllSearchItems = [];
        var extractedData = json.decode(response.body);

        final List<dynamic> MainCategoryDetails = extractedData['meals'];
        print("######### ");
        print(MainCategoryDetails);
        for (var i = 0; i < MainCategoryDetails.length; i++) {
          if (i != 4) {
            AllSearchItems.add(Search(
              idCategory: MainCategoryDetails[i]['idMeal'].toString(),
              strCategory: MainCategoryDetails[i]['strMeal'].toString(),
              strCategoryThumb:
                  MainCategoryDetails[i]['strMealThumb'].toString(),
            ));
          }
        }
        ;

        print('All search details' + AllSearchItems.toString());
        _isLoading = false;
        print('search loading completed --->' + 'loading data');
        notifyListeners();
      } else {
        _isLoading = true;
        notifyListeners();
      }
    } on HttpException catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      print('error in search prod -->>' + e.toString());
      print('Search Data is one by one loaded the product' + e.toString());
      _isLoading = false;

      _isSelect = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    AllSearchItems.clear(); // Assuming AllSearchItems holds your search results
    notifyListeners(); // Notify widgets listening to this provider
  }
}
