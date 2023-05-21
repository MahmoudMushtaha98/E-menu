import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:newemenu/widget/textbutton.dart';
import 'resturent_name.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey=GlobalKey<FormState>();
  final _formKey2=GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool _saving = false;

  Future<void> _submitForm()async{
    if(_formKey.currentState!.validate()&&_formKey2.currentState!.validate()){
      await signuoGenerate(context);
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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: sizeHeight * 0.5,
                  child: Icon(Icons.login,
                      color: Colors.grey, size: sizeWidth * 0.5),
                ),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    width: sizeWidth * 0.8,
                    height: sizeHeight * 0.07,
                    child: TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        label: Text(
                          'Email',
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
                        if(value!.isEmpty){
                          return 'Please enter yor email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.04,
                ),
                Form(
                  key: _formKey2,
                  child: SizedBox(
                    width: sizeWidth * 0.8,
                    height: sizeHeight * 0.07,
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        label: Text(
                          'Password',
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
                        if(value!.isEmpty){
                          return'Please enter yor password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButtonWidget(
                  text: 'Sign Up',
                  callback: () async {
                    await _submitForm();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signuoGenerate(BuildContext context) async {
    setState(() {
      _saving = true;
    });
    try {
      final newUser =
          await _auth.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      if (newUser.user != null) {
        final _firestore = FirebaseFirestore.instance;
        _firestore.collection('Users').add({
          "isMerchant": false,
          "email": newUser.user!.email.toString(),
        });
      }
      if(mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RestaurantName(id: newUser.user!.uid)));
      }
      setState(() {
        _saving = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
