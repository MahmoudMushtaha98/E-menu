import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  List<GlobalKey<FormState>> _formKey=[];
  List<TextEditingController> _controllersList = [];
  final _firestore=FirebaseFirestore.instance;
  List<int> _numberOfMeal = [];
  int counter=0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controllersList.clear();
    });
    _controllersList = List.generate(
        widget.categories.length, (index) => TextEditingController());
    setState(() {
      _formKey.clear();
    });
    _formKey=List.generate(widget.categories.length, (index) => GlobalKey<FormState>());
  }

  @override
  void dispose() {
    for (var controller in _controllersList) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _saving=false;

  Future<void> _submitForm()async{
    for(int counter=0;counter<_formKey.length;counter++){
      if(_formKey[counter].currentState!.validate()){
        if(counter==_formKey.length-1){
          await submitGenerate(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
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
                        Form(
                          key: _formKey[index],
                          child: SizedBox(
                            width: sizeWidth*0.2,
                            height: sizeHeight*0.07,
                            child: TextFormField(
                              controller: _controllersList[index],
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
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
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "*";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              TextButtonWidget(text: 'Submit',callback: () async{
                await _submitForm();
                },),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitGenerate(BuildContext context) async {
    setState(() {
      _saving=true;
    });
    await deleteNumbers();
    if(mounted) {
      await selectNumber(context);
    }
  }

  Future<void> deleteNumbers() async {
    final del= await _firestore.collection('Number of meal').where('emailID',isEqualTo: widget.emailID).get();
    if(del.docs.isNotEmpty){
      for(var dele in del.docs){
        dele.reference.delete();
      }
    }
  }

  Future<void> selectNumber(BuildContext context) async {
    _numberOfMeal.clear();
    for (var element in _controllersList) {
      _numberOfMeal.add(int.parse(element.text));
    }
    for(int counterr=0;counterr<_numberOfMeal.length;counterr++){
     try{
       await _firestore.collection('Number of meal').add({
         'counter': counterr,
         'emailID':widget.emailID,
         'numberOfMeal': _numberOfMeal[counterr],
         'type': widget.categories[counterr]
       });
     }catch(e){
       if (kDebugMode) {
         print(e);
       }
     }
    }
    if(mounted) {
      setState(() {
        _saving=false;
      });
      Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            EnterTheMeals(categories: widget.categories,
                numberOfMeals: _numberOfMeal,
                id: widget.emailID),));
    }
  }
}



