
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newemenu/screen/signup.dart';

import '../widget/textbutton.dart';

class LoginPage extends StatelessWidget {

  final _auth = FirebaseAuth.instance;

  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
                      try{
                        final user = await _auth.signInWithEmailAndPassword(email: _email.text, password: _password.text);
                        if(user != null){
                          //todo inter the Navegator
                          print(user.user!.email);
                          print(user.user!.uid);
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
    );
  }
}
