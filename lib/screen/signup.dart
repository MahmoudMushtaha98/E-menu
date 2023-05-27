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
  final _formKey3=GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repassword = TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool _saving = false;

  Future<void> _submitForm()async{
    if(_formKey.currentState!.validate()&&_formKey2.currentState!.validate() && _formKey3.currentState!.validate()){
      await signupGenerate(context);
    }
  }

  bool emailValidator(String email){
    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    return emailValid;
  }
  bool passwordValidator(String password){
    final bool passwordValid =
    RegExp(r"^.{6,}$").hasMatch(password);

    return passwordValid;
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
                        if (value!.isEmpty) {
                          return 'Please enter yor email';
                        }else if(emailValidator(value)==true) {
                          return null;
                        }else{
                          return 'Email not valid';
                        }
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
                          return 'Please enter yor password';
                        }else if(passwordValidator(value)==false){
                          return 'Password weak';
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.04,
                ),
                Form(
                  key: _formKey3,
                  child: SizedBox(
                    width: sizeWidth * 0.8,
                    height: sizeHeight * 0.07,
                    child: TextFormField(
                      controller: _repassword,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        label: Text(
                          're-password',
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
                          return 'Please enter yor password';
                        }else if(passwordValidator(value)==false){
                          return 'Password weak';
                        }else if(!value.contains(_repassword.text)){
                          return 'password not correct';
                        }else{
                          return null;
                        }
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

  Future<void> signupGenerate(BuildContext context) async {
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
      possibleError(e, context);
      setState(() {
        _saving=false;
      });
    }
  }

  void possibleError(Object e, BuildContext context) {
    if (kDebugMode) {
      if(e is FirebaseAuthException && e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The email address is already in use by another account'))
        );

      }else if(e is FirebaseAuthException && e.toString().contains('firebase_auth/network-request-failed')){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The internet is disconnected'))
        );
      }
      else{
        print('suiiiii -$e- suiiiii');
      }
    }
  }
}
