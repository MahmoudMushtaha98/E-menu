import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newemenu/widget/textbutton.dart';
import 'resturent_name.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: sizeHeight*0.5,
                child: Icon(Icons.login,color: Colors.grey,size: sizeWidth*0.5),
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
              SizedBox(
                height: sizeHeight*0.04,
              ),
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
              SizedBox(height: 16.0),
              TextButtonWidget(text: 'Sign Up',function: () async{
                try{
                  final newUser= await _auth.createUserWithEmailAndPassword(email: _email.text, password: _password.text);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantName(id: newUser.user!.uid)));
                }catch(e){
                  print(e);
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
}
