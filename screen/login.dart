
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:newemenu/model/meal_model.dart';
import 'package:newemenu/screen/signup.dart';

import '../widget/textbutton.dart';
import 'menu_screen.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  late final String emailID;
  bool _saving = false;
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  List<String> catigoris=[];
  List<int> catigoryCounter=[];
  List<MealModel> meals=[];


  List sortList(List<int> myList,List<String> mainList){
    for (int i = 0; i < myList.length - 1; i++) {
      for (int j = 0; j < myList.length - i - 1; j++) {
        if (myList[j] > myList[j + 1]) {
          int temp = myList[j];
          String mainTemp= mainList[j];
          myList[j] = myList[j + 1];
          mainList[j]=mainList[j+1];
          myList[j + 1] = temp;
          mainList[j+1]=mainTemp;
        }
      }
    }
    return mainList;
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
                SizedBox(
                  width: sizeWidth*0.8,
                  height: sizeHeight*0.07,
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      label: Text('Email',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(212, 175, 55, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),

                    ),
                  ),
                ),
                SizedBox(height: sizeHeight*0.05,),
                SizedBox(
                  width: sizeWidth*0.8,
                  height: sizeHeight*0.07,
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      label: Text('Password',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(212, 175, 55, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),

                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                      ),
                      SizedBox(height: 50.0),
                      TextButtonWidget(text: 'Login',function: () async{
                        setState(() {
                          _saving=true;
                        });
                        try{
                          final user = await _auth.signInWithEmailAndPassword(email: _email.text, password: _password.text);
                          final cat=await _firestore.collection('Categories').get();
                          for(var catigory in cat.docs){
                            if(catigory.get('EmailID')== user.user!.uid) {
                              catigoris.add(catigory.get('CategoryName'));
                              catigoryCounter.add(catigory.get('counter'));
                            }
                          }
                          sortList(catigoryCounter,catigoris);
                          final meal=await _firestore.collection('All').get();
                          for(var meall in meal.docs){
                            if(meall.get('emailID')==user.user!.uid) {
                              meals.add(MealModel(counter: meall.get('counter'), mealName: meall.get('mealName'), mealComponents: meall.get('mealComponents'), price: meall.get('price'), type: meall.get('type')));
                            }
                          }
                          meals.forEach((element) {
                            print(element.type);
                          });
                          if(user != null){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MeanuScreen(catigories: catigoris,meals: meals),));
                            setState(() {
                              _saving=false;
                            });
                          }
                        }catch(e){
                          print(e);
                        }
                      },),
                      SizedBox(height: 20.0),
                      TextButtonWidget(text: 'Sign Up',function: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));
                      },),

                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
