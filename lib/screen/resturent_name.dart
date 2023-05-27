import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:newemenu/screen/name_of_category.dart';
import 'package:newemenu/widget/textbutton.dart';


class RestaurantName extends StatefulWidget {
  final String id;
   const RestaurantName({Key? key, required this.id}) : super(key: key);

  @override
  State<RestaurantName> createState() => _RestaurantNameState();
}

class _RestaurantNameState extends State<RestaurantName> {
  final TextEditingController _controller = TextEditingController();

  final _firestore = FirebaseFirestore.instance;

  int _numValue = 0;
  bool _isAddButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _numValue =1;
  }

  void _increment() {
    setState(() {
      _numValue++;
      _isAddButtonPressed = true;
    });
  }

  void _decrement() {
    setState(() {
      _numValue--;
      _isAddButtonPressed = false;
    });
  }
bool _saving=false;

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: sizeHeight*0.5,
                child: Image.asset('images/E.png',fit: BoxFit.cover),
              ),
              const SizedBox(width: double.infinity,),
              SizedBox(
                width: sizeWidth*0.8,
                height: sizeHeight*0.07,
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    label: Text('Restaurants name',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(212, 175, 55, 1),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),

                  ),
                ),
              ),
              SizedBox(height: sizeHeight*0.06,),
              Text('How many categories',style: TextStyle(fontWeight: FontWeight.bold,fontSize: sizeHeight*0.03,color: Colors.grey),),
              SizedBox(height: sizeHeight*0.06,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle
                    ),
                    child: IconButton(
                      onPressed: _numValue > 0 ? _decrement : null,
                      icon: const Icon(Icons.remove,color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "$_numValue",
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(212, 175, 55, 1),
                        shape: BoxShape.circle
                    ),
                    child: IconButton(
                      onPressed: _increment,
                      icon: const Icon(Icons.add,color: Colors.white),
                      color: _isAddButtonPressed ? Colors.green : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizeHeight*0.06,),
              TextButtonWidget(text: 'Submit', callback: () async{
                setState(() {
                  _saving=true;
                });
                await deleteRestaurant();
                if(mounted) {
                  await selectName(context);
                }
              },)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteRestaurant() async {
    try{
      final del=await _firestore.collection('RestaurantName').where('emailID',isEqualTo: widget.id).get();
      if(del.docs.isNotEmpty) {
        for (var dele in del.docs) {
          dele.reference.delete();
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> selectName(BuildContext context) async {
    try{
      await _firestore.collection('RestaurantName').add({
        'emailID': widget.id,
        'numberOfCategories': _numValue,
        'restaurantName' : _controller.text
      });
      if(mounted) {
        setState(() {
          _saving=false;
        });
        Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              NameOfCategory(
                  numberOfCategory: _numValue, id: widget.id),));
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
