import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/meal_model.dart';
import 'menu_screen.dart';
import 'orders_screen.dart';

class ChoiceScreen extends StatelessWidget {
  final List<String> catigories;
  final List<MealModel> meals;

  const ChoiceScreen({Key? key, required this.catigories, required this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeanuScreen(catigories: catigories,meals: meals),));
                  },
                  child:  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width*0.6,
                    height: MediaQuery.of(context).size.height*0.2,
                    color: Color.fromRGBO(212, 175, 55, 1),
                    transform: Matrix4.skewX(0.3),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.1,
                          color: Colors.black),
                    ),
                  )),
            ),
            const SizedBox(
              width: double.infinity,
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersScreen(),));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.6,
                  height: MediaQuery.of(context).size.height*0.2,
                  color: Colors.grey,
                  transform: Matrix4.skewX(0.3),
                  child: Text(
                    'Order',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.1,
                        color: Colors.black),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
