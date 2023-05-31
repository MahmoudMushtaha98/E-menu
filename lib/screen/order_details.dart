import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:eMenu/widget/textbutton.dart';

class OrderDetails extends StatefulWidget {
final String orderID;
final String name;
   OrderDetails({Key? key, required this.orderID, required this.name}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _firestore=FirebaseFirestore.instance;
  
  List<MealOrderModel> meals=[];

  void getDetails() async {
    final mealDetails = await _firestore.collection('Order').get();
    for (var meal in mealDetails.docs) {
      if (widget.orderID == meal.get('orderID')) {
        final mealName = await meal.get('mealName');
        final mealRequest = await meal.get('Requests');
        final number= await meal.get('numberOfMeal');
        setState(() {
          meals.add(MealOrderModel(mealName: mealName, mealRequest: mealRequest,numberOfMeal: number));
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    getDetails();
  }

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.name,style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          children: [
            Column(
              children: List.generate(meals.length, (index) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${meals[index].mealName}   x${(meals[index].numberOfMeal==0?meals[index].numberOfMeal+1:meals[index].numberOfMeal)}',style: const TextStyle(color: Colors.white,fontSize: 20),),
                          ),
                          meals[index].mealRequest==''?const SizedBox():
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Text('Notes: ${meals[index].mealRequest}',style: const TextStyle(color: Colors.white,fontSize: 20),),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey,),
                  ],
                );
              }),
            ),
            TextButtonWidget(text: 'Received', callback: () async{

              setState(() {
                _saving=true;
              });
              await deleteAll();
              setState(() {
                _saving=false;
              });
              if(mounted){
                Navigator.pop(context);
              }

            },)
          ],
        ),
      ),
    );
  }

  Future<void> deleteAll() async {
    final deleteMeal= await _firestore.collection('Order').where('orderID',isEqualTo: widget.orderID).get();
    for(var meal in deleteMeal.docs){
      await meal.reference.delete();
    }
    final deleteMealName= await _firestore.collection('Order name').where('orderName',isEqualTo: widget.name).get();
    for(var meal in deleteMealName.docs){
      await meal.reference.delete();
    }
  }
}

class MealOrderModel{
  final String mealName;
  final String mealRequest;
  final int numberOfMeal;
  MealOrderModel({required this.mealName, required this.mealRequest,required this.numberOfMeal});
}