import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:newemenu/widget/textbutton.dart';
import '../model/save_order_model.dart';

class AddToBasket extends StatefulWidget {

  final String emailId;
  final List<SaveOrderModel> saveOrder;
  final ValueChanged<List> onChange;
  const AddToBasket({Key? key, required this.saveOrder, required this.onChange, required this.emailId}) : super(key: key);

  @override
  State<AddToBasket> createState() => _AddToBasketState();
}

class _AddToBasketState extends State<AddToBasket> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final _firestore=FirebaseFirestore.instance;
  bool _saving=false;

  Future<void> _submitForm() async{
    if (_formKey.currentState!.validate()) {
      doThat(context);
    }
  }

  FutureOr<bool> sendRequest(String name, String emailID, List<SaveOrderModel> save) async {
    try {
      final orderName = await _firestore.collection('Order name').add({
        'emailID': widget.emailId,
        'orderName': name,
      });
      final id = orderName.id;
      for (var element in save) {
        await _firestore.collection('Order').add({
          'Requests': element.Requests,
          'mealComponents': element.mealModel.mealComponents,
          'mealName': element.mealModel.mealName,
          'numberOfMeal': element.numberOfMeal,
          'orderID': id,
          'price': element.mealModel.price,
        });
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    double total=0;
    for (var element in widget.saveOrder) {
      for(int counter=0;counter<((element.numberOfMeal!=0)?element.numberOfMeal:element.numberOfMeal+1);counter++){
        total+=element.mealModel.price;
      }
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My order',style: TextStyle(color: Colors.grey,fontSize: 20),),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          widget.onChange(widget.saveOrder);
          Navigator.pop(context);
        },icon: const Icon((Icons.arrow_back),color: Colors.grey,)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
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
                child: SingleChildScrollView(
                  child: Column(
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

                                  }, icon: const Icon(Icons.cancel_outlined),color: Colors.white38),
                                ),
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text('Total: $total',style: const TextStyle(color: Colors.grey,fontSize: 20),),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: TextFormField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              label: Text(
                                'Enter your name',
                                style: TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(212, 175, 55, 1),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter yor name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      TextButtonWidget(text: 'Request', callback: () async{
                        await _submitForm();
                      },)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doThat(BuildContext context) async {
     setState(() {
      _saving=true;
    });
    await sendRequest(_controller.text, widget.emailId, widget.saveOrder);
    widget.saveOrder.clear();
    widget.onChange(widget.saveOrder);
    setState(() {
      _saving=false;
    });
    if(mounted) {
      Navigator.pop(context);
    }
  }
}
