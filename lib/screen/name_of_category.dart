import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  List<GlobalKey<FormState>> _formKey=[];
  final _firestore = FirebaseFirestore.instance;
  List<TextEditingController> _controllersList = [];
  List<String> _categoriesList = [];
  int counter=0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controllersList.clear();
    });
    _controllersList = List.generate(widget.numberOfCategory, (index) => TextEditingController());
    setState(() {
      _formKey.clear();
    });
    _formKey = List.generate(widget.numberOfCategory, (index) => GlobalKey<FormState>());
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
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
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
                            Form(
                              key: _formKey[index],
                              child: SizedBox(
                                width: sizeWidth*0.6,
                                height: sizeHeight*0.07,
                                child: TextFormField(
                                  controller: _controllersList[index],
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    label: Text('Name',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(212, 175, 55, 1),
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return '*';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40,)
                    ],
                  );
                }),
              ),
              const SizedBox(height: 10,),

              TextButtonWidget(text: 'Submit',callback: () async{
                await _submitForm();
                },
              ),
              SizedBox(height: sizeHeight*0.1,)
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
    await deleteCategory();
    if(mounted) {
      await selectCategory(context);
    }
  }

  Future<void> deleteCategory() async {
    final del=await _firestore.collection('Categories').where('EmailID',isEqualTo:widget.id ).get();
    if(del.docs.isNotEmpty){
      for(var dele in del.docs){
        dele.reference.delete();
      }
    }
  }

  Future<void> selectCategory(BuildContext context) async {
    setState(() {
      _categoriesList.clear();
    });
    for (var element in _controllersList) {
      _categoriesList.add(element.text);
      try{
        await _firestore.collection('Categories').add({
          'CategoryName': element.text,
          'EmailID': widget.id,
          'counter': counter
        });
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }
      counter++;
    }
    if(mounted) {
      setState(() {
        _saving=false;
      });
      Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            NumberOfMeal(
                categories: _categoriesList, emailID: widget.id),));
    }
  }
}