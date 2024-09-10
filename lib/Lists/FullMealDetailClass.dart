

class FullMeal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strArea;
  final String strDescription;
  final String strYoutube;

  FullMeal(
      {required this.idMeal,
      required this.strMeal,
      required this.strMealThumb,
      required this.strArea,
      required this.strDescription,
      required this.strYoutube});

  factory FullMeal.fromJson(Map<String, dynamic> json) {
    return FullMeal(
        idMeal: json['idMeal'],
        strMeal: json['strMeal'],
        strMealThumb: json['strMealThumb'],
        strArea: json['strArea'],
        strDescription: json['strInstructions'],
        strYoutube: json['strYoutube']);
  }
}
