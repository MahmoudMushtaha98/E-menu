import 'package:flutter/material.dart';
import 'package:newemenu/widget/textbutton.dart';
import '../model/save_order_model.dart';

class AddToBasket extends StatefulWidget {

  final List<SaveOrderModel> saveOrder;
  const AddToBasket({Key? key, required this.saveOrder}) : super(key: key);

  @override
  State<AddToBasket> createState() => _AddToBasketState();
}

class _AddToBasketState extends State<AddToBasket> {
  @override
  Widget build(BuildContext context) {
    double total=0;
    widget.saveOrder.forEach((element) {
      for(int counter=0;counter<((element.numberOfMeal!=0)?element.numberOfMeal:element.numberOfMeal+1);counter++){
        total+=element.mealModel.price;
      }
    });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('My order',style: TextStyle(color: Colors.grey,fontSize: 20),),
        centerTitle: true,

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(212, 175, 55, 1))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: List.generate(widget.saveOrder.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                '${widget.saveOrder[index].mealModel.mealName}   x${(widget.saveOrder[index].numberOfMeal>0)?widget.saveOrder[index].numberOfMeal:widget.saveOrder[index].numberOfMeal+1}',style: const TextStyle(color: Color.fromRGBO(212, 175, 55, 1)),),
                              subtitle: Text(
                                widget.saveOrder[index].mealModel.price.toString(),
                                maxLines: 2,
                                style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.grey),
                              ),
                              trailing: IconButton(onPressed: () {
                                setState(() {
                                  widget.saveOrder.remove(widget.saveOrder[index]);
                                });

                              }, icon: Icon(Icons.cancel_outlined),color: Colors.white38),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text('Total: $total',style: TextStyle(color: Colors.grey,fontSize: 20),),
                      )
                    ],
                  ),
                  SizedBox(width: double.infinity,),
                  TextButtonWidget(text: 'Request', callback: () {
                    widget.saveOrder.clear();
                    Navigator.pop(context);
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
