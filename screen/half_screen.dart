import 'dart:io';

import 'package:flutter/material.dart';

import '../widget/numeric_stepper_widget.dart';

class HalfScreen extends StatelessWidget {
  const HalfScreen({Key? key, required this.mealName, required this.mealComponent, required this.price, this.image,}) : super(key: key);

  final String mealName;
  final String mealComponent;
  final String price;
  final File? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.6,
      child: Column(

        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*0.07,
            child: AppBar(
              title: Text('Customize',style: Theme.of(context).textTheme.titleLarge,),
              backgroundColor: Colors.white,
              leading: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey[700],)),

            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.48,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(mealName,style: Theme.of(context).textTheme.titleLarge,),
                                SizedBox(height: 5,),
                                Text(mealComponent,style: TextStyle(color: Colors.grey),),
                                SizedBox(height: 5,),
                                Text('${price} JOD',style: TextStyle(fontSize: 16),)
                              ],),
                          ),
                          Container(
                              alignment: Alignment.topRight,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white12
                              ),
                              width: MediaQuery.of(context).size.width*0.45,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: image == null
                                    ? Icon(Icons.add_a_photo)
                                    : Image.file(image!, fit: BoxFit.cover),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.grey[100],
                      height: 60,
                      padding: EdgeInsets.all(8),
                      child: Text('How many?',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                  ),                          SizedBox(height: 20,),

                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.grey[100],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(

                      children: [
                        Text('Requests ',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.75,
                          child: TextField(

                            decoration: InputDecoration(
                                labelText: 'Add note',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                labelStyle: TextStyle(color: Colors.grey[300])
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                      child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                          onPressed: () {
                            Navigator.pop(context);
                          }, child: Container(
                        decoration: BoxDecoration(
                            color: Colors.greenAccent[700],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.05,
                        width: double.infinity,
                        child: Text('Add to basket',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white
                        )
                        ),
                      )
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}