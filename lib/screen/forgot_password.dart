import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eMenu/screen/login.dart';
import 'package:eMenu/widget/textbutton.dart';

class ForgotPassword extends StatelessWidget {
   ForgotPassword({Key? key}) : super(key: key);
  final TextEditingController _email=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  final _auth=FirebaseAuth.instance;

Future<void> valid(BuildContext context)async{
  if(_formKey.currentState!.validate()){
    await _auth.sendPasswordResetEmail(email: _email.text);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
  }
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity,height: 50,),
            Container(
              width: MediaQuery.of(context).size.width*0.80,
              alignment: Alignment.center,
                child: const Text('An email will be sent to change the password',style: TextStyle(color: Colors.amber,fontSize: 25))
            ),
            const SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
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
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            TextButtonWidget(text: 'send', callback: () async{
              await valid(context);
            },)
          ],
        ),
      ),
    );
  }
}
