import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eMenu/screen/order_details.dart';


class OrdersScreen extends StatefulWidget {
  final String emailID;
  const OrdersScreen({Key? key, required this.emailID}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _firestore=FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(212, 175, 55, 1))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('Order name').snapshots(),
                      builder: (context, snapshot) {
                      Map<String,Widget> mealWidgets={};
                      List<String> sendName=[];

                      if(!snapshot.hasData){

                      }else{
                        final mealsName=snapshot.data!.docs;
                        for(var name in mealsName){
                          if(name.get('emailID')==widget.emailID) {
                            final mealName = name.get('orderName');
                            final mealID=name.id;
                            final mealWidget = Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height*0.07,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.green
                                ),
                                child: Text(mealName,style: const TextStyle(color: Colors.white,fontSize: 25),
                                )
                            );
                            mealWidgets[mealID]=mealWidget;
                            sendName.add(mealName);
                          }
                        }
                      }

                      List name=mealWidgets.values.toList();
                      List id=mealWidgets.keys.toList();

                        return Column(
                          children: [
                            name.isEmpty? Text('No order...',style: TextStyle(color: Colors.grey,fontSize: 20),):
                            Column(

                              children: List.generate(mealWidgets.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(orderID: id[index],name: sendName[index]),));
                                    },
                                      child: name[index]

                                  ),
                                );
                              }),
                            ),
                          ],
                        );
                      },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
