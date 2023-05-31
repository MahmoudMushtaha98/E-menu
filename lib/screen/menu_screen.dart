import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eMenu/model/save_order_model.dart';
import 'package:eMenu/screen/add_to_basket.dart';
import 'package:eMenu/widget/meal_widget.dart';

import '../model/meal_model.dart';

class MeanuScreen extends StatefulWidget {

  final String emailId;
  final List<String> catigories;
  final List<MealModel> meals;

  const MeanuScreen({Key? key, required this.catigories, required this.meals, required this.emailId,}) : super(key: key);

  @override
  State<MeanuScreen> createState() => _MeanuScreenState();
}

class _MeanuScreenState extends State<MeanuScreen> {
  List<SaveOrderModel> _saveOrder=[];
  void _saveOrderr(SaveOrderModel saveOrderModel){
    setState(() {
      _saveOrder.add(saveOrderModel);
      print(_saveOrder.length);
    });
  }

  void _update(newValue){
    setState(() {
      _saveOrder=newValue;
    });
  }


  Map<String,List<MealModel>> display={};
  void reorder(){
    for(int counter=0;counter<widget.catigories.length;counter++){
      String catigory=widget.catigories[counter];
      display[catigory] = [];
      for(int counterr=0;counterr<widget.meals.length;counterr++){
        if(catigory == widget.meals[counterr].type){
          display[catigory]!.add(widget.meals[counterr]);
        }
      }
    }
  }
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: []);
  }


  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    reorder();
    return Scaffold(
      floatingActionButton: _saveOrder.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddToBasket(saveOrder: _saveOrder,onChange: _update,emailId: widget.emailId,)),
                );
              },
              backgroundColor: const Color.fromRGBO(212, 175, 55, 1),
              child: const Icon(Icons.add_shopping_cart),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                alignment: Alignment.center,
                width: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text('${_saveOrder.length}'),
              ),
            ),
          ],
        ),
      )
          : null,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: List.generate(widget.catigories.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.catigories[index],style:  TextStyle(fontSize: sizeWidth*0.07,color: Colors.blueGrey),),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,width: 2),
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: List.generate(display[widget.catigories[index]]!.length, (mealIndex) {
                                return Column(
                                  children: [
                                    MealWidget(
                                      mealName: display[widget.catigories[index]]![mealIndex].mealName,
                                      mealComponent: display[widget.catigories[index]]![mealIndex].mealComponents,
                                      price: display[widget.catigories[index]]![mealIndex].price.toString(),
                                      saveOrder: _saveOrderr,
                                    ),

                                    const SizedBox(height: 8,)
                                  ],
                                );
                              }),
                            ),
                          ),

                        )
                      ],
                    ),
                  );
                }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
