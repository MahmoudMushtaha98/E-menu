import 'package:eMenu/model/meal_model.dart';

class SaveOrderModel{

  MealModel mealModel;
  int numberOfMeal;
  String Requests;

  SaveOrderModel({required this.mealModel, required this.numberOfMeal, required this.Requests});
}