import 'package:flutter/material.dart';

import '../widget/meal_widget.dart';


class AddPhoto extends StatelessWidget {

  final Map categoriesWithMeal;
  final List categories;
  final List numberOfMeals;

  const AddPhoto({Key? key, required this.categoriesWithMeal, required this.categories, required this.numberOfMeals}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    List<String> mealNames = [];
    List<double> mealPrice = [];
    List<String> mealComponents = [];

    List mealsLists = categoriesWithMeal.values.toList();
    for (var meals in mealsLists) {
      for (var meal in meals) {
        mealNames.add(meal.mealName.text);
        mealPrice.add((double.parse(meal.price.text)));
        mealComponents.add(meal.components.text);
      }
    }

    int display(int index) {
      int suii=0;
      if(index==0)
        return 0;
      else{
        for(int counter=0;counter<index;counter++){
          suii+=numberOfMeals[counter] as int;
        }
        return suii;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children:List.generate(categories.length, (counter) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(categories[counter],style: Theme.of(context).textTheme.titleLarge,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: List.generate(numberOfMeals[counter], (index) {
                          return MealWidget(mealName: mealNames[index+display(counter)], mealComponent: mealComponents[index+display(counter)], price: mealPrice[index+display(counter)].toString());
                        }),
                      ),
                    )
                  ],
                ),
              );
            })
            ,
          ),
        ),
      ),
    );
  }
}