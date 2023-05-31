import 'package:flutter/material.dart';
import 'package:eMenu/model/meal_model.dart';
import 'package:eMenu/model/save_order_model.dart';
import '../widget/numeric_stepper_widget.dart';

class HalfScreen extends StatefulWidget {

   const HalfScreen({Key? key, required this.mealName, required this.mealComponent, required this.price,}) : super(key: key);

  final String mealName;
  final String mealComponent;
  final String price;

  @override
  State<HalfScreen> createState() => _HalfScreenState();
}

class _HalfScreenState extends State<HalfScreen> {
  final TextEditingController _controller=TextEditingController();
  int _numValue = 0;

  void _updateNumValue(int newValue) {
    setState(() {
      _numValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return SizedBox(

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
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.mealName,style: Theme.of(context).textTheme.titleLarge,),
                                const SizedBox(height: 5,),
                                Text(widget.mealComponent,style: const TextStyle(color: Colors.grey),),
                                const SizedBox(height: 5,),
                              ],),
                          ),
                          Container(
                              alignment: Alignment.center,
                              height: sizeWidth*0.1,
                              width: sizeWidth*0.25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white12
                              ),
                              child: Text('${widget.price} JOD',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)

                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.grey[100],
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      child: const Text('How many?',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(height: sizeHeight*0.015,),
                  NumericStepperWidget(onChange: _updateNumValue),
                  SizedBox(height: sizeHeight*0.015,),
                  Container(
                    height: sizeHeight*0.02,
                    width: double.infinity,
                    color: Colors.grey[100],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(

                      children: [
                        const Text('Requests ',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                        SizedBox(
                          height: sizeHeight*0.055,
                          width: sizeWidth*0.75,
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                labelText: 'Add note',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                labelStyle: TextStyle(color: Colors.grey[300])
                            ),
                          ),
                        ),
                        SizedBox(height: sizeHeight*0.015,),
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
                            SaveOrderModel saveOrderModel=SaveOrderModel(mealModel: MealModel(mealName: widget.mealName,mealComponents: widget.mealComponent,price: double.parse(widget.price),counter: 0,type: 'order'), numberOfMeal: _numValue, Requests: _controller.text);
                            Navigator.pop(context,saveOrderModel);
                          }, child: Container(
                        decoration: BoxDecoration(
                            color: Colors.greenAccent[700],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.05,
                        width: double.infinity,
                        child: const Text('Add to basket',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white
                        )
                        ),
                      )
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}