import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newemenu/widget/textbutton.dart';

import 'enter_meal.dart';


class NumberOfMeal extends StatefulWidget {
  final List categories;
  final String emailID;

  const NumberOfMeal(
      {Key? key, required this.categories, required this.emailID,})
      : super(key: key);

  @override
  State<NumberOfMeal> createState() => _NumberOfMealState();
}

class _NumberOfMealState extends State<NumberOfMeal> {
  List<TextEditingController> _controllersList = [];
  final _firestore=FirebaseFirestore.instance;
  List<int> _numberOfMeal = [];
  int counter=0;

  @override
  void initState() {
    super.initState();
    _controllersList = List.generate(
        widget.categories.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    _controllersList.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: sizeHeight*0.5,
              child: Image.asset('images/E.png',fit: BoxFit.cover),
            ),
            Column(
              children: List.generate(widget.categories.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: sizeWidth*0.7,
                        child: Text(
                          'How many ${widget.categories[index]} ?',
                          style: TextStyle(color: Colors.grey, fontSize: sizeWidth*0.05,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth*0.2,
                        height: sizeHeight*0.07,
                        child: TextField(
                          controller: _controllersList[index],
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            label: Text('Number',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(212, 175, 55, 1),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            TextButtonWidget(text: 'Submit',callback: () {
              _numberOfMeal.clear();
              _controllersList.forEach((element) {
                _numberOfMeal.add(int.parse(element.text));
              });
              for(int counterr=0;counterr<_numberOfMeal.length;counterr++){
                _firestore.collection('Number of meal').add({
                  'counter': counterr,
                  'emailID':widget.emailID,
                  'numberOfMeal': _numberOfMeal[counterr],
                  'type': widget.categories[counterr]
                });
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => EnterTheMeals(categories: widget.categories,numberOfMeals: _numberOfMeal,id: widget.emailID),));
            },),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            )
          ],
        ),
      ),
    );
  }
}



