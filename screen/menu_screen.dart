import 'package:flutter/material.dart';
import 'package:newemenu/widget/meal_widget.dart';

import '../model/meal_model.dart';

class MeanuScreen extends StatefulWidget {

  final List<String> catigories;
  final List<MealModel> meals;

  const MeanuScreen({Key? key, required this.catigories, required this.meals,}) : super(key: key);

  @override
  State<MeanuScreen> createState() => _MeanuScreenState();
}

class _MeanuScreenState extends State<MeanuScreen> {

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: List.generate(widget.catigories.length, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.catigories[index],style:  TextStyle(fontSize: sizeWidth*0.07,color: Colors.blueGrey),),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: List.generate(widget.meals.length, (index) {
                      return MealWidget(mealName: widget.meals[index].mealName, mealComponent: widget.meals[index].mealComponents, price:widget.meals[index].price.toString() );
                    }),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
