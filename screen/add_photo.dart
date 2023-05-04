import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newemenu/widget/textbutton.dart';

import '../widget/meal_widget.dart';


class AddPhoto extends StatelessWidget {

  final Map categoriesWithMeal;
  final List categories;
  final List numberOfMeals;
  final _firestore=FirebaseFirestore.instance;
  final String id;

   AddPhoto({Key? key, required this.categoriesWithMeal, required this.categories, required this.numberOfMeals, required this.id}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
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

      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Column(
                children:List.generate(categories.length, (counter) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(categories[counter],style: TextStyle(fontSize: sizeWidth*0.07,color: Colors.blueGrey),),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: List.generate(numberOfMeals[counter], (index) {
                                return MealWidget(mealName: mealNames[index+display(counter)], mealComponent: mealComponents[index+display(counter)], price: mealPrice[index+display(counter)].toString());
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
                ,
              ),
              TextButtonWidget(text: 'try', function: () {
                int j=0;
                for(int counter=0;counter<categories.length;counter++){
                  String cat=categories[counter];
                  for(int i=0;i<numberOfMeals[counter];i++){
                    _firestore.collection('All').add({
                      'counter': i,
                      'emailID':id,
                      'mealComponents':mealComponents[j],
                      'mealName':mealNames[j],
                      'price':mealPrice[j],
                      'type':cat
                    });
                   j++;
                  }
                }
              },)
            ],
          ),
        ),
      ),
    );
  }
}
// print('$i$cat : name :${mealNames[j]}, component: ${mealComponents[j]}, price: ${mealPrice[j]}');
