import 'package:flutter/material.dart';

class MealControlerModel {
  TextEditingController mealName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController components = TextEditingController();

  @override
  String toString() {
    return 'MealModel{mealName: ${mealName.text}, price: ${price.text}, components: ${components.text}';
  }
}