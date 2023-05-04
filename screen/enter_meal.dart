import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newemenu/screen/add_photo.dart';
import 'package:newemenu/widget/textbutton.dart';

import '../model/meal_controler_model.dart';

class EnterTheMeals extends StatefulWidget {
  final List categories;
  final List numberOfMeals;
  final String id;

  const EnterTheMeals({Key? key,
    required this.categories,
    required this.numberOfMeals, required this.id,})
      : super(key: key);

  @override
  State<EnterTheMeals> createState() => _EnterTheMealsState();
}

class _EnterTheMealsState extends State<EnterTheMeals> {
  Map<int, List<MealControlerModel>> map = {};

  @override
  void initState() {
    _fillMealsControllers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Column(
                  children: List.generate(widget.categories.length, (counter) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                          ),
                          Text(
                            '${widget.categories[counter]}:',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            buildSizedBoxOfTextfield(
                                                context,
                                                index,
                                                0.6,
                                                'Meal name',
                                                0,
                                                map[counter]![index].mealName),
                                            SizedBox(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width *
                                                  0.05,
                                            ),
                                            buildSizedBoxOfTextfield(
                                                context,
                                                index,
                                                0.2,
                                                'Price',
                                                1,
                                                map[counter]![index].price),
                                          ],
                                        ),
                                        buildSizedBoxOfTextfield(
                                            context,
                                            index,
                                            0.85,
                                            'Meal components',
                                            0,
                                            map[counter]![index].components),
                                        SizedBox(
                                          height:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .height *
                                              0.05,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: map[counter]!.length,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero),
                          )
                        ],
                      ),
                    );
                  }),
                ),
                TextButtonWidget(text: 'Submit', function: () {
                  map.forEach((key, value) {
                    List<MealControlerModel> meals=value;
                    print(meals.toString());
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPhoto(categoriesWithMeal: map, categories: widget.categories, numberOfMeals: widget.numberOfMeals,id: widget.id),));
                },),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05,
                )
              ],
            ),
          ),
        ));
  }

  SizedBox buildSizedBoxOfTextfield(BuildContext context,
      int index,
      double ourWidth,
      String label,
      int numb,
      TextEditingController controller,) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * ourWidth,
      height: 70,
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          label: Text(label,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(212, 175, 55, 1),
              ),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),

        ),
        inputFormatters: numb == 1
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
            : null,
        keyboardType: numb == 1 ? TextInputType.number : null,
        controller: controller,
      ),
    );
  }





  void _fillMealsControllers() {
    List.generate(widget.categories.length, (index) {
      List<MealControlerModel> meals = [];
      for (int c=0;c<widget.numberOfMeals[index];c++) {
        meals.add(MealControlerModel());
      }
      map.putIfAbsent(index, () => meals);
    });
  }
}

