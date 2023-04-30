import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newemenu/widget/textbutton.dart';

import 'number_of_meal.dart';


class NameOfCategory extends StatefulWidget {
  final int numberOfCategory;
  final String id;

  const NameOfCategory({Key? key, required this.numberOfCategory, required this.id}) : super(key: key);

  @override
  State<NameOfCategory> createState() => _NameOfCategoryState();
}

class _NameOfCategoryState extends State<NameOfCategory> {
  final _firestore = FirebaseFirestore.instance;
  List<TextEditingController> _controllersList = [];
  List<String> _categoriesList = [];
  int counter=0;

  @override
  void initState() {
    super.initState();
    _controllersList = List.generate(widget.numberOfCategory, (index) => TextEditingController());
  }

  @override
  void dispose() {
    _controllersList.forEach((controller) => controller.dispose());
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: sizeHeight*0.5,
              child: Image.asset('images/E.png',fit: BoxFit.cover),
            ),
            Column(
              children: List.generate(widget.numberOfCategory, (index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Category ${index+1}',style: TextStyle(color: Colors.grey,fontSize: sizeWidth*0.05),),
                          SizedBox(width: sizeWidth*0.1,),
                          SizedBox(
                            width: sizeWidth*0.6,
                            height: sizeHeight*0.07,
                            child: TextField(
                              controller: _controllersList[index],
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: Text('Name',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(212, 175, 55, 1),
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40,)
                  ],
                );
              }),
            ),
            SizedBox(height: 10,),

            TextButtonWidget(text: 'Submit',function: () {
              _controllersList.forEach((element) {
                _categoriesList.add(element.text);
                _firestore.collection('Categories').add({
                  'CategoryName': element.text,
                  'EmailID': widget.id,
                  'counter': counter
                });
                counter++;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => NumberOfMeal(categories: _categoriesList,emailID: widget.id),));
            },),
            SizedBox(height: sizeHeight*0.1,)
          ],

        ),
      ),
    );
  }
}